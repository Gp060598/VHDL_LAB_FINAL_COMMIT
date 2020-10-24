Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Entity full_adder is
port( a,b,cin:in std_logic;
      cout,sum:out std_logic);
end full_adder;

architecture adder of full_adder is
begin
cout<= ( a and b) or( b and cin) or(a and cin);
sum<= (a xor b xor cin);
end adder;
