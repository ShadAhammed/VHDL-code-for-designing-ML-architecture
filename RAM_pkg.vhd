library IEEE;
library std;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use work.SVM_pkg.all;

package RAM_pkg is

--Declaring the size of Test RAM and Prediction array
type test_array is array (0 to No_of_Test_Vectors*No_of_Features-1) of std_logic_vector(N-1 downto 0);
type prediction_array is array (0 to No_of_Test_Vectors-1) of std_logic ;

--Multiple test files contaning various records for testing
file test1: text open read_mode is "C:\Users\lenovo\Desktop\altera\SVM\TestData.csv" ;
file test2: text open read_mode is "C:\Users\lenovo\Desktop\altera\SVM\TestData2.csv" ;
file test3: text open read_mode is "C:\Users\lenovo\Desktop\altera\SVM\TestData3.csv" ;
file test4: text open read_mode is "C:\Users\lenovo\Desktop\altera\SVM\TestData4.csv" ;
file output1: text open write_mode is "C:\Users\lenovo\Desktop\altera\SVM\output.csv" ;
file prediction: text open read_mode is "C:\Users\lenovo\Desktop\altera\SVM\Prediction.csv" ;
file P: text ;
file t: text ;

--Function to Read Test RAM and Prediction Array
impure function TV_function(file t: text) return test_array;
impure function Predict_function(file P: text) return prediction_array;

end RAM_pkg;

Package body RAM_pkg is

impure function TV_function(file t: text) return test_array is
variable line_var : line ;
variable num : std_logic_vector(N-1 downto 0) ;
variable comma: character ;
variable test2: test_array ;

begin
if not endfile(t) then
for i in 0 to No_of_Test_Vectors-1 loop
    readline(t, line_var);  
for j in 0 to No_of_Features-1 loop
    read(line_var, num);        
	 test2((No_of_Features)*i+j) := std_logic_vector(signed(num));
    read(line_var,comma);
end loop;
end loop;
end if;
file_close(t) ;
return test2 ;
end function ;

impure function Predict_function(file P: text) return prediction_array is
variable line_var : line;
variable num : std_logic;
variable comma: character;
variable prediction2: prediction_array ;

begin
if not endfile(P) then 
	readline(P, line_var);  
	for i in 0 to No_of_Test_Vectors-1 loop
		read(line_var, num);        
		prediction2(i) := std_logic(num);
		read(line_var,comma);
	end loop;
end if;
file_close(P);
return Prediction2;
end function;


end Package body ;