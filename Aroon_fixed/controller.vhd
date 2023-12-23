library ieee;
use ieee.std_logic_1164.all;

-- controller
entity controller is
	port( 	  
		-- inputs	
		clk : in std_logic;
		rst : in std_logic;
		Go : in std_logic;  
		gtH : in std_logic;  
		lwL : in std_logic;  
		Zi_max : in std_logic; 
		Zj_max : in std_logic;
		load : in std_logic;
		

		-- outputs
		S1 : out std_logic;  
		Li : out std_logic;  
		Lj : out std_logic;  
		Lh : out std_logic;  
		LL : out std_logic;  
		Ei : out std_logic;  
		Ej : out std_logic;  
		enH : out std_logic;  
		en_buy : out std_logic;  
		en_sell : out std_logic;  
		enL : out std_logic;  
		Csel : out std_logic;  
		clrH : out std_logic;  
		clrL : out std_logic;  
		Done : out std_logic;  
		en_reg1 : out std_logic;  
		en_reg2 : out std_logic
	);
end controller;

architecture arch of controller is

	type y is (S_wait, S_load, S_count, S_done);
	signal state : y;  
	
begin

	process(clk)
	begin
		if (rising_edge (clk)) then
			if(rst = '1') then		-- Synchronous reset (active low)
				state <= S_wait;
			else
				case (state) is
					when S_wait => 
						if (Go = '1') then
							state <= S_load;
						else
							state <= S_wait;
						end if;
						
					when S_load => 
						state <= S_count;
					   
					when S_count =>
                        if (gtH = '1') then
							if (Zj_max = '1') then
								if (Zi_max = '1') then
									state<= S_done;
								else
									state<= S_load;
								end if;	
							end if;	
						else
						
							if (Zj_max='1') then
								if (Zi_max='1') then
									state<= S_done;
								else
									state<= S_load;
							    end if;
							else
							     state<= S_count;
							end if;     
						end if;  
						
						if (lwL = '1') then
							if (Zj_max = '1') then
								if (Zi_max = '1') then
									state<= S_done;
								else
									state<= S_load;
								end if;	
							end if;	
						else
							if (Zj_max='1') then
								if (Zi_max='1') then
									state<= S_done;
								else
									state<= S_load;
							    end if;
							else
							     state<= S_count;
							end if;     
						end if;
						    		
					when S_done =>
				        state <= S_done;
						
				    when others =>
				        state <= S_wait;
				end case;	
			end if;
		end if;	
    end process;
	
	-- control signals 
    Li <= '1' when (state = S_wait) else '0';  --
    Lj <= '1' when (state = S_load) or (state = S_count and Zj_max='1') else '0'; --
    Lh <= '1' when (state = S_load) or (state = S_count and Zj_max='1') else '0'; 
    LL <= '1' when (state = S_load) or (state = S_count and Zj_max='1') else '0'; 
    Csel <= '1' when (state = S_count) else '0'; 
    S1 <= '1' when (state = S_load or state = S_count) else '0'; 
    Ei <= '1' when (state = S_count and gtH='1' and Zj_max = '1' and Zi_max = '0') or (state = S_count and gtH='0' and Zj_max = '1' and Zi_max = '0') else '0'; 
    Ej <= '1' when (state = S_count) else '0';  
    --en_reg1 <= '1' when (state = S_load) or (state = S_count and gtH='1') else '0';
    en_reg1 <= '1' when (state = S_count and load='1') or (state = S_count and gtH='1') else '0';
    --en_reg2 <= '1' when (state = S_load) or (state = S_count and lwL='1') else '0';
    en_reg2 <= '1' when (state = S_count and load='1') or (state = S_count and lwL='1') else '0';
	en_buy <= '1' when (state = S_count and Zj_max='1') else '0';  
	en_sell <= '1' when (state = S_count and Zj_max='1') else '0';  
	enH <= '1' when (state = S_count) else '0'; 
	enL <= '1' when (state = S_count) else '0'; 
    clrH <= '1' when (state=S_wait) or (state = S_count and gtH='1') or (state = S_count and Zj_max = '1')  else '0'; 
    clrL <= '1' when (state=S_wait) or (state = S_count and lwL='1') or (state = S_count and Zj_max = '1')  else '0'; 
    Done <= '1' when (state = S_done) else '0';
end arch;


