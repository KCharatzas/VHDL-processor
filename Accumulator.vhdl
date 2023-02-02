library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity ACC is
    Port(
        D_CE, D_Ra: in STD_LOGIC_VECTOR (7 downto 0); --Register Inputs
        R, Load : in STD_LOGIC; --Reset and Load from RAM
        Q, Qout, QExt: out STD_LOGIC_VECTOR (7 downto 0) --Register outputs
    );
end ACC;

architecture Behavioral of ACC is
signal mem: STD_LOGIC_VECTOR(7 downto 0) := "00000000"; --ACC memory
begin
    process (R, Load, D_CE) begin --Process on Reset, Load or change in input

        --On reset, clear memory
        if (R = '1') then
            mem <= "00000000";

        --On Load, load ram into memory
        elsif (Load = '1') then
            mem <= D_Ra;

        --Otherwise, provide direct access to computation engine 
        else
            mem <= D_CE;

        end if;
    end process;

Q <= mem; --Output memory to Q
QExt <= mem; --Output memory to External output
QOut <= mem; --Output memory to RAM

end Behavioral;