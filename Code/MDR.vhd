library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MDR is
    Port (
        clk     : in STD_LOGIC;
        DataIn  : in STD_LOGIC_VECTOR(31 downto 0);
        DataOut : out STD_LOGIC_VECTOR(31 downto 0)
    );
end MDR;

architecture Behavioral of MDR is
    signal reg : STD_LOGIC_VECTOR(31 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            reg <= DataIn;
        end if;
    end process;
    
    DataOut <= reg;
end Behavioral;