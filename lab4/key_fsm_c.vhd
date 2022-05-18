-- Autorzy: Grzegorz Placzek 148071, Kamil Kaluzny 148121

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.all;
use std.env.all;

entity key_fsm_c is
generic(DIGIT: natural :=8);
 port (clk: in std_logic;
 rst: in std_logic;
 left, right, up, down, center: in std_logic;
 data_out: out std_logic_vector(DIGIT*4-1 downto 0) := (others => '0');
 cntr_en: out std_logic:='0';
 cntr_rst: out std_logic:='0';
 cntr_load: out std_logic:='0';
 edit_en_out: out std_logic:='0'
 );

end entity;

architecture beh1 of key_fsm_c is
	type state_type is (start,reset,stop,idle,load,edit,inc_v,dec_v,inc_p,dec_p);
	signal c_state, n_state: state_type;
	signal vector: std_logic_vector(DIGIT*4-1 downto 0) := (others => '0');
	signal pos: integer := 0;
	signal val: integer := 0;
	signal inc_val: std_logic := '0';
	signal dec_val: std_logic := '0';
	signal inc_pos: std_logic := '0';
	signal dec_pos: std_logic := '0';
	signal edit_en: std_logic := '0';
   
begin
	proc_fsm: process(clk, c_state, right, left, up, down, center)
 begin
	--if rising_edge(clk) then
	n_state <= idle;
	cntr_rst <= '0';
	cntr_load <= '0';
	inc_val <= '0';
	dec_val <= '0';
	inc_pos <= '0';
	dec_pos <= '0';
	case c_state is
		when idle =>  
			edit_en <= '0';
			--edit_en_out <= '0';			
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
			else
				n_state <= idle;
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
		when inc_v => 
			n_state <= edit;
			--if unsigned(vector((pos+1)*4-1 downto (pos)*4)) < 9 then
			--	vector((pos+1)*4-1 downto (pos)*4) <= std_logic_vector(unsigned(vector((pos+1)*4-1 downto (pos)*4)) + 1);
			--else 
			--	vector((pos+1)*4-1 downto (pos)*4) <= std_logic_vector(to_unsigned(0,4));
			--end if;
			--val <= (val+1) mod 10;
			--vector((pos+1)*4-1 downto (pos)*4) <= std_logic_vector(to_unsigned(val,4));
		when dec_v => 
			n_state <= edit;
			--if unsigned(vector((pos+1)*4-1 downto (pos)*4)) > 0 then
			--	vector((pos+1)*4-1 downto (pos)*4) <= std_logic_vector(unsigned(vector((pos+1)*4-1 downto (pos)*4)) - 1);
			--else 
			--	vector((pos+1)*4-1 downto (pos)*4) <= std_logic_vector(to_unsigned(9,4));
			--end if;
			--val <= (val-1) mod 10;
			--vector((pos+1)*4-1 downto (pos)*4) <= std_logic_vector(to_unsigned(val,4));
		when inc_p => 
			n_state <= edit;
			--if pos < DIGIT - 1 then
			--	pos <= pos + 1;
			--else
			--	pos <= 0;
			--end if;
			--pos <= (pos+1) mod DIGIT;
			--val <= to_integer(unsigned( vector((pos+1)*4-1 downto (pos)*4)));
		when dec_p => 
			n_state <= edit;
			--if pos > 0 then
			--	pos <= pos - 1;
			--else
			--	pos <= DIGIT-1;
			--end if;
			--pos <= (pos-1) mod DIGIT;
			--val <= to_integer(unsigned( vector((pos+1)*4-1 downto (pos)*4)));
		when edit => 
			edit_en <= '1';
			--edit_en_out <= '1';			
			--cntr_en <= '0';
			if up='1' then
				n_state <= inc_v;
				inc_val <= '1';
			elsif down='1' then
				n_state <= dec_v;
				dec_val <= '1';
			elsif left='1' then
				n_state <= inc_p;
				inc_pos <= '1';
			elsif right='1' then
				n_state <= dec_p;
				dec_pos <= '1';
			elsif center='1' then
				n_state <= load;
			else 
				n_state <= edit;
			end if;
 
		when others=>
			n_state <= edit;
	end case;
	--end if;
end process;

	proc_memory: process (clk)
	begin
		if rising_edge(clk) then
			if (rst ='1') then 
				c_state <= idle;
			else
				c_state <= n_state;
			end if;
			
			if (c_state = stop or c_state = edit) then
				cntr_en <= '0';
			elsif (c_state = start) then
				cntr_en <= '1';
			end if;
			edit_en_out <= edit_en;

			if (inc_pos = '1') then
				--pos <= (pos+1) mod DIGIT;
				if pos < 9 then
					pos <= pos + 1;
				else
					pos <= 0;
				end if;
			elsif (dec_pos = '1') then
				if pos > 0 then
					pos <= pos - 1;
				else
					pos <= DIGIT-1;
				end if;
				--pos <= (pos-1) mod DIGIT;
			end if;

			if (inc_val = '1') then 
				--val <= val mod 10;
				--vector((pos+1)*4-1 downto (pos)*4) <= std_logic_vector(to_unsigned(val,4));
				if unsigned(vector((pos+1)*4-1 downto (pos)*4)) < 9 then
					vector((pos+1)*4-1 downto (pos)*4) <= std_logic_vector(unsigned(vector((pos+1)*4-1 downto (pos)*4)) + 1);
				else 
					vector((pos+1)*4-1 downto (pos)*4) <= std_logic_vector(to_unsigned(0,4));
				end if;
			elsif (dec_val = '1') then
				--val <= val mod 10;
				--vector((pos+1)*4-1 downto (pos)*4) <= std_logic_vector(to_unsigned(val,4));
				if unsigned(vector((pos+1)*4-1 downto (pos)*4)) > 0 then
					vector((pos+1)*4-1 downto (pos)*4) <= std_logic_vector(unsigned(vector((pos+1)*4-1 downto (pos)*4)) - 1);
				else 
					vector((pos+1)*4-1 downto (pos)*4) <= std_logic_vector(to_unsigned(9,4));
				end if;
			end if;
		end if;
	end process;
	data_out <= vector;
end beh1;
