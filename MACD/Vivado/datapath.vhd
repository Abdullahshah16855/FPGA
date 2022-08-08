library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Datapath
entity datapath is
generic (N : integer := 17; M : integer := 5);
port 
( 	
	-- Inputs
	clk : in std_logic;
	rst : in std_logic;
	S1  : in std_logic; 
	S2  : in std_logic;
	S3  : in std_logic;
	S4  : in std_logic;
	Ei  : in std_logic; 
	Li  : in std_logic; 
	EA  : in std_logic; 
	EB  : in std_logic; 
	EC  : in std_logic; 
	ED  : in std_logic; 
	We  : in std_logic; 
	esum: in std_logic;  
	Rstsum: in std_logic;  
	RstC: in std_logic;  
	Csel_1: in std_logic; 
	Csel_2: in std_logic; 
	Csel_3: in std_logic; 
	Din : in std_logic_vector(N-1 downto 0); 
	RdAddr : in std_logic_vector(N-1 downto 0); 
	
	-- Outputs
	Zi12  : out std_logic; 
	Zi26  : inout std_logic; 
	Zi9  : inout std_logic; 
	gt12 : out std_logic;
	gt26 : inout std_logic;
	gt9 : inout std_logic;
	Zmax : out std_logic; 
	Dout : out std_logic_vector(1 downto 0)
);
end datapath;

architecture arch of datapath is

	signal avg_1 : std_logic_vector(32 downto 0);  --
	signal avg_2 : std_logic_vector(32 downto 0);  --
	signal avg_3 : std_logic_vector(24 downto 0);  --
	signal avg_K1_temp : std_logic_vector(49 downto 0);  --
	signal avg_K2_temp : std_logic_vector(49 downto 0);  --
	signal avg_K3_temp : std_logic_vector(49 downto 0);  --
	signal EMA12 : std_logic_vector(N-1 downto 0); 
	signal EMA26 : std_logic_vector(N-1 downto 0); 
	signal avg_12 : std_logic_vector(N-1 downto 0); 
	signal avg_26 : std_logic_vector(N-1 downto 0); 
	signal avg_9 : std_logic_vector(N-1 downto 0); 
	signal EA_out : std_logic_vector(N-1 downto 0); 
	signal EB_out : std_logic_vector(N-1 downto 0); 
	signal EC_out : std_logic_vector(N+M-1 downto 0); 
	signal ED_out : std_logic_vector(N-1 downto 0); 
	signal EN_MACD : std_logic; 
	signal EN_MACD_signal : std_logic; 
	signal ram_out : std_logic_vector(N-1 downto 0); 
	signal i_count : std_logic_vector(N-1 downto 0);  
	signal cntr_in : std_logic_vector(N-1 downto 0);
	signal mux0_out : std_logic_vector(N-1 downto 0); 
	signal mux1_out : std_logic_vector(N-1 downto 0); 
	signal mux2_out : std_logic_vector(N-1 downto 0); 
	signal mux3_out : std_logic_vector(N-1 downto 0); 
	signal mux4_out : std_logic_vector(N-1 downto 0); 
	signal mux5_out : std_logic_vector(N-1 downto 0); 
	signal mux6_out : std_logic_vector(N-1 downto 0);
	signal MACD : std_logic_vector(N-1 downto 0); 
	signal MACD_signal : std_logic_vector(N-1 downto 0); 
	signal Adder_out: std_logic_vector(N+M-1 downto 0); --
	signal Adder_out_MACD: std_logic_vector(N+M-1 downto 0); --
	signal esum_out : std_logic_vector(N+M-1 downto 0);  --
	signal EMA12_out : std_logic_vector(N-1 downto 0); 
	signal EMA26_out : std_logic_vector(N-1 downto 0); 
	signal EMA9_out : std_logic_vector(N-1 downto 0); 
	signal EMA12_calc_1 : std_logic_vector(32 downto 0); --
	signal EMA26_calc_1 : std_logic_vector(32 downto 0); --
	signal EMA9_calc_1 : std_logic_vector(20 downto 0); --
	signal EMA12_calc_K1_temp : std_logic_vector(39 downto 0); --
	signal EMA26_calc_K2_temp : std_logic_vector(39 downto 0); --
	signal EMA9_calc_K3_temp : std_logic_vector(39 downto 0); --
	signal K1_temp : std_logic_vector(N-1 downto 0); 
	signal K2_temp : std_logic_vector(N-1 downto 0); 
	signal K3_temp : std_logic_vector(N-1 downto 0); 
	signal K1_temp2 : std_logic_vector(N-1 downto 0);
	signal K2_temp2 : std_logic_vector(N-1 downto 0);
	signal K3_temp2 : std_logic_vector(N-1 downto 0);
    constant K1_constant : std_logic_vector(N-1 downto 0):=x"02762";
	constant K1_constant2 : std_logic_vector(N-1 downto 0):=x"0D89D";
    constant K2_constant : std_logic_vector(N-1 downto 0):=x"012F6";
	constant K2_constant2 : std_logic_vector(N-1 downto 0):=x"0ED09";
	constant K3_constant : std_logic_vector(N-1 downto 0):=x"03333";
	constant K3_constant2 : std_logic_vector(N-1 downto 0):=x"0CCCC";
	signal Previous_macd   : std_logic_vector(N-1 downto 0);
    signal Previous_macd_signal  : std_logic_vector(N-1 downto 0); 
	signal buy : std_logic_vector(1 downto 0);
    signal sell : std_logic_vector(1 downto 0);
	signal sell_out : std_logic_vector(3 downto 0);
	constant CNTR_MAX : std_logic_vector(N-1 downto 0) := x"0016D";   -- X"00C8" = 200

