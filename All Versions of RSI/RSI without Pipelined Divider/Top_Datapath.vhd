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
        div_start  : in std_logic; 
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
        We  : in std_logic; 
        Din : in std_logic_vector(N-1 downto 0); 
        RdAddr : in std_logic_vector(7 downto 0); 
        -- Outputs
        Zi  : out std_logic; 
        Zi_start  : out std_logic; 
        gt1  : out std_logic; 
        sel  : out std_logic; 
        Zmax : out std_logic;
        enable1 : out std_logic; 
        enable2 : out std_logic; 
        --enable2 : out std_logic; 
        Dout : out std_logic_vector(1 downto 0)
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
    --signal GainOut            :     std_logic_vector(9 downto 0);
    signal GainOut            :     std_logic_vector(N-1 downto 0);
   -- signal reg10_out            :     std_logic_vector(9 downto 0);
    signal reg10_out            :     std_logic_vector(N-1 downto 0);
    signal ram_out    		  :     std_logic_vector(N-1 downto 0); 
    signal in_1      		  :     std_logic_vector(N-1 downto 0); 
    signal in_2      		  :     std_logic_vector(N-1 downto 0); 
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
    --signal Gain_Out         :     std_logic_vector(N-1 downto 0); 
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
    signal Divide_gain        :     std_logic_vector(N+M-1 downto 0); 
   -- signal mux2_out   		  :     std_logic_vector(N-1 downto 0);
    --signal reg5_out           :     std_logic_vector(N+M-1 downto 0);
    --signal reg5_out_1         :     std_logic_vector(N+M-1 downto 0);
    signal reg6_out           :     std_logic_vector(N-1 downto 0);     
    signal Adder2_out           :     std_logic_vector(N+M-1 downto 0);  
    signal Loss_Out           :     std_logic_vector(N-1 downto 0);  
    signal AverageLoss1       :     std_logic_vector(N-1 downto 0); 
    signal AverageLoss2       :     std_logic_vector(N-1 downto 0);
    signal Divide_Loss        :     std_logic_vector(N+M-1 downto 0);
	
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


begin
	
	cntr_in <=  x"00"; 	-- Initialize counter value with '1'

	-- Counter i
	couter_i : entity work.countern generic map (N => 8) port map (clk => clk, rst => rst, ld => Li, en => Ei, input => cntr_in, output => i_count);
    
	--Status signal
	Zi   <= '1'   when (i_count =  x"11")  else '0'; -- 17
	sel   <= '1'   when (i_count =  x"11")  else '0'; -- 17
	gt1  <= '1'   when (i_count >  x"11")  else '0';
	--Zmax <= '1'   when (i_count >= x"c7")  else '0';
	Zmax <= '1'   when (i_count >= x"CC")  else '0';
	enable1 <= '1' when (i_count >= x"02" and i_count<= x"11")   else '0';
	enable2 <= '1' when (i_count >= x"02" and i_count<=x"11")   else '0';
	Zi_start   <= '1'   when (i_count =  x"11")  else '0'; -- 17
	
	-- Conditions
	Zi_inst   <= '1'   when (i_count =  x"12")  else '0'; -- 16
    gt1_inst  <= '1'   when (i_count >  x"12")  else '0';
	count     <= '1'   when (i_count <= x"11")  else '0';
	
	addr_ram <= i_count when (csel1 = '1') else RdAddr;
	
	RAM_A : entity work.RAM generic map (addr_width=>8,data_width => N) port map(clk => clk, WE => We, ADDR => addr_ram, DIN => Din, DOUT => ram_out);
    reg_1 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg1, D => ram_out, Q => reg1_out);     
	

	difference<= std_logic_vector((signed(Ram_out)-signed(reg1_out))) when i_count>=x"02" else (others=>'0');
	Gain <=std_logic_vector(signed(difference))  when signed(difference)>0 else (others=>'0');
   reg_diff_gain : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_Gdiff, D => Gain, Q =>Gain_diff );     
	-- Gain
    in_1<=Gain_diff;	
    in_2<=Gain_diff;	
   
   	Adder1_out <= reg2_out + Gain_diff;
   reg_Gain : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg4, D => Gain_diff, Q => Gain_out);  
   reg_2 : entity work.reg generic map (N => N+M) port map (clk => clk, rst => rst, en => en_reg2, D => Adder1_out, Q => reg2_out); 

  reg2_out_1<=reg2_out when (count <='1') else (others=>'0');  
  ROM_gain : entity work.ROM_L port map(ADDR =>reg2_out_1,  COUT => AverageGain1);    --- average gain divide by 14
   Divide_gain <=std_logic_vector((unsigned(reg3_out)*(13))+ (unsigned(Gain_out)));       -- 13*previous+gain
  ROM_Average_gain : entity work.ROM  port map(ADDR => Divide_gain,  COUT => AverageGain2);   -- divide_Gaun divide by 14
   mux1_out <= AverageGain1 when (csel2 = '1') else AverageGain2;
  reg_3 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg3, D => mux1_out, Q => reg3_out);     
    
    Loss <=std_logic_vector(abs(signed(difference)))  when signed(difference)<0 else (others=>'0'); 
    reg_diff_loss : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_Ldiff, D => Loss, Q =>loss_diff );     
         
 
    Adder2_out <= reg5_out + Loss_diff;
        
    reg_Loss : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg7, D => Loss_diff, Q => Loss_out);  
    reg_5 : entity work.reg generic map (N => N+M) port map (clk => clk, rst => rst, en => en_reg5, D => Adder2_out, Q => reg5_out); 
      reg5_out_1<=reg5_out when (count <='1') else (others=>'0'); --- need to be replace
    ROM_Loss : entity work.ROM_L  port map(ADDR => reg5_out_1,  COUT => AverageLoss1);   --average loss  divide by 14
    Divide_Loss <=std_logic_vector((unsigned(reg6_out)*(13))  + (unsigned(Loss_out)));  --13*previous+loss
    ROM_Average_Loss : entity work.ROM  port map(ADDR => Divide_Loss,  COUT => AverageLoss2);   -- Divide_loss divide by 14
    reg_6 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => en_reg6, D => mux2_out, Q => reg6_out);
    mux2_out <=AverageLoss1 when (csel3 = '1') else AverageLoss2;
	
	Div_module : entity work.div_block  port map(clk=>clk,rst=>rst,div_start=>div_start, ina =>mux1_out, inb=> mux2_out,en_reg10=>en_reg10,en_reg11=>en_reg11,quot=>RS_reg_out);    -- Rs = RS_1 / Mux2_out average gain by loss
    
    ROM_RSI : entity work.RSI_ROM  port map(ADDR => RS_reg_out,  COUT => RSI);   -- 10000/100-RS
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
