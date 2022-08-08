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
	rst : in std_logic;

	RdAddr : in std_logic_vector(N-1 downto 0);
	S1 : in std_logic;  
	gt1 : inout std_logic;  
	lt1 : inout std_logic;  
	Li : in std_logic;  
	Lj : in std_logic;  
	Ei : in std_logic;  
	Ej : in std_logic;  
	EA : in std_logic;  
	EB : in std_logic;  
	EC : in std_logic;  
	ED : in std_logic;  
	WE_A : in std_logic;  
	WE_B : in std_logic;  
	Csel : in std_logic;  
	RstC : in std_logic;  
	RstD : in std_logic;  
	Din_up : in std_logic_vector(N-1 downto 0);  
	Din_down : in std_logic_vector(N-1 downto 0);  
	-- outputs
	Zi_max : out std_logic; 
	Zj_max : inout std_logic;
	Dout : out std_logic_vector (N-1 downto 0);
	Order_signal : out std_logic_vector(1 downto 0)
);
end datapath;

architecture arch of datapath is

constant Length_file : std_logic_vector(N-1 downto 0) := x"000B8";  -- 185
constant Frame_size : std_logic_vector(N-1 downto 0) := x"0000F";  

signal cntr_i_in : std_logic_vector(L-1 downto 0);
signal cntr_j_in : std_logic_vector(L-1 downto 0);
signal i : std_logic_vector(L-1 downto 0); 
signal j : std_logic_vector(L-1 downto 0); 
signal mux0_out : std_logic_vector(L-1 downto 0); 
signal mux1_out : std_logic_vector(L-1 downto 0); 
signal mux2_out : std_logic; 
signal mux3_out : std_logic; 
signal esell : std_logic; 
signal ebuy : std_logic; 
signal RamA_out : std_logic_vector(L-1 downto 0); 
signal RamB_out : std_logic_vector(L-1 downto 0); 
signal EA_out : std_logic_vector(L-1 downto 0); 
signal EB_out : std_logic_vector(L-1 downto 0); 
signal Adder1_out : std_logic_vector(L-1 downto 0); 
signal Adder2_out : std_logic_vector(L-1 downto 0); 
signal Aroon_up_1 : std_logic_vector(N+L-1 downto 0); 
--signal Aroon_up_2 : std_logic_vector(N+L-1 downto 0); 
signal Aroon_up : std_logic_vector(N-1 downto 0); 
signal Aroon_down_1 : std_logic_vector(N+L-1 downto 0); 
--signal Aroon_down_2 : std_logic_vector(N+L-1 downto 0); 
signal Aroon_down : std_logic_vector(N-1 downto 0);
signal Period : std_logic_vector(L-1 downto 0); 
signal Period1 : std_logic_vector(L-1 downto 0); 
signal Count : std_logic_vector(L-1 downto 0); 
signal Count1 : std_logic_vector(L-1 downto 0); 
signal Previous_Aroon_up   : std_logic_vector(N-1 downto 0);
signal Previous_Aroon_down   : std_logic_vector(N-1 downto 0);
signal buy                :     std_logic_vector(1 downto 0);
signal sell               :     std_logic_vector(1 downto 0);
signal sell_out            :     std_logic_vector(3 downto 0);

signal Count_high : std_logic_vector(L-1 downto 0):=(others=>'0'); 
signal Count_low : std_logic_vector(L-1 downto 0):=(others=>'0'); 


begin
	
	cntr_i_in <= (others=>'0');
	
	-- counter i
	cntr_i : entity work.countern generic map (N => L)
	port map(clk => clk, rst => rst, ld=> li, en => Ei, input => cntr_i_in, output => i);
	Zi_max <= '1' when (i = Length_file) else '0';
	
	-- counter j
	cntr_j_in <= i + 1;
	cntr_j : entity work.countern generic map (N => L)
	port map(clk => clk, rst => rst, ld => lj, en => Ej, input => cntr_j_in, output => j);
	Zj_max <= '1' when (j = i+Frame_size) else '0';
	
	-- multiplexers
	mux0_out <= j when (Csel = '1') else i;
	mux1_out <= mux0_out when (S1 = '1') else RdAddr;
	mux2_out <= '1' when (gt1 = '0') else '0';
	mux3_out <= '1' when (lt1 = '0') else '0';
	
	-- RAM
	RAM_A : entity work.RAM generic map (addr_width => L, data_width => N)
	port map( clk => clk, WE => WE_A, ADDR => mux1_out, DIN => Din_up, DOUT => RamA_out);
	Rom_up : entity work.ROM port map(addr =>Aroon_up_1,cout=>Aroon_up);
	
	-- register
	reg_A : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => EA, D => RamA_out, Q => EA_out); 
	reg_Count : entity work.reg generic map (N => N) port map (clk => clk, rst => RstC, en => EC, D => Adder1_out, Q => Count); 
	
	gt1 <= '1' when (RamA_out > EA_out) else '0';
	
	-- Accumulator
	Adder1_out <= mux2_out + Count;
	
	-- Formula Calculation
	Period <= Count when (Zj_max = '1') else (others=>'0');
	Aroon_up_1 <= std_logic_vector(unsigned(14-Period)*100);
	--Aroon_up_2 <=  std_logic_vector(unsigned(Aroon_up_1)/14);
   -- Aroon_up <=  Aroon_up_2 (N-1 downto 0);
  -- Dout <= Aroon_up;
	
	--Aroon_down
	RAM_B : entity work.RAM generic map (addr_width => L, data_width => N)
	port map( clk => clk, WE => WE_A, ADDR => mux1_out, DIN => Din_down, DOUT => RamB_out);
	
	-- register
	reg_B : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => EB, D => RamB_out, Q => EB_out); 
	reg_D : entity work.reg generic map (N => N) port map (clk => clk, rst => RstD, en => ED, D => Adder2_out, Q => Count1); 
	
	lt1 <= '1' when (RamB_out < EB_out) else '0';
	
	Rom_down : entity work.ROM port map(addr =>Aroon_down_1,cout=>Aroon_down);
	
	-- Accumulator
	Adder2_out <= mux3_out + Count1;
	
	-- Formula Calculation
	Period1 <= Count1 when (Zj_max = '1') else (others=>'0');
	Aroon_down_1 <= std_logic_vector(unsigned(14-Period1)*100);
	--Aroon_down_2 <=  std_logic_vector(unsigned(Aroon_down_1)/14);
    --Aroon_down <=  Aroon_down_2 (N-1 downto 0);
    Dout <= Aroon_down;
    
    	
    reg_Previous_Arron_up : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => Ebuy, D => Aroon_up , Q => Previous_Aroon_up);     
    reg_Previous_Arron_down : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => Esell, D => Aroon_down, Q => Previous_Aroon_down );  
    
    Ebuy<='1' when Zj_max='1' else '0';
    Esell<='1' when Zj_max='1' else '0';
    Buy <="01" when   (Aroon_up > Aroon_down and Previous_Aroon_up  <= Previous_Aroon_down )  else (others=>'0'); 
    Sell <="10" when  (Aroon_up < Aroon_down and Previous_Aroon_up  >= Previous_Aroon_down )  else (others=>'0'); 
    sell_out <= Buy & Sell   when (Zj_MAX='1')  else (others=>'0');
            with sell_out select 
            Order_signal  <=  Buy when  "0100",
                              Sell when "0010",
            (others => '0') when others;
    
end arch;


