--This block is containing the basic information of the support vector model.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

package SVM_pkg is

Constant N: integer := 14 ; 
Constant scale: std_logic_vector := std_logic_vector(to_signed(22,7));											-- Number of bits used for Training Dataset
Constant No_of_Support_Vectors: Integer := 233 ;
Constant No_of_alpha_function: Integer := 233 ;
Constant No_of_Features: Integer := 184 ;
constant Bias: signed := to_signed(integer(-2.30191565*2**26),29);
constant gamma: signed := to_signed(integer(-0.001*2**10),8);
Constant No_of_Test_Vectors: Integer := 10 ;

end SVM_pkg;