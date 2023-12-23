library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- up_dp
entity up_dp is
generic (N : integer := 18);
port 
( 	
	-- inputs	
	clk : in std_logic;
	rst : in std_logic:='1';
	
	en_reg1 : in std_logic;  
	enH : in std_logic;  
	lh : in std_logic;  
	gtH : out std_logic;  
	clrH : in std_logic:='0';  
	ramA_out : in  std_logic_vector(N-1 downto 0);  
	dout : out std_logic_vector(7 downto 0)
);
end up_dp;

architecture arch of up_dp is

signal reg1_out : std_logic_vector(N-1 downto 0); 
signal aroon_up : std_logic_vector(7 downto 0); 
signal up_count : std_logic_vector(3 downto 0); 

constant cntr_in : std_logic_vector(3 downto 0):=(others=>'0');

begin
	-- Register
	reg_1 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg1, D => ramA_out, Q => reg1_out); 
	
	-- Comparator
	gtH <= '1' when (ramA_out > reg1_out) else '0';

	-- Counter H
	couter_H : entity work.countern generic map (N => 4) port map (clk => clk, rst => clrH, ld => lh, en => enH, input => cntr_in, output => up_count);

	-- ROM
	Rom_high: entity work.div_rom14 port map(addr  => up_count, cout => aroon_up);	

	dout <= aroon_up;
	
end arch;


