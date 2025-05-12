-- Copyright (c) 2019 David Palma licensed under the MIT license
-- Author: David Palma
-- Project: MIPS32 multi-cycle
-- Module: Top level

library ieee;
use ieee.std_logic_1164.all;

entity TopLevel is
  port( CLK, reset_neg : in std_logic );
end TopLevel;

architecture Behavioral of TopLevel is

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
        CLK          : in  std_logic;
        reset        : in  std_logic;
        Opcode       : in  std_logic_vector(5 downto 0);    -- input in Control Unit
		Funct        : in  std_logic_vector(5 downto 0);    -- input in Alu control##
		
		PCWriteCond  : out std_logic;					    -- BEQ ouput
        PCWrite      : out std_logic;					    -- enable for write data in PC 
        IorD         : out std_logic;						-- selector for Address (data mem)
        MemRead      : out std_logic; 						-- enable for Read data in data mem
        MemWrite     : out std_logic;						-- enable for Write data in data mem
        MemtoReg     : out std_logic;  					-- selector for Write Data in Reg File
        IRWrite      : out std_logic;						-- enable for intsruction 
        PCSource     : out std_logic_vector(1 downto 0); 	-- selector
		
        ALUSrcB      : out std_logic_vector(1 downto 0); 	-- selector	for Second ALU input
        ALUSrcA      : out std_logic;	 					-- selector for first ALU input
        RegWrite     : out std_logic;		 				-- enable for write data in  Reg File
        RegDst       : out std_logic;						-- selector for write reg in Reg file
        ALUControl   : out std_logic_vector(3 downto 0)	 	-- ALU Control selector ##
    );
end component;

