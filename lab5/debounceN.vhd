-------------------------------------------------------------------------------
-- Project: IP components lib
-- Author(s): Marek Kropidlowski
-- Created: Dec 2015   
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity debounceN is
   generic(N: positive:=5;
           RE_DETECTOR: boolean:=False);
   port(clk_sys: in std_logic; -- system clock
        clk_slow: in std_logic; -- debounce clock (100Hz)
        button: in std_logic_vector(N-1 downto 0);
        trigger_out: out std_logic_vector(N-1 downto 0)
        );
end debounceN;

architecture behav of debounceN is
   type memory is array(N-1 downto 0) of std_logic_vector(3 downto 0);
   signal trigStore: memory:=(others=>(others=>'0'));
   type ff_tab is array(N-1 downto 0) of std_logic_vector(1 downto 0);
   signal ffStore: ff_tab:=(others=>(others=>'0'));
   signal trigger: std_logic_vector(trigger_out'range):=(others=>'0');
   signal re_pulse: std_logic_vector(trigger_out'range):=(others=>'0');

begin

gen_filter: for i in memory'range generate
 process (clk_slow)
 begin
   if rising_edge(clk_slow) then
      trigStore(i)(0) <= button(i);
      trigStore(i)(1) <= trigStore(i)(0);
      trigStore(i)(2) <= trigStore(i)(1);
      trigStore(i)(3) <= trigStore(i)(2);
   end if;
 end process;
 trigger(i) <= '1' when (trigStore(i) = "0001") else '0';
end generate;

gen_re: if RE_DETECTOR generate
  gen_filter: for i in ff_tab'range generate
    process (clk_sys)
    begin
      if rising_edge(clk_sys) then
         ffStore(i)(0) <= trigger(i);
         ffStore(i)(1) <= ffStore(i)(0);
      end if;
    end process;
    re_pulse(i) <= '1' when (ffStore(i) = "01") else '0';   
  end generate;
  trigger_out <= re_pulse;
end generate;

gen_out: if not RE_DETECTOR generate
  trigger_out <= trigger;
end generate;

end behav;