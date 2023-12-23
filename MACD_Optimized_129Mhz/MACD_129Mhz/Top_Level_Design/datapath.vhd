library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- datapath
entity datapath is
generic (N : integer := 17; M : integer := 5);
port 
( 	
	-- Inputs
	clk : in std_logic;
	rst : in std_logic;
	sel_1  : in std_logic; 
	sel_2  : in std_logic;
	sel_3  : in std_logic;
	sel_4  : in std_logic;
	ei  : in std_logic; 
	li  : in std_logic; 
	en_reg1  : in std_logic; 
	en_reg2  : in std_logic; 
	en_reg3  : in std_logic; 
	en_reg4  : in std_logic; 
	en_reg5  : in std_logic; 
	en_reg6  : in std_logic; 
	en_reg7  : in std_logic; 
	en_reg8  : in std_logic; 
	en_reg9  : in std_logic; 
	en_reg10  : in std_logic; 
	en_reg11  : in std_logic; 
	en_reg12  : in std_logic; 
	we_ram  : in std_logic; 
	reg1_rst: in std_logic;  
	EN_MACD  : in std_logic; 
	EN_MACD_signal  : in std_logic; 
	cp_in : in std_logic_vector(N-1 downto 0); 
	addr_read : in std_logic_vector(N-1 downto 0); 
	
	-- Outputs
	Zi9  : out std_logic; 
	Zi12  : out std_logic; 
	Zi26  : out std_logic; 
	gt9 : out std_logic;
	gt12 : out std_logic;
	gt26 : out std_logic;
	Zmax : out std_logic; 
	order_signal : out std_logic_vector(1 downto 0)
);
end datapath;

architecture arch of datapath is

signal i : std_logic_vector(N-1 downto 0); 
signal Buy : std_logic_vector(1 downto 0); 
signal Sell : std_logic_vector(1 downto 0); 
signal macd : std_logic_vector(N-1 downto 0); 
signal cp_out : std_logic_vector(N-1 downto 0); 
signal sell_out : std_logic_vector(3 downto 0); 
signal ema12_out : std_logic_vector(N-1 downto 0); 
signal ema26_out : std_logic_vector(N-1 downto 0); 
signal ema9_out : std_logic_vector(N-1 downto 0); 
signal reg8_out : std_logic_vector(N-1 downto 0); 
signal diff_out : std_logic_vector(N-1 downto 0); 
signal addr_ram : std_logic_vector(N-1 downto 0); 
signal reg1_out : std_logic_vector(N+M-1 downto 0); 
signal reg9_out : std_logic_vector(N+M-1 downto 0); 
signal adder1_out : std_logic_vector(N+M-1 downto 0); 
signal adder2_out : std_logic_vector(N+M-1 downto 0); 
signal macd_signal : std_logic_vector(N-1 downto 0); 
signal Previous_macd : std_logic_vector(N-1 downto 0); 
signal Previous_macd_signal : std_logic_vector(N-1 downto 0); 

constant cntr_in : std_logic_vector(N-1 downto 0):=(others=>'0');
constant cntr_max : std_logic_vector(15 downto 0):=x"00C8";

begin
	
	-- Counter i
	couter_i : entity work.countern generic map (N => N) port map (clk => clk, rst => rst, ld => li, en => ei, input => cntr_in, output => i);
	Zi12 <= '1' when (i = x"0000C") else '0';
	gt12 <= '1' when (i > x"0000C") else '0';
	Zi26 <= '1' when (i = x"0001A") else '0';
	gt26 <= '1' when (i > x"0001A") else '0';
	Zi9 <= '1' when (i = x"00025") else '0';--22
	gt9 <= '1' when (i > x"00025") else '0';
	Zmax <= '1' when (i >= cntr_max) else '0';
	
    addr_ram <= i when (sel_1 = '1') else addr_read;
	RAM_A : entity work.RAM generic map (addr_width => 17, data_width => N) port map(clk => clk, WE => we_ram, ADDR => addr_ram, DIN => cp_in, dout => cp_out);
	
	-- Accumulator
	adder1_out <= cp_out + reg1_out;
	reg1 : entity work.reg generic map (N => N+M) port map (clk => clk, rst => reg1_rst, en => en_reg1, D => adder1_out, Q => reg1_out); 
	
	EMA12_inst : entity work.EMA12 port map (clk=>clk, rst=>rst, csel => sel_2, en_reg1 => en_reg2, en_reg2 => en_reg3, en_reg3 => en_reg4, in_1 => reg1_out, in_2 => cp_out, ema12_out => ema12_out); 
	EMA26_inst : entity work.EMA26 port map (clk=>clk, rst=>rst, csel => sel_3, en_reg1 => en_reg5, en_reg2 => en_reg6, en_reg3 => en_reg7, in_1 => reg1_out, in_2 => cp_out, ema26_out => ema26_out); 
	
	diff_out <= ema12_out-ema26_out+250;
	reg_8 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg8, D => diff_out, Q => reg8_out); 
	
	macd <= reg8_out;
	
	-- Accumulator
	adder2_out <= reg9_out + macd;
	reg_9 : entity work.reg generic map (N => N+M) port map (clk => clk, rst => rst, en => en_reg9, D => adder2_out, Q => reg9_out); 
	
	EMA9_inst : entity work.EMA9 port map (clk=>clk, rst=>rst, csel => sel_4, en_reg1 => en_reg10, en_reg2 => en_reg11, en_reg3 => en_reg12, in_1 => reg9_out, in_2 => macd, ema9_out => ema9_out); 
	
	macd_signal <= ema9_out;
	
	-- Comparator 
    reg_Previous_macd : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => EN_MACD, D => MACD , Q => Previous_macd);     
    reg_Previous_macd_signal : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => EN_MACD_signal, D => MACD_signal, Q => Previous_macd_signal ); 
            
    Buy <="01"  when (MACD > MACD_signal and Previous_macd <= Previous_macd_signal )  else (others=>'0'); 
    Sell <="10" when (MACD < MACD_signal and Previous_macd >= Previous_macd_signal )  else (others=>'0'); 
    sell_out <= Buy & Sell;
    
	with sell_out select 
		order_signal <= Buy when  "0100",
						Sell when "0010",
						(others => '0') when others;
end arch;
