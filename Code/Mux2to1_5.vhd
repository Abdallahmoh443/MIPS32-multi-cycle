library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Mux2to1_5 is
    Port (
        input0 : in  std_logic_vector(4 downto 0);
        input1 : in  std_logic_vector(4 downto 0);
        sel    : in  std_logic;
		
        output : out std_logic_vector(4 downto 0)
    );
end entity;



architecture Behavior of Mux2to1_5 is
begin
    output <= input0 when sel = '0' else input1;
end architecture;
