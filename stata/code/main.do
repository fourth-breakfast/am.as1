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
global project "C:/Users/andres/Desktop/eur/blok 1/am/stata/assignment 1"

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




