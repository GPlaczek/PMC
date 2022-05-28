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
 
ENTITY cntr_Nbcd_load_tb IS
END cntr_Nbcd_load_tb;
 
ARCHITECTURE behavior OF cntr_Nbcd_load_tb IS 
    constant D: positive:=3;

  component cntr_Nbcd_load is
      generic (DIGIT: positive:=8); -- counter length in 4-bit digit 
      Port ( clk : in  STD_LOGIC; 
      rst : in  STD_LOGIC; -- sync, high
      ce : in  STD_LOGIC; -- high
      load : in STD_LOGIC; -- sync, high
      din : in  STD_LOGIC_VECTOR (4*DIGIT -1 downto 0);
      q : out  STD_LOGIC_VECTOR (4*DIGIT -1 downto 0);
      ceo : out  STD_LOGIC);
end component;

   --Inputs
    signal qi : std_logic_vector(D*4 -1 downto 0):=(others=>'0');
    signal di : std_logic_vector(D*4 -1 downto 0):=(4*D-1=>'1',others=>'0');
    signal clk_in, clk_slow : std_logic := '0';  
    signal rst, ce, load: std_logic:='0';
    signal ceo: std_logic;

   -- Clock period definitions
   constant clk_in_period : time := 10 ns;
   constant offset: time := 3 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cntr_Nbcd_load 
        Generic MAP (D)
        PORT MAP (
          q => qi,
          ceo => ceo,
          clk => clk_in,
          rst => rst,
          ce => ce,
          load => load,
          din => di
        );

   -- Clock definitions
   GenClock(clk_in, clk_in_period);
   pulse(ce, (15**D)*clk_in_period, 40*clk_in_period);
   pulse_gen(rst, 2, clk_in_period+offset, (10**D)*clk_in_period);
   pulse_gen(load, 2, 3*clk_in_period+offset, (8**D)*clk_in_period);

   StopAfter( (10**D) * clk_in_period *5 );

END;
