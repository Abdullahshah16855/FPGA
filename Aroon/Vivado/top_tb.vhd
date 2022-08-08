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
  signal Din_up: std_logic_vector(N-1 downto 0);
  signal Din_down: std_logic_vector(N-1 downto 0);
  signal RdAddr: std_logic_vector(N-1 downto 0);
  signal Done: std_logic;
  --signal order_signal: std_logic_vector(1 downto 0);
  signal Dout: std_logic_vector(N-1 downto 0);
  
  constant clk_period: time := 10 ns;
		
begin

	-- Insert values for generic parameters !!
	uut: entity work.top generic map ( N => N ) port map ( clk => clk, rst => rst, Go => Go, WE_A => WE_A,We_B=>We_B, RdAddr => RdAddr, Din_up => Din_up,Din_down=>Din_down, Dout=>Dout, Done => Done);

	-- Clock 
	clk <= not clk after clk_period/2;
  
	stimulus: process
  
		FILE vectorFile: TEXT OPEN READ_MODE is "Aroon_data.txt"; --file read
		FILE vectorFile1: TEXT OPEN READ_MODE is "Arron_down_data.txt"; --file read
	
		VARIABLE VectorLine: LINE; --line by line access
		VARIABLE VectorLine1: LINE; --line by line access
		VARIABLE space: CHARACTER;
		VARIABLE test_input: integer;
		VARIABLE test_input1: integer;
		
		file file_pointer : text;
		variable line_num : line;
          
	begin
	    -- hold reset state for 100 ns.
		wait for 10*clk_period;
		rst <= '0';
		WE_A <= '1';
		WE_B <= '1';
		
--		--Open the file write.txt from the specified location for writing(WRITE_MODE).
--		 file_open(file_pointer,"D:\University Data\FYP Material\FPGA Programs in Vivado\Top Level Designing\Aroon Indicator\Vivado_Implementation\Aroon\Output.txt",WRITE_MODE); 
			
		-- Reading close price data from Memory
		for i in 0 to 199 loop
			readline(vectorFile, VectorLine); 				-- Put file data into line
			read(VectorLine,test_input);
			readline(vectorFile1, VectorLine1); 				-- Put file data into line
			read(VectorLine1,test_input1);
			RdAddr <= std_logic_vector(to_unsigned(i, RdAddr'Length));
			Din_up <= std_logic_vector (to_unsigned(test_input, Din_up'Length));
			Din_down<= std_logic_vector (to_unsigned(test_input1, Din_down'Length));
			wait for clk_period;
		end loop;
	
		WE_A <= '0';
		WE_B <= '0';
		Go <= '1';  
		
--		-- Writing output results to the External file.txt 
--		 for i in 0 to 199 loop
--			 write(line_num,conv_integer(Dout)); 	-- Write the line.
--			 writeline (file_pointer,line_num); 				-- Write the contents into the file.
--			 wait for clk_period;
--		 end loop;
		
		wait until Done = '1'; 
		wait; 
	end process;
end;
