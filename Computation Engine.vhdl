library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity CalculationEngine is
Port(
    CE_OpCode: in STD_LOGIC_VECTOR (3 downto 0);
    CE_Execute, CE_Reset: in STD_LOGIC; --Enablex execution of code/resets code executions
    CE_AccDataIn: in STD_LOGIC_VECTOR (7 downto 0); --Input from acc
    CE_AccDataOut: out STD_LOGIC_VECTOR (7 downto 0); --Output to acc
    CE_FlagZero, CE_FlagOverflow, CE_FlagEquals: out STD_LOGIC; --Flags
    CE_DataRegIn : in STD_LOGIC_VECTOR (7 downto 0) --Input from data register
);
end CalculationEngine;

architecture Behavioral of CalculationEngine is
    signal CE_ExpandedCalcBuffer: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
begin

    Process(CE_Execute, CE_Reset) begin

        if (CE_Reset = '1') then --Reset on "reset signal"
            CE_ExpandedCalcBuffer <= "0000000000000000";

        elsif (CE_Execute = '1') then
            --Flag setting/resetting:
            
            --Zero flag
            if (CE_AccDataIn = "00000000") then --Check for Zero
                CE_FlagZero <= '1'; --Set zero flag
            else
                CE_FlagZero <= '0'; --Reset Zero flag
            end if;
            
            --Equality flag
            if (CE_AccDataIn = CE_DataRegIn) then --Check for equality
                CE_FlagEquals <= '1';
            else
                CE_FlagEquals <= '0';
            end if;
    
            --Overflow flag
            if (CE_ExpandedCalcBuffer(15 downto 8) > "00000000") then --If the top 2 byes have any activity, an overflow of the bottom two bytes has occured
                CE_FlagOverflow <= '1';
            else
                CE_FlagOverflow <= '0';
            end if;

            with CE_OpCode(3 downto 0) select
                CE_ExpandedCalcBuffer <=
                    CE_ExpandedCalcBuffer and "0000000000000000"
                        WHEN "0000", --Set all bits to 0

                    ("0000000000000000" + CE_AccDataIn) + "1" 
                        WHEN "0001", --Extend Acc to 16 bits and add 1
                        
                    ("0000000000000000" + CE_AccDataIn) + CE_DataRegIn 
                        WHEN "0010", --Extend Acc to 16 bits and add DataReg
    
                    ("0000000000000000" + CE_AccDataIn) - CE_DataRegIn 
                        WHEN "0011", --Extend Acc to 16 bits and sub DataReg

                    STD_LOGIC_VECTOR(unsigned(CE_AccDataIn) * unsigned(CE_DataRegIn))
                        WHEN "0100", --Multiply Acc and DataReg

                    ("0000000000000000" + STD_LOGIC_VECTOR(shift_left(unsigned(CE_AccDataIn), to_integer(unsigned(CE_DataRegIn))))) 
                        WHEN "0101", --Bitshift left DataReg times

                    ("0000000000000000" + STD_LOGIC_VECTOR(shift_right(unsigned(CE_AccDataIn), to_integer(unsigned(CE_DataRegIn)))))
                        WHEN "0110", --Bitshift right DataReg times

                    "0000000000000000" + (CE_AccDataIn nand CE_DataRegIn) 
                        WHEN "0111", --Extend Acc to 16 bits and nand with DataReg 

                    "0000000000000000" + (CE_AccDataIn xor CE_DataRegIn) 
                        WHEN "1000", --Extend Acc to 16 bits and xor with DataReg 

                    CE_ExpandedCalcBuffer or "0000000011111111"
                        WHEN "1001", --Set all bits to 1

                    CE_ExpandedCalcBuffer 
                        WHEN OTHERS; --In case of unexpected opcode, do nothing
            
        else --If reset and execute is 0 priovide direct access to Acc
            CE_ExpandedCalcBuffer <= ("0000000000000000" + CE_AccDataIn);
        
        end if;
    
    end process;

    CE_AccDataOut <= CE_ExpandedCalcBuffer(7 downto 0); --Provide direct write access to acc 
end Behavioral;