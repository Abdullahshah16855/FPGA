library ieee;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Datapath
entity datapath is
generic (N : integer := 20; M : integer := 20);
port 
( 	    clk : in std_logic;
        rst : in std_logic;
       -- rst_reg2 : in std_logic;
        csel1  : in std_logic; 
        csel2  : in std_logic;
        csel3  : in std_logic; 
        Ei  : in std_logic; 
        Li  : in std_logic; 
        en_reg1  : in std_logic; 
        en_reg2  : in std_logic; 
        en_reg5  : in std_logic;
        en_reg6  : in std_logic;
        en_reg7  : in std_logic;
        en_reg4  : in std_logic;
        en_reg3  : in std_logic; 
        en_reg9  : in std_logic; 
        en_reg8  : in std_logic;
        en_reg10  : in std_logic;
        en_reg11  : in std_logic;
        en_Gdiff  : in std_logic; 
        en_Ldiff  : in std_logic; 
        div_start  : in std_logic; 
        We  : in std_logic; 
        Din : in std_logic_vector(N-1 downto 0); 
        RdAddr : in std_logic_vector(7 downto 0); 
        -- Outputs
        Zi  : out std_logic; 
        Zi_start  : out std_logic; 
        gt1  : out std_logic; 
        sel  : out std_logic; 
        zmax1 : out std_logic;
        enable1 : out std_logic; 
        enable2 : out std_logic; 
        --enable2 : out std_logic; 
        Dout : out std_logic_vector(1 downto 0);
        div_done : out std_logic
);
end datapath;

architecture arch of datapath is

    
    signal cntr_in            :     std_logic_vector(7 downto 0);
	signal i_count    		  :     std_logic_vector(7 downto 0);
	signal addr_ram   		  :     std_logic_vector(7 downto 0); 
	signal mux1_out   		  :     std_logic_vector(N-1 downto 0); 
    signal mux2_out   		  :     std_logic_vector(N-1 downto 0);
    signal LossOut   		  :     std_logic_vector(N-1 downto 0);
    signal reg11_out   		  :     std_logic_vector(N-1 downto 0);
    signal RS_Shrink   		  :     std_logic_vector(N-1 downto 0);
    signal reg10_out            :     std_logic_vector(N-1 downto 0);
    signal ram_out    		  :     std_logic_vector(N-1 downto 0); 
    signal muxG_out     		  :     std_logic_vector(N-1 downto 0); 
    signal in_3      		  :     std_logic_vector(N-1 downto 0); 
    signal in_4      		  :     std_logic_vector(N-1 downto 0); 
    signal muxL_out      		  :     std_logic_vector(N-1 downto 0); 
	signal reg1_out     	  :     std_logic_vector(N-1 downto 0);
    signal reg2_out           :     std_logic_vector(N+M-1 downto 0);
    signal reg2_out_1         :     std_logic_vector(N+M-1 downto 0);
    signal reg5_out           :     std_logic_vector(N+M-1 downto 0);
    signal reg5_out_1         :     std_logic_vector(N+M-1 downto 0);
    signal difference         :     std_logic_vector(N-1 downto 0); 
	signal Gain       		  :     std_logic_vector(N-1 downto 0); 
	signal Loss       		  :     std_logic_vector(N-1 downto 0);  
	signal RS_2      		  :     std_logic_vector(26 downto 0);  
    signal Gain_diff          :     std_logic_vector(N-1 downto 0); 
	--signal Loss_Out         :     std_logic_vector(N-1 downto 0);  
	signal Loss_diff          :     std_logic_vector(N-1 downto 0);  
	signal RS                 :     std_logic_vector(11 downto 0);
	--signal RS                 :     std_logic_vector(N-1 downto 0);
	signal RS_reg_out         :     std_logic_vector(11 downto 0);
	--signal RS_reg_out         :     std_logic_vector(N-1 downto 0);
    signal RS_1               :     std_logic_vector(N-1 downto 0); 	
    signal RSI                :     std_logic_vector(N-1 downto 0);
    signal Rsi_prev           :     std_logic_vector(N-1 downto 0);
    --signal mux1_out   		  :     std_logic_vector(N-1 downto 0); 
    signal mux1_out_shrink    :     std_logic_vector(9 downto 0);
   -- signal reg2_out           :     std_logic_vector(N+M-1 downto 0);
   -- signal reg2_out_1         :     std_logic_vector(N+M-1 downto 0);
    signal reg3_out           :     std_logic_vector(N-1 downto 0); 
    signal Adder1_out           :     std_logic_vector(N+M-1 downto 0);   
    signal Gain_Out           :     std_logic_vector(N-1 downto 0); 
    signal AverageGain1       :     std_logic_vector(N-1 downto 0); 
    signal AverageGain2       :     std_logic_vector(N-1 downto 0); 
    signal Divide_gain        :     std_logic_vector(N-1 downto 0); 
   -- signal mux2_out   		  :     std_logic_vector(N-1 downto 0);
    --signal reg5_out           :     std_logic_vector(N+M-1 downto 0);
    --signal reg5_out_1         :     std_logic_vector(N+M-1 downto 0);
    signal reg6_out           :     std_logic_vector(N-1 downto 0);     
    signal Adder2_out           :     std_logic_vector(N+M-1 downto 0);  
    signal Loss_Out           :     std_logic_vector(N-1 downto 0);  
    signal AverageLoss1       :     std_logic_vector(N-1 downto 0); 
    signal AverageLoss2       :     std_logic_vector(N-1 downto 0);
    signal Divide_Loss        :     std_logic_vector(N-1 downto 0);
    signal Divide_Loss_reg    :     std_logic_vector(N-1 downto 0);
    signal mult13_right    	  :     std_logic_vector(N+M-1 downto 0);
    signal mult13_left    	  :     std_logic_vector(N+M-1 downto 0);
	
    signal buy                :     std_logic_vector(1 downto 0);
    signal sell               :     std_logic_vector(1 downto 0);
    signal sel_out            :     std_logic_vector(3 downto 0);
    signal count              :     std_logic;
    signal Zi_inst              :     std_logic;
    signal csel0              :     std_logic;
    signal rst_reg2             :     std_logic;
    signal rst_reg5             :     std_logic;
    signal gt1_inst              :     std_logic;
    signal RSI_2              :     std_logic_vector(N-1 downto 0); 
    signal RSI_Dout           :     std_logic_vector(N-1 downto 0);
	signal SMA_gain     : std_logic_vector(N-1 downto 0);		
	signal SMA_loss     : std_logic_vector(N-1 downto 0);		

