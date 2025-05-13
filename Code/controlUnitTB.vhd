library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ControlUnit_tb is
end entity ;

architecture testbench of ControlUnit_tb is
    -- Constants for opcodes
    constant Rtype : std_logic_vector(5 downto 0) := "000000";
    constant LW    : std_logic_vector(5 downto 0) := "100011";
    constant SW    : std_logic_vector(5 downto 0) := "101011";
    constant Beq   : std_logic_vector(5 downto 0) := "000100";
    constant Jump  : std_logic_vector(5 downto 0) := "000010";
    
    -- Constants for funct codes (R-type)
    constant func_add : std_logic_vector(5 downto 0) := "100000";
    constant func_sub : std_logic_vector(5 downto 0) := "100010";
    constant func_and : std_logic_vector(5 downto 0) := "100100";
    constant func_or  : std_logic_vector(5 downto 0) := "100101";
    constant func_slt : std_logic_vector(5 downto 0) := "101010";

    -- Test signals
    signal clk          : std_logic := '0';
    signal reset        : std_logic := '0';
    signal Opcode       : std_logic_vector(5 downto 0) := (others => '0');
    signal Funct        : std_logic_vector(5 downto 0) := (others => '0');
    signal PCWrite      : std_logic;
    signal PCWriteCond  : std_logic;
    signal IorD         : std_logic;
    signal MemRead      : std_logic;
    signal MemWrite     : std_logic;
    signal MemtoReg     : std_logic;
    signal IRWrite      : std_logic;
    signal PCSource     : std_logic_vector(1 downto 0);
    signal ALUSrcB      : std_logic_vector(1 downto 0);
    signal ALUSrcA      : std_logic;
    signal RegWrite     : std_logic;
    signal RegDst       : std_logic;
    signal ALUControl   : std_logic_vector(3 downto 0);

    -- Clock period definition
    constant clk_period : time := 10 ns;
	
	component ControlUnit is 
		   port(
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


begin
	
    Control_Unit: ControlUnit
        port map (
            clk          => clk,
            reset        => reset,
            Opcode       => Opcode,
            Funct        => Funct,
            PCWrite      => PCWrite,
            PCWriteCond  => PCWriteCond,
            IorD         => IorD,
            MemRead      => MemRead,
            MemWrite     => MemWrite,
            MemtoReg     => MemtoReg,
            IRWrite      => IRWrite,
            PCSource     => PCSource,
            ALUSrcB      => ALUSrcB,
            ALUSrcA      => ALUSrcA,
            RegWrite     => RegWrite,
            RegDst       => RegDst,
            ALUControl   => ALUControl
        );

    -- Clock process
	 process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

 	process
    begin
        -- Reset the system
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;
        
        report "Testing R-type (ADD) instruction";
        Opcode <= Rtype;
        Funct <= func_add;
        wait for clk_period * 4;  
        
        report "Testing LW instruction";
        Opcode <= LW;
        wait for clk_period * 5;  
        
        report "Testing SW instruction";
        Opcode <= SW;
        wait for clk_period * 4;  
        
        report "Testing BEQ instruction";
        Opcode <= Beq;
        wait for clk_period * 3;  
        
        report "Testing JUMP instruction";
        Opcode <= Jump;
        wait for clk_period * 2;
		
        report "Testing R-type (SUB) instruction";
        Opcode <= Rtype;
        Funct <= func_sub;
        wait for clk_period * 4;
        
        report "Testing R-type (AND) instruction";
        Opcode <= Rtype;
        Funct <= func_and;
        wait for clk_period * 4;
        
        report "Testing R-type (OR) instruction";
        Opcode <= Rtype;
        Funct <= func_or;
        wait for clk_period * 4;
        
        report "Testing R-type (SLT) instruction";
        Opcode <= Rtype;
        Funct <= func_slt;
        wait for clk_period * 4; 
		
        report "Testing unknown opcode";
        Opcode <= "111111";
        wait for clk_period * 2;
        
        -- End simulation
        report "All tests completed";
        wait;
    end process;

end architecture ;

