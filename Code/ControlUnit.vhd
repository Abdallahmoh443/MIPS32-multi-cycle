library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controlunit is
    port (
        clk          : in  std_logic;
        reset        : in  std_logic;
        Opcode       : in  std_logic_vector(5 downto 0);    -- input in Control Unit
        Funct        : in  std_logic_vector(5 downto 0);    -- input in Alu control
        PCWrite      : out std_logic;					    -- enable for write data in PC
        PCWriteCond  : out std_logic;					    -- BEQ ouput
        IorD         : out std_logic;						-- selector for Address (data mem)
        MemRead      : out std_logic; 						-- enable for Read data in data mem
        MemWrite     : out std_logic;						-- enable for Write data in data mem
        MemtoReg     : out std_logic;  						-- selector for Write Data in Reg File
        IRWrite      : out std_logic;						-- enable for intsruction 
        PCSource     : out std_logic_vector(1 downto 0); 	-- selector
        ALUSrcB      : out std_logic_vector(1 downto 0); 	-- selector	for Second ALU input
        ALUSrcA      : out std_logic;	 					-- selector for first ALU input
        RegWrite     : out std_logic;		 				-- enable for write data in  Reg File
        RegDst       : out std_logic;						-- selector for write reg in Reg file
        ALUControl   : out std_logic_vector(3 downto 0)	 	-- ALU Control selector
    );
end entity ;

architecture behavioral of Controlunit is
		-- instructions op code
    constant Rtype: std_logic_vector(5 downto 0) := "000000"; 	-- 4 states : fetch -> decode -> execute -> writeback	 
    constant LW   : std_logic_vector(5 downto 0) := "100011";	-- 5 states : fetch -> decode -> execute -> memory -> writeback
    constant SW   : std_logic_vector(5 downto 0) := "101011";	-- 4 states : fetch -> decode -> execute -> memory	
    constant Beq  : std_logic_vector(5 downto 0) := "000100"; 	-- 3 states : fetch -> decode -> execute	
    constant Jump : std_logic_vector(5 downto 0) := "000010"; 	-- 2 states : fetch -> execute	
    
    type statetype is (
        fetch,   	-- Read instruction & calc PC+4 
        decode,  	-- Read registers (rs & rt in R-type & Branch) or (rs & offset in SW & LW) and sign-extends offsets   
        execute, 	-- ALU operetions (Addtion in R-type & SW & LW & Branch Address - substract in Branch step)   
        memory,  	-- Read & Write Data in Data Memoery in SW & LW  
        writeback   -- Write data into Reg File in R-type &	LW
    );
    
    signal current_state, next_state : statetype;
    signal aluop : std_logic_vector(1 downto 0);
    
begin
	
    alu_control: entity alucontrol
    port map (aluop, funct, alucontrol); -- alu control unit port map
	
    process(clk, reset)	  -- reset and clock process
    begin
        if reset = '1' then
            current_state <= fetch;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;			  
	
    process(current_state, opcode) -- process suspended if current state or op code changed
    begin  
		-- default values to avoid unPredictable errors
        pcwrite      <= '0';
        pcwritecond  <= '0';
        memread      <= '0';
        memwrite     <= '0';
        memtoreg     <= '0';
        irwrite      <= '0';
        pcsource     <= "00";
        alusrcb      <= "00";
        alusrca      <= '0';
        regwrite     <= '0';
        regdst       <= '0';
        aluop        <= "00";

        case current_state is
            when fetch =>	 
				--Read intsructions 
				IorD 	 <= '0'; --pc input for Mem Data
                memread  <= '1';
				memwrite <= '0';
                irwrite  <= '1'; 
				-- Calc Pc+4
                alusrca  <= '0';  --PC input for ALU  
                alusrcb  <= "01"; --4   
                aluop    <= "00"; --add  
				Pcsource <= "00";  -- PC+4 input in Pc
                pcwrite  <= '1';
                next_state <= decode;

            when decode => -- enables in A & B reg if there exist  
			
			if opcode = BEQ  then	-- clac PC+4 + sign Extended off set * 4  
				  alusrca <= '0';    -- PC + 4
  				  aluop   <= "00";   -- ADD
        		  alusrcb <= "11";   -- offset * 4
   			 end if;
                
            if opcode = Rtype or opcode = LW or opcode = SW or opcode = Beq or opcode = Jump
				then next_state <= execute;
   			else
      		  next_state <= fetch;  -- handle unknown opcode
   		    end if;

            
            when execute =>
                case opcode is
                    when Rtype =>  
                        alusrca  <= '1';   
                        alusrcb  <= "00";   
                        aluop    <= "10"; --Rtype selector	
                        next_state <= writeback;
                        
                    when LW | SW =>  
                        alusrca  <= '1';     -- register a
                        alusrcb  <= "10";    -- sign extended offset
                        aluop    <= "00";    --ADD
                        next_state <= memory;
                        
                    when Beq => 
						--Check rs = rt
                        alusrca     <= '1';    -- register a
                        alusrcb     <= "00";   -- register b
                        aluop       <= "01";   -- sub (compare)
						
                        pcwritecond <= '1';    
                        pcsource    <= "01";   -- branch 
                        next_state  <= fetch;
                        
                    when Jump =>  
					    pcsource <= "10";      -- jump 
                        pcwrite  <= '1';
                        next_state <= fetch;
                        
                    when others =>
                        next_state <= fetch; -- handle unknown opcode
                end case;

            when memory =>
                if opcode = LW then
                    memread <= '1';
                    iord    <= '1';  		    -- alu result 
                    next_state <= writeback;
                else  							-- SW
                    memwrite <= '1';
                    iord     <= '1';  			-- alu result 
                    next_state <= fetch;
                end if;
				
            when writeback => 
			
			if opcode = Rtype then	 
				    memtoreg <= '0';    -- alu result
                    regdst   <= '1';    -- rd 
                    regwrite <= '1';
					
                elsif opcode = LW then
                    regdst   <= '0';    -- rt
                    memtoreg <= '1';    -- memory data reg	
				    regwrite <= '1';
                end if;
                next_state <= fetch;
        end case;
    end process;
end architecture ;