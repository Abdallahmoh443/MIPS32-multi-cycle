library ieee;
use ieee.std_logic_1164.all;

entity top_level is
  port( CLK, reset_neg : in std_logic );
end top_level;

architecture Behavioral of top_level is	 
component ALU is
	Port (
        A          : in  STD_LOGIC_VECTOR(31 downto 0);
        B          : in  STD_LOGIC_VECTOR(31 downto 0);
        ALUControl : in  STD_LOGIC_VECTOR(3 downto 0);
        Result     : out STD_LOGIC_VECTOR(31 downto 0);
        Zero       : out STD_LOGIC
    );
end component;

component ALUControl  is
	Port (
        ALUOp      : in STD_LOGIC_VECTOR(1 downto 0);
        Funct      : in STD_LOGIC_VECTOR(5 downto 0);
        ALUControl : out STD_LOGIC_VECTOR(3 downto 0)
    );
end component;

component ControlUnit  is
	 Port (
        clk          : in STD_LOGIC;
        reset        : in STD_LOGIC;
        Opcode       : in STD_LOGIC_VECTOR(5 downto 0);
        Funct        : in STD_LOGIC_VECTOR(5 downto 0);
		
        PCWrite      : out STD_LOGIC;
        PCWriteCond  : out STD_LOGIC;
        IorD         : out STD_LOGIC;
        MemRead      : out STD_LOGIC;
        MemWrite     : out STD_LOGIC;
        MemtoReg     : out STD_LOGIC;
        IRWrite      : out STD_LOGIC;
        PCSource     : out STD_LOGIC_VECTOR(1 downto 0);
        ALUSrcB      : out STD_LOGIC_VECTOR(1 downto 0);
        ALUSrcA      : out STD_LOGIC;
        RegWrite     : out STD_LOGIC;
        RegDst       : out STD_LOGIC;
        ALUControl   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end component; 

component InstructionRegister  is
	 Port (
        clk      : in STD_LOGIC;
        IRWrite  : in STD_LOGIC;  -- enable
        InstrIn  : in STD_LOGIC_VECTOR(31 downto 0);
		
        Opcode   : out STD_LOGIC_VECTOR(5 downto 0);
        Rs       : out STD_LOGIC_VECTOR(4 downto 0);
        Rt       : out STD_LOGIC_VECTOR(4 downto 0);
        Rd       : out STD_LOGIC_VECTOR(4 downto 0);
        Shamt    : out STD_LOGIC_VECTOR(4 downto 0);
        Funct    : out STD_LOGIC_VECTOR(5 downto 0);
        Imm      : out STD_LOGIC_VECTOR(15 downto 0)
    );
end component;

component Memory   is
	   port (
        clk: in std_logic;
        address : in std_logic_vector(31 downto 0);
        dataIn : in std_logic_vector(31 downto 0); -- Data to write [used only with "SW"]

        -- Control Signals
        MemWrite : in std_logic;
        MemRead : in std_logic;
        
        -- Output Data [Data or Instructions]
        dataOut : out std_logic_vector(31 downto 0)
	);
end component;

component Mux2to1   is
	 Port (
        input0 : in  std_logic_vector(31 downto 0);
        input1 : in  std_logic_vector(31 downto 0);
        sel    : in  std_logic;
		
        output : out std_logic_vector(31 downto 0)
    );
end component;

component Mux2to1_5   is
	 Port (
        input0 : in  std_logic_vector(4 downto 0);
        input1 : in  std_logic_vector(4 downto 0);
        sel    : in  std_logic;
		
        output : out std_logic_vector(4 downto 0)
    );
end component;

component Mux3to1   is
	  Port (
        input0 : in  std_logic_vector(31 downto 0);
        input1 : in  std_logic_vector(31 downto 0);	   
		input2 : in  std_logic_vector(31 downto 0);
        sel    : in  std_logic_vector(1 downto 0);
		
        output : out std_logic_vector(31 downto 0)
    );
end component;

component Mux4to1   is
	 Port (
        input0 : in  std_logic_vector(31 downto 0);
        input1 : in  std_logic_vector(31 downto 0);	   
		input2 : in  std_logic_vector(31 downto 0);
        input3 : in  std_logic_vector(31 downto 0);
        sel    : in  std_logic_vector(1 downto 0);
		
        output : out std_logic_vector(31 downto 0)
    );
end component;

component Registers    is
	 port (
		clk,RegWrite,reset: in std_logic;
		ReadRegister1,ReadRegister2,WriteRegister: in std_logic_vector(4 downto 0);
		
		WriteData: in std_logic_vector(31 downto 0);
		ReadData1,ReadData2: out std_logic_vector(31 downto 0)
		);
end component;

component ShiftLeft  is
	
end component;

component ShiftLeft2  is
	   Port (
		input  : in  std_logic_vector(31 downto 0);
	
        output : out std_logic_vector(31 downto 0)
    );
end component; 

component S_Extend  is
	   Port (
		input  : in  std_logic_vector(15 downto 0);
	
        output : out std_logic_vector(31 downto 0)
    );
end component;

component AandBRegisters  is
		Port (
        clk    : in STD_LOGIC;
        AIn    : in STD_LOGIC_VECTOR(31 downto 0);
        BIn    : in STD_LOGIC_VECTOR(31 downto 0);
		
        AOut   : out STD_LOGIC_VECTOR(31 downto 0);
        BOut   : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

component MDR  is
		Port (
        clk     : in STD_LOGIC;
        DataIn  : in STD_LOGIC_VECTOR(31 downto 0);
		
        DataOut : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

component ALUOut  is
		Port (
        clk     : in STD_LOGIC;
        ALUIn   : in STD_LOGIC_VECTOR(31 downto 0);
		
        ALUOut  : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component; 		


component ProgramCounter  is
		Port (
        clk      : in STD_LOGIC;
        reset    : in STD_LOGIC;
        PCWrite  : in STD_LOGIC;
        NextPC   : in STD_LOGIC_VECTOR(31 downto 0);  
		
        CurrentPC : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component; 


constant PC_increment : std_logic_vector(31 downto 0) := "00000000000000000000000000000100";

 -- signals
  signal PC_out, MuxToAddress, MemDataOut, MemoryDataRegOut, InstructionRegOut, MuxToWriteData, ReadData1ToA, ReadData2ToB, RegAToMux, RegBOut, SignExtendOut, ShiftLeft1ToMux4, MuxToAlu, Mux4ToAlu, AluResultOut, AluOutToMux, JumpAddress, MuxToPC : std_logic_vector(31 downto 0);
  signal ZeroCarry_TL, ALUSrcA_TL, RegWrite_TL, RegDst_TL, PCWriteCond_TL, PCWrite_TL, IorD_TL, MemRead_TL, MemWrite_TL, MemToReg_TL, IRWrite_TL, ANDtoOR, ORtoPC : std_logic;
  signal MuxToWriteRegister : std_logic_vector(4 downto 0);
  signal ALUControltoALU : std_logic_vector(3 downto 0);
  signal PCsource_TL, ALUSrcB_TL, ALUOp_TL : std_logic_vector(1 downto 0);

  
begin	
  -- Program Counter
PC: ProgramCounter port map (
    clk => clk,                         -- Clock signal
    reset => reset,                     -- Reset signal
    PCWrite => PCWrite_actual,          -- PC write enable (combined from PCWrite and PCWriteCond)
    NextPC => pcsource_mux_out,         -- Next PC value (from PCSource mux)
    CurrentPC => PC_current             -- Current PC value output
);

-- Instruction Memory (Main Memory)
Mem: Memory port map (
    clk => clk,                         -- Clock signal
    address => mem_address,             -- Memory address (from IorD mux)
    dataIn => b_out,                    -- Data to write (from B register)
    MemWrite => MemWrite,               -- Memory write enable
    MemRead => MemRead,                 -- Memory read enable
    dataOut => mem_data_out             -- Memory data output
);

-- Memory Data Register
MDR_inst: MDR port map (
    clk => clk,                         -- Clock signal
    DataIn => mem_data_out,             -- Data from memory
    DataOut => mdr_data                 -- Latched memory data output
);

-- Instruction Register
IR: InstructionRegister port map (
    clk => clk,                         -- Clock signal
    IRWrite => IRWrite,                 -- IR write enable
    InstrIn => mem_data_out,            -- Instruction input from memory
    Opcode => opcode,                   -- Opcode field [31-26]
    Rs => rs,                           -- Rs register address [25-21]
    Rt => rt,                           -- Rt register address [20-16]
    Rd => rd,                           -- Rd register address [15-11]
    Shamt => open,                      -- Shift amount [10-6] (not used)
    Funct => funct,                     -- Function code [5-0]
    Imm => imm                          -- Immediate value [15-0]
);

-- Control Unit
Control: ControlUnit port map (
    clk => clk,                         -- Clock signal
    reset => reset,                     -- Reset signal
    Opcode => opcode,                   -- Instruction opcode
    Funct => funct,                     -- Instruction function code
    PCWrite => PCWrite,                 -- PC write enable
    PCWriteCond => PCWriteCond,         -- PC write conditional
    IorD => IorD,                       -- Instruction or Data memory select
    MemRead => MemRead,                 -- Memory read enable
    MemWrite => MemWrite,               -- Memory write enable
    MemtoReg => MemtoReg,               -- Memory to register mux select
    IRWrite => IRWrite,                 -- IR write enable
    PCSource => PCSource,               -- PC source select
    ALUSrcB => ALUSrcB,                 -- ALU B input source select
    ALUSrcA => ALUSrcA,                 -- ALU A input source select
    RegWrite => RegWrite,               -- Register file write enable
    RegDst => RegDst,                   -- Register destination select
    ALUControl => alu_control           -- ALU control signals
);

-- Register File
Registers_inst: Registers port map (
    clk => clk,                         -- Clock signal
    RegWrite => RegWrite,               -- Register write enable
    reset => reset,                     -- Reset signal
    ReadRegister1 => rs,                -- First read register address
    ReadRegister2 => rt,                -- Second read register address
    WriteRegister => write_register,    -- Write register address
    WriteData => write_data,            -- Data to write to register
    ReadData1 => read_data1,            -- First read data output
    ReadData2 => read_data2             -- Second read data output
);

-- A and B Registers
AB_Regs: AandBRegisters port map (
    clk => clk,                         -- Clock signal
    AIn => read_data1,                  -- A input from register file
    BIn => read_data2,                  -- B input from register file
    AOut => a_out,                      -- A register output
    BOut => b_out                       -- B register output
);

-- ALU
ALU_inst: ALU port map (
    A => alu_src_a,                     -- ALU A input
    B => alu_src_b,                     -- ALU B input
    ALUControl => alu_control,          -- ALU control signals
    Result => alu_result,               -- ALU result output
    Zero => alu_zero                    -- ALU zero flag
);

-- ALUOut Register
ALUOut_inst: ALUOut port map (
    clk => clk,                         -- Clock signal
    ALUIn => alu_result,                -- ALU result input
    ALUOut => alu_out                   -- Latched ALU result output
);

-- ALU Control
ALUControl_inst: ALUControl port map (
    ALUOp => ALUOp,                     -- ALUOp from control unit
    Funct => funct,                     -- Function code from instruction
    ALUControl => alu_control           -- ALU control signals output
);

-- Sign Extend
SignExtend_inst: S_Extend port map (
    input => imm,                       -- 16-bit immediate input
    output => sign_extended             -- 32-bit sign-extended output
);

-- Shift Left 2 (for branch address calculation)
ShiftLeft2_inst: ShiftLeft2 port map (
    input => sign_extended,             -- Sign-extended immediate input
    output => shifted_imm               -- Shifted output (imm << 2)
);

-- IorD Mux (Instruction or Data memory address select)
IorD_Mux: Mux2to1 port map (
    input0 => PC_current,               -- PC address input
    input1 => alu_out,                  -- ALU result address input
    sel => IorD,                        -- Select signal from control
    output => mem_address               -- Memory address output
);

-- RegDst Mux (Register destination select)
RegDst_Mux: Mux2to1_5 port map (
    input0 => rt,                       -- Rt register input
    input1 => rd,                       -- Rd register input
    sel => RegDst,                      -- Select signal from control
    output => write_register            -- Write register output
);

-- MemtoReg Mux (Memory to register data select)
MemtoReg_Mux: Mux2to1 port map (
    input0 => alu_out,                  -- ALU result input
    input1 => mdr_data,                 -- Memory data input
    sel => MemtoReg,                    -- Select signal from control
    output => write_data                -- Register write data output
);

-- ALUSrcA Mux (ALU A input select)
ALUSrcA_Mux: Mux2to1 port map (
    input0 => PC_current,               -- PC value input
    input1 => a_out,                    -- A register input
    sel => ALUSrcA,                     -- Select signal from control
    output => alu_src_a                 -- ALU A input output
);

-- ALUSrcB Mux (ALU B input select)
ALUSrcB_Mux: Mux4to1 port map (
    input0 => b_out,                    -- B register input
    input1 => x"00000004",              -- Constant 4 input (for PC+4)
    input2 => sign_extended,            -- Sign-extended immediate input
    input3 => shifted_imm,              -- Shifted immediate input
    sel => ALUSrcB,                     -- Select signal from control
    output => alu_src_b                 -- ALU B input output
);

-- PCSource Mux (Next PC value select)
PCSource_Mux: Mux3to1 port map (
    input0 => alu_result,               -- ALU result (PC+4) input
    input1 => alu_out,                  -- ALUOut (branch target) input
    input2 => jump_address,             -- Jump address input
    sel => PCSource,                    -- Select signal from control
    output => pcsource_mux_out          -- Next PC value output
);
	  
end Behavioral;
  	 
	  