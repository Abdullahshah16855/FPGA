library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all;

entity module is
generic ( N : integer := 17 ) ;
port ( 
		clk : in std_logic;
		rst : in std_logic;
		sel_mux : in std_logic;
		en_reg : in std_logic;
		ina : in std_logic_vector (N-1 downto 0);  -- input a 
		bs:  in std_logic_vector (N-1 downto 0); --  bs i.e.  Bshifted
		-- control signals
		a:  out std_logic_vector (N-1 downto 0); --  bs i.e.  Bshifted
		gt : out std_logic
		
 );
end module;
 
architecture rtl of module is
    
signal gt_temp : std_logic;
signal sub_out :  std_logic_vector (N-1 downto 0);
signal sub_out1 :  std_logic_vector (N-1 downto 0);
signal mux_out :  std_logic_vector (N-1 downto 0);
signal a_temp :  std_logic_vector (N-1 downto 0);

begin
	--sub_out <= ina-bs when ina>0 else (others=>'0');
	sub_out <= ina-bs;
	mux_out<=ina when(sel_mux='0') else sub_out;
	gt_temp <= '1' when (ina >= bs) else '0';
    gt <= gt_temp;
	reg_1 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg, D => mux_out, Q => a_temp);  
    a <= a_temp;
	

end rtl;
