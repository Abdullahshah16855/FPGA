library ieee;
use ieee.std_logic_1164.all;

-- top
entity top is
	generic (N : integer := 20);
	port 
	( 	-- Inputs 
		clk : in std_logic;
		rst : in std_logic;
		Go :  in std_logic;
		We :  in std_logic;
		Din : in std_logic_vector(N-1 downto 0);
		RdAddr : in std_logic_vector(7 downto 0);
		-- Outputs
		Done : out std_logic;
		Dout : out std_logic_vector(1 downto 0)
    );
end top;

architecture arch of top is
   -- Top signals
   signal csel1 : std_logic;
   signal csel2 : std_logic;
   signal csel3 : std_logic;
   signal Li : std_logic;
   signal Ei : std_logic;
   signal en_reg1 : std_logic;
   signal en_reg2 : std_logic;
   signal en_reg5 : std_logic;
   signal en_reg3 : std_logic;
   signal en_reg4 : std_logic;
   signal en_reg7 : std_logic;
   signal en_reg6 : std_logic;
   signal en_reg8 : std_logic;
   signal en_reg9 : std_logic;
   signal en_reg10 : std_logic;
   signal en_reg11 : std_logic;
   signal en_Ldiff : std_logic;
  signal en_Gdiff : std_logic;
   signal Zi : std_logic;
   signal gt1 : std_logic;
   signal Zmax : std_logic;
   signal enable1 : std_logic;
   signal enable2 : std_logic;
   signal sel : std_logic;
begin 
	-- Top_DatapathInstant	
	datapath_inst: entity work.datapath
    generic map ( N => N)
    port map
    ( 	 
	clk => clk,   
	rst => rst,  
	csel1  => csel1,   
	csel2  => csel2,   
	csel3  => csel3,   
	Ei  => Ei,    
	Li  => Li,    
	en_reg1  => en_reg1,       
	en_reg2  => en_reg2,    
	en_reg5  => en_reg5,
    en_reg3  => en_reg3,    
	en_reg6  => en_reg6,    
	en_reg4  => en_reg4,    
	en_reg7  => en_reg7,     
	en_reg8  => en_reg8,     
	en_reg9 => en_reg9,     
	en_reg10 => en_reg10,     
	en_reg11 => en_reg11,     
   en_Gdiff  => en_Gdiff,
    enable1  => enable1,     
    enable2  => enable2,     
    en_Ldiff  => en_Ldiff,     
	We  => We,    
	Zi  => Zi,   
	sel => sel,   
	gt1  => gt1,   
	Din  => Din,   
	Dout => Dout,
	Zmax => Zmax, 
	RdAddr => RdAddr

	);
	-- Controller Instant
	controller_inst: entity work.controller 
	port map
	( 	  
	clk	=> clk,	
	rst => rst,  
	Go 	=> Go,	 
	csel1 => csel1,    
	csel2 => csel2,    
	csel3 => csel3,       
	Li => Li,    
	Ei => Ei,   
	enable1  => enable1, 
	enable2  => enable2, 
	en_reg1 => en_reg1,        
	en_reg2 => en_reg2,    
	en_reg5 => en_reg5,
	en_reg4 => en_reg4,
	en_reg7 => en_reg7,
    en_reg3  => en_reg3,    
    en_reg6  => en_reg6,
    en_reg8  => en_reg8,
    en_reg9  => en_reg9,
    en_reg10  => en_reg10,
    en_reg11  => en_reg11,
    en_Gdiff  => en_Gdiff,     
   en_Ldiff  => en_Ldiff,  
	Zi  => Zi,
	sel => sel,
	gt1=>gt1,   
	Zmax => Zmax,  
	Done => Done 
	);
	
end arch;


