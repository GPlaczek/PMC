library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.env.all;

entity reg_tb is
end entity reg_tb;

architecture new_behav of reg_tb is
	constant Tpd: time:= 2 ns;
	signal clock, load_data, rotate : std_logic := '0';
	signal q_out : std_logic_vector(7 downto 0);
	signal data : std_logic_vector(7 downto 0);

	procedure clock_gen(signal s: out std_logic; period: delay_length) is
	begin loop
		s <= '0', '1' after period/2;
		wait for period; end loop;
	end procedure;
		
	procedure set_pulse(signal s:out std_logic; t,t_high,t_low: delay_length; iter: integer) is
	begin
	wait for t;
	for i in 1 to iter loop
		s <= '1', '0' after t_high;
		wait for (t_high+t_low);
	end loop;	
	end procedure;

	---procedure data_control(signal d: out std_logic_vector(7 downto 0); t1, t2, t3: delay_length; v1,v2: std_logic_vector(7 downto 0); signal load_enable: out std_logic) is
	--begin		
	--	wait for t1;
	--	d <= v1;
	--	load_enable <= '1', '0' after t2;
	--	wait for t3;
	--	d <= v2;
	--	load_enable <= '1', '0' after t2;
	--	wait;
	--end procedure;

	procedure data_control(signal s: out std_logic_vector(7 downto 0); t1, t2: delay_length; v1,v2: std_logic_vector(7 downto 0)) is
	begin
		wait for t1;
		s <= v1, v2 after t2;
	end procedure;
	
	procedure rotation(t1, t2, t3: delay_length; signal r: out std_logic) is
	begin
		r <= '0', '1' after t1, '0' after t2, '1' after t3;
	end procedure;

	procedure stop_after(t: delay_length) is
	begin	
		wait for t; stop(2); 
		--wait; stop; assert false report "OK" severity Failure;
	end procedure;
begin
	UUT: entity work.reg(behav) generic map(Tpd) port map(
		clk => clock,
		load => load_data,
		rot => rotate,
		d => data,
		q => q_out);
	clock_gen(clock, 10 ns);
	set_pulse(load_data, 5 ns, 10 ns, 110 ns, 2);
	data_control(data, 10 ns, 120 ns, x"01", x"11");
	rotation(15 ns, 95 ns, 185 ns, rotate); 
	stop_after(350 ns);
	--rotate <= '1';
end new_behav;
