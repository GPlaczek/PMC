library ieee;
use ieee.std_logic_1164.all;
use work.devices_pkg.all;
use work.gates_pkg.all;

entity counter is
  port(
	ce: in std_logic;
	clk: in std_logic;
	rst: in std_logic; -- reset 
      	q: inout std_logic_vector(23 downto 0);
	tc: out std_logic;
	res: inout std_logic -- reset od przepelnienia
);
end entity;

architecture struct of counter is
 signal ceo: std_logic_vector(5 downto 0);
 signal reset: std_logic; -- reset -> rst or res

begin
  tc <= '1' when q = x"148070" else '0';
  res <= '1' when q = x"148071" else '0';
  cntr_0: cntr_u generic map(T => 0ns) port map(reset, ce, clk, ceo(0), q(3 downto 0));
  cntr_1: cntr_u generic map(T => 0ns) port map(reset, ceo(0), clk, ceo(1), q(7 downto 4));
  cntr_2: cntr_u generic map(T => 0ns) port map(reset, ceo(1), clk, ceo(2), q(11 downto 8));
  cntr_3: cntr_u generic map(T => 0ns) port map(reset, ceo(2), clk, ceo(3), q(15 downto 12));
  cntr_4: cntr_u generic map(T => 0ns) port map(reset, ceo(3), clk, ceo(4), q(19 downto 16));
  cntr_5: cntr_u generic map(T => 0ns) port map(reset, ceo(4), clk, open, q(23 downto 20));
  or_gate: or2 generic map(Tpd => 0ns) port map(rst, res, reset);
end architecture struct;
