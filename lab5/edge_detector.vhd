-------------------------------------------------------------------------------
-- Project: IP components lib
-- Author(s): Marek Kropidlowski
-- Created: Dec 2015   
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity edge_detector is
   generic(N: positive:=1;
           RisingEdge: boolean:=True); -- rising or falling edge
   port(clk_sys: in std_logic; -- system clock
        async_in: in std_logic_vector(N-1 downto 0);
        edge_flag: out std_logic_vector(N-1 downto 0)
        );
end edge_detector;

architecture behav of edge_detector is
   type ff_tab is array(N-1 downto 0) of std_logic_vector(1 downto 0);
   signal ffStore: ff_tab:=(others=>(others=>'0'));
   signal re_pulse: std_logic_vector(edge_flag'range):=(others=>'0');

begin

gen_re: if RisingEdge generate
  gen_filter: for i in ff_tab'range generate
    process (clk_sys)
    begin
      if rising_edge(clk_sys) then
         ffStore(i)(0) <= async_in(i);
         ffStore(i)(1) <= ffStore(i)(0);
      end if;
    end process;
    re_pulse(i) <= '1' when (ffStore(i) = "01") else '0';   
  end generate;
  edge_flag <= re_pulse;
end generate;

gen_fe: if not RisingEdge generate
  gen_filter: for i in ff_tab'range generate
    process (clk_sys)
    begin
      if rising_edge(clk_sys) then
         ffStore(i)(0) <= async_in(i);
         ffStore(i)(1) <= ffStore(i)(0);
      end if;
    end process;
    re_pulse(i) <= '1' when (ffStore(i) = "10") else '0';   
  end generate;
  edge_flag <= re_pulse;
end generate;

end behav;
