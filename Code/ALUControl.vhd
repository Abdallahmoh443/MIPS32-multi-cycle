library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUControl is
    port (
        AlUOp      : in  std_logic_vector(1 downto 0);
        funct      : in  std_logic_vector(5 downto 0);
        ALUcontrol : out std_logic_vector(3 downto 0)
    );
end entity ;

architecture behavioral of ALUControl is
    -- function codes for r-type instructions
    constant func_add   : std_logic_vector(5 downto 0) := "100000";
    constant func_sub   : std_logic_vector(5 downto 0) := "100010";
    constant func_and   : std_logic_vector(5 downto 0) := "100100";
    constant func_or    : std_logic_vector(5 downto 0) := "100101";
    constant func_slt   : std_logic_vector(5 downto 0) := "101010";  -- set less than
    
    -- alu operation codes
    constant ALU_add    : std_logic_vector(3 downto 0) := "0010";  -- addition
    constant ALU_sub    : std_logic_vector(3 downto 0) := "0110";  -- subtraction
    constant ALU_and    : std_logic_vector(3 downto 0) := "0000";  -- bitwise and
    constant ALU_or     : std_logic_vector(3 downto 0) := "0001";  -- bitwise or
    constant ALU_slt    : std_logic_vector(3 downto 0) := "0111";  -- set less than (a < b)
begin
    process(aluop, funct)
    begin
        case aluop is
            when "00" =>   --Adding
                alucontrol <= alu_add;
            when "01" =>	--Substract
                alucontrol <= alu_sub;
            when "10" =>	--Rtype
                case funct is
                    when func_add =>
					alucontrol <= alu_add;  -- add
                    when func_sub =>
					alucontrol <= alu_sub;  -- subtract
                    when func_and =>
					alucontrol <= alu_and;  -- and
                    when func_or  =>
					alucontrol <= alu_or;   -- or
                    when func_slt =>
					alucontrol <= alu_slt;  -- set less than
                    when others   =>
					alucontrol <= alu_add;  -- default to add
                end case;
                
            when others =>
                alucontrol <= alu_add;
        end case;
    end process;
end architecture ;