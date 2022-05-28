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
 
ENTITY led8_drv_tb IS
END led8_drv_tb;
 
ARCHITECTURE behavior OF led8_drv_tb IS 
    
    component led8_drv is
        Generic ( MAIN_CLK: natural:=100E6;                 -- main frequency in Hz
                  CLKDIV_INTERNAL: boolean:=True);          -- 
        Port ( a : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN0
               b : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN1
               c : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN2
               d : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN3 
               e : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN4
               f : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN5
               g : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN6
               h : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN7 
               clk_in : in  STD_LOGIC;                      -- main_clk or slow_clk (external)
               sseg : out  STD_LOGIC_VECTOR (6 downto 0);   -- active Low
               an : out  STD_LOGIC_VECTOR (7 downto 0));    -- active Low
    end component;

   --Inputs
    signal qi : std_logic_vector(31 downto 0):=(others=>'0');
    alias h: std_logic_vector(3 downto 0) is qi(31 downto 28);
    alias g: std_logic_vector(3 downto 0) is qi(27 downto 24);
    alias f: std_logic_vector(3 downto 0) is qi(23 downto 20);
    alias e: std_logic_vector(3 downto 0) is qi(19 downto 16);
    alias d: std_logic_vector(3 downto 0) is qi(15 downto 12);
    alias c: std_logic_vector(3 downto 0) is qi(11 downto 8);
    alias b: std_logic_vector(3 downto 0) is qi(7 downto 4);
    alias a: std_logic_vector(3 downto 0) is qi(3 downto 0);
    signal clk_in, clk_slow : std_logic := '0';  

 	--Outputs
   signal sseg : std_logic_vector(6 downto 0);
   signal an : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_in_period : time := 10 ns;
   constant slow_period : time := 1234 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: led8_drv 
        Generic MAP (MAIN_CLK=>100e6, CLKDIV_INTERNAL=>True)
        PORT MAP (
          a => a,
          b => b,
          c => c,
          d => d,
          e => e,
          f => f,
          g => g,
          h => h,
          clk_in => clk_in,
          sseg => sseg,
          an => an
        );

   -- input driver
   process(clk_slow) begin 
    if rising_edge(clk_slow) then
      qi <= qi + 1;
    end if;
   end process;

   -- output report
   process
   constant DL: positive:=8; -- disp length
   variable display: string(DL+2 downto 1):="----------";
   begin
    wait on an;
    if decodeANi(an) > DL then
      report "AN unknown";
    else
      display(decodeANi(an)+1):=decode7(sseg);
      display(DL+2):=decodeAN(an);
      print("pos:" & display);
    end if;
   end process;

   -- Clock definitions
   GenClock(clk_in, clk_in_period);
   GenClock(clk_slow, slow_period);
   StopAfter(1 sec);
   
END;
