library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity topLevelTB is
end topLevelTB;

architecture behavior of topLevelTB is

    -- Component declaration for the TopLevel module
    component TopLevel is
        port (
            clk       : in std_logic;
            reset_neg : in std_logic
        );
    end component;

    signal clk   : std_logic := '0';
    signal reset : std_logic := '0';

    -- clock period
    constant clk_period : time := 10 ns;

begin

    -- instantiate the processor
    -- Fixed: Changed 'uut: entity TopLevel' to standard component instantiation
    uut: TopLevel
        port map (
            clk       => clk,
            reset_neg => reset
        );

    -- Clock process
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Reset process to initialize processor
    reset_process: process
    begin
        reset <= '1';  -- Active reset
        wait for clk_period*2;
        reset <= '0';  -- Deactivate reset
        wait;  -- Wait indefinitely
    end process;

end behavior;