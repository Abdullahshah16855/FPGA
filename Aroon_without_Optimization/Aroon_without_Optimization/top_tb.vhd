library IEEE;
use IEEE.Std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

USE ieee.std_logic_textio.all;
LIBRARY std;
USE std.textio.all;

entity top_tb is
	generic (N : integer := 20);
end;

architecture bench of top_tb is

  signal clk: std_logic:= '1';
  signal rst: std_logic:= '1';
  signal Go: std_logic:= '0';
  signal WE_A: std_logic;
  signal WE_B: std_logic;
  signal Din_high: std_logic_vector(N-1 downto 0);
  signal Din_low: std_logic_vector(N-1 downto 0);
  signal RdAddr: std_logic_vector(N-1 downto 0);
  signal Order_signal: std_logic_vector(1 downto 0);
  signal Done: std_logic;
   constant clk_period: time := 10 ns;
		
begin

	-- Insert values for generic parameters !!
	uut: entity work.top generic map ( N => N ) port map ( clk => clk, rst => rst, Go => Go, WE_A => WE_A , WE_B => WE_B, RdAddr => RdAddr, Din_high => Din_high,Din_low => Din_low, Order_signal=>Order_signal, Done => Done);

	-- Clock 
	clk <= not clk after clk_period/2;
  
	stimulus: process
  
		FILE vectorFile: TEXT OPEN READ_MODE is "Aroon_data.txt"; --file read
        FILE vectorFile_1: TEXT OPEN READ_MODE is "arron_down_data.txt"; --file read

		VARIABLE VectorLine: LINE; --line by line access
		VARIABLE test_input: integer;
        VARIABLE VectorLine_1: LINE; --line by line access
        VARIABLE test_input_1: integer;
        file file_pointer : text;
        variable line_num : line;
        file file_pointer_1 : text;
        variable line_num_1 : line;
          
	begin
			-- hold reset state for 100 ns.
			wait for 10*clk_period;
		rst <= '0';
		WE_A <= '1';
		WE_B <= '1';
		
		 file_open(file_pointer,"D:\University Data\FYP Material\FPGA Programs in Vivado\Top Level Designing\Aroon Indicator\Vivado_Implementation\Aroon_with_Clock\Aroon_clk\Arron_down_output.txt",WRITE_MODE); 
	     file_open(file_pointer_1,"D:\University Data\FYP Material\FPGA Programs in Vivado\Top Level Designing\Aroon Indicator\Vivado_Implementation\Aroon_with_Clock\Aroon_clk\Arron_up_output.txt",WRITE_MODE); 

		-- Reading close price data from Memory
		for i in 0 to 199 loop
			readline(vectorFile, VectorLine); 				-- Put file data into line
			read(VectorLine,test_input);
			readline(vectorFile_1, VectorLine_1); 				-- Put file data into line
            read(VectorLine_1,test_input_1);
			RdAddr <= std_logic_vector(to_unsigned(i, RdAddr'Length));
			Din_high <= std_logic_vector (to_unsigned(test_input, Din_high'Length));
			Din_low <= std_logic_vector (to_unsigned(test_input_1, Din_low'Length));
			
			wait for clk_period;
		end loop;
	
		WE_A <= '0'; 
		WE_B <= '0'; 
		Go <= '1';  
		
--		for i in 0 to 3000 loop
--			writeline (file_pointer_1,line_num_1);                 -- Write the contents into the file.
--			writeline (file_pointer,line_num); 				-- Write the contents into the file.
--			write(line_num_1,conv_integer(order_signal)); 	-- Write the line.
--			--write(line_num,conv_integer(Dout_down)); 	-- Write the line.
--			wait for clk_period;
--		 end loop;
		
		wait until Done = '1'; 
		wait; 
	end process;
end;
