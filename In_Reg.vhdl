library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity In_Reg is
    Port(
        D : in STD_LOGIC_VECTOR (7 downto 0); --Data input containing desired operation and address
        E : in STD_LOGIC;
        OpCode: out STD_LOGIC_VECTOR (3 downto 0); --Passthrough for OpCodes
        DataAdd: out STD_LOGIC_VECTOR (3 downto 0) --Passthrough for Data Address
    );
end In_Reg;

architecture Behavioral of In_Reg is

begin
    process(D, E)
    begin
        if (E = '1') then
            OpCode <= D(7 downto 4); --OpCodes are the 4 MSB of the data
            DataAdd <= D(3 downto 0); --The address of the data to perform the opcodes on is the 4 LSB of the data
        end if;
    end process;
end Behavioral;