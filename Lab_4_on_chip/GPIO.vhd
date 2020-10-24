library ieee;
use ieee.std_logic_1164.all;
use work.my_declerations.all;

entity GPIO is
generic(N:integer:=16);
port(din:in std_logic_vector(N-1 downto 0);
     clk,reset:in std_logic;
     dout:out std_logic_vector(N-1 downto 0);
     ie,oe:in std_logic
     );
end GPIO;

Architecture GPIO_structure of GPIO is
signal reg_in,reg_out,GPIO_out:std_logic_vector(N-1 downto 0);
 begin
process(clk,reset,ie,oe,reg_in,reg_out,din,gpio_out) is
 begin
 if(reset='0') then
 gpio_out<=(others=>'0');
 reg_out<=(others=>'0');
 reg_in<=(others=>'0');
 else
  if(ie='0') then reg_in <=din;
  else reg_in<=gpio_out;
  end if;
  
  if(rising_edge(clk)) then reg_out<=reg_in;
  end if;
  
  if(oe='0') then gpio_out<=(others=>'0');
  else gpio_out<=reg_out;
  end if;
end if;
end process;
dout<=gpio_out;
end GPIO_structure;
