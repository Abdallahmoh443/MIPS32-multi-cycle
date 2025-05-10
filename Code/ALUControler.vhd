library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUControl is
    Port (
        ALUOp     : in  STD_LOGIC_VECTOR(1 downto 0);
        Funct     : in  STD_LOGIC_VECTOR(5 downto 0);
        ALUControl: out STD_LOGIC_VECTOR(3 downto 0)
    );
end entity;

architecture Behavior of ALUControl is
    signal control_sel : STD_LOGIC_VECTOR(7 downto 0);
begin
    control_sel <= ALUOp & Funct;

    with control_sel select
        ALUControl <= 
            -- R-type  
            "0000" when "10100000", 
            "0001" when "10100010", 
            "0010" when "10100100", 
            "0011" when "10100101", 
            "0100" when "10100111", 
            "0101" when "10100110", 
            "1000" when "10101010",  
            
            -- I-type  
            "0110" when "00000000",   
            "0111" when "01000000",  
            "1001" when "00101000",  
            "1010" when "00101100",   
            "1011" when "00101101",   
            
            "0000" when others;     
end architecture;