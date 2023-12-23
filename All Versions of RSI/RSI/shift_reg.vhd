library ieee ;
use ieee.std_logic_1164.all ;

entity shift_reg is
generic ( N : integer := 17 ) ;
port ( 
	clk : in std_logic ;
	enable : in std_logic ;
	load : in std_logic ;
	sin : in std_logic ;
	d : in std_logic_vector(N-1 downto 0) ;
	q : out std_logic_vector(N-1 downto 0) 
) ;
end shift_reg ;

architecture right_shift of shift_reg is
signal qt: std_logic_vector(N-1 downto 0);
begin
	process (clk)
	begin
	if rising_edge(clk) then
		if load = '1' then
			qt <= d ;
        else
            if enable = '1' then
                qt <= sin & qt(N-1 downto 1);
			end if;
		end if ;
	end if;
end process ;
q <= qt;
end right_shift;

architecture left_shift of shift_reg is
signal qt: std_logic_vector(N-1 downto 0);
begin
	process (clk)
	begin
	if rising_edge(clk) then
		if load = '1' then
			qt <= d ;
        else
            if enable = '1' then
                qt <= qt(N-2 downto 0) & sin;
			end if;
		end if ;
	end if;
end process ;
q <= qt;
end left_shift;