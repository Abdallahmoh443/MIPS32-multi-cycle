library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity Memory is 
	port (
        clk: in std_logic;
        address : in std_logic_vector(31 downto 0);
        dataIn : in std_logic_vector(31 downto 0); -- Data to write [used only with "SW"]

        -- Control Signals
        MemWrite : in std_logic;
        MemRead : in std_logic;
        
        -- Output Data [Data or Instructions]
        dataOut : out std_logic_vector(31 downto 0)
	);
					   			   
end entity;
-- Our Memory is a simple array of 2048 8-bits words [Byte]
architecture Behavioral of Memory is
    type memArray is array(0 to 2047) of std_logic_vector(7 downto 0); -- Creating custom type
    signal Memory: memArray := (others => (others => '0')); -- Creating an instance of that type

    begin
        process (clk) 
            variable addr_ind : Integer; 
        begin
            if (rising_edge(clk)) then -- If that change was an uprising edge
                addr_ind := to_integer(unsigned(address));

                if (MemRead = '1') then -- Fetch data from address
                    dataOut(31 downto 24) <= Memory(addr_ind); 
                    dataOut(23 downto 16) <= Memory(addr_ind+1); 
                    dataOut(15 downto 8)  <= Memory(addr_ind+2); 
                    dataOut(7 downto 0)   <= Memory(addr_ind+3); 

                elsif (MemWrite = '1') then -- Store data in address
                    Memory(addr_ind)   <= dataIn(31 downto 24); -- MSB  
                    Memory(addr_ind+1) <= dataIn(23 downto 16);  
                    Memory(addr_ind+2) <= dataIn(15 downto 8);  
                    Memory(addr_ind+3) <= dataIn(7 downto 0); --LSB 
                end if;

            end if;
        end process;
end architecture;
    