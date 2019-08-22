library IEEE;
library std;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use ieee.numeric_std.all;
use work.ROM_pkg.all;

entity kernel is
	port( input: in std_logic_vector (2*N+7 downto 0);
			reset: in std_logic;
			clk: in std_logic;
			output: out std_logic_vector(2*N+7 downto 0));
end entity;
			
architecture behavior of kernel is

Signal exp_int : std_logic_vector(2*N+7 downto 0) ;

begin

PROCESS(clk)
Variable exp_MEM :  exp_array  := exp_func(exp);	

begin	
if rising_edge(clk) then
	if reset = '1' then
		exp_int <= (others => '0');
	else
		for i in 0 to 2838 loop
			if input > exp_MEM(i+1,0) and input <= exp_MEM(i,0) then
				exp_int <= exp_MEM(i,1);
			end if;
		end loop;
	end if;
end if;
end process;

output <= exp_int;

end architecture;