begin
	
	cntr_in <=  x"00000"; 	-- Initialize counter value with '1'

	-- Counter i
	couter_i : entity work.countern generic map (N => N) port map (clk => clk, rst => rst, ld => Li, en    => Ei, input => cntr_in, output => i_count);
	
	-- RAM 
	RAM_A : entity work.RAM generic map (addr_width => 20, data_width => N) port map(clk => clk, WE => We, ADDR => mux0_out, DIN => Din, Dout => ram_out);
    
	-- Register
	reg_esum_out : entity work.reg generic map (N => N+M) port map (clk => clk, rst => Rstsum, en => esum, D => Adder_out, Q => esum_out); 
    reg_EA : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => EA, D => mux1_out, Q => EA_out); 
	reg_EB : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => EB, D => mux3_out, Q => EB_out); 
	reg_EC : entity work.reg generic map (N => N+M) port map (clk => clk, rst => RstC, en => EC, D => Adder_out_MACD, Q => EC_out); 
    reg_ED : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => ED, D => mux5_out, Q => ED_out); 

	--Status signal
	Zi12 <= '1' when (i_count = x"0000C") else '0';
	Zi26 <= '1' when (i_count = x"0001A") else '0';
	Zi9 <= '1' when (i_count = x"00022") else '0';
	gt12 <= '1' when (i_count > x"0000C") else '0';
	gt26 <= '1' when (i_count > x"0001A") else '0';
	gt9 <= '1' when (i_count > x"00022") else '0';
	Zmax <= '1' when (i_count >= CNTR_MAX) else '0';
	
	-- Multiplexers
    mux0_out <= i_count when (S1 = '1') else RdAddr;
    mux1_out <= avg_12 when (S2 = '1') else EMA12_out;
    mux2_out <= ram_out when (Csel_1 = '1') else (others=>'0');
	mux3_out <= avg_26 when (S3 = '1') else EMA26_out;
	mux4_out <= ram_out when (Csel_2 = '1') else (others=>'0');
	mux5_out <= avg_9 when (S4 = '1') else EMA9_out; 
	mux6_out <= MACD when (Csel_3 = '1') else (others=>'0');

	-- Accumulator
	Adder_out <= ram_out + esum_out;
	Adder_out_MACD <= MACD+ EC_out;
	
	-- Calculation of EMA12
    avg_K1_temp <= std_logic_vector(unsigned(esum_out)*5461); -- 33 bits
    avg_1 <= avg_K1_temp (32 downto 0); -- 33 bits
    avg_12 <= "000" & avg_1(32 downto 16);  -- Right shift by 16 ( 17 bits)
	
		-- Calculation of EMA12
    K1_temp <= K1_constant;
    K1_temp2 <= K1_constant2;
    EMA12_calc_K1_temp <= std_logic_vector((unsigned(mux2_out)*unsigned(K1_temp))+(unsigned(EA_out)*unsigned(K1_temp2))); -- 33 bits
    EMA12_calc_1 <= EMA12_calc_K1_temp (32 downto 0); -- 33 bits
    EMA12_out <= "000" & EMA12_calc_1(32 downto 16);    -- Right shift by 16 (17 bits)
    EMA12 <= mux1_out;		
	
	-- Calculation of EMA26
    avg_K2_temp <= std_logic_vector(unsigned(esum_out)*2520); -- 33 bits
    avg_2 <= avg_K2_temp (32 downto 0); -- 33 bits
    avg_26 <= "000" & avg_2(32 downto 16);  -- Right shift by 16 ( 17 bits)
    
	-- Calculation of EMA12
    K2_temp <= K2_constant;
    K2_temp2 <= K2_constant2;
    EMA26_calc_K2_temp <= std_logic_vector((unsigned(mux4_out)*unsigned(K2_temp))+(unsigned(EB_out)*unsigned(K2_temp2))); -- 33 bits
    EMA26_calc_1 <= EMA26_calc_K2_temp (32 downto 0); -- 33 bits
    EMA26_out <= "000" & EMA26_calc_1(32 downto 16);    -- Right shift by 16 (17 bits)
    EMA26 <= mux3_out;	
	
	-- Calculation of EMA9
    avg_K3_temp <= std_logic_vector(unsigned(EC_out)*7281); -- 25 bits
    avg_3 <= avg_K3_temp (24 downto 0); -- 25 bits
    avg_9 <= "00000000000" & avg_3(24 downto 16);  -- Right shift by 16 ( 9 bits)
    
	-- Calculation of EMA9
    K3_temp <= K3_constant;
    K3_temp2 <= K3_constant2;
    EMA9_calc_K3_temp <= std_logic_vector((unsigned(mux6_out)*unsigned(K3_temp))+(unsigned(ED_out)*unsigned(K3_temp2))); -- 21 bits
    EMA9_calc_1 <= EMA9_calc_K3_temp (20 downto 0); -- 21 bits
    EMA9_out <=  "00000000000" & EMA9_calc_1(20 downto 12);    -- Right shift by 16 (9 bits)
    MACD_signal <= mux5_out;  -- MACD_signal = EMA9 
    
    -- Calculation of MACD
    MACD <= (EMA12-EMA26+250) when (gt26='1' or Zi26='1')  else (others=>'0');
	
	-- Comparator 
    reg_Previous_macd : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => EN_MACD, D => MACD , Q => Previous_macd);     
    reg_Previous_macd_signal : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => EN_MACD_signal, D => MACD_signal, Q => Previous_macd_signal ); 
            
	EN_MACD<='1' when (gt9='1' or Zi9='1') else '0';
    EN_MACD_signal<='1' when (gt9='1' or Zi9='1') else '0';
    Buy <="01"  when (MACD > MACD_signal and Previous_macd <= Previous_macd_signal )  else (others=>'0'); 
    Sell <="10" when (MACD < MACD_signal and Previous_macd >= Previous_macd_signal )  else (others=>'0'); 
    sell_out <= Buy & Sell;
        with sell_out select 
			Dout <= Buy when  "0100",
                    Sell when "0010",
					(others => '0') when others;


end arch;
