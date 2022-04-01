library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity licznik is
	generic(
		N: integer := 4;
		D: integer := 6);
	port(
		clk: in std_logic;
		ce: in std_logic := '1';
		clr: in std_logic;
		c: out std_logic_vector(23 downto 0);
		tc: out std_logic);
end licznik;

architecture struct of licznik is

signal ceo_1: std_logic := '0';
signal ceo_2: std_logic := '0';
signal ceo_3: std_logic := '0';
signal ceo_4: std_logic := '0';
signal ceo_5: std_logic := '0';
signal ceo_6: std_logic := '0';

signal c_1: std_logic_vector(3 downto 0);
signal c_2: std_logic_vector(3 downto 0);
signal c_3: std_logic_vector(3 downto 0);
signal c_4: std_logic_vector(3 downto 0);
signal c_5: std_logic_vector(3 downto 0);
signal c_6: std_logic_vector(3 downto 0);

signal clr_1: std_logic;
signal clr_2: std_logic;
signal clr_4: std_logic;
signal clr_5: std_logic;
signal clr_6: std_logic;

signal reset: std_logic;
signal clear: std_logic;

begin

ctr_1: entity work.cntr_u port map(clear, ce, clk, ceo_1, c_1);
ctr_2: entity work.cntr_u port map(clear, ceo_1, clk, ceo_2, c_2);
ctr_3: entity work.cntr_u port map(clear, ceo_2, clk, ceo_3, c_3);
ctr_4: entity work.cntr_u port map(clear, ceo_3, clk, ceo_4, c_4);
ctr_5: entity work.cntr_u port map(clear, ceo_4, clk, ceo_5, c_5);
ctr_6: entity work.cntr_u port map(clear, ceo_5, clk, open, c_6);

and_ceo_1: entity work.and2 port map(c_1(0), c_1(3), ceo_1);
and_ceo_2: entity work.and2 port map(c_2(0), c_2(3), ceo_2);
and_ceo_3: entity work.and2 port map(c_3(0), c_3(3), ceo_3);
and_ceo_4: entity work.and2 port map(c_4(0), c_4(3), ceo_4);
and_ceo_5: entity work.and2 port map(c_5(0), c_5(3), ceo_5);
and_ceo_6: entity work.and2 port map(c_6(0), c_6(3), ceo_6);

clr_1 <= c_1(0); -- 1
reset_2: entity work.and3 port map(c_2(0), c_2(1), c_2(2), clr_2); -- 7
-- 0
clr_4 <= c_4(3); -- 8
clr_5 <= c_5(2); -- 4
clr_6 <= c_6(0); -- 1

rst: entity work.and5 port map(clr_1, clr_2, clr_4, clr_5, clr_6, reset);
clear_counter: entity work.or2 port map(reset, clr, clear);

c(3 downto 0) <= c_1;
c(7 downto 4) <= c_2;
c(11 downto 8) <= c_3;
c(15 downto 12) <= c_4;
c(19 downto 16) <= c_5;
c(23 downto 20) <= c_5;

end struct;
