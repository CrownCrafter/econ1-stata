** 1. Importing data and setting directory. **

cd "/Users/d1y0r/Desktop/Econometrics 1/Assignment 1"
import excel "/Users/d1y0r/Desktop/Econometrics 1/Assignment 1/CPS_data.xlsx"
sheet("Sheet1") firstrow
use "CPS_data.xlsx"
clear

** 2. Creating a subset for Massachusetts:  **

keep if STATE == "Massachusetts"


** 3.  Save the Massachusetts data as a new Stata file:  **

save "MA_subset.dta", replace
use "MA_subset.dta", replace

** 4. Creating a variable "EXP", which is total work experience  using the formula experience = age - years of education - 6.  **
*gen Exp= Age - Education - 6

gen exp= A_AGE - A_HGA - 6
gen exp2 = exp^2
gen lnexp=log(exp)
gen lnwage = log(WSAL_VAL)

** 5. Dropping some variables and renaming them for visibility  **

drop STATE
drop PEINUSYR 
drop HEA
drop HUNDER18
drop A_CIVLF
drop PEAFEVER
drop PENATVTY
drop PRDTRACE
drop A_UNCOV
drop PRCITSHP
drop A_MARITL
drop A_UNMEM
drop GESTFIPS 
 
rename A_SEX sex
rename A_HGA educ
rename WSAL_VAL wage
rename HRSWK hours_work
rename WKSWORK weeks_empl
rename A_AGE age
rename PEIO1COW job_class


** 5. Dropping some observations **

drop if age > 65 | age < 18
drop if missing(lnwage)
drop if missing(lnexp)
** 5. Creating histograms of some variables **

hist wage
hist wage if wage > 0
hist age if age > 18
hist sex
hist hours_work


label var lnwage "Log of earnings"
label var exp "Years of work experience"
label var exp2 "Years of work experience squared"
label var educ "Years of schooling"

label define fem 2 male 1 female
label value sex fem
