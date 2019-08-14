-- Initialize the support vector memory with clock

library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SVM_pkg.all;
use work.ROM_pkg.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity SVROM is

	port(	clk: in std_logic;
			reset: in std_logic;
			SV_c: out std_logic_vector(15 downto 0);
			rd_SV: in std_logic;
			data: out std_logic_vector(N-1 downto 0));
end entity;

architecture rtl of SVROM is

signal SVdata_int: std_logic_vector(N-1 downto 0) ;
Signal SV_MEM :  SV_array  := SV_function(Support_Vector);
signal counter1: integer ;
Begin
	PROCESS(clk)
	
	BEGIN
		if rising_edge(clk) then
			if reset = '1' then
				counter1 <= 0 ;
				SVdata_int <= (others => '0');
			elsif rd_SV = '1' then
				SVdata_int <= SV_MEM(counter1) ;
			end if;
			if reset = '0' then
				if counter1 < SV_MEM'length-1 then
					counter1 <= counter1 + 1 ;
				else counter1 <= 0 ;
				end if;
			end if;
		end if;		
	END PROCESS;
SV_c <= std_logic_vector(to_unsigned(counter1,16));
data<= SVdata_int;
end architecture;