Library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_SIGNED.ALL;
use ieee.std_logic_arith.all;
entity test_ripple is
end test_ripple;

architecture test_bench_ripple_carry_adder of test_ripple is
component ripple_carry_adder_structural is
generic( n:integer:=3);
port( a,b:in std_logic_vector(n downto 0);
      sum:out std_logic_vector(n downto 0)
     );
end component;
signal a_tb:std_logic_vector(3 downto 0);
signal b_tb:std_logic_vector(3 downto 0);
signal sum_tb:std_logic_vector(3 downto 0);
type my_array is array(integer range <>) of integer;
constant values:my_array:=(0,-1,2,4);
constant value1:my_array:=(1,1,2,2);
begin
uut: ripple_carry_adder_structural generic map(3) port map(a=>a_tb,b=>b_tb,sum=>sum_tb);
process
begin
for i in values'range loop
a_tb<=conv_std_logic_vector(values(i),4);
b_tb<=conv_std_logic_vector(value1(i),4);
wait for 1ns;
assert(a_tb+b_tb=sum_tb) report "check design" severity warning;
wait for 9ns;
end loop;
end process;
end test_bench_ripple_carry_adder; 


