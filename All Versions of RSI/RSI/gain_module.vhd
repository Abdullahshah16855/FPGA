library ieee;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gain_module is
generic (N : integer := 20; M : integer := 20);
port 
( 	    
	clk 	: in std_logic;
	rst 	: in std_logic;
	csel2  	: in std_logic;
	en_reg2 : in std_logic; 
	en_reg3 : in std_logic;
	en_reg4 : in std_logic;
	gain_diff : in std_logic_vector(N-1 downto 0);
	SMA_gain  : out  std_logic_vector(N-1 downto 0)
);
end gain_module;

architecture arch of gain_module is
    
signal reg2_out : std_logic_vector(N-1 downto 0);
signal reg3_out : std_logic_vector(N-1 downto 0);
signal mux1_out : std_logic_vector(N-1 downto 0);
signal adder1_out : std_logic_vector(N-1 downto 0);
signal average_gain1 : std_logic_vector(N-1 downto 0);
signal average_gain2 : std_logic_vector(N-1 downto 0);
signal mult13_left : std_logic_vector(N+M-1 downto 0);
signal gain_out : std_logic_vector(N-1 downto 0);
signal divide_gain : std_logic_vector(N-1 downto 0);

begin

	adder1_out <= std_logic_vector(unsigned(gain_diff) + unsigned(reg2_out));
	
    reg2_inst : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg2, D => adder1_out, Q => reg2_out);     
	ROM_inst1 : entity work.ROM port map (ADDR => reg2_out,  COUT => average_gain1);    --- average gain divide by 14
	
	mux1_out <= average_gain1 when (csel2 = '1') else average_gain2;
	mult13_left <= std_logic_vector(unsigned(mux1_out) * 13);  --13*previous+loss
    reg3_inst : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg3, D => mult13_left(19 downto 0), Q => reg3_out);     
    
	reg4_inst : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg4, D => gain_diff, Q => gain_out);     
	divide_gain <= std_logic_vector(unsigned(reg3_out) + unsigned(gain_out));
	
	ROM_inst2 : entity work.ROM port map (ADDR => divide_gain,  COUT => average_gain2);    --- average gain divide by 14
	SMA_gain<=mux1_out;

   -- reg6_inst : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => mux1_out, Q => SMA_gain);     
	
end arch;
