library ieee;
use ieee.std_logic_1164.all;

entity mux is
  port(
    in0: in std_logic_vector(31 downto 0);
    in1: in std_logic_vector(31 downto 0);
    sel: in std_logic;
    mux_out: out std_logic_vector(31 downto 0));
end entity;

architecture behav of mux is
begin
  mux_out <= in0 when sel = '0' else in1;
end behav;
