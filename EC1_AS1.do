
keep if STATE == "Massachusetts"

// Data processing
** Descriptive of dataset
label var WSAL_VAL "Total wage and Salary"
label var HRSWK "Hours worked per week "
label var HUNDER18 "# person under 18 in the household"
label var A_AGE "Age"
label var A_CIVLF "Currrent, civilian labour force"
label var PEIO1COW "Current job, class of worker"
label var PRCITSHP "Citizenship"
label var A_SEX  "Gender"
label var A_UNMEM "Current Job union or not"
label var educ "Education "
label var PEINUSYR "Years entry to US"
label var WKSWORK "Weeks worked in previous 12 months"
label var PEAFEVER "Veteran"
label var PRDTRACE "Demographic"
label var A_UNCOV "Current job, union cover"
label var A_MARITL "Marital status"
label var HEA "Health Status"
label var A_HGA "Educational attainment"

** generate variables based on genders
gen female = (A_SEX==2)
gen male=(A_SEX==1)

** generate education level in categories, keep the original just incase
gen EDUC == A_HGA
label var EDUC "# Years of education"
drop if EDUC== 0 // because children 
replace EDUC= 1 if EDUC == 31 
replace EDUC=2.5 if EDUC==32 
replace EDUC=5.5 if EDUC==33
replace EDUC=7.5 if EDUC==34 
replace EDUC=9 if EDUC==35
replace EDUC=10 if EDUC==36
replace EDUC=11 if EDUC==37 
replace EDUC=12 if EDUC==38 | EDUC==39
replace EDUC=13 if EDUC==40 
replace EDUC=14 if EDUC==41 | EDUC==42
replace EDUC=16 if EDUC==43
replace EDUC=18 if EDUC==44
replace EDUC=19 if EDUC==45
replace EDUC=20 if EDUC==46

** I would combine less than = high school together, 

1   //Less Than 1st Grade
2.5 //1st,2nd,3rd,or 4th grade
5.5 // 5th Or 6th Grade
7.5 // 7th and 8th grade
9  // 9th Grade
10 //10th Grade
11 //11th Grade
12 // 12th Grade No Diploma & High school graduate-high school diploma
13 //Some College But No Degree
14 // Assc degree-occupation/vocation&Assc degree-academic program
16 //Bachelor's degree 
18 //Master's degree 
19 //Professional school degree 
20 //Doctorate degree

** generate experience
gen EXP=A_AGE-EDUC-6
label var EXP "# years of work experience"
drop if EXP<0 //(47 observations deleted)

gen EXP2=EXP^2
label var EXP2 "# years experience squared"

** generate log total wage
gen lnwage=log(WSAL_VAL) //(993 missing values generated)
label var lnwage "Log of total earnings"


** plot graph to understand relationships
twoway (scatter EXP EDUC)(lfit EXP EDUC),title(Scatter plot with Linear Fit Line) //See that sample with lower education tend to work longer. A decreasing fitted line 

graph drop _all
twoway (scatter EXP EDUC if A_SEX==2)(lfit EXP EDUC),title(Scatter Plot with Linear Fit Line:WOMEN) name(scatter1)
twoway (scatter EXP EDUC if A_SEX==1)(lfit EXP EDUC),title(Scatter Plot with Linear Fit Line: MEN) name(scatter2)
graph combine scatter1 scatter2, cols(2)

twoway (scatter EXP EDUC if A_SEX==2)(lfit EXP EDUC),title(Scatter Plot with Linear Fit Line:WOMEN with EXP) name(scatter1)
twoway (scatter EXP2 EDUC if A_SEX==2)(lfit EXP2 EDUC),title(Scatter Plot with Linear Fit Line: WOMEN with EXP2) name(scatter2)
graph combine scatter1 scatter2, cols(2)

// Clear all graphs
graph drop _all

**

twoway (scatter EXP EDUC if A_SEX==1 & EDU>16)(lfit EXP EDUC if A_SEX==1 & EDU>16 ),title(Scatter Plot with Linear Fit Line: MEN)




*from bowen 
* Descriptive statistics of the final sample
estpost summarize lgwage educ exp
esttab using summary_table.tex, booktabs cells("mean sd count") replace

mkdir tables
esttab . using tables/sumstat.rtf, cells("mean sd min max") label rtf replace 
esttab . using tables/sumstat.tex, cells("mean sd min max") label tex replace 
tab educ if !female
** make a scatter plot showing the relation between wages and schooling 

twoway scatter lgwage educ, by(female) mcolor(%10)

*** Regression ***
regress lgwage educ exp exp2 if !female ,robust
eststo reg_male

reg lgwage educ exp exp2 if female
eststo reg_female

reg lgwage educ exp exp2 c.female#c.educ c.female#c.exp c.female#c.exp2, robust
eststo reg_interact
