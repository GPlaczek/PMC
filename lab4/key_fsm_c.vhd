library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity key_fsm_c is
	generic(DIGIT: natural:=6);
    port (clk: in std_logic;
 rst: in std_logic; -- synch, high
 left, right, up, down, center: in std_logic; -- keys
 data_out: out std_logic_vector(DIGIT*4-1 downto 0);
 cntr_en: out std_logic;
 cntr_rst: out std_logic;
 cntr_load: out std_logic;
 edit_en_out: out std_logic);
end entity;

architecture behav of key_fsm_c is
type state_type is (idle, start, stop, reset, load, edit, inc_v, inc_p, dec_v, dec_p);
signal c_state: state_type := idle;
signal  n_state: state_type;
begin
	buttons: process(clk, left, right, up, down, center)
	variable num: integer := 0;
	variable index: integer := 0;
	variable modulo: std_logic_vector(DIGIT*4-1 downto 0) := (others => '0');
	begin
		if rising_edge(clk) then
			case c_state is
				when start =>
					cntr_en <= '1';
					n_state <= idle;
				when stop =>
					cntr_en <= '0';
					n_state <= idle;
				when reset =>
					cntr_rst <= '1';
					data_out <= x"00";
					n_state <= idle;
				when load =>
					cntr_load <= '1';
					n_state <= idle;
					data_out <= modulo;
				when inc_p =>
					num := to_integer(unsigned(modulo((index+1)*4-1 downto index*4-1)));
					index := (index+1) mod DIGIT;
					n_state <= edit;
				when dec_p =>
					num := to_integer(unsigned(modulo((index+1)*4-1 downto index*4-1)));
					index := (index-1) mod DIGIT;
					n_state <= edit;
				when inc_v =>
					if num = 9 then
						num := 0;
					else
						num := num + 1;
					end if;
					modulo((index+1)*4-1 downto index*4) := std_logic_vector(to_unsigned(num, 4));
					n_state <= edit;
				when dec_v =>
					if num = 9 then
						num := 0;
					else
						num := num - 1;
					end if;
					modulo((index+1)*4-1 downto index*4) := std_logic_vector(to_unsigned(num, 4));
					n_state <= edit;
				when idle =>
					cntr_en <= '0';
					cntr_rst <= '0';
					cntr_load <= '0';
					edit_en_out <= '0';
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
					edit_en_out <= '1';
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
end behav;
