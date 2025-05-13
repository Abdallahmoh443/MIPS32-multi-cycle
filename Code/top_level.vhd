library ieee;
use ieee.STD_LOGIC_1164.all;

entity TopLevel is
  port( CLK, reset_neg : in STD_LOGIC );
end TopLevel;

architecture Behavioral of TopLevel is

-- Missing component declaration for ALU
component ALU is
  Port (
        operand_1    : in  STD_LOGIC_VECTOR(31 downto 0);
        operand_2    : in  STD_LOGIC_VECTOR(31 downto 0);
        ALU_control  : in  STD_LOGIC_VECTOR(3 downto 0);
		
        Result       : out STD_LOGIC_VECTOR(31 downto 0);
        Zero         : out STD_LOGIC
    );
end component;


component ControlUnit is
  port (
        CLK          : in  STD_LOGIC;
        reset        : in  STD_LOGIC;
        Opcode       : in  STD_LOGIC_VECTOR(5 downto 0);    -- input in Control Unit
		Funct        : in  STD_LOGIC_VECTOR(5 downto 0);    -- input in Alu control##
		
		PCWriteCond  : out STD_LOGIC;					    -- BEQ ouput
        PCWrite      : out STD_LOGIC;					    -- enable for write data in PC 
        IorD         : out STD_LOGIC;						-- selector for Address (data mem)
        MemRead      : out STD_LOGIC; 						-- enable for Read data in data mem
        MemWrite     : out STD_LOGIC;						-- enable for Write data in data mem
        MemtoReg     : out STD_LOGIC;  					-- selector for Write Data in Reg File
        IRWrite      : out STD_LOGIC;						-- enable for intsruction 
        PCSource     : out STD_LOGIC_VECTOR(1 downto 0); 	-- selector
		
        ALUSrcB      : out STD_LOGIC_VECTOR(1 downto 0); 	-- selector	for Second ALU input
        ALUSrcA      : out STD_LOGIC;	 					-- selector for first ALU input
        RegWrite     : out STD_LOGIC;		 				-- enable for write data in  Reg File
        RegDst       : out STD_LOGIC;						-- selector for write reg in Reg file
        ALUControl   : out STD_LOGIC_VECTOR(3 downto 0)	 	-- ALU Control selector ##
    );
end component;

component InstructionRegister is
  Port (
		CLK      : in STD_LOGIC;
		reset_neg: in STD_LOGIC;
        IRWrite  : in STD_LOGIC;  -- enable
        InstrIn  : in STD_LOGIC_VECTOR(31 downto 0);
		
        Opcode   : out STD_LOGIC_VECTOR(5 downto 0);
        Rs       : out STD_LOGIC_VECTOR(4 downto 0);
        Rt       : out STD_LOGIC_VECTOR(4 downto 0);
        Rd       : out STD_LOGIC_VECTOR(4 downto 0);
        Shamt    : out STD_LOGIC_VECTOR(4 downto 0);
        Funct    : out STD_LOGIC_VECTOR(5 downto 0);
        Imm      : out STD_LOGIC_VECTOR(15 downto 0);
        ShiftLeftOut : out STD_LOGIC_VECTOR(25 downto 0)
    );
end component;

