library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALUControl is
    Port (
        ALUOp      : in STD_LOGIC_VECTOR(1 downto 0);
        Funct      : in STD_LOGIC_VECTOR(5 downto 0);
        ALUControl : out STD_LOGIC_VECTOR(3 downto 0)
    );
end ALUControl;

architecture Behavioral of ALUControl is
    -- Function codes for R-type
    constant FUNC_ADD   : STD_LOGIC_VECTOR(5 downto 0) := "100000";
    constant FUNC_SUB   : STD_LOGIC_VECTOR(5 downto 0) := "100010";
    constant FUNC_AND   : STD_LOGIC_VECTOR(5 downto 0) := "100100";
    constant FUNC_OR    : STD_LOGIC_VECTOR(5 downto 0) := "100101";
    constant FUNC_SLT   : STD_LOGIC_VECTOR(5 downto 0) := "101010";
    
    -- ALU operation codes
    constant ALU_ADD    : STD_LOGIC_VECTOR(3 downto 0) := "0010";
    constant ALU_SUB    : STD_LOGIC_VECTOR(3 downto 0) := "0110";
    constant ALU_AND    : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    constant ALU_OR     : STD_LOGIC_VECTOR(3 downto 0) := "0001";
    constant ALU_SLT    : STD_LOGIC_VECTOR(3 downto 0) := "0111";
begin
    process(ALUOp, Funct)
    begin
        case ALUOp is
            when "00" =>
			ALUControl <= ALU_ADD;  -- ADD for memory address calculation
            when "01" =>
			ALUControl <= ALU_SUB;  -- SUB for branch comparison
            when "10" => -- R-type operations
                case Funct is
                    when FUNC_ADD => 
					ALUControl <= ALU_ADD;
                    when FUNC_SUB =>
					ALUControl <= ALU_SUB;
                    when FUNC_AND =>
					ALUControl <= ALU_AND;
                    when FUNC_OR  =>
					ALUControl <= ALU_OR;
                    when FUNC_SLT =>
					ALUControl <= ALU_SLT;
                    when others   =>
					ALUControl <= ALU_ADD; -- Default to ADD
                end case;
            when others => ALUControl <= ALU_ADD; -- Default to ADD
        end case;
    end process;
end Behavioral;