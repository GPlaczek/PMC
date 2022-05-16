library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity key_fsm_c is
	generic(DIGIT: natural:=8);
    port (clk: in std_logic;
 rst: in std_logic; -- synch, high
 left, right, up, down, center: in std_logic; -- keys
 data_out: out std_logic_vector(DIGIT*4-1 downto 0);
 cntr_en: out std_logic;
 cntr_rst: out std_logic;
 cntr_load: out std_logic;
 edit_en_out: out std_logic);
end entity;

architecture beh1 of key_fsm_c is
type state_type is (idle, start, stop, reset, load, edit, inc_v, inc_p, dec_v, dec_p);
signal c_state: state_type := idle;
signal  n_state: state_type;
begin
	buttons: process(c_state, clk, left, right, up, down, center)
	variable num: integer := 0;
	variable index: integer := 0;
	variable temp_num: std_logic_vector(DIGIT*4-1 downto 0) := (others => '0');
	begin
		if rising_edge(clk) then
			case c_state is
				when start =>
					n_state <= idle;
					cntr_en <= '1';
				when stop =>
					n_state <= idle;
					cntr_en <= '0';
				when reset =>
					n_state <= idle;
					cntr_rst <= '1';
				when load =>
					n_state <= idle;
					cntr_load <= '1';
					edit_en_out <= '0';
					data_out <= temp_num;
				when inc_p =>
					n_state <= edit;
					if index < DIGIT  then
						index := index + 1;
						num := to_integer(unsigned(temp_num((index+1)*4-1 downto (index)*4)));
					end if;
				when dec_p =>
					n_state <= edit;
					if index > 0 then
						index := index - 1;
						num := to_integer(unsigned(temp_num((index+1)*4-1 downto (index)*4)));
					end if;
				when inc_v =>
					n_state <= edit;
					if num = 9 then
						num := 0;
					else
						num := num + 1;
					end if;
					temp_num((index+1)*4-1 downto (index)*4) := std_logic_vector(to_unsigned(num, 4));
				when dec_v =>
					n_state <= edit;
					if num = 0 then
						num := 9;
					else
						num := num - 1;
					end if;
					temp_num((index+1)*4-1 downto (index)*4) := std_logic_vector(to_unsigned(num, 4));
				when idle =>
					n_state <= idle;
					cntr_en <= '0';
					cntr_rst <= '0';
					if right = '1' then
						n_state <= start;
					elsif left = '1' then
						n_state <= stop;
					elsif up = '1' then
						n_state <= load;
					elsif down = '0' then
						n_state <= reset;
					elsif center = '1' then
						n_state <= edit;
					end if;
				when edit =>
					n_state <= edit;
					edit_en_out <= '1';
					num := to_integer(unsigned(temp_num((index+1)*4-1 downto (index)*4)));
					if right = '1' then
						n_state <= dec_p;
					elsif left = '1' then
						n_state <= inc_p;
					elsif up = '1' then
						n_state <= dec_v;
					elsif down = '0' then
						n_state <= inc_v;
					elsif center = '1' then
						n_state <= load;
					end if;
			end case;
		end if;
	end process;
	memory: process (clk, rst)
	begin
	if (rst = '1') then
		c_state <= idle;
	elsif rising_edge(clk) then
		c_state <= n_state;
	end if;
	end process;
end beh1;
