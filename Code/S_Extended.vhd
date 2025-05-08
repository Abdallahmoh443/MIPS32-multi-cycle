library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity SignExtend is
    Port (
        input  : in  std_logic_vector(15 downto 0);
        output : out std_logic_vector(31 downto 0)
    );
end entity;


architecture Behavior of SignExtend is
begin
    output <= (15 downto 0 => input(15)) & input;
end architecture;
