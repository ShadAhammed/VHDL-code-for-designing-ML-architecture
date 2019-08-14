-- Calculate norm between support vector and test vector and generate with each clock
-- Multiply the norm value with gamma

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use work.SVM_pkg.all;


entity Norm2 is
port(
	a : in  std_logic_vector(N-1 downto 0) ;					--Feature from Support Vector
	b : in  std_logic_vector(N-1 downto 0) ;					--Feature from Test Vector
   s : out std_logic_vector(2*N+7 downto 0) ;				-- Norm x gamma
	clk: in std_logic;
	reset: in std_logic) ;
end Norm2;


architecture structural of Norm2 is
	signal s_new: signed(2*N-1 downto 0) ;
	--signal s_int: signed(2*N-1 downto 0) ;
	signal cnt : integer ;
	signal do_norm : std_logic ;


begin

counter: process(clk)
begin
	if (rising_edge(clk)) then
		if reset = '1' then
			do_norm <= '0';
			cnt <= 0 ;
		else 
			do_norm <= '1' ;
		end if;
		if cnt > No_of_Features - 2 or do_norm = '0' then
				cnt <= 0;
		else
			cnt <= cnt + 1 ;
		end if;
	end if;
end process;
--count <= cnt;

process(clk)
	variable x: signed(N-1 downto 0);
	variable x2: signed(2*N-1 downto 0);
begin
if rising_edge(clk) then
	if reset  = '1' then
		s_new <= (others => '0');
	elsif do_norm = '1' then
		 x := signed(a) - signed(b);
		 x2 := x*x ;
		 if cnt /= 0 then
			  s_new <= x2 + s_new ;
		 else 
			  s_new <= x2 ;
		 end if;
	end if;
end if;
end process;

s <= std_logic_vector(gamma*s_new);

end structural;


