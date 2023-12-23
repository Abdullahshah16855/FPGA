library ieee;
use ieee.std_logic_1164.all;

-- controller
entity controller is
	port( 	  
		-- inputs	
		clk : in std_logic;
		rst : in std_logic;
		Go 	: in std_logic; 
		Zi  : in std_logic;  
		gt1  : in std_logic;  
		sel  : in std_logic;  
		Zmax : in std_logic; 
		Zi_start : in std_logic; 
		enable1 : in std_logic; 
		enable2 : in std_logic; 
		-- outputs
		csel1 : out std_logic; 
		csel2 : out std_logic; 
		csel3 : out std_logic; 
		Li : out std_logic; 
		Ei : out std_logic; 
		div_start : out std_logic; 
		en_reg1 : out std_logic; 
		en_reg2 : out std_logic; 
		en_reg5 : out std_logic;
        en_reg3 : out std_logic; 
		en_reg6 : out std_logic; 		
		en_reg4 : out std_logic; 		
		en_reg7 : out std_logic; 		
		en_reg8 : out std_logic; 		
		en_reg9 : out std_logic; 		
		en_reg10 : out std_logic; 		
		en_reg11 : out std_logic; 		
		en_Gdiff : out std_logic; 		
		en_Ldiff : out std_logic; 		
		Done : out std_logic

	);
end controller;

architecture arch of controller is

	type y is ( S_waiting, S_loading1,S_loading2 ,S_counting, S_done);
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
							state <= S_loading1;
						else
							state <= S_waiting;
						end if;
						
					when S_loading1 => 
						state <= S_loading2;
					
					when S_loading2 => 
						state <= S_counting;

					when S_counting => 
						if (Zi = '1') then
							if (Zmax = '1') then
								state<= S_done;
							else
								state<= S_counting;
						    end if;
						else
						    if(gt1='1') then
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
    Li <= '1' when (state = S_waiting) else '0'; 
    Ei <= '1' when (state = S_counting) or (state = S_loading1)or (state = S_loading2) else '0'; 
    en_reg1 <= '1' when (state = S_loading2) or (state = S_counting)  else '0';  
    --en_Gdiff <= '1' when (state = S_loading1) or (state = S_counting) else '0';  
    en_Gdiff <= '1' when (state = S_loading2) or (state = S_counting) else '0';  
    en_Ldiff <= '1' when (state = S_loading2) or (state = S_counting)  else '0';  
    en_reg2 <= '1' when (state = S_counting and enable1='1')    else '0'; 
    en_reg5 <= '1' when (state = S_counting and enable2 ='1')   else '0'; 
	en_reg3 <= '1' when (state = S_counting)   else '0'; 
	en_reg10 <= '1' when (state = S_counting)   else '0'; 
	en_reg11 <= '1' when (state = S_counting)   else '0'; 
    en_reg6 <= '1' when (state = S_counting)   else '0'; 
    csel1 <= '1' when (state = S_loading1) or (state = S_loading2)or (state = S_counting) else '0'; 
    csel2 <= '1' when (state = S_counting and zi = '1') else '0'; 
    csel3 <= '1' when (state = S_counting and zi = '1') else '0'; 
    en_reg4 <= '1' when (state = S_counting and (Zi = '1'or gt1='1')) else '0'; 
    en_reg7 <= '1' when (state = S_counting and (Zi = '1'or gt1='1')) else '0'; 
    en_reg8 <= '1' when (state = S_counting and (Zi = '1'or gt1='1')) else '0'; 
    en_reg9 <= '1' when (state = S_counting and ( gt1='1') ) else '0'; 
    Done <= '1' when (state = S_done) else '0';
	div_start <='1' when (Zi_start ='1') else '0';

end arch;


