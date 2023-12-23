library ieee;
use ieee.std_logic_1164.all;

entity flip_flop is
Port
	(
	-- Input 
	clk : in std_logic;
	rst : in std_logic;
	en  : in std_logic;
	D 	: in std_logic;
	-- Output
	Q 	: out std_logic
	);
end flip_flop;

architecture arch of flip_flop is

signal output : std_logic;
 
begin
	process (clk) 
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				output <= '0';  
			elsif (en = '1') then
				output <= D;
			end if;
		end if;
	end process;
	
	Q <= output; 

end arch;
	
		