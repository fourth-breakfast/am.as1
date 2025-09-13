/*
project:
course:
author:
date:

input:
output:

description:
*/


// setup
clear all
set more off
version 18


// globals
global project "C:/Users/andres/repositories/am.as1/stata"

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
use "$rawdata/raw.dta", clear


// clean data
save "$cleandata/clean.dta", replace

describe
summarize


// question one
gen height_m = height / 100
gen bmi = weight / (height_m^2)

gen bmi_cat = .
replace bmi_cat = 1 if bmi < 18.5 & !missing(bmi)
replace bmi_cat = 2 if bmi >= 18.5 & bmi < 25 & !missing(bmi)
replace bmi_cat = 3 if bmi >= 25 & bmi < 30 & !missing(bmi)
replace bmi_cat = 4 if bmi >= 30 & !missing(bmi)

gen overweight = (bmi_cat >= 3) if !missing(bmi_cat)
gen obese = (bmi_cat == 4) if !missing(bmi_cat)

tab black overweight, row missing
tab black obese, row missing

graph box income, over(black)
hist income, by(black)

summarize bmi
tabulate black, summarize(bmi)


// question two
reg income bmi black, r