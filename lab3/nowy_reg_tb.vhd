library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_tb is
end entity reg_tb;

architecture new_behav of reg_tb is
	constant Tpd: time:= 2 ns;
	signal clock, load_data, rotate : std_logic := '0';
	signal q_out : std_logic_vector(7 downto 0);
	signal data : std_logic_vector(7 downto 0);
	signal temp : std_logic_vector(7 downto 0);

	procedure clk_process(signal clock: out std_logic) is
	begin loop
		wait for 10 ns;
		clock <= not clock; end loop;
	end procedure;

	procedure load(signal data: out std_logic_vector(7 downto 0);
	signal load_data: out std_logic) is
	begin
		wait for 5 ns;
		data <= x"01";
		load_data <= '1', '0' after 10 ns;
		wait;
	end procedure;
	procedure correct(signal clk: in std_logic;
	signal rot: in std_logic;
	signal load_data: in std_logic;
	signal data: in std_logic_vector(7 downto 0);
	signal q_out: in std_logic_vector(7 downto 0);
	signal temp: out std_logic_vector(7 downto 0)) is
	begin
		if rising_edge(clk) then
			if load_data='1' then
				temp <= data after 3 ns;
			elsif rot='1' then
				temp <= temp(6 downto 0) & temp(7) after 3 ns;
			end if;
		end if;
		assert true
		report "FAIL"
		severity Failure;
	end procedure;
begin
	UUT: entity work.reg(behav) generic map(Tpd) port map(
		clk => clock,
		load => load_data,
		rot => rotate,
		d => data,
		q => q_out);
	clk_process(clock);
	load(data, load_data);
	correct(clock,
		rotate,
		load_data,
		data,
		q_out,
		temp);
	rotate <= '1';
end new_behav;
