-------------------------------------------------------------------------------
-- Project: IP components lib
-- Author(s): Marek Kropidlowski
-- Created: Dec 2019   
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use std.env.all;

package ip_pkg is

 constant ResReal: real:=1.0e-12; --ps : simulator resolution in real

 procedure GenClock(signal c: out std_logic; T: in time);

 procedure StopAfter(T: in time);

 function time2real(t : time) return real;

-- pulse_gen  -------------------------------------------------------------------------------------
----_____hpulse______
-- /                 \_____lpulse______/  x number
---
procedure pulse_gen (signal s: out std_ulogic; number: natural; hpulse,lpulse: delay_length);

-- pulse  -----------------------------------------------------------------------------------------
----_____hpulse______
-- /                 \_____space______
---
procedure pulse (signal s: out std_ulogic; hpulse,space: delay_length);

-- bounced_pulse  ---------------------------------------------------------------------------------
----                    _____hpulse______
-- x n_of_bounce /\/\/\/                 \/\/\/\_____space______ 
---
procedure bounced_pulse (signal s: out std_ulogic; n_of_bounce: natural; bounce,hpulse,space: delay_length);

-- 7-seg decoder
function decode7 (hex: std_logic_vector(6 downto 0); neg: boolean:=true) return character;
function decodeAN (an: std_logic_vector; neg: boolean:=true) return character;
function decodeANi (an: std_logic_vector; neg: boolean:=true) return natural;

procedure print(str : in string);
procedure write_bcd_info(bcd: in std_logic_vector; expected: in string);
procedure check_bcd_vector(bcd: in std_logic_vector; expected: in std_logic_vector; result: out boolean);

-- N-stages K-bit register  -----------------------------------------------------------------------
 component NstageReg is
    generic(K: natural:=8;
            Stages: natural:=2);
    port(clk, rst: in std_logic;
        d: in std_logic_vector(K-1 downto 0);
        q: out std_logic_vector(K-1 downto 0)
        );
 end component;
 
end package ip_pkg;

------------------------------

