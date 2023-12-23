library ieee;
use ieee.std_logic_1164.all;

-- Divider div_ctrl
entity div_ctrl is
port( 	  
	clk : in std_logic;
	rst : in std_logic;
	
	-- status signals
	gt0 : in std_logic;
	gt1 : in std_logic;
	gt2 : in std_logic;
	gt3 : in std_logic;
	gt4 : in std_logic;
	gt5 : in std_logic;
	gt6 : in std_logic;
	gt7 : in std_logic;
	gt8 : in std_logic;
	gt9 : in std_logic;
	gt10 : in std_logic;
	gt11 : in std_logic;
	zi11 : in std_logic;
	Zmax : in std_logic;
	
	-- control signals
	Li : out std_logic;
	Ei : out std_logic;
	
	ld_sr0 : out std_logic;
	ld_sr1 : out std_logic;
	ld_sr2 : out std_logic;
	ld_sr3 : out std_logic;
	ld_sr4 : out std_logic;
	ld_sr5 : out std_logic;
	ld_sr6 : out std_logic;
	ld_sr7 : out std_logic;
	ld_sr8 : out std_logic;
	ld_sr9 : out std_logic;
	ld_sr10 : out std_logic;
	ld_sr11 : out std_logic;	
	
	sel_mux0 : out std_logic;
	sel_mux1 : out std_logic;
	sel_mux2 : out std_logic;
	sel_mux3 : out std_logic;
	sel_mux4 : out std_logic;
	sel_mux5 : out std_logic;
	sel_mux6 : out std_logic;
	sel_mux7 : out std_logic;
	sel_mux8 : out std_logic;
	sel_mux9 : out std_logic;
	sel_mux10 : out std_logic;
	sel_mux11 : out std_logic;
	
	en_gt0 : out std_logic;
	div_start : in std_logic
	-- en_gt1 : out std_logic;
	-- en_gt2 : out std_logic;
	-- en_gt3 : out std_logic;
	-- en_gt4 : out std_logic;
	-- en_gt5 : out std_logic;
	-- en_gt6 : out std_logic;
	-- en_gt7 : out std_logic;
	-- en_gt8 : out std_logic;
	-- en_gt9 : out std_logic;
	-- en_gt10 : out std_logic;
	-- en_gt11 : out std_logic
);
end div_ctrl;

