library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity ALU_TB is
-- Port ( );
end ALU_TB;

architecture TB of ALU_TB is
component ALU is
port(
    ALU_OpCode : in STD_LOGIC_VECTOR (3 downto 0);
    ALU_DataReg_DataIn : in STD_LOGIC_VECTOR (7 downto 0);
    ALU_ACCDataIn : in STD_LOGIC_VECTOR (7 downto 0);
    ALU_DataRegLoad : in STD_LOGIC;
    ALU_ACCLoad : in STD_LOGIC;
    ALU_Execute : in STD_LOGIC;
    ALU_Reset : in STD_LOGIC;
    ALU_ACCDataOut : out STD_LOGIC_VECTOR (7 downto 0);
    -- Out_DataReg : out STD_LOGIC_VECTOR (7 downto 0);
    ALU_ExternalOut : out STD_LOGIC_VECTOR (7 downto 0);
    ALU_FlagZero, ALU_FlagOverflow, ALU_FlagEquals: out STD_LOGIC
    );
end component;

signal ALU_DataReg_DataIn_Tb : STD_LOGIC_VECTOR (7 downto 0);
signal ALU_ACCDataIn_Tb : STD_LOGIC_VECTOR (7 downto 0);
signal ALU_ACCDataOut_Tb : STD_LOGIC_VECTOR (7 downto 0);
--signal ODR : STD_LOGIC_VECTOR (7 downto 0);
signal ALU_ExternalOut_Tb : STD_LOGIC_VECTOR (7 downto 0);
signal ALU_OpCode_Tb : STD_LOGIC_VECTOR (3 downto 0):="0000";
signal ALU_DataRegLoad_Tb : STD_LOGIC:= '0';
signal ALU_ACCLoad_Tb : STD_LOGIC:= '0';
signal ALU_Execute_Tb : STD_LOGIC:= '0';
signal ALU_Reset_Tb : STD_LOGIC:= '0';
signal ALU_FlagZero_Tb : STD_LOGIC:= '0';
signal ALU_FlagEquals_Tb : STD_LOGIC:= '0';
signal ALU_FlagOverflow_Tb : STD_LOGIC:= '0';

begin
DUT: ALU
port map(
    ALU_DataReg_DataIn => ALU_DataReg_DataIn_Tb,
    ALU_ACCDataIn => ALU_ACCDataIn_Tb,
    ALU_DataRegLoad => ALU_DataRegLoad_Tb,
    ALU_ACCLoad => ALU_ACCLoad_Tb,
    ALU_Execute => ALU_Execute_Tb,
    ALU_Reset => ALU_Reset_Tb,
    ALU_ACCDataOut => ALU_ACCDataOut_Tb, 
    -- Out_DataReg => ODR,
    ALU_ExternalOut => ALU_ExternalOut_Tb,
    ALU_FlagZero => ALU_FlagZero_Tb,
    ALU_FlagOverflow => ALU_FlagOverflow_Tb,
    ALU_FlagEquals => ALU_FlagEquals_Tb,
    ALU_OpCode => ALU_OpCode_Tb
    );
ALU_Reset_Tb <= '1' after 5 ns, '0' after 10 ns;
ALU_DataRegLoad_Tb <= '1' after 5 ns, '0' after 50 ns, '1' after 80 ns, '0' after
85 ns;
ALU_ACCLoad_Tb <= '1' after 5 ns, '0' after 50 ns;
ALU_DataReg_DataIn_Tb <= "00000001" after 1 ns, "00000111" after 80 ns;
ALU_ACCDataIn_Tb <= "00001010" after 1 ns;
ALU_OpCode_Tb <= 
    "0011" after 20 ns,
    "0001" after 75 ns,
    "0010" after 85 ns,
    "0100" after 100 ns,
    "0101" after 115 ns,
    "0110" after 130 ns,
    "0111" after 145 ns,
    "1000" after 160 ns,
    "1001" after 175 ns;
ALU_Execute_Tb <= 
    '1' after 11 ns,
    '0' after 13 ns,
    '1' after 60 ns,
    '0' after 70 ns,
    '1' after 80 ns,
    '0' after 85 ns,
    '1' after 95 ns,
    '0' after 100 ns,
    '1' after 110 ns,
    '0' after 115 ns,
    '1' after 125 ns,
    '0' after 130 ns,
    '1' after 140 ns,
    '0' after 145 ns,
    '1' after 155 ns,
    '0' after 160 ns,
    '1' after 170 ns,
    '0' after 175 ns,
    '1' after 185 ns,
    '0' after 190 ns;
    
end TB;