library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all;

entity divider is
generic ( N : integer := 17 ) ;
port ( 
		clk : in std_logic;
		rst : in std_logic;
		ina : in std_logic_vector (N-1 downto 0);
		inb:  in std_logic_vector (N-1 downto 0);
		-- control signals
		Li : in std_logic;
		Ei : in std_logic;
		ld_shift1 : in std_logic;
		en_shift1 : in std_logic;
		ld_shift2 : in std_logic;
		en_shift2 : in std_logic;
		init : in std_logic;
		en_reg : in std_logic;
		-- status signals
		gt : out std_logic;
		Z_start : out std_logic;
		Z_end : out std_logic;
		-- output
		y  : out std_logic_vector (N-1 downto 0)
 );
end divider;
 
architecture rtl of divider is
    
signal b_shifted :  std_logic_vector (N-1 downto 0);
signal sub_out :  std_logic_vector (N-1 downto 0);
signal mux_out :  std_logic_vector (N-1 downto 0);
signal reg_out :  std_logic_vector (N-1 downto 0);
signal i :  std_logic_vector (N-1 downto 0);
signal gt_temp : std_logic;
-- constant CNTR_START :  std_logic_vector (N-1 downto 0) := '0' & x"0010";
constant CNTR_START :  std_logic_vector (N-1 downto 0) := '0' & x"000B";
constant CNTR_END :  std_logic_vector (N-1 downto 0) := (OTHERS => '0');

begin
	-- Counter i
	couter_i : entity work.countern generic map (N => 17) port map (clk => clk, rst => rst, ld => Li, en => Ei, input => CNTR_START, output => i);
	Z_start <= '1' when (i = CNTR_START) else '0';	
	Z_end <= '1' when (i = CNTR_END) else '0';	

	shift_reg1 : entity work.shift_reg (right_shift) generic map(N => N) port map(clk => clk, load => ld_shift1, enable => en_shift1, sin => '0', d => inb, q => b_shifted) ;

	sub_out <= reg_out - b_shifted;
	mux_out <= ina when (init = '0') else sub_out;
	reg1 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg, D => mux_out, Q => reg_out);  

	gt_temp <= '1' when (reg_out >= b_shifted) else '0';
	gt <= gt_temp;

	shift_reg2 : entity work.shift_reg (left_shift) generic map(N => N) port map(clk => clk, load => ld_shift2, enable => en_shift2, sin => gt_temp, d => (others => '0'),  q => y) ;
end rtl;
