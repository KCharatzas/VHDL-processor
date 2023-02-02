library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity PgmCounter is
    Port(
        PGMC_Reset, PGMC_Enable, PGMC_Override : in STD_LOGIC; --Reset, Enable and override signals
        PGMC_CountIn : in STD_LOGIC_VECTOR (3 downto 0); --Input for the instruction count (overrides count if PGMC_Override is on)
        PGMC_CountOut_CPU, PGMC_CountOut_DEBUG : out STD_LOGIC_VECTOR (3 downto 0) --Output for the instruction that the program counter has counted up to
    );
end PgmCounter;

architecture Behavioral of PgmCounter is

signal PGMC_CountInternal : STD_LOGIC_VECTOR (3 downto 0) := "0000"; --The program count
begin
    process(PGMC_Enable, PGMC_Reset, PGMC_Override)
    begin
        if (PGMC_Reset = '1') then
            PGMC_CountInternal <= "0000"; --Asynchronous Reset
        elsif (PGMC_Override = '1') then
            PGMC_CountInternal <= PGMC_CountIn; --Allows overriding the PGMC (For jump instructions for example)
        elsif (rising_edge(PGMC_Enable)) then --Enable is only considered on rising edge to prevent double counting
            PGMC_CountInternal <= PGMC_CountInternal + '1';
        end if;
    end process;
    
    --Output counter values
    PGMC_CountOut_CPU <= PGMC_CountInternal;
    PGMC_CountOut_DEBUG <= PGMC_CountInternal;
end Behavioral;