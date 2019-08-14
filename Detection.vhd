--This block is taking output from kernel block as input and multiplying it with alpha coefficient
--The multiplied data is then go through prediction process
--Output signal 'Class' shows the class of the test vector - 1 means seizure, 0 means non seizure
--Record class will be 1, when signal detection_counter > 2, it means a seizure occurrence is experienced


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.SVM_pkg.all;


entity Detection is
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
end entity;

architecture rtl of Detection is
signal mul: signed(3*N+7 downto 0) ;
signal c1 : std_logic ;
signal c2: integer ;
Signal det: std_logic ;
signal det2: std_logic ;
signal det3: std_logic ;
signal detection_counter : integer ;
signal do_alpha_mul : std_logic ;
signal data_int: signed(3*N+7 downto 0) ;
constant c_start : integer := No_of_Features ;
begin
	process(clk)
	begin
	if rising_edge(clk) then
		if reset = '1' then
		mul <= (others => '0');
		elsif do_alpha_mul = '1' then
			mul <= signed(exp_norm)*signed(Alphadata);
		else mul <= (others => '0');
		end if;
	end if;
	end process;
	
	mul_Data <= std_logic_vector(mul);			
	
	Process(clk,reset)		
	begin	
		if rising_edge(clk) then
			if reset = '1' then
				c1 <= '0';
				c2 <= 0 ;
				do_alpha_mul <= '0';
			else do_alpha_mul <= '1';
			end if;
			if do_alpha_mul = '1' then
				c2 <= c2 + 1;
			end if;
			if c2 > c_start + No_of_Features*(No_of_Support_Vectors - 1) + 2 then
				c2 <= 4;
			end if;
			if c2 mod No_of_Features = 1 and c2 > 1 then
				c1 <= '1';
			else c1 <= '0';
			end if;
		end if;
	end process;

	process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				data_int <=(others => '0');
			end if;
			if reset = '0' then
				if c1 = '1' and do_alpha_mul = '1' and c2 > c_start+2  then
					data_int <= data_int + mul;
				end if;
				if c2 = c_start+2 then
					data_int <= mul;
				end if;
			end if;
		end if; 
	end process;
	
	Data <= std_logic_vector(data_int);
	
	
	--Detection Process
	
	Process(clk)
	begin
	if rising_edge(clk) then
		if reset = '1' then
			det <= '0';
		elsif c2 > c_start + No_of_Features*(No_of_Support_Vectors - 1) + 2 then 
				det <= '1' ;
		else det <= '0';
		end if;
	end if;
	end process;
	
	Process(clk)
	
	begin
		if rising_edge(clk) then
			if reset = '1' then
				detection_counter <= 0;
				det2 <= '0';
				det3 <= '0';
			end if;
			if reset = '0' then
				if c2 > c_start + No_of_Features*(No_of_Support_Vectors - 1) + 2 and to_integer(data_int+Bias) > 0 then
					det2 <= '1';
				else det2 <= '0';
				end if;
				if det = '1' then			
					if det2 = '1' then
						detection_counter <= detection_counter + 1 ;
					elsif detection_counter < 3 then
						detection_counter <= 0 ;
					end if;
				end if;
				if detection_counter > 4 then
					det3 <= '1';
				else det3 <= '0';
				end if;
			end if;
		end if;
	end process;

Counter <= std_logic_vector(to_unsigned(detection_counter,4));
Detect <= det;
Class <= det2;
Record_Class <= det3; 
	
end architecture;

