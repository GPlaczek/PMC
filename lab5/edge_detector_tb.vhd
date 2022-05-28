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
 
ENTITY edge_detector_tb IS
END edge_detector_tb;
 
ARCHITECTURE behavior OF edge_detector_tb IS 
   constant BTN: natural:=5; -- no of btns

   component edge_detector is
   generic(N: positive:=1;
           RisingEdge: boolean:=True); -- rising or falling edge
   port(clk_sys: in std_logic; -- system clock
        async_in: in std_logic_vector(N-1 downto 0);
        edge_flag: out std_logic_vector(N-1 downto 0)
        );
   end component;

   --Inputs
    signal clk_in: std_logic := '0';  
    signal left,right,up,down,center: std_logic:='0';
    signal trigger_out_fe, trigger_out_re, button: std_logic_vector(BTN-1 downto 0);

   -- Clock period definitions
   constant clk_in_period : time := 10 ns;
   constant offset: time := 3 ns;
   constant space: time := 30*clk_in_period;
   constant pulseH: time := 8*clk_in_period;
 
BEGIN
  
  button <= (left & right & up & down & center);
  
	-- Instantiate the Unit Under Test (UUT)
   debounce_ut_re: edge_detector
        generic map(BTN,true)
        port map(
          clk_sys => clk_in,
          async_in => button,
          edge_flag => trigger_out_re
          );

   debounce_ut_nore: edge_detector
        generic map(BTN,false)
        port map(
          clk_sys => clk_in,
          async_in => button,
          edge_flag => trigger_out_fe
          );

  -- sequential stimuli
  process BEGIN
    pulse(center,pulseH,space); -- 
    pulse_gen(left,3,pulseH,space); -- 
    pulse_gen(right,1,pulseH,space); -- 
    pulse_gen(up,2,pulseH,space); -- 
    pulse_gen(down,3,pulseH,space); -- 
    pulse_gen(center,1,pulseH,space); -- 

    wait;
  end process;

   -- Clock definition
   GenClock(clk_in, clk_in_period);
   StopAfter( 500 * clk_in_period );

END;
