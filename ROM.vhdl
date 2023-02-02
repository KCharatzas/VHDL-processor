library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity ROM is
    Port(
        ROM_Address : in STD_LOGIC_VECTOR (3 downto 0);
        ROM_Value : out STD_LOGIC_VECTOR (7 downto 0)
    );
end ROM;

architecture Behavioral of ROM is

   --The ROM is an array of 16 locations each containing 8 bits
    type ROMTABLE is array (0 to 15) of STD_LOGIC_VECTOR(7 downto 0);
    constant testprogram : ROMTABLE := 
        (
        0 => "10100011", --Load Acc with X (RAM POS 3)
        1 => "10110100", --Load Data Reg with Y (RAM POS 4)
        2 => "00110000", --Acc - Data Reg (X-Y) 
        3 => "01010000", --Shift Left once (doubling)
        4 => "11000110", --Store Acc (X-Y) to Ram (POS 6)
        5 => "10100010", --Load Acc with W (RAM POS 2)
        6 => "10110101", --Load Data Reg with Z (RAM POS 5)
        7 => "00100000", --Acc + Data Reg (W+Z)
        8 => "01100000", --Shift right once (halving)
        9 => "10110110", --Load (X-Y) (RAM POS 6) into data reg
        10 => "10000000", --DataReg XOR Acc
        11 => "10110001", --Load V into Data Reg (RAM POS 1)
        12 => "01000000", --Acc * Data Reg
        13 => "11000111", --Store Acc Result to postion 7 of RAM
        14 => "10100111", --Load Acc with F (RAM POS 7)
        15 => "00000000" --Reset Acc
        );
begin
process(ROM_Address)
    begin
        ROM_Value <= testprogram(to_integer(unsigned(ROM_Address)));
    end process;
end Behavioral;