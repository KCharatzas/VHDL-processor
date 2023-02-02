library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity RAM is
    Port(
        RAM_Address : in STD_LOGIC_VECTOR (3 downto 0);
        RAM_Value : in STD_LOGIC_VECTOR (7 downto 0);
        RAM_WriteEnable : in STD_LOGIC;
        RAM_DataReg_Out, RAM_ACC_Out : out STD_LOGIC_VECTOR (7 downto 0)
    );
end RAM;

architecture Behavioral of RAM is

type RAMTABLE is array (0 to 15) of STD_LOGIC_VECTOR(7 downto 0);

--Ramdata is a signal because it can be changed by other processes
signal ramdata : RAMTABLE := --Initialise RAM with kown values
    (
    0 => "00000001", --1
    1 => "00000100", --V = 4
    2 => "00000111", --W = 7
    3 => "00000011", --X = 3
    4 => "00000001", --Y = 1
    5 => "00000101", --Z = 5
    6 => "00000000", --(X-Y) will be stored here
    7 => "00000000", --F will be stored here
    8 => "00000000",
    9 => "00000000",
    10 => "00000000",
    11 => "00000000",
    12 => "00000000",
    13 => "00000000",
    14 => "00000000",
    15 => "00000000"
    );
begin
process(RAM_Address, RAM_WriteEnable)
    begin
        if (RAM_WriteEnable = '1') then
            ramdata(to_integer(unsigned(RAM_Address))) <= RAM_Value; --If Write signal is enabled write to RAM
        else
            RAM_ACC_Out <= ramdata(to_integer(unsigned(RAM_Address))); --If Write signal is not enable RAM gets read to
            RAM_DataReg_Out <= ramdata(to_integer(unsigned(RAM_Address))); --and data is passed to Accumulator and Data Register
        end if;
    end process;
end Behavioral;