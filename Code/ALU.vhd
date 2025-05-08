library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
        A          : in  STD_LOGIC_VECTOR(31 downto 0);
        B          : in  STD_LOGIC_VECTOR(31 downto 0);
        ALUControl : in  STD_LOGIC_VECTOR(3 downto 0);
        Result     : out STD_LOGIC_VECTOR(31 downto 0);
        Zero       : out STD_LOGIC
    );
end entity;

architecture Behavior of ALU is
    signal ALUResult : STD_LOGIC_VECTOR(31 downto 0);
begin

 
       with ALUControl select
	    ALUResult <= 
	        std_logic_vector(unsigned(A) + unsigned(B))   when "0000",   
	        std_logic_vector(unsigned(A) - unsigned(B))   when "0001",  
	        A and B    when "0010",  
	        A or B     when "0011",   
	        A nor B    when "0100",  
	        A nand B    when "0101",   
	        A xor B     when "0110",   
	        std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B(4 downto 0)))))  when "0111",   
	        std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B(4 downto 0))))) when "1000",  
	        (31 downto 1 => '0') & '1'   when "1001", 
	        (others => '0')    when others;
	
    Result <= ALUResult;

  
    Zero <= '1' when ALUResult = x"00000000" else '0';
    

end architecture;  

	   