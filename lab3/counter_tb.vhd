library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.env.all;

entity counter_tb is
end entity counter_tb;

architecture behav of counter_tb is
 constant sim_time: time := 14808000 ns;
 constant clk_time: time := 100 ns;
 signal ce_tb, clk_tb, rst_tb, tc_tb: std_logic := '0';
 signal q_tb : std_logic_vector(23 downto 0);

procedure clock_gen(signal s:out std_logic; period: delay_length) is
    begin loop
    s <= '0', '1' after period/2;
    wait for period; end loop;
end procedure;

procedure set_pulse(signal s:out std_logic; t_high,t_low: delay_length) is
    begin
    s <= '1', '0' after t_high;
    wait for (t_high+t_low);
end procedure;
    
procedure stop_after(t: delay_length) is
	begin
	wait for t; stop(2);
end procedure;

procedure get_period(signal s:in std_logic; name: string:="period ") is
    variable t1, t2: delay_length:=0 ns;
    begin
    if rising_edge(s) then t1:=now;
    wait until s='0';
    wait until s='1';
    t2:=now - t1;
    report name & time'image(t2) severity Warning;
    end if;
end procedure;

procedure get_ce(signal s:in std_logic; name: string:="ce ") is
    variable t1, t2: delay_length:=0 ns;
    begin
    if rising_edge(s) then t1:=now;
    wait until s='0';
    t2:=now - t1;
    report name & time'image(t2) severity Warning;
    end if;
end procedure;

procedure reset(signal s1:out std_logic) is
    begin
    s1 <= '1', '0' after 100 ns;
end procedure;
    
procedure enable(signal s:out std_logic) is
	begin
	s <= '1';
end procedure;

begin
    UUT: entity work.counter(struct)
    port map(
        ce => ce_tb,
        clk => clk_tb,
        rst => rst_tb,
        q => q_tb,
        tc => tc_tb
    );
	clock_gen(clk_tb, clk_time);
	reset(rst_tb);
	enable(ce_tb);
	get_period(tc_tb, "CLOCK: ");
	get_ce(tc_tb, "CE: ");
	stop_after(sim_time);
		
end architecture behav;
