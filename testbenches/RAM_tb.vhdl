library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity RAM_TB is
-- Port ( );
end RAM_TB;

architecture TB of RAM_TB is

component RAM is
port(
    RAM_Address : in STD_LOGIC_VECTOR (3 downto 0);
    RAM_WriteEnable : in STD_LOGIC;
    RAM_Value : in STD_LOGIC_VECTOR (7 downto 0);
    RAM_DataReg_Out : out STD_LOGIC_VECTOR (7 downto 0);
    RAM_ACC_Out : out STD_LOGIC_VECTOR (7 downto 0)
);
end component;
signal RAM_Address_Tb : STD_LOGIC_VECTOR (3 downto 0);
signal RAM_WriteEnable_Tb : STD_LOGIC;
signal RAM_Value_Tb : STD_LOGIC_VECTOR (7 downto 0);
signal RAM_DataReg_Out_Tb : STD_LOGIC_VECTOR (7 downto 0);
signal RAM_ACC_Out_Tb : STD_LOGIC_VECTOR (7 downto 0);

begin
DUT: RAM
port map(
    RAM_Address => RAM_Address_Tb,
    RAM_WriteEnable => RAM_WriteEnable_Tb,
    RAM_Value => RAM_Value_Tb,
    RAM_DataReg_Out => RAM_DataReg_Out_Tb,
    RAM_ACC_Out => RAM_ACC_Out_Tb
    );

RAM_Address_Tb <= 
    "0000" after 1 ns,
    "0001" after 12 ns,
    "0010" after 22 ns,
    "0000" after 32 ns,
    "0001" after 42 ns,
    "0010" after 52 ns;

RAM_Value_Tb <= 
    "11100110" after 1 ns,
    "00001000" after 12 ns,
    "10101010" after 22 ns;

RAM_WriteEnable_Tb <= 
    '1' after 10 ns,
    '0' after 11 ns,
    '1' after 13 ns,
    '0' after 14 ns,
    '1' after 23 ns,
    '0' after 24 ns,
    '1' after 43 ns,
    '0' after 53 ns;
    
end TB;