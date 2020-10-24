library ieee;
use ieee.std_logic_1164.all;
use work.my_declerations.all;
use ieee.std_logic_arith.all;

ENTITY memory IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END memory;

architecture structure_fake of memory is
signal RAM:program(0 to 255):=(
				(LDI_C & reg5 & B"1_0000_0000"),
				(ADD_C & reg5 & reg5 & reg5 &NU3),
				(ADD_C & reg5 & reg5 & reg5 &NU3),
				(ADD_C & reg5 & reg5 & reg5 &NU3),
				(ADD_C & reg5 & reg5 & reg5 &NU3),
				(LDI_C & reg6 & B"0_0010_0000"),
				(LDI_C & reg3 & B"0_0000_0011"),
				(ST_C  & NU3  & reg6 & reg3 & nu3),
				(LDI_C & REG1 & B"0_0000_0001"),
				(LDI_C & reg0 & B"0_0000_1110"),
				(MOV_C & REG2 & reg0 & NU3 & NU3),
				(ADD_c & reg2 & reg2 & reg1 &nu3),
				(SUB_C & reg0 & reg0 & reg1 & NU3),
				(BRZ & X"003"),
				(NOP_C & NU3 & NU3 & NU3 & NU3),
				(BRA & X"FFC"),
				(ST_c & NU3 & Reg6 & Reg2 & NU3),
				(ST_C & NU3 & Reg5 & Reg2 & NU3),
				(BRA & X"000"),
                                others=>(NOP_C & NU3 & NU3 & NU3 & NU3));
begin
       process(clock) is
	begin

	if(rising_edge(clock) and wren='1') then
	 Ram(conv_integer(unsigned(address)))<=data;
        end if;
       end process;
      q<=Ram(conv_integer(unsigned(address))) when wren='0' else (others=>'0');
end structure_fake;
				
