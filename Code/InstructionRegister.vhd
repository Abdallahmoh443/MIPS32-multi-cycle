library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity InstructionRegister is
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
        Imm      : out STD_LOGIC_VECTOR(15 downto 0);
	ShiftLeftOut : out STD_LOGIC_VECTOR(25 downto 0)
    );
end InstructionRegister;

architecture Behavioral of InstructionRegister is
    signal reg : STD_LOGIC_VECTOR(31 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if IRWrite = '1' then
                reg <= InstrIn;
            end if;
        end if;
    end process;
    
    Opcode <= reg(31 downto 26);
    Rs     <= reg(25 downto 21);
    Rt     <= reg(20 downto 16);
    Rd     <= reg(15 downto 11);
    Shamt  <= reg(10 downto 6);
    Funct  <= reg(5 downto 0);
    Imm    <= reg(15 downto 0);
    ShiftLeftOut <= reg(25 downto 0);
end Behavioral;
