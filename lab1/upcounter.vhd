library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.std_logic_unsigned.all;

entity counter is
	port (clk: in std_logic;
		reset: in std_logic;
		num: out std_logic_vector(7 downto 0));
end counter;

architecture struct of counter is
signal count: std_logic_vector(7 downto 0);
begin
	process(reset, clk)
	begin
		if(clk'event and clk='1' and reset='1') then
			count <= "00000000";
		elsif(clk'event and clk='1') then
			count <= count + 1;
		end if;
	end process;
	num <= count;
end struct;
