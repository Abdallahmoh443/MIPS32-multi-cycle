library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Registers is
	port (
	clk : in std_logic;
	reset_neg : in std_logic;
	ReadRegister1 : in std_logic_vector(4 downto 0);
	ReadRegister2 : in std_logic_vector(4 downto 0);
	WriteRegister: in std_logic_vector(4 downto 0);

	WriteData: in std_logic_vector(31 downto 0);
	RegWrite: in std_logic;
	
	ReadData1: out std_logic_vector(31 downto 0);
	ReadData2: out std_logic_vector(31 downto 0)
		);
end Registers;

architecture Behavioral of Registers is
 
    type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
    signal registers : reg_array := (others => (others => '0'));
	
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset_neg = '1' then
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