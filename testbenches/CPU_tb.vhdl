library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity CPU_TB is
-- Port ( );
end CPU_TB;

architecture TB of CPU_TB is

component CPU_Controller is
port(
    CPU_Clock, CPU_Enable, CPU_Reset : in STD_LOGIC; --Core Control signals
    CPU_FlagZero, CPU_FlagOverflow, CPU_FlagEquals: in STD_LOGIC; --Flags: (Zero, Equals, Overflow)
    CPU_OpCodeIn: in STD_LOGIC_VECTOR (3 downto 0); --OpCodes
    CPU_OpCodeOut, CPU_StateOut: out STD_LOGIC_VECTOR (3 downto 0); --Opcode and state passthrough for internal components and testbench
    CPU_ALUReset, CPU_ALUExecute : out STD_LOGIC; --ALU Core Control signals
    CPU_ALULoad_Acc, CPU_ALULoad_Reg : out STD_LOGIC; --ALU function signals
    CPU_RAMWrite, CPU_RAMLoad : out STD_LOGIC; --RAM Function signals
    CPU_PGMCReset, CPU_PGMCInc : out STD_LOGIC; --Program Counter Function Signals
    CPU_IRLoad : out STD_LOGIC
    );
end component;

signal CPU_Enable_Tb : STD_LOGIC := '1';
signal CPU_Clock_Tb, CPU_Reset_Tb : STD_LOGIC := '0';

signal CPU_FlagZero_Tb, CPU_FlagOverflow_Tb, CPU_FlagEquals_Tb: STD_LOGIC := '0';
signal CPU_OpCodeIn_Tb: STD_LOGIC_VECTOR (3 downto 0);
signal CPU_OpCodeOut_Tb, CPU_StateOut_Tb: STD_LOGIC_VECTOR (3 downto 0);

signal CPU_ALUReset_Tb, CPU_ALUExecute_Tb : STD_LOGIC;
signal CPU_ALULoad_Acc_Tb, CPU_ALULoad_Reg_Tb : STD_LOGIC; --ALU function signals

signal CPU_RAMWrite_Tb, CPU_RAMLoad_Tb : STD_LOGIC; --RAM Function signals

signal CPU_PGMCReset_Tb, CPU_PGMCInc_Tb : STD_LOGIC; --Program Counter Function Signals

signal CPU_IRLoad_Tb : STD_LOGIC;
begin
DUT: CPU_Controller
port map(
    CPU_Clock => CPU_Clock_Tb,
    CPU_Enable => CPU_Enable_Tb,
    CPU_Reset => CPU_Reset_Tb,
    CPU_FlagZero => CPU_FlagZero_Tb,
    CPU_FlagOverflow => CPU_FlagOverflow_Tb,
    CPU_FlagEquals => CPU_FlagEquals_Tb,
    CPU_OpCodeIn => CPU_OpCodeIn_Tb,
    CPU_OpCodeOut => CPU_OpCodeOut_Tb,
    CPU_StateOut => CPU_StateOut_Tb,
    CPU_ALUReset => CPU_ALUReset_Tb,
    CPU_ALUExecute => CPU_ALUExecute_Tb,
    CPU_ALULoad_Acc => CPU_ALULoad_Acc_Tb,
    CPU_ALULoad_Reg => CPU_ALULoad_Reg_Tb,
    CPU_RAMWrite => CPU_RAMWrite_Tb,
    CPU_RAMLoad => CPU_RAMLoad_Tb,
    CPU_PGMCReset => CPU_PGMCReset_Tb,
    CPU_PGMCInc => CPU_PGMCInc_Tb,
    CPU_IRLoad => CPU_IRLoad_Tb
    );

CPU_Clock_Tb <= not CPU_Clock_Tb after 5 ns;
CPU_Enable_Tb <= '1';
CPU_OpCodeIn_Tb <= "0000";
CPU_OpCodeIn_Tb <= CPU_OpCodeIn_Tb + '1' after 20 ns;

end TB;