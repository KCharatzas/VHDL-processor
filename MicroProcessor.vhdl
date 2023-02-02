library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity MicroProcessor is
Port(
    uP_ExternalDataIn: in STD_LOGIC_VECTOR (7 downto 0); --External inputs to the uP controller
    uP_Enable, uP_Reset: in STD_LOGIC; --Enable and Reset signals
    uP_Clock : in STD_LOGIC; --Clock signal
    uP_ExternalDataOut: out STD_LOGIC_VECTOR (7 downto 0); --Allows Accumulator (ACC) to be read externally
    uP_DataReg_DataOut: out STD_LOGIC_VECTOR (7 downto 0); --Allows DataReg to be read externally
    uP_CurrentState : out STD_LOGIC_VECTOR (3 downto 0); --Used for debugging/testbench purposes
    uP_PGMC_Debug_Out : out STD_LOGIC_VECTOR (3 downto 0); --Used for debugging/testbench purposes
    uP_CPU_ALUExecuteDEBUG : out STD_LOGIC --Used for debugging/testbench purposes
);
end MicroProcessor;

architecture Behavioral of MicroProcessor is
--These signals act like wires (or busses), carrying data between the internal components of the uP
Signal BUS_OpCode_CPU_ALU: STD_LOGIC_VECTOR (3 downto 0);
Signal BUS_DataAddress: STD_LOGIC_VECTOR (3 downto 0);
Signal BUS_OpCode_IR_CPU: STD_LOGIC_VECTOR (3 downto 0);
Signal BUS_InstructionCount_UPC_ROM: STD_LOGIC_VECTOR (3 downto 0);
Signal BUS_ALU_RAM: STD_LOGIC_VECTOR (7 downto 0);
Signal BUS_ALU_DREG: STD_LOGIC_VECTOR (7 downto 0);
Signal BUS_ALU_PGMC: STD_LOGIC_VECTOR (3 downto 0);
Signal BUS_ROM_IR: STD_LOGIC_VECTOR (7 downto 0);
Signal BUS_ACC_MUX: STD_LOGIC_VECTOR (7 downto 0);
Signal BUS_MUX_RAM: STD_LOGIC_VECTOR (7 downto 0);
Signal SIG_ResetALU: STD_LOGIC;
Signal SIG_ExecuteALU: STD_LOGIC;
Signal SIG_FlagEquals: STD_LOGIC;
Signal SIG_FlagOverflow: STD_LOGIC;
Signal SIG_FlagZero: STD_LOGIC;
Signal SIG_LoadAcc_CPU_ALU: STD_LOGIC;
Signal SIG_LoadDR_CPU_ALU: STD_LOGIC;
Signal SIG_LoadIR_CPU_IR: STD_LOGIC;
Signal SIG_RAMWriteEnable_CPU_RAM: STD_LOGIC;
Signal SIG_RAMLoad_CPU_RAM: STD_LOGIC;
Signal SIG_ResetPrgmCount_CPU_PGMC: STD_LOGIC;
Signal SIG_IncPrgmCount_CPU_PGMC: STD_LOGIC;
Signal SIG_JumpPrgmCount_CPU_PGMC: STD_LOGIC;

begin
ProgramCounter : entity work.PgmCounter
port map ( 
    PGMC_Enable => SIG_IncPrgmCount_CPU_PGMC,
    PGMC_Reset => SIG_ResetPrgmCount_CPU_PGMC,
    PGMC_Override => SIG_JumpPrgmCount_CPU_PGMC,
    PGMC_CountOut_CPU => BUS_InstructionCount_UPC_ROM,
    PGMC_CountOut_DEBUG => uP_PGMC_Debug_Out,
    PGMC_CountIn => BUS_ALU_PGMC
);

ROM : entity work.ROM
port map (
    ROM_Address => BUS_InstructionCount_UPC_ROM,
    ROM_Value => BUS_ROM_IR
);

IR : entity work.In_Reg
port map (
    D => BUS_ROM_IR,
    E => SIG_LoadIR_CPU_IR,
    OpCode => BUS_OpCode_IR_CPU,
    DataAdd => BUS_DataAddress
);

CPU : entity work.CPU_Controller
port map (
    CPU_Clock => uP_Clock,
    CPU_Enable => uP_Enable,
    CPU_Reset => uP_Reset,
    CPU_FlagZero => SIG_FlagZero, 
    CPU_FlagEquals => SIG_FlagEquals, 
    CPU_FlagOverflow => SIG_FlagOverflow,
    CPU_OpCodeIn => BUS_OpCode_IR_CPU,
    CPU_OpCodeOut => BUS_OpCode_CPU_ALU,
    CPU_StateOut => uP_CurrentState,
    CPU_ALUReset => SIG_ResetALU,
    CPU_ALUExecute => SIG_ExecuteALU,
    CPU_ALUExecuteDEBUG => uP_CPU_ALUExecuteDEBUG,
    CPU_ALULoad_Acc => SIG_LoadAcc_CPU_ALU,
    CPU_ALULoad_Reg => SIG_LoadDR_CPU_ALU,
    CPU_RAMWrite => SIG_RAMWriteEnable_CPU_RAM,
    CPU_RAMLoad => SIG_RAMLoad_CPU_RAM,
    CPU_PGMCReset => SIG_ResetPrgmCount_CPU_PGMC, 
    CPU_PGMCInc => SIG_IncPrgmCount_CPU_PGMC,
    CPU_PGMCJump => SIG_JumpPrgmCount_CPU_PGMC,
    CPU_IRLoad => SIG_LoadIR_CPU_IR
); 

ALU : entity work.ALU
port map (
    ALU_OpCode => BUS_OpCode_CPU_ALU,
    ALU_DataReg_DataIn => BUS_ALU_DREG,
    ALU_DataReg_DataOut => uP_DataReg_DataOut,
    ALU_DataReg_4BitDataOut => BUS_ALU_PGMC,
    ALU_ACCDataIn => BUS_ALU_RAM,
    ALU_DataRegLoad => SIG_LoadDR_CPU_ALU,
    ALU_ACCLoad => SIG_LoadAcc_CPU_ALU,
    ALU_Execute => SIG_ExecuteALU,
    ALU_Reset => SIG_ResetALU,
    ALU_ACCDataOut => BUS_ACC_MUX,
    ALU_ExternalOut => uP_ExternalDataOut,
    ALU_FlagZero => SIG_FlagZero,
    ALU_FlagOverflow => SIG_FlagOverflow,
    ALU_FlagEquals => SIG_FlagEquals
);

MUX : entity work.Mux1
port map (
    InACC => BUS_ACC_MUX,
    InEXT => uP_ExternalDataIn,
    LoadRAM => SIG_RAMLoad_CPU_RAM,
    OutRAM => BUS_MUX_RAM
);

RAM : entity work.RAM
port map (
    RAM_Address => BUS_DataAddress,
    RAM_Value => BUS_MUX_RAM,
    RAM_WriteEnable => SIG_RAMWriteEnable_CPU_RAM,
    RAM_DataReg_Out => BUS_ALU_DREG,
    RAM_ACC_Out => BUS_ALU_RAM
);

end Behavioral;