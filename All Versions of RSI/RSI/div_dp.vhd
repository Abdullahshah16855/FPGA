library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all;

entity div_dp is
generic ( N : integer := 18 ) ;
port 
( 
	clk : in std_logic;
	rst : in std_logic;
	ina : in std_logic_vector (N-1 downto 0); -- input a 
	inb : in std_logic_vector (N-1 downto 0); -- input b
	--y   : out std_logic_vector (N-1 downto 0); -- output
	y   : out std_logic_vector (11 downto 0); -- output
	
	-- control signals
	Li : in std_logic;
	Ei : in std_logic;
	sel_mux0 : in std_logic;
	sel_mux1 : in std_logic;
	sel_mux2 : in std_logic;
	sel_mux3 : in std_logic;
	sel_mux4 : in std_logic;
	sel_mux5 : in std_logic;
	sel_mux6 : in std_logic;
	sel_mux7 : in std_logic;
	sel_mux8 : in std_logic;
	sel_mux9 : in std_logic;
	sel_mux10 : in std_logic;
	sel_mux11 : in std_logic;
	
	ld_sr0 : in std_logic;
	ld_sr1 : in std_logic;
	ld_sr2 : in std_logic;
	ld_sr3 : in std_logic;
	ld_sr4 : in std_logic;
	ld_sr5 : in std_logic;
	ld_sr6 : in std_logic;
	ld_sr7 : in std_logic;
	ld_sr8 : in std_logic;
	ld_sr9 : in std_logic;
	ld_sr10 : in std_logic;
	ld_sr11 : in std_logic;	
	
	en_gt0 : in std_logic;
	-- en_gt1 : in std_logic;
	-- en_gt2 : in std_logic;
	-- en_gt3 : in std_logic;
	-- en_gt4 : in std_logic;
	-- en_gt5 : in std_logic;
	-- en_gt6 : in std_logic;
	-- en_gt7 : in std_logic;
	-- en_gt8 : in std_logic;
	-- en_gt9 : in std_logic;
	-- en_gt10 : in std_logic;
	-- en_gt11 : in std_logic;
	
	-- status signals
	gt0 : inout std_logic;
	gt1 : inout std_logic;
	gt2 : inout std_logic;
	gt3 : inout std_logic;
	gt4 : inout std_logic;
	gt5 : inout std_logic;
	gt6 : inout std_logic;
	gt7 : inout std_logic;
	gt8 : inout std_logic;
	gt9 : inout std_logic;
	gt10 : inout std_logic;
	gt11 : inout std_logic;
	Zmax : out std_logic;
	zi11 : out std_logic
 );
end div_dp;
 
architecture rtl of div_dp is

type yy_array is array (0 to 11) of std_logic_vector (11 downto 0);
	signal yy : yy_array;
    
signal bs0: std_logic_vector (N-1 downto 0);
signal bs1: std_logic_vector (N-1 downto 0);
signal bs2: std_logic_vector (N-1 downto 0);
signal bs3: std_logic_vector (N-1 downto 0);
signal bs4: std_logic_vector (N-1 downto 0);
signal bs5: std_logic_vector (N-1 downto 0);
signal bs6: std_logic_vector (N-1 downto 0);
signal bs7: std_logic_vector (N-1 downto 0);
signal bs8: std_logic_vector (N-1 downto 0);
signal bs9: std_logic_vector (N-1 downto 0);
signal bs10: std_logic_vector (N-1 downto 0);
signal bs11: std_logic_vector (N-1 downto 0);

signal a0: std_logic_vector (N-1 downto 0);
signal a1: std_logic_vector (N-1 downto 0);
signal a2: std_logic_vector (N-1 downto 0);
signal a3: std_logic_vector (N-1 downto 0);
signal a4: std_logic_vector (N-1 downto 0);
signal a5: std_logic_vector (N-1 downto 0);
signal a6: std_logic_vector (N-1 downto 0);
signal a7: std_logic_vector (N-1 downto 0);
signal a8: std_logic_vector (N-1 downto 0);
signal a9: std_logic_vector (N-1 downto 0);
signal a10: std_logic_vector (N-1 downto 0);
signal a11: std_logic_vector (N-1 downto 0);