component MDR is
  Port (
		clk        : in STD_LOGIC;
		reset_neg  : in STD_LOGIC;
        DataIn  : in STD_LOGIC_VECTOR(31 downto 0);
		
        DataOut : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

component Mux2to1 is
  Port (
        input0 : in  STD_LOGIC_VECTOR(31 downto 0);
        input1 : in  STD_LOGIC_VECTOR(31 downto 0);
        sel    : in  STD_LOGIC;
		
        output : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

component Mux2to1_5 is
  Port (
        input0 : in  STD_LOGIC_VECTOR(4 downto 0);
        input1 : in  STD_LOGIC_VECTOR(4 downto 0);
        sel    : in  STD_LOGIC;
		
        output : out STD_LOGIC_VECTOR(4 downto 0)
    );
end component;

component Mux3to1 is
  Port (
        input0 : in  STD_LOGIC_VECTOR(31 downto 0);
        input1 : in  STD_LOGIC_VECTOR(31 downto 0);	   
		input2 : in  STD_LOGIC_VECTOR(31 downto 0);
        sel    : in  STD_LOGIC_VECTOR(1 downto 0);
		
        output : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

component Mux4to1 is
  Port (
        input0 : in  STD_LOGIC_VECTOR(31 downto 0);
        input1 : in  STD_LOGIC_VECTOR(31 downto 0);	   
		input2 : in  STD_LOGIC_VECTOR(31 downto 0);
        input3 : in  STD_LOGIC_VECTOR(31 downto 0);
        sel    : in  STD_LOGIC_VECTOR(1 downto 0);
		
        output : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

component ProgramCounter is
  Port (
        clk      : in STD_LOGIC;
        reset_neg: in STD_LOGIC;
		NextPC   : in STD_LOGIC_VECTOR(31 downto 0);
        PCWrite  : in STD_LOGIC;
        
        CurrentPC : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

component Registers is
  port (
	clk : in STD_LOGIC;
	reset_neg : in STD_LOGIC;
	ReadRegister1 : in STD_LOGIC_VECTOR(4 downto 0);
	ReadRegister2 : in STD_LOGIC_VECTOR(4 downto 0);
	WriteRegister: in STD_LOGIC_VECTOR(4 downto 0);

	WriteData: in STD_LOGIC_VECTOR(31 downto 0);
	RegWrite: in STD_LOGIC;
	
	ReadData1: out STD_LOGIC_VECTOR(31 downto 0);
	ReadData2: out STD_LOGIC_VECTOR(31 downto 0)
		);
end component;

component ShiftLeft is
  port( -- input
        input  : in STD_LOGIC_VECTOR(31 downto 0);

        -- output
        output : out STD_LOGIC_VECTOR(31 downto 0) );
end component;

component ShiftLeft2 is
  port( -- input
        input  : in STD_LOGIC_VECTOR(25 downto 0);

        -- output
        output : out STD_LOGIC_VECTOR(27 downto 0) );
end component;

component SignExtend is
  port( -- input
        input  : in STD_LOGIC_VECTOR(15 downto 0);

        -- output
        output : out STD_LOGIC_VECTOR(31 downto 0) );
end component;

component AandBRegisters is
        Port (
		clk      : in STD_LOGIC;
		reset_neg: in STD_LOGIC;
        AIn      : in STD_LOGIC_VECTOR(31 downto 0);
        BIn      : in STD_LOGIC_VECTOR(31 downto 0);
		
        AOut     : out STD_LOGIC_VECTOR(31 downto 0);
        BOut     : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

component ALUOut is
  Port (
		clk      : in STD_LOGIC;
	 	reset_neg: in STD_LOGIC;
        ALUIn    : in STD_LOGIC_VECTOR(31 downto 0);
        ALUOut   : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

component OrGate is
  port(
	a , b :in STD_LOGIC;
	c : out STD_LOGIC
	);
end component;


component andGate is
  port(
	a , b :in STD_LOGIC;
	c : out STD_LOGIC
	);
end component;

component Memory is
    port (
        clk: in std_logic;
        address : in std_logic_vector(31 downto 0);
        dataIn : in std_logic_vector(31 downto 0);
        MemWrite : in std_logic;
        MemRead : in std_logic;
        dataOut : out std_logic_vector(31 downto 0)
    );
end component;

constant PC_increment : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000100";

-- signals
  signal PC_out, MuxToAddress, MemDataOut, MemoryDataRegOut, InstructionRegOut, MuxToWriteData, ReadData1ToA, ReadData2ToB, RegAToMux, RegBOut, SignExtendOut, ShiftLeft1ToMux4, MuxToAlu, Mux4ToAlu, AluResultOut, AluOutToMux, JumpAddress, MuxToPC : STD_LOGIC_VECTOR(31 downto 0);
  signal ZeroCarry_TL, ALUSrcA_TL, RegWrite_TL, RegDst_TL, PCWriteCond_TL, PCWrite_TL, IorD_TL, MemRead_TL, MemWrite_TL, MemToReg_TL, IRWrite_TL, ANDtoOR, ORtoPC : STD_LOGIC;
  signal ShiftLeftOutput: STD_LOGIC_VECTOR(25 downto 0);
  signal Imm_Ins        : STD_LOGIC_VECTOR(15 downto 0);
  signal Funct_Ins, Opcode_Ins      : STD_LOGIC_VECTOR(5 downto 0);
  signal MuxToWriteRegister, Rs_Ins, Rt_Ins, Rd_Ins, Shamt_Ins : STD_LOGIC_VECTOR(4 downto 0);
  signal ALUControltoALU : STD_LOGIC_VECTOR(3 downto 0);
  signal PCsource_TL, ALUSrcB_TL : STD_LOGIC_VECTOR(1 downto 0);
  
  -- Fix: Removed ALUOp_TL signal as it's not used and would cause confusion
  
begin

  -- Fixed the jump address concatenation
  JumpAddress(31 downto 28) <= PC_out(31 downto 28);
  
  -- Direct component instantiation to ensure proper connections
  A_Logic_Unit : ALU                 port map(MuxToAlu, Mux4ToALU, ALUControltoALU, AluResultOut, ZeroCarry_TL);
  CTRL_UNIT    : ControlUnit         port map(CLK, reset_neg, Opcode_Ins, Funct_Ins, PCWriteCond_TL, PCWrite_TL, IorD_TL, MemRead_TL, MemWrite_TL, MemToReg_TL, IRWrite_TL, PCsource_TL, ALUSrcB_TL, ALUSrcA_TL, RegWrite_TL, RegDst_TL, ALUControltoALU);
  INSTR_REG    : InstructionRegister port map(CLK, reset_neg, IRWrite_TL, MemDataOut, Opcode_Ins, Rs_Ins, Rt_Ins, Rd_Ins, Shamt_Ins, Funct_Ins, Imm_Ins, ShiftLeftOutput);
  
  -- Fixed Memory component instantiation (removed entity keyword)
  MEM          : Memory              port map(CLK, MuxToAddress, RegBOut, MemWrite_TL, MemRead_TL, MemDataOut);
  MEM_DATA_REG : MDR                 port map(CLK, reset_neg, MemDataOut, MemoryDataRegOut);
  MUX_1        : Mux2to1             port map(PC_out, AluOutToMux, IorD_TL, MuxToAddress);
  MUX_2        : Mux2to1_5           port map(Rt_Ins, Rd_Ins, RegDst_TL, MuxToWriteRegister);
  MUX_3        : Mux2to1             port map(AluOutToMux, MemoryDataRegOut, MemToReg_TL, MuxToWriteData);
  MUX_4        : Mux2to1             port map(PC_out, RegAToMux, ALUSrcA_TL, MuxToAlu);
  MUX_5        : Mux4to1             port map(RegBOut, PC_increment, SignExtendOut, ShiftLeft1ToMux4, ALUSrcB_TL, Mux4ToAlu);
  MUX_6        : Mux3to1             port map(AluResultOut, AluOutToMux, JumpAddress, PCsource_TL, MuxToPC);
  PC           : ProgramCounter      port map(CLK, reset_neg, MuxToPC, ORtoPC, PC_out);
  REG          : Registers           port map(CLK, reset_neg, Rs_Ins, Rt_Ins, MuxToWriteRegister, MuxToWriteData, RegWrite_TL, ReadData1ToA, ReadData2ToB);
  SE           : SignExtend          port map(Imm_Ins, SignExtendOut);
  SLL1         : ShiftLeft           port map(SignExtendOut, ShiftLeft1ToMux4);
  SLL2         : ShiftLeft2          port map(ShiftLeftOutput, JumpAddress(27 downto 0));
  AandB        : AandBRegisters      port map(CLK, reset_neg, ReadData1ToA, ReadData2ToB, RegAToMux, RegBOut);
  ALU_Out      : ALUOut              port map(CLK, reset_neg, AluResultOut, AluOutToMux);
  AND_Gate     : andGate             port map(ZeroCarry_TL, PCWriteCond_TL, ANDtoOR);
  OR_Gate      : orGate              port map(ANDtoOR, PCWrite_TL, ORtoPC);
end Behavioral;