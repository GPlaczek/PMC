-------------------------------------------------------------------------------
-- Project: IP components lib
-- Author(s): Marek Kropidlowski
-- Created: Dec 2015   
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;
USE work.ip_pkg.all;
 
ENTITY debounceN_tb IS
END debounceN_tb;
 
ARCHITECTURE behavior OF debounceN_tb IS 
   constant BTN: natural:=5; -- no of btns

  component top_fsm is
    port(
        btn: in std_logic_vector(5 downto 1);
        clk_sys: in std_logic;
        rst: in std_logic;
        sseg: out std_logic_vector(6 downto 0);
        an: out std_logic_vector(7 downto 0);
        f_out: out std_logic);
  end component;


    signal clk_in: std_logic := '0';  
    signal rst: std_logic:='0';
    signal butn: std_logic_vector(5 downto 1) := (others => '0');

    --Outputs
    signal sseg: std_logic_vector(6 downto 0);
    signal an: std_logic_vector(7 downto 0);
    signal f_out: std_logic;

   -- Clock period definitions
   constant clk_in_period : time := 10 ns;
   constant clk_slow_period : time := 2 ms;
   constant bounce_time : time := clk_slow_period/2;
   
   constant offset: time := 3 ns;
   constant space: time := 3*clk_slow_period;
   constant pulseH: time := 2*clk_slow_period;
 
BEGIN
  
	-- Instantiate the Unit Under Test (UUT)
   top_uut: top_fsm 
        port map(
          clk_sys => clk_in,
          btn => butn,
          rst => rst,
          sseg => sseg,
          an => an,
          f_out => f_out
          );

  -- sequential stimuli
  process BEGIN
    pulse(butn(1),pulseH,space); -- 
    bounced_pulse(butn(5),3,bounce_time,pulseH,space); -- 
    bounced_pulse(butn(4),4,bounce_time,pulseH,space); -- 
    bounced_pulse(butn(3),2,bounce_time,pulseH,space); -- 
    bounced_pulse(butn(2),3,bounce_time,pulseH,space); -- 
    bounced_pulse(butn(1),1,bounce_time,pulseH,space); -- 

    wait;
  end process;

  process begin
    rst <= '1', '0' after 40 ns;
  end process;

   -- Clock definition
   GenClock(clk_in, clk_in_period);
   StopAfter( 2000 ms );

END;
