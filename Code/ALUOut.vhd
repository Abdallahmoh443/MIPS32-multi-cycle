library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUOut is
    Port (
		clk      : in STD_LOGIC;
	 	reset_neg: in std_logic;
        ALUIn    : in STD_LOGIC_VECTOR(31 downto 0);
        ALUOut   : out STD_LOGIC_VECTOR(31 downto 0)
    );
end ALUOut;

architecture Behavioral of ALUOut is
    signal reg : STD_LOGIC_VECTOR(31 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            reg <= ALUIn;
        end if;
    end process;
    
    ALUOut <= reg;
end Behavioral;