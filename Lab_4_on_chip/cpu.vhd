library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.my_declerations.all;

entity CPU is
generic( N:integer:= 16); --Here it is the no of bits
port( Din: in std_logic_vector(n-1 downto 0);
      clk,reset:in std_logic;
      address_cpu,dout:out std_logic_vector(N-1 downto 0);
      Z_flag,N_flag,O_flag,R_WN:out std_logic 
     );
end CPU;
architecture structure_cpu of cpu is
component micro_rom is
port(inst: in operation;
     flag,st_flag:in std_logic;
     upc:in std_logic_vector(1 downto 0);
     reset:in std_logic;
     wren,reada,readb:out std_logic;
     uinst: out opcode;
     bypass:out std_logic_vector(2 downto 0);
     select_flag:out std_logic_Vector(1 downto 0);
     address_en,data_en,r_wn:out std_logic
     );
end component;

component FSM is
  port(instr: IN operation;
    clk,reset : IN std_logic;
    state: IN std_logic_vector(3 downto 0);
    PC_out: OUT std_logic_vector(1 downto 0);
    flag:out std_logic);
end component;

component data_way is
generic(M:integer:=3;
        N:integer:=16);
port( 
      Ins:in instruction; --feed the instruction to the datapath
      offset,Din:in std_logic_vector(N-1 downto 0);
      Bypass:in std_logic_vector(2 downto 0);
      address_en,data_en:in std_logic;
      clk:in std_logic;
      Z_flag,n_flag,o_flag:out std_logic;
      address,data:out std_logic_vector(N-1 downto 0)
     );
end component;

component divider is
port( clk_in:in std_logic;
     clk_out:out std_logic);
 end component;


signal clk_out:std_logic;
signal instr:operation;
signal writeread:std_logic;
--signal op:opcode;
signal state:std_logic_vector(3 downto 0);
signal Upc,select_flag:std_logic_vector(1 downto 0);
signal wren,reada,readb:std_logic;
signal uinst:opcode;
signal flag,st_flag:std_logic;
signal bypass:std_logic_vector(2 downto 0);
signal add_en,d_en:std_logic;
signal ins:instruction;
signal z,n_f,o:std_logic;
signal address:std_logic_vector(N-1 downto 0);
type instruction_register_type is array(15 downto 0) of std_logic_vector(15 downto 0);
constant instruction_register:program(15 downto 0):=(X"9080",X"A406",X"80C0",X"AA04",X"A605",X"7000",X"6440",X"58C0",X"4040",X"2040",X"3040",X"1040",X"1040",X"0040",X"0040",X"A201");
constant default_inst:instruction:=('0','0',reg0,Reg0,Reg0,'0','0','0',ADD_a,'1','1');
signal current_instruction,sign_ex:std_logic_vector(n-1 downto 0);
signal sign:std_logic;
signal offset:std_logic_vector(n-1 downto 0);
signal addr:integer;


 begin
 --A0:divider port map(clk_in=>clk, clk_out=>clk_out);

 A0:fsm port map(instr=>instr,clk=>clk,reset=>reset,state=>state,pc_out=>upc,flag=>st_flag);

 A1: micro_rom port map(inst=>state,flag=>flag,st_flag=>st_flag,upc=>upc,reset=>reset,wren=>wren,
                          reada=>reada,readb=>readb,uinst=>uinst,bypass=>bypass,
                          address_en=>add_en, data_en=>d_en,r_wn=>writeread,select_flag=>select_flag);

 A2: data_way generic map(3,16) port map(Ins=>Ins,offset=>offset,din=>din,bypass=>bypass,
                                        address_en=>add_en,data_en=>d_en,clk=>clk,
                                        z_flag=>z,n_flag=>n_f,o_flag=>o,address=>address,data=>dout);

 
	sign<=current_instruction(8) when instr=LDI_C else current_instruction(11);
 	sign_ex<=(others=>sign);
	offset<=sign_ex(15 downto 9)&current_instruction(8 downto 0) when instr=LDI_C else
        sign_ex(15 downto 12)&current_instruction(11 downto 0); 

--dout<=data;
address_cpu<=address;
R_WN<='0' when address= X"F000" else writeread;
addr <= (conv_integer(unsigned(address))) mod 16;

z_flag<=z;
o_flag<=o;
n_flag<=n_f;

process(upc,reset,wren,reada,readb,current_instruction,instr,uinst,z,n_f,o,addr,din,select_flag) is
     
	begin	
	if(reset='0') then
	instr<=add_c;
 	current_instruction<=din;
        ins<=default_inst;
        ins.reset<=reset;
        flag<='0';
        state<=din(15 downto 12);
     else ins.reset<=reset;
        if upc="01" then
	      current_instruction<=din;  
	      end if;                               --instruction_register(addr);
        instr<=current_instruction(15 downto 12);  
        state<=instr;    
        ins.wreg<=current_instruction(11 downto 9);
	      ins.ra<=current_instruction(8 downto 6);
	      ins.rb<=current_instruction(5 downto 3);
	

	if instr=LD_c then
	 if(upc="01") then
	 ins.ra<=conv_std_logic_vector(addr,3);
	 end if;
	ins.ie<='0';
	end if;
	if instr=St_c then
         --if(upc="10") then
	 ins.wreg<=conv_std_logic_vector(addr,3);
       	 --end if;
	ins.ie<='0';
	end if;

	if select_flag = "00" then
        flag <= z;
      elsif select_flag = "10" then
        flag <= n_f;
      elsif select_flag = "01" then
        flag <= o;
      else
        flag <= '0';
      end if;
  ins.op<=uinst;
  ins.wren<=wren;
  ins.reada<=reada;
  ins.readb<=readb;
end if;
end process;
end structure_cpu;


