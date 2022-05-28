library ieee;
use ieee.std_logic_1164.all;

entity top_fsm is
  port(
    btn: in std_logic_vector(5 downto 1);
    clk_sys: in std_logic;
    rst: in std_logic;
    sseg: out std_logic_vector(6 downto 0);
    an: out std_logic_vector(7 downto 0);
    f_out: out std_logic);
end entity;

architecture struct of top_fsm is
  signal clk100Hz: std_logic;
  signal clk1MHz: std_logic;
  signal clk1kHz: std_logic;

  signal dn_trigger_out: std_logic_vector(4 downto 0);

  signal ed_edge_flag: std_logic_vector(4 downto 0);

  signal fsm_data_out: std_logic_vector(31 downto 0);
  signal fsm_cntr_load: std_logic;
  signal fsm_cntr_en: std_logic;
  signal fsm_cntr_rst: std_logic;
  signal fsm_edit_en_out: std_logic;

  signal cnl_q: std_logic_vector(31 downto 0);

  signal mux_out: std_logic_vector(31 downto 0);

begin
  debounce_n: entity work.DebounceN
    port map(
      button => btn,
      clk_slow => clk100Hz,
      clk_sys => clk1MHz,
      trigger_out => dn_trigger_out);

  edge_detector: entity work.Edge_detector
    port map(
      async_in => dn_trigger_out,
      clk_sys => clk1MHz,
      edge_flag => ed_edge_flag);

  clk_gen: entity work.Clk_gen_1Hz_v6
    port map(
      clk_in => clk_sys,
      rst => rst,
      f_100Hz => clk100Hz,
      f_1MHz => clk1MHz,
      f_1kHz => clk1kHz);

  key_fsm_c: entity work.key_fsm_c
    port map(
      left => btn(5),
      right => btn(4),
      up => btn(3),
      down => btn(2),
      center => btn(1),
      rst => rst,
      clk => clk1MHz,
      data_out => fsm_data_out,
      cntr_load => fsm_cntr_load,
      cntr_en => fsm_cntr_en,
      cntr_rst => fsm_cntr_rst,
      edit_en_out => fsm_edit_en_out);

  cntr_nbcd_load: entity work.Cntr_Nbcd_load
    port map(
      din => fsm_data_out,
      load => fsm_cntr_load,
      ce => fsm_cntr_en,
      rst => fsm_cntr_rst,
      clk => clk1MHz,
      ceo => F_out,
      q => cnl_q);

  mux: entity work.mux
    port map(
      in1 => fsm_data_out,
      in0 => cnl_q,
      sel => fsm_edit_en_out,
      mux_out => mux_out);

  led: entity work.led8_drv
    port map(
      a => mux_out(3 downto 0),
      b => mux_out(7 downto 4),
      c => mux_out(11 downto 8),
      d => mux_out(15 downto 12),
      e => mux_out(19 downto 16),
      f => mux_out(23 downto 20),
      g => mux_out(27 downto 24),
      h => mux_out(31 downto 28),
      clk_in => clk1kHz,
      sseg => sseg,
      an => an);

end architecture struct;
