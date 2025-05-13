library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ControlUnit is
    Port (
        clk          : in STD_LOGIC;
        reset        : in STD_LOGIC;
        Opcode       : in STD_LOGIC_VECTOR(5 downto 0);
        Funct        : in STD_LOGIC_VECTOR(5 downto 0);
		
        PCWrite      : out STD_LOGIC;
        PCWriteCond  : out STD_LOGIC;
        IorD         : out STD_LOGIC;
        MemRead      : out STD_LOGIC;
        MemWrite     : out STD_LOGIC;
        MemtoReg     : out STD_LOGIC;
        IRWrite      : out STD_LOGIC;
        PCSource     : out STD_LOGIC_VECTOR(1 downto 0);
        ALUSrcB      : out STD_LOGIC_VECTOR(1 downto 0);
        ALUSrcA      : out STD_LOGIC;
        RegWrite     : out STD_LOGIC;
        RegDst       : out STD_LOGIC;
        ALUControl   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end ControlUnit;

architecture Behavioral of ControlUnit is
   
    -- Component declaration for ALUControl - renamed to ALUControlUnit to avoid naming conflict
    component ALUControlUnit is
        port (
            AlUOp      : in  std_logic_vector(1 downto 0);
            funct      : in  std_logic_vector(5 downto 0);
            ALUcontrol : out std_logic_vector(3 downto 0)
        );
    end component;
    
    -- Opcode definitions
    constant OP_RTYPE   : STD_LOGIC_VECTOR(5 downto 0) := "000000";
    constant OP_LW      : STD_LOGIC_VECTOR(5 downto 0) := "100011";
    constant OP_SW      : STD_LOGIC_VECTOR(5 downto 0) := "101011";
    constant OP_BEQ     : STD_LOGIC_VECTOR(5 downto 0) := "000100";
    constant OP_J       : STD_LOGIC_VECTOR(5 downto 0) := "000010";
    
    -- Modified state type to include additional states for LW/SW
    type StateType is (
        FETCH,
        DECODE,
        MEM_ADDR,    -- Calculate memory address
        MEM_READ,    -- Read from memory
        MEM_WRITE,   -- Write to memory 
        EXECUTE,
        WRITEBACK
    );
    
    signal current_state, next_state : StateType;
    signal ALUOp : STD_LOGIC_VECTOR(1 downto 0);
    
begin

    -- Properly instantiate the ALUControl component with the new name
    ALU_Control_Unit: ALUControlUnit
    port map (
        ALUOp => ALUOp,
        Funct => Funct,
        ALUControl => ALUControl
    );

    -- State register process
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= FETCH;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- Next state and output logic process
    process(current_state, Opcode)
    begin
        -- Default outputs
        PCWrite      <= '0';
        PCWriteCond  <= '0';
        IorD         <= '0';
        MemRead      <= '0';
        MemWrite     <= '0';
        MemtoReg     <= '0';
        IRWrite      <= '0';
        PCSource     <= "00";
        ALUSrcB      <= "00";
        ALUSrcA      <= '0';
        RegWrite     <= '0';
        RegDst       <= '0';
        ALUOp        <= "00";  -- Default ALUOp

        case current_state is
            when FETCH =>
                MemRead  <= '1';
                ALUSrcA  <= '0';
                ALUSrcB  <= "01";
                ALUOp    <= "00";  -- Add operation for PC+4
                IorD     <= '0';
                IRWrite  <= '1';
                PCWrite  <= '1';
                PCSource <= "00";
                next_state <= DECODE;

            when DECODE =>
                ALUSrcA  <= '0';
                ALUSrcB  <= "11";
                ALUOp    <= "00";  -- Add for address calculations
                
                if Opcode = OP_RTYPE then
                    next_state <= EXECUTE;
                elsif Opcode = OP_LW or Opcode = OP_SW then
                    next_state <= MEM_ADDR;  -- Both LW and SW go to memory address calculation
                elsif Opcode = OP_BEQ then
                    next_state <= EXECUTE;  -- BEQ needs to execute ALU comparison
                elsif Opcode = OP_J then
                    PCWrite  <= '1';
                    PCSource <= "10";
                    next_state <= FETCH;  -- Jump directly back to fetch
                else
                    next_state <= FETCH;  -- Unknown opcode, go back to fetch
                end if;

            when MEM_ADDR =>
                -- Calculate memory address for both LW and SW
                ALUSrcA  <= '1';
                ALUSrcB  <= "10";
                ALUOp    <= "00";  -- Add for effective address
                
                if Opcode = OP_LW then
                    next_state <= MEM_READ;
                elsif Opcode = OP_SW then
                    next_state <= MEM_WRITE;
                else
                    next_state <= FETCH;  -- Should never happen
                end if;
                
            when MEM_READ =>
                -- Read from memory using calculated address
                MemRead  <= '1';
                IorD     <= '1';  -- Use ALU result for memory address
                next_state <= WRITEBACK;

            when MEM_WRITE =>
                -- Write to memory using calculated address
                MemWrite <= '1';
                IorD     <= '1';  -- Use ALU result for memory address
                next_state <= FETCH;

            when EXECUTE =>
                if Opcode = OP_RTYPE then
                    ALUSrcA  <= '1';
                    ALUSrcB  <= "00";
                    ALUOp    <= "10";  -- R-type operation
                    next_state <= WRITEBACK;
                elsif Opcode = OP_BEQ then
                    ALUSrcA     <= '1';
                    ALUSrcB     <= "00";
                    ALUOp       <= "01";  -- Subtraction for comparison
                    PCWriteCond <= '1';
                    PCSource    <= "01";
                    next_state  <= FETCH;
                else
                    next_state <= FETCH;
                end if;

            when WRITEBACK =>
                if Opcode = OP_RTYPE then
                    RegDst   <= '1';
                    RegWrite <= '1';
                    MemtoReg <= '0';
                    next_state <= FETCH;
                elsif Opcode = OP_LW then
                    RegDst   <= '0';
                    RegWrite <= '1';
                    MemtoReg <= '1';
                    next_state <= FETCH;
                else
                    next_state <= FETCH;
                end if;

            when others =>
                next_state <= FETCH;
        end case;
    end process;
end Behavioral;