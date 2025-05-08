library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MUX2to1 is
    Port (
        input0 : in  std_logic_vector(31 downto 0);
        input1 : in  std_logic_vector(31 downto 0);
        sel    : in  std_logic;
        output : out std_logic_vector(31 downto 0)
    );
end entity;



architecture Behavior of MUX2to1 is
begin
    output <= input0 when sel = '0' else input1;
end architecture;
