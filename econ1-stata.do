
import excel "/home/ayushm/Programs/econ1-stata/CPS_data.xlsx", sheet("Sheet1") firstrow
gen interested = 1 if STATE =="Massachusetts"
keep if interested == 1
gen interested = 0 if A_HGA
