Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity ripple_carry_adder_structural is
generic( n:integer:=3);
port( a,b:in std_logic_vector(n downto 0);
      sum:out std_logic_vector(n downto 0)
     );
end ripple_carry_adder_structural;

architecture structure of ripple_carry_adder_structural is

component full_adder is
port( a,b,cin:in std_logic;
      cout,sum:out std_logic);
end component;
signal carry:std_logic_vector(n downto 0);
signal cin,cout:std_logic:='0';
signal test_sum:std_logic_vector(n downto 0);
begin
u1:for i in a'range generate
u2:if (i=0) generate
UT:full_adder port map(a=>a(i),b=>b(i),cin=>cin,sum=>sum(i),cout=>carry(i));
end generate u2;
u3:if(i>0) generate
UT:full_adder port map(a=>a(i),b=>b(i),cin=>carry(i-1),sum=>sum(i),cout=>carry(i));
end generate u3;
u4:if(i=n) generate
UT:full_adder port map(a=>a(i),b=>b(i),cin=>carry(i-1),sum=>sum(i),cout=>cout);
end generate u4;
end generate u1;

test_sum<=a+b;

end structure;
