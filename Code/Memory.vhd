library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
entity Memory is 
	port (
        clk: in std_logic;
        -- We only have 2048 address available so 11 bits would be enough
        -- But we use 32 bit because we are dealing with other registers and gates
        -- that work with 32-bit format.
        address : in std_logic_vector(31 downto 0);
        dataIn : in std_logic_vector(31 downto 0); -- Data to write [used only with "SW"]
        -- Control Signals
        MemWrite : in std_logic;
        MemRead : in std_logic;
        
        -- Output Data [Data or Instructions]
        dataOut : out std_logic_vector(31 downto 0)
	);
					   			   
end entity;
-- Our Memory is a simple array of 2052 8-bits words [Byte] to allow for word-aligned access
architecture Behavioral of Memory is
    type memArray is array(0 to 2051) of std_logic_vector(7 downto 0); -- Increased size to prevent boundary issues
    
    -- Initialize memory with a function to ensure proper simulation behavior
    function init_memory return memArray is
        variable temp_mem : memArray := (others => (others => '0'));
        
        -- MIPS Instructions for c = a + b:
        -- 1. lw $t0, 20($zero)   # Load a into $t0
        -- 2. lw $t1, 24($zero)   # Load b into $t1
        -- 3. add $t2, $t0, $t1   # $t2 = $t0 + $t1 (a + b)
        -- 4. sw $t2, 28($zero)   # Store result in c
    begin
        -- Instruction 1: lw $t0, 20($zero) = x"8C080014"
        temp_mem(0) := x"8C";  -- Most significant byte
        temp_mem(1) := x"08";
        temp_mem(2) := x"00";
        temp_mem(3) := x"14";  -- Least significant byte
        
        -- Instruction 2: lw $t1, 24($zero) = x"8C090018"
        temp_mem(4) := x"8C";
        temp_mem(5) := x"09";
        temp_mem(6) := x"00";
        temp_mem(7) := x"18";
        
        -- Instruction 3: add $t2, $t0, $t1 = x"01095020"
        temp_mem(8) := x"01";
        temp_mem(9) := x"09";
        temp_mem(10) := x"50";
        temp_mem(11) := x"20";
        
        -- Instruction 4: sw $t2, 28($zero) = x"AC0A001C"
        temp_mem(12) := x"AC";
        temp_mem(13) := x"0A";
        temp_mem(14) := x"00";
        temp_mem(15) := x"1C";
        
        -- Data value for variable a = 10 (0x0000000A)
        temp_mem(20) := x"00";
        temp_mem(21) := x"00";
        temp_mem(22) := x"00";
        temp_mem(23) := x"0A";
        
        -- Data value for variable b = 15 (0x0000000F)
        temp_mem(24) := x"00";
        temp_mem(25) := x"00";
        temp_mem(26) := x"00";
        temp_mem(27) := x"0F";
        
        -- Location for variable c (will be filled with 25 (0x00000019) after execution)
        temp_mem(28) := x"00";
        temp_mem(29) := x"00";
        temp_mem(30) := x"00";
        temp_mem(31) := x"00";
        
        return temp_mem;
    end function;
    
    -- Use the initialization function
    signal Memory: memArray := init_memory;
    
begin
    -- Memory organization:
    -- Addresses 0-16: Instructions
    -- Addresses 20-23: Variable a (value = 10)
    -- Addresses 24-27: Variable b (value = 15)
    -- Addresses 28-31: Variable c (will store a + b = 25)
		
	-- Clocked process (for writes only)
    process (clk)
        variable addr_ind : Integer; 
    begin
        if (rising_edge(clk)) then
            if (MemWrite = '1') then
                addr_ind := to_integer(unsigned(address));
                -- Add boundary check to prevent out-of-range access
                if (addr_ind <= 2048) then  -- Ensure we don't access beyond array bounds
                    Memory(addr_ind)   <= dataIn(31 downto 24); 
                    Memory(addr_ind+1) <= dataIn(23 downto 16);  
                    Memory(addr_ind+2) <= dataIn(15 downto 8);  
                    Memory(addr_ind+3) <= dataIn(7 downto 0);
                end if; 
            end if;
        end if;
    end process;  
	
    -- Combinational read (immediate)
    process (MemRead, address)
        variable addr_ind : Integer; 
    begin
        if (MemRead = '1') then
            addr_ind := to_integer(unsigned(address));
            -- Add boundary check to prevent out-of-range access
            if (addr_ind <= 2048) then  -- Ensure we don't access beyond array bounds
                dataOut(31 downto 24) <= Memory(addr_ind); 
                dataOut(23 downto 16) <= Memory(addr_ind+1); 
                dataOut(15 downto 8)  <= Memory(addr_ind+2); 
                dataOut(7 downto 0)   <= Memory(addr_ind+3);
            else
                dataOut <= (others => '0'); -- Default output for out-of-bounds addresses
            end if;
        else
            dataOut <= (others => '0'); -- Default output
        end if;
    end process;
end architecture;