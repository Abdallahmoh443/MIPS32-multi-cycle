library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity topLevelTB is
end topLevelTB;

architecture behavior of topLevelTB is

    signal clk   : std_logic := '0';
    signal reset : std_logic := '0';

    -- clock period
    constant clk_period : time := 20 ns;

begin

    -- instantiate the processor
    uut: entity TopLevel
        port map (
            clk  ,
            reset 
        );

    -- Clock process
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

end behavior;