signal en_gt1  : std_logic;
signal en_gt2  : std_logic;
signal en_gt3  : std_logic;
signal en_gt4  : std_logic;
signal en_gt5  : std_logic;
signal en_gt6  : std_logic;
signal en_gt7  : std_logic;
signal en_gt8  : std_logic;
signal en_gt9  : std_logic;
signal en_gt10 : std_logic;
signal en_gt11 : std_logic;

signal reg11_out :  std_logic_vector (N-1 downto 0);
signal reg12_out :  std_logic_vector (N-1 downto 0);
signal reg22_out :  std_logic_vector (N-1 downto 0);
signal reg13_out :  std_logic_vector (N-1 downto 0);
signal reg23_out :  std_logic_vector (N-1 downto 0);
signal reg33_out :  std_logic_vector (N-1 downto 0);
signal reg14_out :  std_logic_vector (N-1 downto 0);
signal reg24_out :  std_logic_vector (N-1 downto 0);
signal reg34_out :  std_logic_vector (N-1 downto 0);
signal reg44_out :  std_logic_vector (N-1 downto 0);
signal reg15_out :  std_logic_vector (N-1 downto 0);
signal reg25_out :  std_logic_vector (N-1 downto 0);
signal reg35_out :  std_logic_vector (N-1 downto 0);
signal reg45_out :  std_logic_vector (N-1 downto 0);
signal reg55_out :  std_logic_vector (N-1 downto 0);
signal reg16_out :  std_logic_vector (N-1 downto 0);
signal reg26_out :  std_logic_vector (N-1 downto 0);
signal reg36_out :  std_logic_vector (N-1 downto 0);
signal reg46_out :  std_logic_vector (N-1 downto 0);
signal reg56_out :  std_logic_vector (N-1 downto 0);
signal reg66_out :  std_logic_vector (N-1 downto 0);
signal reg17_out :  std_logic_vector (N-1 downto 0);
signal reg27_out :  std_logic_vector (N-1 downto 0);
signal reg37_out :  std_logic_vector (N-1 downto 0);
signal reg47_out :  std_logic_vector (N-1 downto 0);
signal reg57_out :  std_logic_vector (N-1 downto 0);
signal reg67_out :  std_logic_vector (N-1 downto 0);
signal reg77_out :  std_logic_vector (N-1 downto 0);
signal reg18_out :  std_logic_vector (N-1 downto 0);
signal reg28_out :  std_logic_vector (N-1 downto 0);
signal reg38_out :  std_logic_vector (N-1 downto 0);
signal reg48_out :  std_logic_vector (N-1 downto 0);
signal reg58_out :  std_logic_vector (N-1 downto 0);
signal reg68_out :  std_logic_vector (N-1 downto 0);
signal reg78_out :  std_logic_vector (N-1 downto 0);
signal reg88_out :  std_logic_vector (N-1 downto 0);
signal reg19_out :  std_logic_vector (N-1 downto 0);
signal reg29_out :  std_logic_vector (N-1 downto 0);
signal reg39_out :  std_logic_vector (N-1 downto 0);
signal reg49_out :  std_logic_vector (N-1 downto 0);
signal reg59_out :  std_logic_vector (N-1 downto 0);
signal reg69_out :  std_logic_vector (N-1 downto 0);
signal reg79_out :  std_logic_vector (N-1 downto 0);
signal reg89_out :  std_logic_vector (N-1 downto 0);
signal reg99_out :  std_logic_vector (N-1 downto 0);
signal reg110_out:  std_logic_vector (N-1 downto 0);
signal reg210_out:  std_logic_vector (N-1 downto 0);
signal reg310_out:  std_logic_vector (N-1 downto 0);
signal reg410_out:  std_logic_vector (N-1 downto 0);
signal reg510_out:  std_logic_vector (N-1 downto 0);
signal reg610_out:  std_logic_vector (N-1 downto 0);
signal reg710_out:  std_logic_vector (N-1 downto 0);
signal reg810_out:  std_logic_vector (N-1 downto 0);
signal reg910_out:  std_logic_vector (N-1 downto 0);
signal reg1010_out :  std_logic_vector (N-1 downto 0);
signal reg111_out:  std_logic_vector (N-1 downto 0);
signal reg211_out:  std_logic_vector (N-1 downto 0);
signal reg311_out:  std_logic_vector (N-1 downto 0);
signal reg411_out:  std_logic_vector (N-1 downto 0);
signal reg511_out:  std_logic_vector (N-1 downto 0);
signal reg611_out:  std_logic_vector (N-1 downto 0);
signal reg711_out:  std_logic_vector (N-1 downto 0);
signal reg811_out:  std_logic_vector (N-1 downto 0);
signal reg911_out:  std_logic_vector (N-1 downto 0);
signal reg1011_out :  std_logic_vector (N-1 downto 0);
signal reg1111_out :  std_logic_vector (N-1 downto 0);

