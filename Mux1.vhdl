library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity Mux1 is
    Port(
        InACC, InEXT : in STD_LOGIC_VECTOR (7 downto 0);--Inputs from Accumulator and for External Data 
        LoadRAM : in STD_LOGIC; --Signal to load from RAM
        OutRAM: out STD_LOGIC_VECTOR (7 downto 0) --Passthrough of MUX
    );
end Mux1;

architecture Behavioral of Mux1 is

begin
OutRAM <= 
    InACC WHEN LoadRAM = '0' else
    InEXT WHEN LoadRAM = '1';
end Behavioral;