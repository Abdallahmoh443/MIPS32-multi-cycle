library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is
    Port (
        clk      : in STD_LOGIC;
        reset_neg: in STD_LOGIC;
		NextPC   : in STD_LOGIC_VECTOR(31 downto 0);
        PCWrite  : in STD_LOGIC;
        
        CurrentPC : out STD_LOGIC_VECTOR(31 downto 0)
    );
end ProgramCounter;

architecture Behavioral of ProgramCounter is
    signal PC : STD_LOGIC_VECTOR(31 downto 0);
begin
    process(clk, reset_neg)
    begin
        if reset_neg = '1' then
            PC <= (others => '0');
        elsif rising_edge(clk) then
            if PCWrite = '1' then
                PC <= NextPC;
            end if;
        end if;
    end process;
    
    CurrentPC <= PC;
end Behavioral;