signal i :  std_logic_vector (N-1 downto 0);
--constant CNTR_MAX :  std_logic_vector (N-1 downto 0) := '0'& x"00E0";	-- 11 in decimal

begin
couter_i
     : entity work.countern generic map (N => 18) port map (clk => clk, rst => rst, ld => Li, en => Ei, input => (others => '0'), output => i);
	zi11 <= '1' when (i >= x"11") else '0';
	Zmax <= '1' when (i=x"00C7") else '0';
	
    bs0<=inb;
    update_mod0 : entity work.module generic map (N => N) port map(clk => clk, rst => rst, sel_mux => sel_mux0, en_reg => '1', ina => ina, bs=> bs0 , gt => gt0,a => a0);
	
	--y(N-1 downto 12) <= (others => '0');
	ff0  : entity work.flip_flop port map (clk => clk, rst => rst, en => '1', D => en_gt0 , Q => en_gt1 ); 
	ff1  : entity work.flip_flop port map (clk => clk, rst => rst, en => '1', D => en_gt1 , Q => en_gt2 ); 
	ff2  : entity work.flip_flop port map (clk => clk, rst => rst, en => '1', D => en_gt2 , Q => en_gt3 ); 
	ff3  : entity work.flip_flop port map (clk => clk, rst => rst, en => '1', D => en_gt3 , Q => en_gt4 ); 
	ff4  : entity work.flip_flop port map (clk => clk, rst => rst, en => '1', D => en_gt4 , Q => en_gt5 ); 
	ff5  : entity work.flip_flop port map (clk => clk, rst => rst, en => '1', D => en_gt5 , Q => en_gt6 ); 
	ff6  : entity work.flip_flop port map (clk => clk, rst => rst, en => '1', D => en_gt6 , Q => en_gt7 ); 
	ff7  : entity work.flip_flop port map (clk => clk, rst => rst, en => '1', D => en_gt7 , Q => en_gt8 ); 
	ff8  : entity work.flip_flop port map (clk => clk, rst => rst, en => '1', D => en_gt8 , Q => en_gt9 ); 
	ff9  : entity work.flip_flop port map (clk => clk, rst => rst, en => '1', D => en_gt9 , Q => en_gt10); 
	ff10 : entity work.flip_flop port map (clk => clk, rst => rst, en => '1', D => en_gt10, Q => en_gt11); 
	
	shift_reg0  : entity work.shift_reg generic map (N => 12) port map (clk => clk, enable => en_gt0,  load=> ld_sr0 , sin => gt0,  D => (others => '0'), Q => yy(0)); 
	shift_reg1  : entity work.shift_reg generic map (N => 12) port map (clk => clk, enable => en_gt1,  load=> ld_sr1 , sin => gt1,  D => (others => '0'), Q => yy(1)); 
	shift_reg2  : entity work.shift_reg generic map (N => 12) port map (clk => clk, enable => en_gt2,  load=> ld_sr2 , sin => gt2,  D => (others => '0'), Q => yy(2)); 
	shift_reg3  : entity work.shift_reg generic map (N => 12) port map (clk => clk, enable => en_gt3,  load=> ld_sr3 , sin => gt3,  D => (others => '0'), Q => yy(3)); 
	shift_reg4  : entity work.shift_reg generic map (N => 12) port map (clk => clk, enable => en_gt4,  load=> ld_sr4 , sin => gt4,  D => (others => '0'), Q => yy(4)); 
	shift_reg5  : entity work.shift_reg generic map (N => 12) port map (clk => clk, enable => en_gt5,  load=> ld_sr5 , sin => gt5,  D => (others => '0'), Q => yy(5)); 
	shift_reg6  : entity work.shift_reg generic map (N => 12) port map (clk => clk, enable => en_gt6,  load=> ld_sr6 , sin => gt6,  D => (others => '0'), Q => yy(6)); 
	shift_reg7  : entity work.shift_reg generic map (N => 12) port map (clk => clk, enable => en_gt7,  load=> ld_sr7 , sin => gt7,  D => (others => '0'), Q => yy(7)); 
	shift_reg8  : entity work.shift_reg generic map (N => 12) port map (clk => clk, enable => en_gt8,  load=> ld_sr8 , sin => gt8,  D => (others => '0'), Q => yy(8)); 
	shift_reg9  : entity work.shift_reg generic map (N => 12) port map (clk => clk, enable => en_gt9,  load=> ld_sr9 , sin => gt9,  D => (others => '0'), Q => yy(9)); 
	shift_reg10 : entity work.shift_reg generic map (N => 12) port map (clk => clk, enable => en_gt10, load=> ld_sr10, sin => gt10, D => (others => '0'), Q => yy(10)); 
	shift_reg11 : entity work.shift_reg generic map (N => 12) port map (clk => clk, enable => en_gt11, load=> ld_sr11, sin => gt11, D => (others => '0'), Q => yy(11)); 
	
	--y <= "00000" & yy(0)(11) & yy(1)(10) & yy(2)(9) & yy(3)(8) & yy(4)(7) & yy(5)(6) & yy(6)(5) & yy(7)(4) & yy(8)(3) & yy(9)(2) & yy(10)(1) & yy(11)(0);
	y <= yy(0)(11) & yy(1)(10) & yy(2)(9) & yy(3)(8) & yy(4)(7) & yy(5)(6) & yy(6)(5) & yy(7)(4) & yy(8)(3) & yy(9)(2) & yy(10)(1) & yy(11)(0);
	reg11 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => inb, Q => reg11_out); 
	bs1<='0'&reg11_out(N-1 downto 1); 	
    update_mod1 : entity work.module generic map (N => N) port map(clk => clk, rst => rst, sel_mux => sel_mux1, en_reg => '1', ina => a0, bs=> bs1 , gt => gt1,a => a1);
	
	reg12 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => inb, Q => reg12_out);  
	reg22 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg12_out, Q => reg22_out); 
	bs2<="00"&reg22_out(N-1 downto 2);	
	update_mod2 : entity work.module generic map (N => N) port map(clk => clk, rst => rst, sel_mux =>  sel_mux2, en_reg => '1', ina => a1, bs=> bs2 , gt => gt2, a => a2);
    
	reg13 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => inb, Q => reg13_out);  
	reg23 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg13_out, Q => reg23_out); 
	reg33 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg23_out, Q => reg33_out); 
	bs3<="000"&reg33_out(N-1 downto 3);
    update_mod3 : entity work.module generic map (N => N) port map(clk => clk, rst => rst, sel_mux =>  sel_mux3, en_reg => '1', ina => a2, bs=> bs3 , gt => gt3, a => a3);
    
	reg14 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => inb, Q => reg14_out);  
	reg24 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg14_out, Q => reg24_out); 
	reg34 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg24_out, Q => reg34_out); 
	reg44 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg34_out, Q => reg44_out); 
	bs4<="0000"&reg44_out(N-1 downto 4);
	update_mod4 : entity work.module generic map (N => N) port map(clk => clk, rst => rst, sel_mux =>  sel_mux4, en_reg => '1', ina => a3, bs=> bs4 , gt => gt4, a => a4);
    
	reg15 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => inb, Q => reg15_out);  
	reg25 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg15_out, Q => reg25_out); 
	reg35 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg25_out, Q => reg35_out); 
	reg45 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg35_out, Q => reg45_out); 
	reg55 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg45_out, Q => reg55_out); 
	bs5<="00000"&reg55_out(N-1 downto 5);
	update_mod5 : entity work.module generic map (N => N) port map(clk => clk, rst => rst, sel_mux =>  sel_mux5, en_reg => '1', ina => a4, bs=> bs5 , gt => gt5, a => a5);
	
	reg16 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => inb, Q => reg16_out);  
	reg26 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg16_out, Q => reg26_out); 
	reg36 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg26_out, Q => reg36_out); 
	reg46 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg36_out, Q => reg46_out); 
	reg56 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg46_out, Q => reg56_out); 
	reg66 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg56_out, Q => reg66_out); 
	bs6<="000000"&reg66_out(N-1 downto 6);
    update_mod6 : entity work.module generic map (N => N) port map(clk => clk, rst => rst, sel_mux =>  sel_mux6, en_reg => '1', ina => a5, bs=> bs6 , gt => gt6, a => a6);
	
	reg17 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => inb, Q => reg17_out);  
	reg27 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg17_out, Q => reg27_out); 
	reg37 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg27_out, Q => reg37_out); 
	reg47 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg37_out, Q => reg47_out); 
	reg57 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg47_out, Q => reg57_out); 
	reg67 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg57_out, Q => reg67_out); 
	reg77 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg67_out, Q => reg77_out); 
	bs7<="0000000"&reg77_out(N-1 downto 7);
	update_mod7 : entity work.module generic map (N => N) port map(clk => clk, rst => rst, sel_mux =>  sel_mux7, en_reg => '1', ina => a6, bs=> bs7 , gt => gt7, a => a7);

	reg18 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => inb, Q => reg18_out);  
	reg28 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg18_out, Q => reg28_out); 
	reg38 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg28_out, Q => reg38_out); 
	reg48 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg38_out, Q => reg48_out); 
	reg58 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg48_out, Q => reg58_out); 
	reg68 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg58_out, Q => reg68_out); 
	reg78 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg68_out, Q => reg78_out); 
	reg88 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg78_out, Q => reg88_out); 
	bs8<="00000000"&reg88_out(N-1 downto 8);
    update_mod8 : entity work.module generic map (N => N) port map(clk => clk, rst => rst, sel_mux =>  sel_mux8, en_reg => '1', ina => a7, bs=> bs8 , gt => gt8, a => a8);

	reg19 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => inb, Q => reg19_out);  
	reg29 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg19_out, Q => reg29_out); 
	reg39 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg29_out, Q => reg39_out); 
	reg49 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg39_out, Q => reg49_out); 
	reg59 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg49_out, Q => reg59_out); 
	reg69 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg59_out, Q => reg69_out); 
	reg79 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg69_out, Q => reg79_out); 
	reg89 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg79_out, Q => reg89_out); 
	reg99 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg89_out, Q => reg99_out); 
	bs9<="000000000"&reg99_out(N-1 downto 9);
    update_mod9 : entity work.module generic map (N => N) port map(clk => clk, rst => rst, sel_mux =>  sel_mux9, en_reg => '1', ina => a8, bs=> bs9 , gt => gt9, a => a9);
    
	reg110 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => inb, Q => reg110_out);  
	reg210 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg110_out, Q => reg210_out); 
	reg310 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg210_out, Q => reg310_out); 
	reg410 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg310_out, Q => reg410_out); 
	reg510 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg410_out, Q => reg510_out); 
	reg610 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg510_out, Q => reg610_out); 
	reg710 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg610_out, Q => reg710_out); 
	reg810 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg710_out, Q => reg810_out); 
	reg910 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg810_out, Q => reg910_out); 
	reg1010 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg910_out, Q => reg1010_out); 
	bs10<="0000000000"&reg1010_out(N-1 downto 10);
	update_mod10 : entity work.module generic map (N => N) port map(clk => clk, rst => rst, sel_mux =>  sel_mux10, en_reg => '1', ina => a9, bs=> bs10 , gt => gt10, a => a10);
    
	reg111 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => inb, Q => reg111_out);  
	reg211 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg111_out, Q => reg211_out); 
	reg311 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg211_out, Q => reg311_out); 
	reg411 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg311_out, Q => reg411_out); 
	reg511 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg411_out, Q => reg511_out); 
	reg611 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg511_out, Q => reg611_out); 
	reg711 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg611_out, Q => reg711_out); 
	reg811 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg711_out, Q => reg811_out); 
	reg911 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg811_out, Q => reg911_out); 
	reg1011 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg911_out, Q => reg1011_out); 
	reg1111 : entity work.reg generic map (N => N) port map (clk => clk, rst => rst, en => '1', D => reg1011_out, Q => reg1111_out); 
	bs11<="00000000000"&reg1111_out(N-1 downto 11);
	update_mod11 : entity work.module generic map (N => N) port map(clk => clk, rst => rst, sel_mux =>  sel_mux11, en_reg => '1', ina => a10, bs=> bs11 , gt => gt11, a => a11);

end rtl;
