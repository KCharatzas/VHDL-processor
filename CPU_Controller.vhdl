library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity CPU_Controller is
    Port(
        CPU_Clock, CPU_Enable, CPU_Reset : in STD_LOGIC; --Core Control signals 
        CPU_FlagZero, CPU_FlagOverflow, CPU_FlagEquals: in STD_LOGIC; --Flags: (Zero, Equals, Overflow)
        CPU_OpCodeIn: in STD_LOGIC_VECTOR (3 downto 0); --OpCodes
        CPU_OpCodeOut, CPU_StateOut: out STD_LOGIC_VECTOR (3 downto 0); --Opcode and state passthrough for internal components and testbench
        CPU_ALUExecuteBUFFER : buffer STD_LOGIC;
        CPU_ALUReset, CPU_ALUExecute, CPU_ALUExecuteDEBUG : out STD_LOGIC; --ALU Core Control signals
        CPU_ALULoad_Acc, CPU_ALULoad_Reg : out STD_LOGIC; --ALU function signals
        CPU_RAMWrite, CPU_RAMLoad : out STD_LOGIC; --RAM Function signals
        CPU_PGMCReset, CPU_PGMCInc, CPU_PGMCJump : out STD_LOGIC; --Program Counter Function Signals
        CPU_IRLoad : out STD_LOGIC --Instruction Register load
    );
end CPU_Controller;

architecture Behavioral of CPU_Controller is
Type States is (STATE_Reset, STATE_Decode, STATE_ALU_Execute, 
STATE_ResetOnNext, STATE_IncrementPGMC); --States because CPU_Controller is programmed as a Finite State MAchine (FSM)
signal CPU_CS : States := STATE_ResetOnNext; --Start just before a reset
signal CPU_NS : States; --Next CPU state
begin

process(CPU_Clock, CPU_Reset) begin
    if (CPU_Reset = '1') then
        CPU_CS <= STATE_ResetOnNext;
    elsif (rising_edge(CPU_Clock)) then
        CPU_CS <= CPU_NS;
    end if;
end process;

process(CPU_CS) begin
    if(CPU_Enable = '1') then
        CASE CPU_CS IS
            WHEN STATE_Reset =>
                CPU_ALUExecuteBUFFER <= '0';
                CPU_ALULoad_Acc <= '0';
                CPU_ALULoad_Reg <= '0';
                CPU_RAMWrite <= '0';
                CPU_RAMLoad <= '0'; --RAMLoad allows RAM to be loaded from external data input
                CPU_PGMCInc <= '0';
                CPU_PGMCReset <= '0';
                CPU_ALUReset <= '0';
                CPU_IRLoad <= '1';
                CPU_NS <= STATE_IncrementPGMC ;
                CPU_StateOut <= "0000"; --Tell Testbench CPU is in 0th state
            WHEN STATE_Decode =>
                CASE CPU_OpCodeIn is
                    when "1010" =>  CPU_ALULoad_Acc <= '1';
                    when "1011" =>  CPU_ALULoad_Reg <= '1';
                    when "1100" =>  CPU_RAMLoad <= '0';
                                    CPU_RAMWrite <= '1';
                    when "1101" =>  CPU_RAMLoad <= '1';
                                    CPU_RAMWrite <= '1';
                    when "1110" => 
                                    if (CPU_FlagZero = '1') then
                                        CPU_PGMCInc <= '1';
                                    end if;
                    when "1111" => 
                                    if (CPU_FlagZero = '1') then
                                        CPU_PGMCJump <= '1';
                                    end if; 
                    when OTHERS => CPU_ALUExecuteBUFFER <= '1'; --If the OpCode isnt one of these it must be an ALU opcode so turn on the ALU
                END CASE;
                CPU_NS <= STATE_ALU_Execute;
                CPU_StateOut <= "0001"; --Tell Testbench CPU is in 1st state
            WHEN STATE_ALU_Execute =>
                CPU_ALUExecuteBUFFER <= '1';
                CPU_NS <= STATE_ResetOnNext;
                CPU_StateOut <= "0010"; --Tell Testbench CPU is in 2nd state
            WHEN STATE_ResetOnNext =>
                CPU_NS <= STATE_Reset;
                CPU_StateOut <= "0011"; --Tell Testbench CPU is in 3rd state
            WHEN STATE_IncrementPGMC => 
                CPU_PGMCInc <= '1';
                CPU_NS <= STATE_Decode;
                CPU_StateOut <= "0100"; --Tell Testbench CPU is in 4th state
        END CASE;
    END IF;
END PROCESS;

CPU_ALUExecuteDEBUG <= CPU_ALUExecuteBUFFER;
CPU_ALUExecute <= CPU_ALUExecuteBUFFER;
CPU_OpCodeOut <= CPU_OpCodeIn; --Passthrough OpCode

end Behavioral;