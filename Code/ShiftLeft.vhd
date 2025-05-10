library IEEE;
use IEEE.STD_LOGIC_1164.ALL;					  

entity ShiftLeft is
    Port (
		input  : in  std_logic_vector(31 downto 0);
	
        output : out std_logic_vector(31 downto 0)
    );
end ShiftLeft;

architecture Behavioral of ShiftLeft is
begin
    output <= input(29 downto 0) & "00";
end Behavioral;
