library ieee;
use ieee.std_logic_1164.all;

entity decoder is			
port(
	data: in std_logic_vector(23 downto 0);
	tc: out std_logic;
	res: out std_logic
);
end entity;

architecture behav of decoder is
begin
res <= '1' when data = x"148071" else '0';
tc <= '1' when data = x"148070" else '0';
end architecture behav;


library ieee;
use ieee.std_logic_1164.all;
use work.devices_pkg.all;
use work.gates_pkg.all;

entity counter is
  port(
	ce: in std_logic;
	clk: in std_logic;
	rst: in std_logic;
      	q: out std_logic_vector(23 downto 0);
	tc: out std_logic
);
end entity;

architecture struct of counter is
 signal q_0, q_1, q_2, q_3, q_4, q_5: std_logic_vector(3 downto 0);
 signal ce_0, ce_1, ce_2, ce_3, ce_4, ce_5, tmp_res, tmp_res_2: std_logic;
 signal cur_q: std_logic_vector(23 downto 0);

 component decoder
 port(
	data: in std_logic_vector(23 downto 0);
	tc: out std_logic;
	res: out std_logic
 );
 end component;
begin
  inst_or: or2 generic map(Tpd => 0ns) port map(rst, tmp_res, tmp_res_2);
  cntr_0: cntr_u generic map(T => 0ns) port map(tmp_res_2, ce, clk, ce_0, q_0);
  cntr_1: cntr_u generic map(T => 0ns) port map(tmp_res_2, ce_0, clk, ce_1, q_1);
  cntr_2: cntr_u generic map(T => 0ns) port map(tmp_res_2, ce_1, clk, ce_2, q_2);
  cntr_3: cntr_u generic map(T => 0ns) port map(tmp_res_2, ce_2, clk, ce_3, q_3);
  cntr_4: cntr_u generic map(T => 0ns) port map(tmp_res_2, ce_3, clk, ce_4, q_4);
  cntr_5: cntr_u generic map(T => 0ns) port map(tmp_res_2, ce_4, clk, ce_5, q_5);
  cur_q <= q_5 & q_4 & q_3 & q_2 & q_1 & q_0;
  inst_decoder: decoder port map(cur_q, tc, tmp_res);
  q <= cur_q;
end architecture struct;
