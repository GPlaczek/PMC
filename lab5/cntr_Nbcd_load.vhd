-------------------------------------------------------------------------------
-- Project: IP components lib
-- Author(s): Marek Kropidlowski
-- Created: Dec 2015   
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cntr_Nbcd_load is
    generic (DIGIT: positive:=4); -- counter length in 4-bit digit 
    Port ( clk : in  STD_LOGIC; 
           rst : in  STD_LOGIC; -- sync, high
           ce : in  STD_LOGIC; -- high
           load : in STD_LOGIC; -- sync, high
           din : in  STD_LOGIC_VECTOR (4*DIGIT -1 downto 0);
           q : out  STD_LOGIC_VECTOR (4*DIGIT -1 downto 0);
           ceo : out  STD_LOGIC);
end cntr_Nbcd_load;

architecture Behavioral of cntr_Nbcd_load is
  constant TC: unsigned(3 downto 0):=to_unsigned(9,4);
  type bcd_array is array(DIGIT downto 1) of unsigned(TC'range);
  signal q_bcd: bcd_array:= (others=> (others=>'0'));
  signal q_i: std_logic_vector(q'range):=(others=>'0');
  signal ceo_i: std_logic_vector(DIGIT+1 downto 1):=(others=>'0');
  signal din_reg: std_logic_vector(din'range):=(others=>'1');
  signal tc_flag: std_logic:='0';
begin

ceo <= ceo_i(DIGIT+1) or tc_flag;
ceo_i(1) <= ce;
tc_flag <= '1' when din_reg=q_i else '0';

gen_cntr: for i in bcd_array'range generate
  process(clk) begin
      if rising_edge(clk) then
          if (rst or tc_flag)='1' then
              q_bcd(i) <= (others=>'0');
          else
              if ceo_i(i)='1' then 
                if q_bcd(i)=TC then 
                  q_bcd(i) <= (others=>'0'); 
                else 
                  q_bcd(i) <= q_bcd(i)+1; 
                end if; 
              end if;
          end if;
          if load='1' then 
            din_reg<=din;
          end if;
      end if;
  end process;
  ceo_i(i+1) <= ceo_i(i) and q_bcd(i)(3) and q_bcd(i)(0);
  q_i(4*i-1 downto 4*i-4) <= std_logic_vector(q_bcd(i));
  q(4*i-1 downto 4*i-4) <= std_logic_vector(q_bcd(i));
end generate;

end Behavioral;