begin
	
	cntr_in <=  x"00"; 	-- Initialize counter value with '1'

	-- Counter i
	couter_i : entity work.countern generic map (N => 8) port map (clk => clk, rst => rst, ld => Li, en => Ei, input => cntr_in, output => i_count);
    
	--Status signal
	Zi   <= '1'   when (i_count =  x"11")  else '0'; -- 17
	Zi_start   <= '1'   when (i_count =  x"11")  else '0'; -- 17
	sel   <= '1'   when (i_count =  x"11")  else '0'; -- 17
	gt1  <= '1'   when (i_count >  x"11")  else '0';
	--zmax1 <= '1'   when (i_count >= x"c7")  else '0';
	zmax1 <= '1'   when (i_count >= x"cc")  else '0';
	enable1 <= '1' when (i_count >= x"02" and i_count<= x"11")   else '0';
	enable2 <= '1' when (i_count >= x"02" and i_count<=x"11")   else '0';
	
	-- Conditions
	Zi_inst   <= '1'   when (i_count =  x"12")  else '0'; -- 16
    gt1_inst  <= '1'   when (i_count >  x"12")  else '0';
	count     <= '1'   when (i_count <= x"11")  else '0';
	
	addr_ram <= i_count when (csel1 = '1') else RdAddr;
	
	RAM_A : entity work.RAM generic map (addr_width=>8, data_width => N) port map(clk => clk, WE => We, ADDR => addr_ram, DIN => Din, DOUT => ram_out);
    reg_1 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg1, D => ram_out, Q => reg1_out);     
	

	difference<= std_logic_vector((signed(Ram_out)-signed(reg1_out))) when i_count>=x"02" else (others=>'0');
	Gain <=std_logic_vector(signed(difference))  when signed(difference)>0 else (others=>'0');
    reg_diff_gain : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_Gdiff, D => Gain, Q =>Gain_diff );     
	
	gain_module1 : entity work.gain_module generic map (N => N, M => M)
	port map
	( 	    
		clk 		=> clk		, 		
		rst 		=> rst 		,
		csel2  		=> csel2  	,	
		en_reg2 	=> en_reg2 	,
		en_reg3 	=> en_reg3 	,
		en_reg4 	=> en_reg4 	,
		gain_diff 	=> gain_diff, 	
		SMA_gain  		=> SMA_gain  		
	);
	
	
	

	-- Loss Calculation
    Loss <=std_logic_vector(abs(signed(difference)))  when signed(difference)<0 else (others=>'0'); 
    reg_diff_loss : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_Ldiff, D => Loss, Q =>loss_diff );     
         
	loss_module1 : entity work.loss_module generic map (N => N, M => M)
	port map
	( 	    
		clk 		=> clk		, 		
		rst 		=> rst 		,
		csel3  		=> csel3  	,	
		en_reg5 	=> en_reg5 	,
		en_reg6 	=> en_reg6 	,
		en_reg7 	=> en_reg7 	,
		loss_diff 	=> loss_diff, 	
		SMA_loss  		=> SMA_loss  		
	);
	-- Divider module
	div_block1 : entity work.div_block  port map(clk=>clk,rst=>rst,div_start=>div_start, ina =>SMA_gain, inb=> SMA_loss,en_reg10=>en_reg10,en_reg11=>en_reg11,quot=>RS_reg_out, div_done => div_done);    -- Rs = RS_1 / Mux2_out average gain by loss
    
    --Calculation of RSI
    ROM_RSI2 : entity work.RSI_ROM2  port map(ADDR => RS_reg_out,  COUT => RSI);   -- 10000/100-RS
    --ROM_RSI : entity work.RSI_ROM  port map(ADDR => RS_reg_out,  COUT => RSI);   -- 10000/100-RS
	RSI_Dout <= RSI when ( gt1_inst='1')  else (others=>'0');
   reg9_Previous_rsi : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg9, D => rsi, Q => Rsi_prev);         
	
	Buy <="01" when  (Rsi_prev>=30 and rsi<30) else (others=>'0'); 
    Sell <="10" when  (Rsi_prev<=70 and rsi>70) else (others=>'0'); 

    sel_out <= Buy & Sell   when (gt1_inst='1')  else (others=>'0');
    with sel_out select 
      Dout <=  Buy when  "0100",
               Sell when "0010",
              (others => '0') when others;
	
end arch;
