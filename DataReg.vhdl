library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity Data_Reg is
    Port(
        D : in STD_LOGIC_VECTOR (7 downto 0); --Register input
        R, Load : in STD_LOGIC; --Reset and Load signals
        DataReg_Jump : out STD_LOGIC_VECTOR (3 downto 0); --DataRegister Output only LSB 4 bits data for jump
        DataReg_Out : out STD_LOGIC_VECTOR (7 downto 0); --Register Output
        DataReg_DEBUG : out STD_LOGIC_VECTOR (7 downto 0) --Debug Output
    );
end Data_Reg;

architecture Behavioral of Data_Reg is
Signal DataReg_InternalValue: STD_LOGIC_VECTOR (7 downto 0) := "00000000"; --Internal memory/register

begin
    Process(Load, R)
    begin
    
        --On Reset signal clear internal memory
        if R = '1' then
            DataReg_InternalValue <= "00000000";

        --On Load signal enable
        elsif (Load = '1') then
            DataReg_InternalValue <= D;

        --Otherwise output internal memory
        else
            DataReg_Out <= DataReg_InternalValue; 
            DataReg_DEBUG <= DataReg_InternalValue; 
            DataReg_Jump <= DataReg_InternalValue (3 downto 0); --Data register is 8 but PGMC is on 4, so only the lower 4 bits are used

        end if;
    end process;
end Behavioral;