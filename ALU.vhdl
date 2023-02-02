library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity ALU is
    port(
        --ALU signals
        ALU_OpCode: in STD_LOGIC_VECTOR (3 downto 0); --Opcodes telling the ALU what to do
        ALU_Execute, ALU_Reset: in STD_LOGIC; --Enablex execution of code/ resets code execution
        ALU_ExternalOut: out STD_LOGIC_VECTOR (7 downto 0); --Output ACC externally
        ALU_FlagZero, ALU_FlagOverflow, ALU_FlagEquals: out STD_LOGIC; --Flags
    
        --Acc signals
        ALU_ACCLoad: in STD_LOGIC; --Control signal to load from accumulator
        ALU_ACCDataIn: in STD_LOGIC_VECTOR (7 downto 0); --Input from acc
        ALU_ACCDataOut: out STD_LOGIC_VECTOR (7 downto 0); --Output to acc

        --DataReg signals
        ALU_DataRegLoad: in STD_LOGIC; --Control signal to load from Data register
        ALU_DataReg_DataIn : in STD_LOGIC_VECTOR (7 downto 0); --Input from data register
        ALU_DataReg_DataOut : out STD_LOGIC_VECTOR (7 downto 0); --Output from data register out of ALU
        ALU_DataReg_4BitDataOut : out STD_LOGIC_VECTOR (3 downto 0) --Output from data register out of ALU
    );
end ALU;

architecture Behavioral of ALU is
--These signals carry components between Calculation engine, Accumulator (ACC) and Data Register
-- as they are made up of different components
signal BUS_DataOut_CE_ACC, BUS_DataIn_CE_ACC, BUS_DataIn_CE_DataReg : STD_LOGIC_VECTOR (7 downto 0);
begin

    CE : entity work.CalculationEngine
    port map(
        CE_AccDataOut => BUS_DataOut_CE_ACC,
        CE_AccDataIn => BUS_DataIn_CE_ACC,
        CE_DataRegIn => BUS_DataIn_CE_DataReg,
        CE_OpCode => ALU_OpCode,
        CE_Execute => ALU_Execute,
        CE_Reset => ALU_Reset,
        CE_FlagZero => ALU_FlagZero,
        CE_FlagOverflow => ALU_FlagOverflow,
        CE_FlagEquals => ALU_FlagEquals
    );

    Acc : entity work.ACC
    port map(
        D_CE => BUS_DataOut_CE_ACC,
        D_Ra => ALU_ACCDataIn,
        R => ALU_Reset,
        Load => ALU_ACCLoad,
        QExt => ALU_ExternalOut,
        Q => BUS_DataIn_CE_ACC,
        Qout => ALU_ACCDataOut
    );

    DATAREG : entity work.Data_Reg 
    port map(
        D => ALU_DataReg_DataIn,
        R => ALU_Reset,
        Load => ALU_DataRegLoad,
        DataReg_Out => BUS_DataIn_CE_DataReg,
        DataReg_Jump => ALU_DataReg_4BitDataOut,
        DataReg_DEBUG => ALU_DataReg_DataOut
    );

end Behavioral;