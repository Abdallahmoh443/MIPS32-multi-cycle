library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUOutRegister is
    Port (
        clk     : in STD_LOGIC;
        ALUIn   : in STD_LOGIC_VECTOR(31 downto 0);
        ALUOut  : out STD_LOGIC_VECTOR(31 downto 0)
    );
end ALUOutRegister;

architecture Behavioral of ALUOutRegister is
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