library ieee;
use ieee.std_logic_1164.all;

entity orGate is 
	port(
	a , b :in std_logic;
	c : out std_logic
	);
end entity ;

architecture arch of  OrGate is 
begin 
	c <= a or b;
	end architecture ;