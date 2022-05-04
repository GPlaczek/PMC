library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.env.all;

entity counter_tb is
end entity counter_tb;

architecture behav of counter_tb is
 constant sim_periods: integer := 148080;
 constant clk_time: time := 100 ns;
 signal ce_tb, clk_tb, rst_tb, tc_tb: std_logic := '0';
 signal q_tb : std_logic_vector(23 downto 0);

procedure set_rst(signal s:out std_logic; periods: integer) is
    begin
    s <= '1', '0' after clk_time * periods;
end procedure;

procedure clock_gen(signal s:out std_logic; period: time) is
    begin loop
    s <= '0', '1' after period/2;
    wait for period; end loop;
end procedure;

procedure set_ce(signal s:out std_logic) is
	begin
	s <= '1';
end procedure;
    
procedure stop_after(t: integer) is
	begin
	wait for t * clk_time; stop(2);
end procedure;

procedure get_ceo_last_state(signal s:in std_logic; signal q:in std_logic_vector(23 downto 0)) is
    variable t_start, t_stop: time;
    begin
    if rising_edge(s) then t_start:=now;
    report "last state before reset: " & to_hex_string(q) severity Note;
    wait until s='0';
    t_stop:=now - t_start;
    report "ceo: "& time'image(t_stop) severity Note;
    end if;
end procedure;

procedure get_clk(signal s:in std_logic) is
    variable t1, t2: time:=0 ns;
    begin
    if rising_edge(s) then t1:=now;
    wait until s='0';
    wait until s='1';
    t2:=now - t1;
    report "clk: " & time'image(t2) severity Note;
    end if;
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
	set_rst(rst_tb, 1);
	set_ce(ce_tb);
	get_clk(clk_tb);
	get_ceo_last_state(tc_tb, q_tb);	
	stop_after(sim_periods);
		
end architecture behav;