architecture arch of div_ctrl is

	--type y is ( S_load, S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, S20, S21, S22, S_done);
	type y is ( S_load, S_CALC, S_done);
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
					     if(div_start='1') then 
						   state<=S_CALC;
						 else 
						  state<=S_load;
						  end if;
						  
					when S_CALC =>
					    if(Zmax='1') then
							state <= S_done;
						else 
							state<=S_CALC;
						end if;
						
					when S_done =>
						state <= S_done;
						
					when others =>
						state <= S_load;
				end case;	
			end if;
		end if;	
    end process;
	
	-- control signals
	Li <= '1' when (state = S_load) else '0'; 
    Ei <= '1' when (state = S_load or state=S_CALC) else '0';  
	
	sel_mux0 <= '1'  when (gt0 = '1')  else '0'; 
	sel_mux1 <= '1'  when (gt1 = '1')  else '0'; 
	sel_mux2 <= '1'  when (gt2 = '1')  else '0'; 
	sel_mux3 <= '1'  when (gt3 = '1')  else '0'; 
	sel_mux4 <= '1'  when (gt4 = '1')  else '0'; 
	sel_mux5 <= '1'  when (gt5 = '1')  else '0'; 
	sel_mux6 <= '1'  when (gt6 = '1')  else '0'; 
	sel_mux7 <= '1'  when (gt7 = '1')  else '0'; 
	sel_mux8 <= '1'  when (gt8 = '1')  else '0'; 
	sel_mux9 <= '1'  when (gt9 = '1')  else '0'; 
	sel_mux10 <= '1' when (gt10 = '1') else '0';
	sel_mux11 <= '1' when (gt11 = '1') else '0';
	
	ld_sr0 <= '1'  when (state = S_load) else '0';
	ld_sr1 <= '1'  when (state = S_load) else '0';
	ld_sr2 <= '1'  when (state = S_load) else '0';
	ld_sr3 <= '1'  when (state = S_load) else '0';
	ld_sr4 <= '1'  when (state = S_load) else '0';
	ld_sr5 <= '1'  when (state = S_load) else '0';
	ld_sr6 <= '1'  when (state = S_load) else '0';
	ld_sr7 <= '1'  when (state = S_load) else '0';
	ld_sr8 <= '1'  when (state = S_load) else '0';
	ld_sr9 <= '1'  when (state = S_load) else '0';
	ld_sr10 <= '1' when (state = S_load) else '0';
	ld_sr11 <= '1' when (state = S_load) else '0';
	
	en_gt0 <= '0' when (state = S_load or state = S_done) else '1';
	-- en_gt1 <= '0' when (state = S_load or state = S_done or state = S0) else '1';
	-- en_gt2 <= '0' when (state = S_load or state = S_done or state = S0 or state = S1) else '1';
	-- en_gt3 <= '0' when (state = S_load or state = S_done or state = S0 or state = S1 or state = S2) else '1';
	-- en_gt4 <= '0' when (state = S_load or state = S_done or state = S0 or state = S1 or state = S2 or state = S3) else '1';
	-- en_gt5 <= '0' when (state = S_load or state = S_done or state = S0 or state = S1 or state = S2 or state = S3 or state = S4) else '1';
	-- en_gt6 <= '0' when (state = S_load or state = S_done or state = S0 or state = S1 or state = S2 or state = S3 or state = S4 or state = S5) else '1';
	-- en_gt7 <= '0' when (state = S_load or state = S_done or state = S0 or state = S1 or state = S2 or state = S3 or state = S4 or state = S5 or state = S6) else '1';
	-- en_gt8 <= '0' when (state = S_load or state = S_done or state = S0 or state = S1 or state = S2 or state = S3 or state = S4 or state = S5 or state = S6 or state = S7) else '1';
	-- en_gt9 <= '0' when (state = S_load or state = S_done or state = S0 or state = S1 or state = S2 or state = S3 or state = S4 or state = S5 or state = S6 or state = S7 or state = S8) else '1';
	-- en_gt10 <= '0' when (state = S_load or state = S_done or state = S0 or state = S1 or state = S2 or state = S3 or state = S4 or state = S5 or state = S6 or state = S7 or state = S8 or state = S9) else '1';
	-- en_gt11 <= '0' when (state = S_load or state = S_done or state = S0 or state = S1 or state = S2 or state = S3 or state = S4 or state = S5 or state = S6 or state = S7 or state = S8 or state = S9 or state = S10) else '1';
	
	
	-- en_gt0 <= '1' when (state = S0 or state = S1 or state = S2 or state = S3 or state = S4 or state = S5 or state = S6 or state = S7 or state = S8 or state = S9 or state = S10 or state = S11) else '0';
	-- en_gt1 <= '1' when (state = S1 or state = S2 or state = S3 or state = S4 or state = S5 or state = S6 or state = S7 or state = S8 or state = S9 or state = S10 or state = S11 or state = S12) else '0';
	-- en_gt2 <= '1' when (state = S2 or state = S3 or state = S4 or state = S5 or state = S6 or state = S7 or state = S8 or state = S9 or state = S10 or state = S11 or state = S12 or state = S13 ) else '0';
	-- en_gt3 <= '1' when (state = S3 or state = S4 or state = S5 or state = S6 or state = S7 or state = S8 or state = S9 or state = S10 or state = S11 or state = S12 or state = S13 or state = S14 ) else '0';
	-- en_gt4 <= '1' when (state = S4 or state = S5 or state = S6 or state = S7 or state = S8 or state = S9 or state = S10 or state = S11 or state = S12 or state = S13 or state = S14 or state = S15 ) else '0';
	-- en_gt5 <= '1' when (state = S5 or state = S6 or state = S7 or state = S8 or state = S9 or state = S10 or state = S11 or state = S12 or state = S13 or state = S14 or state = S15 or state = S16) else '0';
	-- en_gt6 <= '1' when (state = S6 or state = S7 or state = S8 or state = S9 or state = S10 or state = S11 or state = S12 or state = S13 or state = S14 or state = S15 or state = S16 or state = S17) else '0';
	-- en_gt7 <= '1' when (state = S7 or state = S8 or state = S9 or state = S10 or state = S11 or state = S12 or state = S13 or state = S14 or state = S15 or state = S16 or state = S17 or state = S18) else '0';
	-- en_gt8 <= '1' when (state = S8 or state = S9 or state = S10 or state = S11 or state = S12 or state = S13 or state = S14 or state = S15 or state = S16 or state = S17 or state = S18 or state = S19) else '0';
	-- en_gt9 <= '1' when (state = S9 or state = S10 or state = S11 or state = S12 or state = S13 or state = S14 or state = S15 or state = S16 or state = S17 or state = S18 or state = S19 or state = S20) else'0';
	-- en_gt10 <= '1' when (state = S10 or state = S11 or state = S12 or state = S13 or state = S14 or state = S15 or state = S16 or state = S17 or state = S18 or state = S19 or state = S20 or state = S21) else'0';
	-- en_gt11 <= '1' when (state = S11 or state = S12 or state = S13 or state = S14 or state = S15 or state = S16 or state = S17 or state = S18 or state = S19 or state = S20 or state = S21 or state = S22) else'0';

	
end arch;


