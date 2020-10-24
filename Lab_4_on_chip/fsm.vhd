library IEEE;
use IEEE.std_logic_1164.all;

use work.my_declerations.all;

entity FSM is
  port(instr: IN operation;
    clk,reset : IN std_logic;
    state: In std_logic_vector(3 downto 0);
    flag:out std_logic;
    PC_out: OUT std_logic_vector(1 downto 0));
end FSM;

architecture data_flow of FSM is
  
  --signals
  signal uPC,next_uPC : std_logic_vector(1 downto 0);
  signal ST_flag,next_ST_flag:std_logic;
  
begin
   PC_out<= uPC;
   flag<=st_flag;
 -- state<= pres_state;
  process(uPC,state,reset,st_flag)
  begin
    if reset = '0' then
     next_st_flag<='0';
     next_upc<="00";
   else
     next_st_flag<='0';
    case (state) is
    
    when ADD_c|SUB_C|AND_c|OR_c|XOR_c|NOT_c|MOV_c =>
      if uPC = "00" then
        
        next_uPC <= "01";
      elsif uPC = "01" then
        next_uPC <= "10";
      else
        next_uPC <= "00";
      end if;
    
    when NOP_c|Not_used =>
      if uPC = "00" then
        
        next_uPC <= "01";
      else
        next_uPC <= "00";
      end if;
    
    when LD_c =>
       if uPC = "00" then
        
        next_uPC <= "01";
      elsif uPC = "01" then
        next_uPC <= "10";
      elsif uPC = "10" then
        next_uPC <= "11";
      else
        next_uPC <= "00";
      end if;
      
     when ST_c=>
       if upc="00" then 
       next_upc<="01";
     elsif upc="01" then 
       next_upc<="10";
     elsif upc="10" then
       next_upc<="11";
     else 
        if(st_flag='0') then
         next_upc<="11";
         next_st_flag<='1';
       else
         next_upc<="00";
         next_st_flag<='0';
       end if;
     end if;
     
    when LDI_c =>
      if uPC = "00" then
        
        next_uPC <= "01";
      elsif uPC = "01" then
        next_uPC <= "10";
      else
        next_uPC <= "00";
      end if;
      
    when BRZ|BRN|BRO|BRA =>
        if uPC = "00" then
          
          next_uPC <= "01";
        else
          next_uPC <= "00";
        end if;
    when others => report "Invalid instruction";
    end case;
  end if;
  end process;
  process(clk,reset)
  begin
    if (reset= '0') then
      uPC <= "00";
--     next_uPC <= "00";
    elsif rising_edge(clk) then
      uPC <= next_uPC;
     st_flag<=next_st_flag;
    end if;
  end process;
end data_flow;




