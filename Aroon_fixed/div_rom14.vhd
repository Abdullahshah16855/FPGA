library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity div_rom14 is
    Port ( addr : in STD_LOGIC_VECTOR (3 downto 0);
           Cout : out STD_LOGIC_VECTOR (7 downto 0));
end div_rom14;

architecture Behavioral of div_rom14 is
type vector is Array(0 to 15) of Std_logic_vector(7 downto 0);
Constant memory: vector:=
(0=>x"64",
1=>x"5D",
2=>x"56",
3=>x"4F",
4=>x"47",
5=>x"40",
6=>x"39",
7=>x"32",
8=>x"2B",
9=>x"24",
10=>x"1D",
11=>x"15",
12=>x"0E",
13=>x"07",
14=>x"00",
15=>x"00"
);
begin
Cout<=memory(to_integer(unsigned(addr)));

end Behavioral;
