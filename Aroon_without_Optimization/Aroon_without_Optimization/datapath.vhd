library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- datapath
entity datapath is
generic (N : integer := 20; L : integer := 20);
port 
( 	
	-- inputs	
	clk : in std_logic;
	rst : in std_logic:='1';

	S1 : in std_logic;  
	Li : in std_logic;  
	Lj : in std_logic;  
	Ei : in std_logic;  
	Ej : in std_logic;  
	EA : in std_logic;  
	EB : in std_logic;  
	EC : in std_logic;  
	ED : in std_logic;  
	Csel : in std_logic;  
	WE_A : in std_logic;  
	WE_B : in std_logic;  
	gt1 : inout std_logic;  
	lt1 : inout std_logic;  
	RstC : in std_logic:='0';  
	RstD : in std_logic:='0';  
	RdAddr : in std_logic_vector(N-1 downto 0);
	Din_high : in std_logic_vector(N-1 downto 0);  
	Din_low : in std_logic_vector(N-1 downto 0);  
	-- outputs
	Zi_max : out std_logic; 
	Zj_max : inout std_logic;
	Order_signal : out std_logic_vector(1 downto 0)
);
end datapath;

architecture arch of datapath is


signal cntr_i_in : std_logic_vector(L-1 downto 0);
signal cntr_j_in : std_logic_vector(L-1 downto 0);
signal i : std_logic_vector(L-1 downto 0); 
signal j : std_logic_vector(L-1 downto 0); 
signal mux0_out : std_logic_vector(L-1 downto 0); 
signal mux1_out : std_logic_vector(L-1 downto 0); 
signal mux2_out : std_logic; 
signal mux3_out : std_logic; 
signal Ebuy : std_logic; 
signal Esell : std_logic; 
signal buy : std_logic_vector(1 downto 0);
signal sell : std_logic_vector(1 downto 0);
signal EA_out : std_logic_vector(L-1 downto 0); 
signal EB_out : std_logic_vector(L-1 downto 0); 
signal sell_out : std_logic_vector(3 downto 0);
signal RamA_out : std_logic_vector(L-1 downto 0); 
signal RamB_out : std_logic_vector(L-1 downto 0); 
signal Adder1_out : std_logic_vector(L-1 downto 0); 
signal Adder2_out : std_logic_vector(L-1 downto 0); 
signal Aroon_up_1 : std_logic_vector(N+L-1 downto 0); 
signal Aroon_down_1 : std_logic_vector(N+L-1 downto 0); 
signal Aroon_up : std_logic_vector(N-1 downto 0); 
signal Aroon_down : std_logic_vector(N-1 downto 0); 
signal Period_high : std_logic_vector(L-1 downto 0); 
signal Period_low : std_logic_vector(L-1 downto 0); 
signal Previous_Aroon_up   : std_logic_vector(N-1 downto 0);
signal Previous_Aroon_down   : std_logic_vector(N-1 downto 0);

signal Count_high : std_logic_vector(L-1 downto 0):=(others=>'0'); 
signal Count_low : std_logic_vector(L-1 downto 0):=(others=>'0'); 
constant Length_file : std_logic_vector(N-1 downto 0) := x"000B8";  -- 185
constant Frame_size : std_logic_vector(N-1 downto 0) := x"0000F";  --15

begin
	
	cntr_i_in <= (others=>'0');
	
	-- Count_higher i
	cntr_i : entity work.countern generic map (N => L)
	port map(clk => clk, rst => rst, ld=> li, en => Ei, input => cntr_i_in, output => i);
	Zi_max <= '1' when (i = Length_file) else '0';
	
	-- Count_higher j
	cntr_j_in <= i + 1;
	cntr_j : entity work.countern generic map (N => L)
	port map(clk => clk, rst => rst, ld => lj, en => Ej, input => cntr_j_in, output => j);
	Zj_max <= '1' when (j = i+Frame_size) else '0';
	
	-- Multiplexers
	mux0_out <= j when (Csel = '1') else i;
	mux1_out <= mux0_out when (S1 = '1') else RdAddr;
	mux2_out <= '0' when (gt1 = '1') else '1';
	mux3_out <= '0' when (lt1 = '1') else '1';
	
	-- RAM
	RAM_A : entity work.RAM generic map (addr_width => L, data_width => N) port map( clk => clk, WE => WE_A, ADDR => mux1_out, DIN => Din_high, DOUT => RamA_out);	-- RAM
	RAM_B : entity work.RAM generic map (addr_width => L, data_width => N) port map( clk => clk, WE => WE_B, ADDR => mux1_out, DIN => Din_low, DOUT => RamB_out);
	
	-- ROM
	Rom_high: entity work.ROM port map( addr  => Aroon_up_1, cout => Aroon_up);	
	Rom_low: entity work.ROM port map( addr  => Aroon_down_1, cout => Aroon_down);
	
	-- Register
	reg_A : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => EA, D => RamA_out, Q => EA_out); 
	reg_B : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => EB, D => RamB_out, Q => EB_out); 
	reg_Count_high : entity work.reg generic map (N => N) port map (clk => clk, rst => RstC, en => EC, D => Adder1_out, Q => Count_high); 
	reg_count_low : entity work.reg generic map (N => N) port map (clk => clk, rst => RstD, en => ED, D => Adder2_out, Q => Count_low); 
	
	-- Comparator
	gt1 <= '1' when (RamA_out > EA_out) else '0';
	lt1 <= '1' when (RamB_out < EB_out) else '0';
	
	-- Accumulator
	Adder1_out <= mux2_out + Count_high;
	Adder2_out <= mux3_out + Count_low;
	
	-- Formula Calculation
	Period_high <= Count_high when (Zj_max = '1' and Count_high>=0) else x"0000E";
	Aroon_up_1 <= std_logic_vector(unsigned(14-Period_high)*100);
	
	Period_low <= Count_low when (Zj_max = '1' and Count_low>=0) else x"0000E";
	Aroon_down_1 <= std_logic_vector(unsigned(14-Period_low)*100);
	
	-- Buy/Sell Decision as an Order_signal
	reg_Previous_Arron_up : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => Ebuy, D => Aroon_up , Q => Previous_Aroon_up);     
    reg_Previous_Arron_down : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => Esell, D => Aroon_down, Q => Previous_Aroon_down );  
	
	Ebuy<='1' when Zj_MAX='1' else '0';
    Esell<='1' when Zj_MAX='1' else '0';
	
    Buy <="01" when   (Aroon_up > Aroon_down and Previous_Aroon_up  <= Previous_Aroon_down )  else (others=>'0'); 
    Sell <="10" when  (Aroon_up < Aroon_down and Previous_Aroon_up  >= Previous_Aroon_down )  else (others=>'0'); 
    sell_out <= Buy & Sell   when (Zj_MAX='1')  else (others=>'0');
    
	with sell_out select 
    Order_signal <= Buy when  "0100",
                    Sell when "0010",
					(others => '0') when others;
	
	
end arch;


