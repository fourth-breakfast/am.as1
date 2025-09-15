* Assignment #1 Do-file 

* log

log using "C:\Users\tmcge\Documents\Erasmus University\Applied Microeconometrics\Assignment 1\assignment 1.log"
replace

* Using the Dataset

clear

use "C:\Users\tmcge\Documents\Erasmus University\Applied Microeconometrics\Assignment 1\Assignment 1.dta"

* Describe & Summarize the dataset

des
sum income drinks height weight
tab black

* Question 1: First generate the variable BMI, where BMI equals weight in kg divided by height in meters squared. Construct a categorical variable for BMI that considers the commonly used categories:
	* i) underweight, BMI below 18.5
	* ii) normal weight, BMI larger or equal to 18.5 and lower than 25
	* iii) overweight, BMI larger or equal to 25 and lower than 30
	* iv) obese, BMI of 30 or higher
	
* First, we need height in meters

gen height_m = height/100

* Now we can generate BMI variable

gen BMI = weight/(height_m^2)

* With this variable, we create a categorical variable

sum BMI

gen bmi_categ = .

replace bmi_categ = 1 if BMI < 18.5
replace bmi_categ = 2 if BMI >= 18.5 & BMI < 25
replace bmi_categ = 3 if BMI >= 25 & BMI < 30
replace bmi_categ = 4 if BMI > 30

* a) Compute and report the prevalance of overweight and obesity by ethnic group (black vs non-black). What differences do you observe?

tab black bmi_categ

	* Creating 2 variables, one for the percentage of overweight, one for the percentage of obesity

gen overweight = (bmi_categ >= 3) if !missing(bmi_categ)
gen obese = (bmi_categ == 4) if !missing(bmi_categ)
gen obese_fix = (bmi_categ == 4) if !missing(bmi_categ)

tab black overweight, row missing
tab black obese_fix, row missing 

* b) Make an appropriate graph to compare income distributions across ethnic groups and discuss what you see.

graph box income, by(black)

* We create a box plot to show the differences between you too

* We also create a histogram plot as it might be what the question is asking us for

* c) If there are missing values for BMI, discuss how they may impact the validity of your regression analysis

	* If there are missing variables, this could result in an invalid regression analysis as the missing values might skew the regression that causes inference.
	
	
* Question 2
	* Estimate a multivariate regression model explaining income as a function of BMI and whether the individual is black.
	
reg income BMI black, robust

* a) Interpret the estimated coefficients of all the explanatory variables (sign, magnitude, and significance)

* BMI goes up by 1, annual income goes down by 250.7 euros
* If black, income is on average -5582.002 less per year
* Both variables are insignificant. This means...

* b) Whatis the estimated 95% confidence interval of beta1? What can you conclude based on the information in this confidence interval about the effect of BMI on income?

* Question 3
	* In the previous question, we have assumed that the association between income and BMI is linear.
	
* a) Do you think this assumption is likely to hold? explain.

* b) Add BMI^2 to the regression of question 2 and estimate it. What is the estimated effect of BMI on income? In your answer, interpret the effect at two different points of the BMI distribution

gen BMI_sq = BMI^2

reg income BMI BMI_sq black, robust

test BMI BMI_sq	

predict p_income

sum p_income

scatter p_income BMI_sq

test BMI = 20


***********************

* Question 4:

gen lnincome = ln(income)

tab bmi_categ, gen(d_bmi_categ)

reg lnincome d_bmi_categ1 d_bmi_categ3 d_bmi_categ4 black, robust

predict p_lnincome

sum p_lnincome

scatter p_lnincome d_bmi_categ1 d_bmi_categ3 d_bmi_categ4

**************************

gen lnincome_bmi_1 = lnincome * d_bmi_categ1
gen lnincome_bmi_3 = lnincome * d_bmi_categ3
gen lnincome_bmi_4 = lnincome * d_bmi_categ4

*****************************8

gen black_bmi_1 = black * d_bmi_categ1
gen black_bmi_3 = black * d_bmi_categ3
gen black_bmi_4 = black * d_bmi_categ4

reg lnincome black d_bmi_categ1 black_bmi_1 d_bmi_categ3 black_bmi_3 d_bmi_categ4 black_bmi_4, robust





* Question 7

reg BMI income black, robust

* Question 8

* a)
ivregress 2sls income (BMI=drinks) black, robust
estat firststage

reg income BMI drinks black, robust
test drinks

log close