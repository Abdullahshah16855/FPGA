library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;
 
entity div_block is
generic (N : integer := 20);
port 
( 
    clk : in std_logic;
    rst : in std_logic;
    div_start : in std_logic;
	ina : in std_logic_vector (19 downto 0);-- range 0 to 99;
	inb:  in std_logic_vector (19 downto 0);-- range 1 to 9;
	en_reg10 : in std_logic;
	en_reg11 : in std_logic;
	quot:  out std_logic_vector (11 downto 0);-- range 0 to 99;
	div_done : out std_logic
 );
end div_block;
 
architecture rtl of div_block is
    
signal reg10_out : std_logic_vector (19 downto 0);
signal reg11_out : std_logic_vector (19 downto 0);
signal reg11_temp : std_logic_vector (17 downto 0);
signal div_out: std_logic_vector (11 downto 0);
signal mux1_out   		  :     std_logic_vector(N-1 downto 0); 
signal mult               :     std_logic_vector(N+6 downto 0); 

begin
 

reg10_GainOut : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg10, D =>ina, Q => reg10_out);   
mult <= reg10_out(19 downto 0)&"0000000";  
	 
reg11_LossOut : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg11, D =>inb, Q => reg11_out);  
reg11_temp<=reg11_out(6 downto 0)&"00000000000";

Divider_Rs : entity work.div_top  port map(clk=>clk,rst=>rst,div_start=>div_start,ina =>mult(17 downto 0), inb=>reg11_temp ,y=>div_out, div_done => div_done );    -- Rs = RS_1 / Mux2_out average gain by loss
--Divider_Rs : entity work.divider  port map(ina =>mult(N-1 downto 0), inb=>reg11_out ,quot=>div_out);    -- Rs = RS_1 / Mux2_out average gain by loss

reg3 : entity work.reg generic map (N => 12) port map (clk => clk, rst => rst, en => '1', D => div_out, Q =>quot ); 

 
end rtl;