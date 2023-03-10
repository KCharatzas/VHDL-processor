library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity ROM_TB is
-- Port ( );
end ROM_TB;

architecture TB of ROM_TB is
component ROM is
port(
    ROM_Address : in STD_LOGIC_VECTOR (3 downto 0);
    ROM_Value : out STD_LOGIC_VECTOR (7 downto 0)
    );
end component;
signal ROM_Address_Tb : STD_LOGIC_VECTOR (3 downto 0) := "0000";
signal ROM_Value_Tb : STD_LOGIC_VECTOR (7 downto 0);

begin
DUT: ROM
port map(
    ROM_Address => ROM_Address_Tb,
    ROM_Value => ROM_Value_Tb
    );

ROM_Address_Tb <= ROM_Address_Tb + 1 after 20 ns;
end TB;