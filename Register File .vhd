library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Reg_Files is
	port (
		clk,RegWrite,reset: in std_logic;
		ReadRegister1,ReadRegister2,WriteRegister: in std_logic_vector(4 downto 0);
		
		WriteData: in std_logic_vector(31 downto 0);
		ReadData1,ReadData2: out std_logic_vector(31 downto 0)
		);
end Reg_Files;

architecture Behavioral of Reg_Files is
 
    type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
    signal registers : reg_array := (others => (others => '0'));
	
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                registers <= (others => (others => '0'));
            elsif RegWrite = '1' then
                if WriteRegister /= "00000" then
                    registers(to_integer(unsigned(WriteRegister))) <= WriteData;
                end if;
            end if;
        end if;
    end process;

    ReadData1 <= registers(to_integer(unsigned(ReadRegister1)));
    ReadData2 <= registers(to_integer(unsigned(ReadRegister2)));

end Behavioral;