component InstructionRegister is
  Port (
		CLK      : in STD_LOGIC;
		reset_neg: in std_logic;
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



component MDR is
  Port (
		clk        : in STD_LOGIC;
		reset_neg  : in std_logic;
        DataIn  : in STD_LOGIC_VECTOR(31 downto 0);
		
        DataOut : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

component Mux2to1 is
  Port (
        input0 : in  std_logic_vector(31 downto 0);
        input1 : in  std_logic_vector(31 downto 0);
        sel    : in  std_logic;
		
        output : out std_logic_vector(31 downto 0)
    );
end component;

component Mux2to1_5 is
  Port (
        input0 : in  std_logic_vector(4 downto 0);
        input1 : in  std_logic_vector(4 downto 0);
        sel    : in  std_logic;
		
        output : out std_logic_vector(4 downto 0)
    );
end component;

component Mux3to1 is
  Port (
        input0 : in  std_logic_vector(31 downto 0);
        input1 : in  std_logic_vector(31 downto 0);	   
		input2 : in  std_logic_vector(31 downto 0);
        sel    : in  std_logic_vector(1 downto 0);
		
        output : out std_logic_vector(31 downto 0)
    );
end component;

component Mux4to1 is
  Port (
        input0 : in  std_logic_vector(31 downto 0);
        input1 : in  std_logic_vector(31 downto 0);	   
		input2 : in  std_logic_vector(31 downto 0);
        input3 : in  std_logic_vector(31 downto 0);
        sel    : in  std_logic_vector(1 downto 0);
		
        output : out std_logic_vector(31 downto 0)
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
	clk : in std_logic;
	reset_neg : in std_logic;
	ReadRegister1 : in std_logic_vector(4 downto 0);
	ReadRegister2 : in std_logic_vector(4 downto 0);
	WriteRegister: in std_logic_vector(4 downto 0);

	WriteData: in std_logic_vector(31 downto 0);
	RegWrite: in std_logic;
	
	ReadData1: out std_logic_vector(31 downto 0);
	ReadData2: out std_logic_vector(31 downto 0)
		);
end component;

component ShiftLeft is
  port( -- input
        input  : in std_logic_vector(31 downto 0);

        -- output
        output : out std_logic_vector(31 downto 0) );
end component;

component ShiftLeft2 is
  port( -- input
        input  : in std_logic_vector(25 downto 0);

        -- output
        output : out std_logic_vector(27 downto 0) );
end component;

component SignExtend is
  port( -- input
        input  : in std_logic_vector(15 downto 0);

        -- output
        output : out std_logic_vector(31 downto 0) );
end component;

component AandBRegisters is
        Port (
		clk      : in STD_LOGIC;
		reset_neg: in std_logic;
        AIn      : in STD_LOGIC_VECTOR(31 downto 0);
        BIn      : in STD_LOGIC_VECTOR(31 downto 0);
		
        AOut     : out STD_LOGIC_VECTOR(31 downto 0);
        BOut     : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

component ALUOut is
  Port (
		clk      : in STD_LOGIC;
	 	reset_neg: in std_logic;
        ALUIn    : in STD_LOGIC_VECTOR(31 downto 0);
        ALUOut   : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

constant PC_increment : std_logic_vector(31 downto 0) := "00000000000000000000000000000100";

-- signals
  signal PC_out, MuxToAddress, MemDataOut, MemoryDataRegOut, InstructionRegOut, MuxToWriteData, ReadData1ToA, ReadData2ToB, RegAToMux, RegBOut, SignExtendOut, ShiftLeft1ToMux4, MuxToAlu, Mux4ToAlu, AluResultOut, AluOutToMux, JumpAddress, MuxToPC : std_logic_vector(31 downto 0);
  signal ZeroCarry_TL, ALUSrcA_TL, RegWrite_TL, RegDst_TL, PCWriteCond_TL, PCWrite_TL, IorD_TL, MemRead_TL, MemWrite_TL, MemToReg_TL, IRWrite_TL, ANDtoOR, ORtoPC : std_logic;
  signal MuxToWriteRegister : std_logic_vector(4 downto 0);
  signal ALUControltoALU : std_logic_vector(3 downto 0);
  signal PCsource_TL, ALUSrcB_TL, ALUOp_TL : std_logic_vector(1 downto 0);
  signal Opcode_Ins   : STD_LOGIC_VECTOR(5 downto 0);
  signal Rs_Ins       : STD_LOGIC_VECTOR(4 downto 0);
  signal Rt_Ins       : STD_LOGIC_VECTOR(4 downto 0);
  signal Rd_Ins       : STD_LOGIC_VECTOR(4 downto 0);
  signal Shamt_Ins    : STD_LOGIC_VECTOR(4 downto 0);
  signal Funct_Ins    : STD_LOGIC_VECTOR(5 downto 0);
  signal Imm_Ins      : STD_LOGIC_VECTOR(15 downto 0);
  --need signal from 25 down to 0
begin

  ANDtoOR <= ZeroCarry_TL and PCWriteCond_TL;
  ORtoPC <= ANDtoOR or PCWrite_TL;
  JumpAddress(31 downto 28) <= PC_out(31 downto 28);

  A_Logic_Unit : ALU                 port map(MuxToAlu, Mux4ToALU, ALUControltoALU, AluResultOut, ZeroCarry_TL);
  CTRL_UNIT    : ControlUnit         port map(CLK, reset_neg, Opcode_Ins, Funct_Ins, PCWriteCond_TL, PCWrite_TL, IorD_TL, MemRead_TL, MemWrite_TL, MemToReg_TL, IRWrite_TL, PCsource_TL, ALUSrcB_TL, ALUSrcA_TL, RegWrite_TL, RegDst_TL ,ALUControltoALU);
  INSTR_REG    : InstructionRegister port map(CLK, reset_neg, IRWrite_TL, MemDataOut, Opcode_Ins, Rs_Ins, Rt_Ins, Rd_Ins, Shamt_Ins, Funct_Ins, Imm_Ins);
  MEM          :entity  Memory              port map(CLK,MuxToAddress,RegBOut,MemWrite_TL,MemRead_TL   , MemDataOut);
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
  SLL2         : ShiftLeft2          port map(input =>InstructionRegOut(25 downto 0), output => JumpAddress(27 downto 0));--instruction needed#####
  AandB        : AandBRegisters      port map(CLK, reset_neg, ReadData1ToA, ReadData2ToB,  RegAToMux, RegBOut);
  ALU_Out      : ALUOut				 port map(CLK, reset_neg, AluResultOut, AluOutToMux);
end Behavioral;