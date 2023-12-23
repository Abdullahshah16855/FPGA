library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- datapath
entity datapath is
generic (N : integer := 18);
port 
( 	
	-- inputs	
	clk : in std_logic;
	rst : in std_logic:='1';

	S1 : in std_logic;  
	li : in std_logic;  
	lj : in std_logic;  
	lh : in std_logic;  
	LL : in std_logic;  
	Ei : in std_logic;  
	Ej : in std_logic;  
	enH : in std_logic;  
	enL : in std_logic;  
	en_buy : in std_logic;  
	en_sell : in std_logic;  
	gtH : out std_logic;  
	lwL : out std_logic;  
	clrH : in std_logic;  
	clrL : in std_logic;  
	load : out std_logic;  
	Csel : in std_logic;  
	Zi_max : out std_logic; 
	Zj_max : out std_logic; 
	en_reg1 : in std_logic;  
	en_reg2 : in std_logic;  
	we_ramA : in std_logic;  
	we_ramB : in std_logic;  
	addr_read : in std_logic_vector(N-1 downto 0);
	high_price : in std_logic_vector(N-1 downto 0);  
	low_price : in std_logic_vector(N-1 downto 0);
	order_signal : out std_logic_vector(1 downto 0) 
);
end datapath;

architecture arch of datapath is

signal j : std_logic_vector(N-1 downto 0); 
signal i : std_logic_vector(N-1 downto 0); 
signal buy : std_logic_vector(1 downto 0);
signal buy_temp : std_logic;
signal sell : std_logic_vector(1 downto 0);
signal cntr_j_in : std_logic_vector(N-1 downto 0);
signal mux0_out : std_logic_vector(N-1 downto 0); 
signal addr_ram : std_logic_vector(N-1 downto 0); 
signal sell_out : std_logic_vector(3 downto 0);
signal ramA_out : std_logic_vector(N-1 downto 0); 
signal ramB_out : std_logic_vector(N-1 downto 0); 
signal Aroon_up : std_logic_vector(7 downto 0); 
signal Aroon_down : std_logic_vector(7 downto 0); 
signal Previous_Aroon_up   : std_logic_vector(7 downto 0);
signal Previous_Aroon_down   : std_logic_vector(7 downto 0);
signal Zj_max_temp : std_logic;  

constant cntr_in : std_logic_vector(N-1 downto 0):= (others=>'0');
--constant cntr_in : std_logic_vector(N-1 downto 0):=(others=>'0');
constant Length_file : std_logic_vector(7 downto 0) := x"B8";  -- 185
constant Frame_size : std_logic_vector(7 downto 0) := x"10";  --15

begin
	
	-- Count_higher i
	cntr_i : entity work.countern generic map (N => N)
	port map(clk => clk, rst => rst, ld=> li, en => Ei, input => cntr_in, output => i);
	Zi_max <= '1' when (i = Length_file) else '0';
	
	-- Count_higher j
	cntr_j_in <= i + 1;
	cntr_j : entity work.countern generic map (N => N)
	port map(clk => clk, rst => rst, ld => lj, en => Ej, input => cntr_j_in, output => j);
	Zj_max_temp <= '1' when (j = i+Frame_size) else '0';
	load <= '1' when (j = i+1) else '0';

	
	-- Multiplexers
	mux0_out <= j when (Csel = '1') else i;
	addr_ram <= mux0_out when (S1 = '1') else addr_read;
	
	-- RAM
	RAM_A : entity work.RAM generic map (addr_width => N, data_width => N) port map(clk => clk, WE => we_ramA, ADDR => addr_ram, DIN => high_price, DOUT => ramA_out);	-- RAM
	RAM_B : entity work.RAM generic map (addr_width => N, data_width => N) port map(clk => clk, WE => we_ramB, ADDR => addr_ram, DIN => low_price, DOUT => ramB_out);	-- RAM
	
	-- Aroon_up
	up_inst : entity work.up_dp port map ( clk => clk, rst => rst, en_reg1 => en_reg1 , enH => enH, lh => lh, gtH => gtH, clrH => clrH ,ramA_out => ramA_out , dout => Aroon_up);	
	down_inst : entity work.down_dp port map ( clk => clk, rst => rst, en_reg1 => en_reg2 , enL => enL, LL => LL, lwL => lwL, clrL => clrL ,ramB_out => ramB_out , dout => Aroon_down);	
	
	--Buy/Sell Decision as an Order_signal
 	reg_Previous_Arron_up : entity work.reg generic map (N => 8) port map (clk => clk, rst => rst, en => en_buy, D => Aroon_up , Q => Previous_Aroon_up);     
    reg_Previous_Arron_down : entity work.reg generic map (N => 8) port map (clk => clk, rst => rst, en => en_sell, D => Aroon_down, Q => Previous_Aroon_down );  

    Buy <="01" when   (Aroon_up > Aroon_down and Previous_Aroon_up  <= Previous_Aroon_down )  else (others=>'0'); 
    Buy_temp <='1' when   (Aroon_up > Aroon_down and Previous_Aroon_up  <= Previous_Aroon_down )  else '0'; 
    Sell <="10" when  (Aroon_up < Aroon_down and Previous_Aroon_up  >= Previous_Aroon_down )  else (others=>'0'); 
    sell_out <= Buy & Sell   when (Zj_max_temp='1')  else (others=>'0');
    --sell_out <= Buy & Sell when (j = i+Frame_size) else (others=>'0');
    
    with sell_out select 
    order_signal <= Buy when  "0100",
                   Sell when "0010",
                    (others => '0') when others; 
                    
    Zj_max <= Zj_max_temp;

end arch;


