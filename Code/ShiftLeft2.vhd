library IEEE;

use IEEE.STD_LOGIC_1164.ALL;



entity ShiftLeft2 is
    
	Port (
        
	input  : in  std_logic_vector(25 downto 0);

    output : out std_logic_vector(27 downto 0)

);

end ShiftLeft2;



architecture Behavioral of ShiftLeft2 is

begin
    
output <= input(25 downto 0) & "00";

end Behavioral;
	