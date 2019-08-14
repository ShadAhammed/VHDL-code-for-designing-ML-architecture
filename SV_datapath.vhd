-- Top Structure
-- Other basic blocks are used as components

library IEEE;
library std;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.SVM_pkg.all;


entity SV_datapath is
    Port ( clk : in std_logic;
			  reset: in std_logic;
			  counter: out std_logic_vector(3 downto 0);
			  TestFile: in std_logic_vector (1 downto 0) ;
			  Detect: out std_logic;
			  Class: out std_logic;
			  Record_Class: out std_logic;
			  rd: in std_logic
			  );
end SV_datapath;

architecture Behavioral of SV_datapath is
signal SVdata_int: std_logic_vector(N-1 downto 0) ;
signal Alphadata_int: std_logic_vector(N-1 downto 0) ;
signal norm_int: std_logic_vector (2*N+7 downto 0) ;
signal kernel_int: std_logic_vector(2*N+7 downto 0) ;
signal Alpha_mul_int : std_logic_vector(3*N+7 downto 0) ;
signal Data_int : std_logic_vector(3*N+7 downto 0) ;
signal TestdataIn: std_logic_vector (N-1 downto 0) ;
signal SV_c: std_logic_vector(15 downto 0) ;


component SVROM
port( 	clk: in std_logic;
			reset: in std_logic;
			rd_SV: in std_logic;
			SV_c: out std_logic_vector(15 downto 0);
			data: out std_logic_vector(N-1 downto 0));
end component;

component AlphaROM
port( 	clk: in std_logic;
			reset: in std_logic;
			rd_alpha: in std_logic;
			data: out std_logic_vector(N-1 downto 0));
end component;


component Norm2
port (	a : in  std_logic_vector(N-1 downto 0) ;
			b : in  std_logic_vector(N-1 downto 0) ;
			s : out std_logic_vector(2*N+7 downto 0) ;
			clk: in std_logic;
			reset: in std_logic) ;
end component;

component kernel
port( 	input: in std_logic_vector (2*N+7 downto 0);
			reset: in std_logic;
			clk: in std_logic;
			output: out std_logic_vector(2*N+7 downto 0));
end component;
			
component Detection
	port(	clk: in std_logic;
			reset: in std_logic;
			counter : out std_logic_vector(3 downto 0);
			exp_norm: in std_logic_vector(2*N+7 downto 0);
			Alphadata: in std_logic_vector(N-1 downto 0);
			mul_Data: out std_logic_vector(3*N+7 downto 0);
			Data: out std_logic_vector(3*N+7 downto 0);
			Detect: out std_logic;
			Class: out std_logic;
			Record_Class: out std_logic );
end component;

component TestRAM
port (	f : in std_logic_vector (1 downto 0);
			reset: in std_logic;
			rd: in std_logic;
			TestData: out std_logic_vector(N-1 downto 0);
			clk: in std_logic );
end component ;

Begin
			
SV: SVROM
port map(clk => clk, reset => reset, data => SVdata_int, rd_SV => rd,SV_c => SV_c);


Alpha: AlphaROM
port map(clk => clk, reset => reset, data => Alphadata_int, rd_alpha => rd);

TV: TestRAM
port map(clk =>clk, reset => reset, rd => rd, f => TestFile,TestData => TestdataIn);

Norm: Norm2
port map( a => SVdata_int, b => TestdataIn, s => norm_int, clk => clk,
			reset=> reset);


Exp: kernel
port map ( input => norm_int, output => kernel_int, clk => clk, reset => reset);


Data: Detection
port map(clk => clk, reset => reset, exp_norm => kernel_int, Alphadata => Alphadata_int, mul_Data => Alpha_mul_int, 
			Data => Data_int, Detect => Detect,Class => Class, Record_Class => Record_Class, counter => counter);



end architecture;