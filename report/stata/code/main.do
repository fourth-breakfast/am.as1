/*
	project: assignment 1
	course: applied microeconometrics
	author: group 23
	date: 16-09-25

	input: income_bmi.dta
	output: clean dataset, tables, graphs, regression results, log file

	description: empirical analysis of BMI-income relationship using OLS and IV estimation
*/

// setup
clear all
set more off
version 18

// globals
global project "C:/Users/andres/repositories/am.as1/report/stata"

global code "$project/code"
global rawdata "$project/data/raw"
global cleandata "$project/data/clean"

global logs "$project/output/logs"
global tables "$project/output/tables"
global figures "$project/output/figures"

// start log
capture log close
log using "$logs/main.log", replace

// load data
use "$rawdata/income_bmi.dta", clear

// clean data
save "$cleandata/income_bmi_clean.dta", replace

// question one
gen height_m = height / 100
gen bmi = weight / (height_m^2)

gen bmi_cat = .
replace bmi_cat = 1 if bmi < 18.5 & !missing(bmi)
replace bmi_cat = 2 if bmi >= 18.5 & bmi < 25 & !missing(bmi)
replace bmi_cat = 3 if bmi >= 25 & bmi < 30 & !missing(bmi)
replace bmi_cat = 4 if bmi >= 30 & !missing(bmi)

// a
gen overweight = (bmi_cat >= 3) if !missing(bmi_cat)
gen obese = (bmi_cat == 4) if !missing(bmi_cat)

tab black overweight, row missing
tab black obese, row missing

// b
graph box income, over(black) ///
    title("Income Distribution by Ethnic Group") ///
    ytitle("Household Income (Euros)")
	
graph export "$figures/income_boxplot.png", replace

// c
gen bmi_miss = missing(bmi)
tab black bmi_miss, row missing

// d
sum income height weight bmi
list income height weight if income < 0 | income > 500000
list height weight if height < 100 | height > 250
list bmi if bmi < 10 | bmi > 60

gen flag_income = (income < 0 | income > 500000)
gen flag_height = (height < 100 | height > 250)
gen flag_bmi = (bmi < 10 | bmi > 60)
drop if flag_income == 1 | flag_height == 1 | flag_bmi == 1

// question two
reg income bmi black, robust

// c
quietly sum income
scalar mean_income = r(mean)
scalar black_coeff = _b[black]

display "Mean income: $" mean_income
display "Black coefficient: $" black_coeff
display "Ratio: " (black_coeff/mean_income)*100 "%"

// question three

// b
gen bmi2 = bmi^2
reg income bmi bmi2 black, robust

// question four
gen ln_income = ln(income)

// b
reg ln_income i.bmi_cat black, robust

// d
reg income i.bmi_cat##i.black

// question seven
reg bmi income black, robust

// question eight
ivregress 2sls income (bmi = drinks) black, robust first

// c
estat endogenous
