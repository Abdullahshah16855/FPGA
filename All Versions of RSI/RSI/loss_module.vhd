library ieee;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity loss_module is
generic (N : integer := 20; M : integer := 20);
port 
( 	    
	clk 	: in std_logic;
	rst 	: in std_logic;
	csel3  	: in std_logic;
	en_reg5 : in std_logic; 
	en_reg6 : in std_logic;
	en_reg7 : in std_logic;
	loss_diff : in std_logic_vector(N-1 downto 0);
	SMA_loss  : out  std_logic_vector(N-1 downto 0)
);
end loss_module;

architecture arch of loss_module is
    
signal reg5_out : std_logic_vector(N-1 downto 0);
signal reg6_out : std_logic_vector(N-1 downto 0);
signal mux2_out : std_logic_vector(N-1 downto 0);
signal adder2_out : std_logic_vector(N-1 downto 0);
signal average_loss1 : std_logic_vector(N-1 downto 0);
signal average_loss2 : std_logic_vector(N-1 downto 0);
signal mult13_right : std_logic_vector(N+M-1 downto 0);
signal loss_out : std_logic_vector(N-1 downto 0);
signal divide_loss : std_logic_vector(N-1 downto 0);

begin

	adder2_out <= std_logic_vector(unsigned(loss_diff) + unsigned(reg5_out));
	
    reg5_inst : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg5, D => adder2_out, Q => reg5_out);     
	ROM_inst1 : entity work.ROM port map (ADDR => reg5_out,  COUT => average_loss1);    --- average gain divide by 14
	
	mux2_out <= average_loss1 when (csel3 = '1') else average_loss2;
	mult13_right <= std_logic_vector(unsigned(mux2_out) * 13);  --13*previous+loss
    reg6_inst : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg6, D => mult13_right(19 downto 0), Q => reg6_out);     
    
	reg7_inst : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg7, D => loss_diff, Q => loss_out);     
	divide_loss <= std_logic_vector(unsigned(reg6_out) + unsigned(loss_out));
	
	ROM_inst2 : entity work.ROM port map (ADDR => divide_loss,  COUT => average_loss2);    --- average gain divide by 14
	SMA_loss<=mux2_out;

    --reg7_inst : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => mux2_out, Q => SMA_loss);     
	
end arch;
