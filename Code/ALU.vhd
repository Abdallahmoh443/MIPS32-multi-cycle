library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
        operand_1    : in  STD_LOGIC_VECTOR(31 downto 0);
        operand_2    : in  STD_LOGIC_VECTOR(31 downto 0);
        ALU_control  : in  STD_LOGIC_VECTOR(3 downto 0);
		
        Result       : out STD_LOGIC_VECTOR(31 downto 0);
        Zero         : out STD_LOGIC
    );
end entity;

architecture Behavior of ALU is
    signal ALUResult : STD_LOGIC_VECTOR(31 downto 0);
begin

       with ALU_control select
	    ALUResult <= 
	        std_logic_vector(unsigned(operand_1) + unsigned(operand_2))   when "0000",   
	        std_logic_vector(unsigned(operand_1) - unsigned(operand_2))   when "0001",  
	        operand_1 and operand_2    when "0010",  
	        operand_1 or operand_2     when "0011",   
	        operand_1 nor operand_2    when "0100",  
	        operand_1 nand operand_2    when "0101",   
	        operand_1 xor operand_2     when "0110",   
	        std_logic_vector(shift_left(unsigned(operand_1), to_integer(unsigned(operand_2(4 downto 0)))))  when "0111",   
	        std_logic_vector(shift_right(unsigned(operand_1), to_integer(unsigned(operand_2(4 downto 0))))) when "1000",  
	        (31 downto 1 => '0') & '1'   when "1001", 
	        (others => '0')    when others;
	
    Result <= ALUResult;

  
    Zero <= '1' when ALUResult = x"00000000" else '0';
    

end architecture;  

	   