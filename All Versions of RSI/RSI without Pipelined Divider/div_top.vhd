library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all;

entity div_top is
generic ( N : integer := 17 ) ;
Port ( 
		clk : in std_logic;
		rst : in std_logic;
		div_start : in std_logic;
		ina : in std_logic_vector (N-1 downto 0);
		inb:  in std_logic_vector (N-1 downto 0);
		y:  out std_logic_vector (N-1 downto 0)
 );
end div_top;
 
architecture rtl of div_top is
    
signal Li : std_logic;
signal Ei : std_logic;
signal ld_shift1 : std_logic;
signal en_shift1 : std_logic;
signal ld_shift2 : std_logic;
signal en_shift2 : std_logic;
signal init : std_logic;
signal en_reg : std_logic;
signal gt : std_logic;
signal Z_start : std_logic;
signal Z_end : std_logic;

begin

div_cntrl1 : entity work.div_cntrl 
port map( 	 	
	clk 	  => clk, 	  
	rst 	  => rst, 	  
	Li => Li, 
	Ei => Ei, 
	ld_shift1 => ld_shift1, 
	en_shift1 => en_shift1, 
	ld_shift2 => ld_shift2, 
	en_shift2 => en_shift2, 
	init 	  => init,	  
	en_reg 	  => en_reg, 	  
	gt 		  => gt, 		  
	Z_start	  => Z_start, 		  
	div_start	  => div_start, 		  
	Z_end	  => Z_end
);

divider1 : entity work.divider 
port map ( 
	clk 	  => clk, 	  
	rst 	  => rst, 	  
	Li => Li, 
	Ei => Ei, 
	ina 	  => ina,
	inb		  => inb,
	ld_shift1 => ld_shift1, 
	en_shift1 => en_shift1, 
	ld_shift2 => ld_shift2, 
	en_shift2 => en_shift2, 
	init 	  => init,	  
	en_reg 	  => en_reg, 	  
	gt 		  => gt, 
	Z_start	  => Z_start, 		  
	Z_end	  => Z_end,	
	y 		  => y 	
 );
 
end rtl;
