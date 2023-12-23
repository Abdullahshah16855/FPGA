library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- ema9
entity ema9 is
generic (N : integer := 17; M : integer := 5);
port 
( 	
	-- Inputs
	clk : in std_logic;
	rst : in std_logic;
	csel  : in std_logic;
	in_1 : in std_logic_vector(N+M-1 downto 0); 
	in_2 : in std_logic_vector(N-1 downto 0); 
	en_reg1  : in std_logic; 
	en_reg2  : in std_logic; 
	en_reg3  : in std_logic; 

	ema9_out : out std_logic_vector(N-1 downto 0)
);
end ema9;

architecture arch of ema9 is

	signal ema9 : std_logic_vector(N-1 downto 0); 
	signal sma_9 : std_logic_vector(N-1 downto 0); 
	signal mult1 : std_logic_vector(43 downto 0); 
	signal mult2 : std_logic_vector(32 downto 0); 
	signal mult3 : std_logic_vector(32 downto 0);
	signal mux_out : std_logic_vector(N-1 downto 0); 
	signal reg1_out : std_logic_vector(N-1 downto 0); 
	signal reg2_out : std_logic_vector(N-1 downto 0); 
	signal reg3_out : std_logic_vector(N-1 downto 0); 
	signal r_shift16 : std_logic_vector(N-1 downto 0); 
	signal adder_out: std_logic_vector(32 downto 0); 
	signal mult1_trunc : std_logic_vector(32 downto 0);  
	signal adder_trunc : std_logic_vector(32 downto 0); 
	
	-- constants
    constant K1_constant1 : std_logic_vector(15 downto 0):=x"3333";
	constant K1_constant2 : std_logic_vector(15 downto 0):=x"CCCC";

begin
    -- Calculation of SMA i.e. Avg
    mult1 <= std_logic_vector(unsigned(in_1)*7281); -- 33 bits
    mult1_trunc <= "00000000" & mult1 (24 downto 0); -- 33 bits
    sma_9 <= "00000000" & mult1_trunc(24 downto 16);  -- Right shift by 16 ( 17 bits)
	
    mux_out <= sma_9 when (csel = '1') else r_shift16;
	
    reg_2 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg2, D => mux_out, Q => reg2_out); 
	reg_1 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg1, D => in_2, Q => reg1_out); 
	
    mult2 <= std_logic_vector(unsigned(reg2_out) * unsigned(K1_constant2)); -- 33 bits
    mult3 <= std_logic_vector(unsigned(reg1_out) * unsigned(K1_constant1)); -- 31 bits
	
	adder_out <= mult2 + mult3;
	
    adder_trunc <= adder_out (32 downto 0); -- 33 bits
    r_shift16 <= adder_trunc(32 downto 16);  -- Right shift by 16 (17 bits)
	
	ema9 <= mux_out;
    reg_3 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg3, D => ema9, Q => reg3_out); 
	ema9_out <= reg3_out;

end arch;