package body ip_pkg is

    procedure GenClock(signal c: out std_logic; T: in time) is
      begin
        loop
            c<='0', '1' after T/2;
            wait for T; end loop;
    end procedure;

    procedure StopAfter(T: in time) is
      begin
        wait for T; stop(2);
    end procedure;

    function time2real(t : time) return real is
     begin
        return real(t/resolution_limit) * ResReal;
    end;

    ---
    procedure pulse_gen (signal s: out std_ulogic; number: natural; hpulse,lpulse: delay_length) is
    begin
        for i in 1 to number loop
            s <= '1', '0' after hpulse;
            wait for hpulse + lpulse; end loop;
    end procedure;    

    ---
    procedure pulse (signal s: out std_ulogic; hpulse,space: delay_length) is
    begin
            s <= '1', '0' after hpulse;
            wait for hpulse + space; 
    end procedure;    

    ---
    procedure bounced_pulse (signal s: out std_ulogic; n_of_bounce: natural; bounce,hpulse,space: delay_length) is
    begin
        for i in 1 to n_of_bounce loop
            s <= '1', '0' after bounce/2;
            wait for bounce; end loop;
        s <= '1', '0' after hpulse;
        wait for hpulse;
        for i in 1 to n_of_bounce loop
            s <= '1', '0' after bounce/2;
            wait for bounce; end loop;
        wait for space; 
    end procedure;    

    -- 7-seg decoder
    function decode7 (hex: std_logic_vector(6 downto 0); neg: boolean:=true) return character is
    variable byte: std_logic_vector(7 downto 0);
    variable c: character;
    begin
        if neg then
            byte:='0' & not(hex);
        else 
            byte:='0' & hex;
        end if;
        case byte is
            when x"3f" => c:='0';
            when x"06" => c:='1';
            when x"5b" => c:='2';
            when x"4f" => c:='3';
            when x"66" => c:='4';
            when x"6d" => c:='5';
            when x"7d" => c:='6';
            when x"07" => c:='7';
            when x"7f" => c:='8';
            when x"6f" => c:='9';
            when x"77" => c:='a';
            when x"7c" => c:='b';
            when x"39" => c:='c';
            when x"5e" => c:='d';
            when x"79" => c:='e';
            when x"71" => c:='f';
            when others => c:='-';
        end case;
        return c;
    end function;

    function decodeAN (an: std_logic_vector; neg: boolean:=true) return character is
    variable onehot: std_logic_vector(an'range);
    variable c: character;
    begin
        if neg then
            onehot:= not(an);
        else 
            onehot:= an;
        end if;
        for i in an'range loop
            if onehot(i)='1' then
                c:=integer'image(i)(1);
                return c;
            end if;
        end loop;
        return '-';
    end function;

    function decodeANi (an: std_logic_vector; neg: boolean:=true) return natural is
    variable onehot: std_logic_vector(an'range);
    variable p: natural;
    begin
        if neg then
            onehot:= not(an);
        else 
            onehot:= an;
        end if;
        for i in an'range loop
            if onehot(i)='1' then
                p:=i;
                return p;
            end if;
        end loop;
        return 99;
    end function;

    procedure print(str : in string) is
        variable oline : line;
      begin
        write(oline, str);
        writeline(output, oline);
    end procedure;

    procedure write_bcd_info(bcd: in std_logic_vector; expected: in string) is
    constant J: positive:=(bcd'left+1) /4;
    variable L : LINE;
    begin
      write(L, STRING'("Expected:"), LEFT, 15);
      write(L, STRING'("Actual:"),   LEFT, 15);
      writeline(OUTPUT,L);
      write(L,expected,LEFT,15);
      for i in J downto 1 loop
        write(L, to_integer(unsigned(bcd(i*4-1 downto i*4-4))));
      end loop;
      writeline(OUTPUT,L);
    end procedure;

    procedure check_bcd_vector(bcd: in std_logic_vector; expected: in std_logic_vector; result: out boolean) is
    constant J: positive:=(bcd'left+1) /4;
    variable L : LINE;
    begin
      write(L, STRING'("Expected:"), LEFT, 15);
      write(L, STRING'("Actual:"),   LEFT, 15);
      writeline(OUTPUT,L);
      for i in J downto 1 loop
        write(L, to_integer(unsigned(expected(i*4-1 downto i*4-4))));
      end loop;
      write(L,string'(" "),LEFT,7);
      for i in J downto 1 loop
        write(L, to_integer(unsigned(bcd(i*4-1 downto i*4-4))));
      end loop;
      write(L,string'(" "),LEFT,3);
      if bcd /= expected then
        write(L, STRING'("_ERROR_"),   LEFT, 8);
        result:=false;
      else 
        write(L, STRING'("_OK_"),   LEFT, 8);
        result:=true;
      end if;
      writeline(OUTPUT,L);
      write(L,now,UNIT=>ns);
      writeline(OUTPUT,L);
    end procedure;

end package body ip_pkg;

-------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity NstageReg is
    generic(K: natural:=4;
            Stages: natural:=2);
    port(clk, rst: in std_logic;
        d: in std_logic_vector(K-1 downto 0);
        q: out std_logic_vector(K-1 downto 0));
end;

architecture behav of NstageReg is
 signal data_internal: std_logic_vector(Stages*K-1 downto 0):=(others=>'0');

begin

 gen_loop: for i in 1 to Stages generate
  g1: if i=1 generate
    process(clk) begin
        if rising_edge(clk) then
            if rst='1' then
                data_internal(K-1 downto 0)<=(others=>'0');
            else 
                data_internal(K-1 downto 0)<=d;                
            end if;
        end if;
    end process;
  end generate;
  gx: if i>1 generate
    process(clk) begin
        if rising_edge(clk) then
            if rst='1' then
                data_internal((i*K)-1 downto (i-1)*K)<=(others=>'0');
            else 
                data_internal((i*K)-1 downto (i-1)*K)<=data_internal((i-1)*K-1 downto (i-2)*K);
            end if;
        end if;
    end process;
  end generate;
 end generate;
 q<=data_internal(Stages*K-1 downto (Stages*K)-K);
end architecture;
