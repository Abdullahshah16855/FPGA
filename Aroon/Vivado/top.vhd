library ieee;
use ieee.std_logic_1164.all;

-- top
entity top is
	generic (N : integer := 20);
	port 
	( 	-- Inputs 
		clk : in std_logic;
		rst : in std_logic;
		Go : in std_logic;
		WE_A : in std_logic;
		WE_B : in std_logic;
		Din_up : in std_logic_vector(N-1 downto 0);
		Din_down : in std_logic_vector(N-1 downto 0);
		RdAddr : in std_logic_vector(N-1 downto 0);
		-- Outputs
		Done : out std_logic;
		Dout : out std_logic_vector(N-1 downto 0)
		--order_signal : out std_logic_vector(1 downto 0)
    );
end top;

architecture arch of top is
   -- Top signals
   signal RAdd : std_logic;
   signal S1 : std_logic;
   signal Li : std_logic;
   signal Lj : std_logic;
   signal Ei : std_logic;
   signal Ej : std_logic;
   signal EA : std_logic;
   signal EB : std_logic;
   signal EC :	std_logic;
   signal ED :	std_logic;
   signal Csel : std_logic;
   signal gt1 : std_logic;
   signal lt1 : std_logic;
   signal RstC : std_logic;
   signal RstD : std_logic;
   signal Zi_max	: std_logic;
   signal Zj_max	: std_logic;
 
begin 
	-- datapath Instant	
	datapath_inst: entity work.datapath 
    generic map ( N => N)
    port map
    ( 	 
	clk => clk,   
	rst => rst,  
	RdAddr => RdAddr,
	S1 => S1,
	Li => Li,
	Lj => Lj,
	gt1 => gt1,
	lt1 => lt1,
	Ei => Ei,
	Ej => Ej,
	EA => EA,
	EB => EB,
	EC => EC,
	ED => ED,
	WE_A   => WE_A  ,
	WE_B   => WE_B  ,
	Csel   => Csel  ,
	RstC => RstC,
	RstD => RstD,
	Din_up   => Din_up   ,
	Din_down   => Din_down   ,
	Zi_max => Zi_max,
	Zj_max => Zj_max,
	Dout   => Dout 
	--order_signal=>order_signal
	);

	-- Controller Instant
	controller_inst: entity work.controller 
	port map
	( 	  
	clk	=> clk,	
	rst => rst,  
	Go 	=> Go,	 
	S1 => S1,
	gt1 =>gt1,
	lt1 =>lt1,
	Li => Li,
	Lj => Lj,
	Ei => Ei,
	Ej => Ej,
	EA => EA,
	EB => EB,
	EC => EC,
	ED => ED,
	Csel     => Csel ,   
	RstC   => RstC,   
	RstD   => RstD,   
	Zi_max   => Zi_max , 
	Zj_max   => Zj_max  ,
	Done => Done  
	);
	
end arch;


