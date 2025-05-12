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
	constant alu_Add : std_logic_vector(3 downto 0 ) :="0000";	 
	constant alu_sub : std_logic_vector(3 downto 0 ) :="0001";
	constant alu_and : std_logic_vector(3 downto 0 ) :="0010";
	constant alu_or :  std_logic_vector(3 downto 0 ) :="0011";
	constant alu_nor : std_logic_vector(3 downto 0 ) :="0100";
	constant alu_xor : std_logic_vector(3 downto 0 ) :="0110"; 
	constant alu_slt : std_logic_vector(3 downto 0 ) :="1001";
	constant alu_sll : std_logic_vector(3 downto 0 ) :="0111";
	constant alu_srl : std_logic_vector(3 downto 0 ) :="1000";
	
	
	constant funct_add : std_logic_vector(5 downto 0) := "100000";  
	constant funct_sub : std_logic_vector(5 downto 0) := "100010";
	constant funct_and : std_logic_vector(5 downto 0) := "100100";
	constant funct_or : std_logic_vector(5 downto 0) := "100101";
	constant funct_nor : std_logic_vector(5 downto 0) := "100111";
   	constant funct_xor : std_logic_vector(5 downto 0) := "100110";
	constant funct_slt : std_logic_vector(5 downto 0) := "101010";
	constant funct_sll : std_logic_vector(5 downto 0) := "000000";
	constant funct_srl : std_logic_vector(5 downto 0) := "000010";  
	
begin
    process(aluop, funct)
    begin
        case aluop is 
            when "00" =>   --Adding
                alucontrol <= alu_Add;
            when "01" =>	--Substract
                alucontrol <= alu_sub;
            when "10" =>	--Rtype
                case funct is
                    when funct_add =>
					alucontrol <= alu_Add;  -- add
                    when funct_sub =>
					alucontrol <= alu_sub;  -- subtract
                    when funct_and =>
					alucontrol <= alu_and;  -- and
                    when funct_or  =>
					alucontrol <= alu_or ;   -- or
                    when funct_slt =>
					alucontrol <= alu_slt;  -- set less than
					when funct_nor =>
					alucontrol <= alu_nor ;  
					when funct_xor =>
					alucontrol <= alu_xor; 
					when funct_sll =>
					alucontrol <= alu_sll;
					when  funct_srl =>
					alucontrol <= alu_srl  ;
                    when others   =>
					alucontrol <= alu_Add;  -- default to add
                end case;
                
            when others =>
                alucontrol <= "0010";
        end case;
    end process;
end architecture ;