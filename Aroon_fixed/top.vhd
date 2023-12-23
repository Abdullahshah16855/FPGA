library ieee;
use ieee.std_logic_1164.all;

-- top
entity top is
	generic (N : integer := 18);
	port 
	( 	-- Inputs 
		clk : in std_logic;
		rst : in std_logic;
		go : in std_logic;
		we_ramA : in std_logic;
		we_ramB : in std_logic;
		high_price : in std_logic_vector(N-1 downto 0);
		low_price : in std_logic_vector(N-1 downto 0);
		addr_read : in std_logic_vector(N-1 downto 0);
		-- Outputs
		done : out std_logic;
		order_signal : out std_logic_vector(1 downto 0)
    );
end top;

architecture arch of top is

   signal load : std_logic;
   signal S1 : std_logic;
   signal li : std_logic;
   signal lj : std_logic;
   signal lh : std_logic;
   signal LL : std_logic;
   signal Ei : std_logic;
   signal Ej : std_logic;
   signal en_buy : std_logic;
   signal en_sell : std_logic;
   signal enH : std_logic;
   signal enL : std_logic;
   signal gtH :	std_logic;
   signal lwL :	std_logic;
   signal clrH:	std_logic;
   signal clrL:	std_logic;
   signal Csel : std_logic;
   signal Zi_max : std_logic;
   signal Zj_max : std_logic;
   signal en_reg1 : std_logic;
   signal en_reg2 : std_logic;
   
begin 
	-- datapath Instant	
	datapath_inst: entity work.datapath 
    generic map ( N => N)
    port map
    ( 	 
	clk => clk,   
	rst => rst,  
	S1 => S1,
	load => load,
	Li => Li,
	Lj => Lj,
	lh => lh,
	LL => LL,
	en_buy => en_buy,
	en_sell => en_sell,
	enH => enH,
	enL => enL,
	Ei => Ei,
	Ej => Ej,
	en_reg1 => en_reg1,
	en_reg2 => en_reg2,
	gtH => gtH,
	lwL => lwL,
	clrH => clrH,
	clrL => clrL,
	we_ramA   => we_ramA,
	we_ramB   => we_ramB,
	Csel   => Csel,
	addr_read => addr_read,
	high_price => high_price,
	low_price => low_price,
	Zi_max => Zi_max,
	Zj_max => Zj_max,
	order_signal => order_signal 
	);

	-- Controller Instant
	controller_inst: entity work.controller 
	port map
	( 	  
	clk	=> clk,	
	rst => rst,  
	Go 	=> Go,	 
	S1 => S1,
	load => load,
	Li => Li,
	Lj => Lj,
	lh => lh,
	LL => LL,
	en_buy => en_buy,
	en_sell => en_sell,
	enH => enH,
	enL => enL,
	Ei => Ei,
	Ej => Ej,
	en_reg1 => en_reg1,
	en_reg2 => en_reg2,
	gtH => gtH,
	lwL => lwL,
	clrH => clrH,
	clrL => clrL,
	Csel   => Csel,
	Zi_max => Zi_max,
	Zj_max => Zj_max,
	Done => Done  
	);
	
end arch;


