library ieee;
use ieee.std_logic_1164.all;

-- controller
entity controller is
	port( 	  
		-- inputs	
		clk : in std_logic;
		rst : in std_logic;

		S1 : out std_logic;  
		Li : out std_logic;  
		Lj : out std_logic;  
		Ei : out std_logic;  
		Ej : out std_logic;  
		EA : out std_logic;  
		EB : out std_logic;  
		EC : out std_logic;  
		ED : out std_logic;  
		Csel : out std_logic;  
		RstC : out std_logic;  
		RstD : out std_logic;  
		Done : out std_logic;  
		-- outputs
		Go : in std_logic;  
		gt1 : in std_logic;  
		lt1 : in std_logic;  
		Zi_max : in std_logic; 
		Zj_max : in std_logic
	);
end controller;

architecture arch of controller is

	type y is (S_waiting,S_loading, S_count, S_done);
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
						state <= S_count;

					when S_count =>
						if(gt1='1') then
						 if (Zj_max= '1') then
							if (Zi_max = '1') then
								state<= S_done;
							else
							   state<=S_loading;
							end if;	
					     end if;
						else
						if (Zj_max= '1') then
							if (Zi_max = '1') then
								state<= S_done;
							else
							   state<=S_loading;
							end if;	
					     else
								state<= S_count;
								
							end if;
						end if;
						
						if(lt1='1') then
						 if (Zj_max= '1') then
							if (Zi_max = '1') then
								state<= S_done;
							else
							   state<=S_loading;
							end if;	
					     end if;
						else
						if (Zj_max= '1') then
							if (Zi_max = '1') then
								state<= S_done;
							else
							   state<=S_loading;
							end if;	
					     else
								state<= S_count;
								
							end if;
						end if;
					
					when S_done =>
				        state <= S_done;
						
				    when others =>
				        state <= S_loading;
				end case;	
			end if;
		end if;	
    end process;
	
		-- control signals 
    Li <= '1' when (state = S_waiting) else '0'; 
    Lj <= '1' when (state = S_loading) or (state = S_count and Zj_max='1') else '0'; 
   -- Ei <= '1' when (state = S_count and zj_max='1' ) else '0'; 
    --Ei <= '1' when (state = S_count and lt1='1' and Zj_max = '1' and Zi_max = '0') or (state = S_count and lt1='0' and Zj_max = '1' and Zi_max = '0') else '0'; 
    Ei <= '1' when (state = S_count and gt1='1' and Zj_max = '1' and Zi_max = '0') or (state = S_count and gt1='0' and Zj_max = '1' and Zi_max = '0') else '0'; 
    Ej <= '1' when (state = S_count) else '0';
  --  EA <= '1' when (state = S_loading and gt1='1') or (state = S_count and zj_max='0' and gt1 ='1') else '0'; 
    EA <= '1' when (state = S_loading) or (state = S_count and gt1='1') else '0';
    EB <= '1' when (state = S_loading) or (state = S_count and lt1='1') else '0';
    RstC <= '1' when (state = S_waiting) or (state = S_count  and Zj_max ='1') or (state = S_count and gt1= '1') else '0'; 
    RstD <= '1' when (state = S_waiting) or (state = S_count  and Zj_max ='1') or (state = S_count and lt1= '1') else '0'; 
  --  EC <= '1' when (state = S_count and gt1='0') else '0'; 
    EC <= '1' when (state = S_count) else '0'; 
    --ED <= '1' when (state = S_count and lt1='0') else '0'; 
    ED <= '1' when (state = S_count ) else '0'; 
    Csel <= '1' when (state = S_count) else '0'; 
    S1 <= '1' when (state = S_loading or state = S_count) else '0'; 
    Done <= '1' when (state = S_done) else '0';

end arch;


