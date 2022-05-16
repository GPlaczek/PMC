library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.all;

entity key_fsm_c is
generic(DIGIT: natural :=8);
 port (clk: in std_logic;
 rst: in std_logic; -- synch, high
 left, right, up, down, center: in std_logic; -- keys
 data_out: out std_logic_vector(DIGIT*4-1 downto 0) := (others => '0');
 cntr_en: out std_logic;
 cntr_rst: out std_logic;
 cntr_load: out std_logic;
 edit_en_out: out std_logic
 );

end entity;

architecture beh1 of key_fsm_c is
	type state_type is (start,reset,stop,idle,load,edit,inc_v,dec_v,inc_p,dec_p);
	signal c_state, n_state: state_type;
	
   
begin
	
	proc_fsm: process(c_state, right, left, up, down, center)
	variable pos: integer := 0; 
	variable val: integer := 0;
	variable vector: std_logic_vector(DIGIT*4-1 downto 0) := (others => '0');
 begin
			case c_state is
				when idle =>  
			n_state <= idle;
				  	if right='1' then 
		  				  n_state <= start;
				
			end if;
  			if down='1' then
				n_state <= reset;
				
			end if;
			if left='1' then
				n_state <= stop;
				
			end if;
			if up='1' then
				n_state <= load;
			end if;
			if center='1' then
				n_state <= edit;
			end if;
			 
				when start => 
					n_state <= idle;
			cntr_en <= '1';
				when reset => 
					n_state <= idle;
			cntr_rst <= '1';
				when stop => 
					n_state <= idle;
			cntr_en <= '0';
		when load => 
					n_state <= idle;
			cntr_load <= '1';
			edit_en_out <= '0';
			data_out <= vector;
		when inc_v => 
					n_state <= edit;
			if val <= 8 then
			val:= val+1;
			else 
			val:= 0;
			end if;
			vector((pos+1)*4-1 downto (pos)*4) := std_logic_vector(to_unsigned(val,4));
		when dec_v => 
					n_state <= edit;
			if val > 0 then
			val:= val-1;
			else 
			val:= 9;
			end if;
			vector((pos+1)*4-1 downto (pos)*4) := std_logic_vector(to_unsigned(val,4));
		when inc_p => 
					n_state <= edit;
			if pos < DIGIT-1 then
			pos:= pos + 1;
			val:= to_integer(unsigned( vector((pos+1)*4-1 downto (pos)*4)));
			end if;
		when dec_p => 
					n_state <= edit;
			if pos > 0 then
			pos:= pos - 1;
			val:= to_integer(unsigned( vector((pos+1)*4-1 downto (pos)*4)));
			end if;

		when edit => 
			edit_en_out <= '1';
			n_state <= edit;
				if up='1' then
				n_state <= inc_v;
				
			end if;
			if down='1' then
				n_state <= dec_v;
			end if;
			if left='1' then
				n_state <= inc_p;
			end if;
			if right='1' then
				n_state <= dec_p;
			end if;
			if center='1' then
				n_state <= load;
			end if; 
				
			
			end case;
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
