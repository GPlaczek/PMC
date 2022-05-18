library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.all;
use std.env.all;

entity key_fsm_c is
generic(DIGIT: natural :=8);
 port (clk: in std_logic;
 rst: in std_logic; -- synch, high
 left, right, up, down, center: in std_logic; -- keys
 data_out: out std_logic_vector(DIGIT*4-1 downto 0) := (others => '0');
 cntr_en: out std_logic;
 cntr_rst: out std_logic:='0';
 cntr_load: out std_logic:='0';
 edit_en_out: out std_logic:='0'
 );

end entity;

architecture beh1 of key_fsm_c is
	type state_type is (start,reset,stop,idle,load,edit,inc_v,dec_v,inc_p,dec_p);
	signal c_state, n_state: state_type;
   
begin
	proc_fsm: process(clk, c_state, right, left, up, down, center)
	variable pos: integer := 0; 
	variable val: integer := 0;
	variable vector: std_logic_vector(DIGIT*4-1 downto 0) := (others => '0');
 begin
	if rising_edge(clk) then
	case c_state is
		when idle =>  
			n_state <= idle;
			cntr_rst <= '0';
			cntr_load <= '0';
		  	if right='1' then 
				n_state <= start;
			elsif down='1' then
				n_state <= reset;
			elsif left='1' then
				n_state <= stop;
			elsif up='1' then
				n_state <= load;
			elsif center='1' then
				n_state <= edit;
			end if;
		when start => 
			n_state <= idle;
			cntr_en <= '1';
			cntr_rst <= '0';
		when reset => 
			n_state <= idle;
			cntr_rst <= '1';
		when stop => 
			n_state <= idle;
			cntr_en <= '0';
		when load => 
			n_state <= idle;
			cntr_load <= '1';
			cntr_en <= '0';
			edit_en_out <= '0';
			data_out <= vector;
		when inc_v => 
			n_state <= edit;
			val := (val+1) mod 10;
			vector((pos+1)*4-1 downto (pos)*4) := std_logic_vector(to_unsigned(val,4));
		when dec_v => 
			n_state <= edit;
			val := (val-1) mod 10;
			vector((pos+1)*4-1 downto (pos)*4) := std_logic_vector(to_unsigned(val,4));
		when inc_p => 
			n_state <= edit;
			pos := (pos+1) mod DIGIT;
			val:= to_integer(unsigned( vector((pos+1)*4-1 downto (pos)*4)));
		when dec_p => 
			n_state <= edit;
			pos := (pos-1) mod DIGIT;
			val:= to_integer(unsigned( vector((pos+1)*4-1 downto (pos)*4)));
		when edit => 
			edit_en_out <= '1';
			cntr_en <= '0';
			n_state <= edit;
			--report "curr_val: " & to_hex_string(vector) severity Note;
			if up='1' then
				n_state <= inc_v;
			elsif down='1' then
				n_state <= dec_v;
			elsif left='1' then
				n_state <= inc_p;
			elsif right='1' then
				n_state <= dec_p;
			elsif center='1' then
				n_state <= load;
			end if; 
	end case;
	end if;
end process;

	proc_memory: process (clk,rst)
	begin
		if (rst ='1') then 
			c_state <= idle;
		elsif rising_edge(clk) then
			c_state <= n_state;
		end if;
	end process;

end beh1;
