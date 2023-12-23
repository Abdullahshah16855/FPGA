library ieee;
use ieee.std_logic_1164.all;

-- top
entity top is
	generic (N : integer := 17);
	port 
	( 	-- Inputs 
		clk : in std_logic;
		rst : in std_logic;
		go : in std_logic;
		we_ram : in std_logic;
		cp_in : in std_logic_vector(N-1 downto 0);
		addr_read : in std_logic_vector(N-1 downto 0);
		-- Outputs
		done : out std_logic;
		order_signal : out std_logic_vector(1 downto 0)
    );
end top;

architecture arch of top is
   -- Top signals
   signal sel_1 : std_logic;
   signal sel_2 : std_logic;
   signal sel_3 : std_logic;
   signal sel_4 : std_logic;
   signal li : std_logic;
   signal ei : std_logic;
   signal en_reg1 : std_logic;
   signal en_reg2 : std_logic;
   signal en_reg3 : std_logic;
   signal en_reg4 : std_logic;
   signal en_reg5 : std_logic;
   signal en_reg6 : std_logic;
   signal en_reg7 : std_logic;
   signal en_reg8 : std_logic;
   signal en_reg9 : std_logic;
   signal en_reg10 : std_logic;
   signal en_reg11 : std_logic;
   signal en_reg12 : std_logic;
   signal EN_MACD  : std_logic;
   signal EN_MACD_signal : std_logic;
   signal zi9 : std_logic;
   signal zi12 : std_logic;
   signal zi26 : std_logic;
   signal gt9 : std_logic;
   signal gt12 : std_logic;
   signal gt26 : std_logic;
   signal reg1_rst : std_logic;
   signal Zmax : std_logic;

begin 
	-- datapath Instant	
	datapath: entity work.datapath 
    generic map ( N => N)
    port map
    ( 	 
	clk => clk,   
	rst => rst,  
	ei  => Ei,    
	li  => Li,    
	we_ram  => we_ram,    
	cp_in  => cp_in,   
	reg1_rst => reg1_rst,  
	addr_read => addr_read,
	gt9 => gt9, 
	gt12 => gt12, 
	gt26 => gt26, 
	zi9  => zi9,  
	zi26  => zi26,  
	zi12  => zi12,  
	Zmax => Zmax,
	sel_1  => sel_1,   
	sel_2  => sel_2,   
	sel_3  => sel_3,   
	sel_4  => sel_4,   
	en_reg1  => en_reg1,    
	en_reg2  => en_reg2,    
	en_reg3  => en_reg3,    
	en_reg4  => en_reg4,    
	en_reg5  => en_reg5,    
	en_reg6  => en_reg6,    
	en_reg7  => en_reg7,    
	en_reg8  => en_reg8,    
	en_reg9  => en_reg9,    
	en_reg10  => en_reg10,    
	en_reg11  => en_reg11,    
	en_reg12  => en_reg12,    
	EN_MACD   => EN_MACD,    
	EN_MACD_signal=> EN_MACD_signal, 
	order_signal => order_signal
	);
	-- Controller Instant
	controller_inst: entity work.controller 
	port map
	( 	  
	clk	=> clk,	
	rst => rst,  
	go 	=> go,	 
	sel_1 => sel_1,    
	sel_2 => sel_2,    
	sel_3 => sel_3,    
	sel_4 => sel_4,    
	li => li,    
	ei => ei, 
	gt9 => gt9,     
	gt12 => gt12,  
	gt26 => gt26,  
	zi9  => zi9,  
	zi12  => zi12,  
	zi26  => zi26,    
	Zmax => Zmax, 
	reg1_rst => reg1_rst,    
	en_reg1  => en_reg1,    
	en_reg2  => en_reg2,    
	en_reg3  => en_reg3,    
	en_reg4  => en_reg4,      
	en_reg5  => en_reg5,      
	en_reg6  => en_reg6,      
	en_reg7  => en_reg7, 
	en_reg8  => en_reg8,    
	en_reg9  => en_reg9,    
	en_reg10  => en_reg10,    
	en_reg11  => en_reg11,    
	en_reg12  => en_reg12,  	
	EN_MACD   => EN_MACD,    
	EN_MACD_signal=> EN_MACD_signal,    
	done => done 
	);
	
end arch;


