***Assignment 1***
cd "D:\UvA\Econometrics 1\2024\Assignment 1" //Change the directory
import excel "CPS_data.xlsx",firstrow
keep if STATE == "Massachusetts"

// Data processing
** Health status
gen healthygroup=HEA if HEA<5

** We generate the employed population by assuming a positive wage
gen employed=(WSAL_VAL>0)

** generate variables based on genders
gen female = (A_SEX==2)
gen male=(A_SEX==1)

** generate variable for children
gen children=(A_HGA==0)

// tabulate female employed

** modify dataset for analysis **
//drop if !healthygroup
drop if !healthygroup
//drop if !employed
drop if !employed
//drop if children
drop if children

** Transform the nomial education categories into numerical form
replace A_HGA = 1 if A_HGA == 31 //Less Than 1st Grade
replace A_HGA=2.5 if A_HGA==32 //1st,2nd,3rd,or 4th grade
replace A_HGA=5.5 if A_HGA==33 // 5th Or 6th Grade
replace A_HGA=7.5 if A_HGA==34 // 7th and 8th grade
replace A_HGA=9 if A_HGA==35 // 9th Grade
replace A_HGA=10 if A_HGA==36 //10th Grade
replace A_HGA=11 if A_HGA==37 //11th Grade
replace A_HGA=12 if A_HGA==38 |A_HGA==39 // 12th Grade No Diploma& High school graduate-high school diploma
replace A_HGA=13 if A_HGA==40 //Some College But No Degree
replace A_HGA=14 if A_HGA==41|A_HGA==42 // Assc degree-occupation/vocation&Assc degree-academic program
replace A_HGA=16 if A_HGA==43 //Bachelor's degree (BA,AB,BS)
replace A_HGA=18 if A_HGA==44 //Master's degree (MA,MS,MENG,MED,MSW,MBA)
replace A_HGA=19 if A_HGA==45 //Professional school degree (MD,DDS,DVM,L
replace A_HGA=20 if A_HGA==46 //Doctorate degree (PHD,EDD)

** generate log total wage
gen lgwage=log(WSAL_VAL)
** generate experience
gen exp=A_AGE-A_HGA-6
** generate variable for exp<=0
gen expn=(exp<=0)
drop if expn
gen exp2=exp^2
** varible labels
label var lgwage "Log of total earnings"
label var exp "Years of work experience"
label var exp2 "Years of work experience squared"
rename A_HGA educ
label var educ "Years of schooling"

* Descriptive statistics of the final sample
estpost summarize lgwage educ exp
esttab using summary_table.tex, booktabs cells("mean sd count") replace

mkdir tables
esttab . using tables/sumstat.rtf, cells("mean sd min max") label rtf replace 
esttab . using tables/sumstat.tex, cells("mean sd min max") label tex replace 
tab educ if !female
** make a scatter plot showing the relation between wages and schooling 

twoway scatter lgwage educ, by(female) mcolor(%70)
histogram lgwage, by(PEIO1COW) //  Government ppl paid more
hist PENATVTY, by(female) // Huge Class Imbalance of White ppl
hist educ // Not many schoolers
*** Regression ***
regress lgwage educ exp exp2 if !female ,robust
eststo reg_male

reg lgwage educ exp exp2 if female
eststo reg_female

reg lgwage educ exp exp2 c.female#c.educ c.female#c.exp c.female#c.exp2, robust
eststo reg_interact

reg lgwage c.educ##c.exp exp2 white##female
eststo white_female


