library ieee;
use ieee.std_logic_1164.all;

-- Divider controller
entity div_cntrl is
	port( 	  
		-- inputs	
		clk : in std_logic;
		rst : in std_logic;
		-- control signals
		Li : out std_logic;
		Ei : out std_logic;
		ld_shift1 : out std_logic;
		en_shift1 : out std_logic;
		ld_shift2 : out std_logic;
		en_shift2 : out std_logic;
		init : out std_logic;
		en_reg : out std_logic;
		-- status signals
		gt : in std_logic;
		div_start : in std_logic;
		Z_start : in std_logic;
		Z_end : in std_logic
	);
end div_cntrl;

architecture arch of div_cntrl is

	--type y is ( S_load, S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11);
	type y is ( S_load, S_divide, S_done);
	signal state : y;  
	
begin

	process(clk)
	begin
		if (rising_edge (clk)) then
			if(rst = '1') then		-- Synchronous reset (active low)
				state <= S_load;
			else
				case (state) is
					when S_load =>
					  if (Div_start='1') then
						if (Z_start = '1') then
							state <= S_divide;
						else 
							state <= S_load;
						end if;
					  else
					  state<= S_load;
					  end if;
						
					when S_divide =>
						if (Z_end = '1') then
							state <= S_done;
						else 
							state <= S_divide;
						end if;
					
					when others =>
						state <= S_load;
				end case;	
			end if;
		end if;	
    end process;
	
	-- control signals
	Li <= '1' when  (state = S_load) else '0';
	Ei <= '1' when  (state = S_divide) else '0';
	
	ld_shift1 <= '1' when  (state = S_load) else '0';
	en_shift1 <= '1' when  (state = S_divide) else '0';
	ld_shift2 <= '1' when  (state = S_load) else '0';
	en_shift2 <= '1' when  (state = S_divide) else '0';
	init <= '0' when (state = S_load) else '1';
	en_reg <= '1' when (state = S_load) or  (state = S_divide and gt = '1') else '0';
	
end arch;


