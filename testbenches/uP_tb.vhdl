library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity MicroProcessor_TB is
-- Port ( );
end MicroProcessor_TB;

architecture TB of MicroProcessor_TB is
component MicroProcessor is
port(
    uP_ExternalDataIn: in STD_LOGIC_VECTOR (7 downto 0); --External inputs to the uP controller
    uP_Enable, uP_Reset: in STD_LOGIC; --Enable and Reset signals
    uP_Clock : in STD_LOGIC; --Clock signal
    uP_DataReg_DataOut: out STD_LOGIC_VECTOR (7 downto 0); --Allows DataReg to be read externally
    uP_ExternalDataOut: out STD_LOGIC_VECTOR (7 downto 0); --Allows Accumulator (ACC) to be read externally
    uP_CurrentState, uP_PGMC_Debug_Out : out STD_LOGIC_VECTOR (3 downto 0);
    uP_CPU_ALUExecuteDEBUG : out STD_LOGIC
    );
end component;

Signal uP_Enable_Tb : STD_LOGIC := '1';
Signal uP_ExternalDataIn_Tb : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
Signal uP_Clock_Tb : STD_LOGIC := '0';
Signal uP_Reset_Tb : STD_LOGIC := '0';
Signal uP_ExternalDataOut_Tb : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
Signal uP_DataReg_DataOut_Tb : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
Signal uP_CurrentState_Tb : STD_LOGIC_VECTOR (3 downto 0);
Signal uP_PGMC_Debug_Out_Tb : STD_LOGIC_VECTOR (3 downto 0);
Signal uP_CPU_ALUExecuteDEBUG_Tb : STD_LOGIC;

begin
DUT: MicroProcessor
port map (
    uP_ExternalDataIn => uP_ExternalDataIn_Tb,
    uP_Enable => uP_Enable_Tb,
    uP_Clock => uP_Clock_Tb,
    uP_Reset => uP_Reset_Tb,
    uP_ExternalDataOut => uP_ExternalDataOut_Tb,
    uP_DataReg_DataOut => uP_DataReg_DataOut_Tb,
    uP_PGMC_Debug_Out => uP_PGMC_Debug_Out_Tb,
    uP_CurrentState => uP_CurrentState_Tb,
    uP_CPU_ALUExecuteDEBUG => uP_CPU_ALUExecuteDEBUG_Tb
    );
    
uP_Clock_Tb <= not uP_Clock_Tb after 5 ns;
uP_Enable_Tb <= '1';
end TB;