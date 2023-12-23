library ieee;
use ieee.std_logic_1164.all;

-- controller
entity controller is
port( 	  
	-- inputs	
	clk : in std_logic;
	rst : in std_logic;
	Go 	: in std_logic; 
	Zi12  : in std_logic; 
	Zi26  : in std_logic; 
	Zi9  : in std_logic; 
	gt12 : in std_logic; 
	gt26 : in std_logic; 
	gt9 : in std_logic; 
	Zmax : in std_logic; 
	-- outputs
	li : out std_logic; 
	ei : out std_logic; 
	sel_1 : out std_logic; 
	sel_2 : out std_logic; 
	sel_3 : out std_logic; 
	sel_4 : out std_logic; 
	en_reg1 : out std_logic; 
	en_reg2 : out std_logic; 
	en_reg3 : out std_logic; 
	en_reg4 : out std_logic; 
	en_reg5 : out std_logic; 
	en_reg6 : out std_logic; 
	en_reg7 : out std_logic; 
	en_reg8 : out std_logic; 
	en_macd : out std_logic; 
	en_macd_signal : out std_logic; 

	reg1_rst : out std_logic; 
	Done : out std_logic
	);
end controller;

architecture arch of controller is

	type y is ( S_waiting, S_loading, S_counting, S_done);
	signal state : y;  
	
begin

	process(clk)
	begin
		if (rising_edge (clk)) then
			if(rst = '1') then		-- Synchronous reset (active low)
				state <= S_waiting;
			else
				case (state) is
					when S_waiting => 
						if (Go = '1') then
							state <= S_loading;
						else
							state <= S_waiting;
						end if;
						
					when S_loading => 
						state <= S_counting;

					when S_counting => 
						if (Zi12 = '1') then
							if (Zmax = '1') then
								state<= S_done;
							else
								state<= S_counting;
						    end if;
						else
							if (gt12 = '1') then
								if (Zmax = '1') then
									state<= S_done;
								else
									state<= S_counting;
								end if;	
							else
								if (Zmax = '1') then
									state<= S_done;
								else
									state<= S_counting;
								end if;	
							end if;
						end if;

						if (Zi26 = '1') then
							if (Zmax = '1') then
								state<= S_done;
							else
								state<= S_counting;
						    end if;
						else
							if (gt26 = '1') then
								if (Zmax = '1') then
									state<= S_done;
								else
									state<= S_counting;
								end if;	
							else
								if (Zmax = '1') then
									state<= S_done;
								else
									state<= S_counting;
								end if;	
							end if;
						end if;

						if (Zi9 = '1') then
							if (Zmax = '1') then
								state<= S_done;
							else
								state<= S_counting;
						    end if;
						else
							if (gt9 = '1') then
								if (Zmax = '1') then
									state<= S_done;
								else
									state<= S_counting;
								end if;	
							else
								if (Zmax = '1') then
									state<= S_done;
								else
									state<= S_counting;
								end if;	
							end if;
						end if;
					
					when S_done =>
						state <= S_done;
						
				    when others =>
				        state <= S_waiting;
				end case;	
			end if;
		end if;	
    end process;
	
	-- control signals 
    li <= '1' when (state = S_waiting) else '0'; 
    ei <= '1' when (state = S_loading) or (state = S_counting) else '0'; 
    en_reg1 <= '1' when (state = S_counting or state = S_loading) else '0'; 
    en_reg2 <= '1' when (state = S_counting and Zi12 = '1') or (state = S_counting and gt12 = '1') else '0'; 
    en_reg3 <= '1' when (state = S_counting) else '0'; 
	en_reg4 <= '1' when (state = S_counting and Zi26 = '1') or (state = S_counting and gt26 = '1') else '0'; 
    en_reg5 <= '1' when (state = S_counting) else '0'; 
    
	en_reg6 <= '1' when (state = S_counting) else '0'; 
    en_reg7 <= '1' when (state = S_counting and Zi9 = '1') or (state = S_counting and gt9 = '1') else '0'; 
    en_reg8 <= '1' when (state = S_counting) else '0'; 

    sel_1 <= '1' when (state = S_loading or state = S_counting) else '0'; 
    sel_2 <= '1' when (state = S_counting and Zi12 = '1') else '0'; 
    sel_3 <= '1' when (state = S_counting and Zi26 = '1') else '0'; 
    sel_4 <= '1' when (state = S_counting and Zi9 = '1') else '0'; 
    reg1_rst <= '1' when (state = S_waiting) or (state = S_counting and gt26 = '1') else '0';

	en_macd <= '1' when (state = S_counting and gt9='1') or (state = S_counting and zi9='1') else '0';
	en_macd_signal <= '1' when (state = S_counting and gt9='1') or (state = S_counting and zi9='1') else '0';
	
    Done <= '1' when (state = S_done) else '0';

end arch;


