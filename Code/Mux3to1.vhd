library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MUX3to1 is
    Port (
        input0 : in  std_logic_vector(31 downto 0);
        input1 : in  std_logic_vector(31 downto 0);	   
		input2 : in  std_logic_vector(31 downto 0);
        sel    : in  std_logic_vector(1 downto 0);
		
        output : out std_logic_vector(31 downto 0)
    );
end entity;



architecture Behavior of MUX3to1 is
begin	 
	with sel select
	output <= input0 when "00",
			  input1 when "01",	
			  input2 when "10",	
    		  (others => '0') when others;    
end architecture;



