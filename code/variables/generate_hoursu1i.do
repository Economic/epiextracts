*******************************************************************************
* Usual hours worked per week, primary job
*******************************************************************************
capture confirm variable hoursu1i, exact
if _rc == 0 {
	drop hoursu1i
}
gen hoursu1i = .

if tm(1994m1) <= $date {

	forvalues i = 2/5 {
		gen age`i' = age^`i'
	}

	local indepvars age age2 age3 age4 age5 i.grade92 i.wbho i.citistat i.married i.statefips i.union i.pubsec i.mind16

	gen orgsample = orgwgt > 0 & orgwgt ~= . & age >= 16 & age ~= . & (minsamp == 4 | minsamp == 8)

	* Regression: female, full-time
	reg hoursu1 `indepvars' if hoursu1 > 0 & orgsample == 1 & female == 1 & (3 <= hoursuint & hoursuint <= 6) [aw=orgwgt]
	predict hourpred_ft_f if orgsample == 1 & female == 1 & hoursuint == 7, xb

	* Regression: female, part-time
	reg hoursu1 `indepvars' if hoursu1 > 0 & orgsample == 1 & female == 1 & (1 <= hoursuint & hoursuint <= 2) [aw=orgwgt]
	predict hourpred_pt_f if orgsample == 1 & female == 1 & hoursuint == 8, xb

	* Regression: male, full-time
	reg hoursu1 `indepvars' if hoursu1 > 0 & orgsample == 1 & female == 0 & (3 <= hoursuint & hoursuint <= 6) [aw=orgwgt]
	predict hourpred_ft_m if orgsample == 1 & female == 0 & hoursuint == 7, xb

	* Regression: male, part-time
	reg hoursu1 `indepvars' if hoursu1 > 0 & orgsample == 1 & female == 0 & (1 <= hoursuint & hoursuint <= 2) [aw=orgwgt]
	predict hourpred_pt_m if orgsample == 1 & female == 0 & hoursuint == 8, xb

	* assign predicted values
	replace hoursu1i = hoursu1 if hoursu1 ~= .
	replace hoursu1i = hourpred_ft_f if female == 1 & hoursuint == 7
	replace hoursu1i = hourpred_pt_f if female == 1 & hoursuint == 8
	replace hoursu1i = hourpred_ft_m if female == 0 & hoursuint == 7
	replace hoursu1i = hourpred_pt_m if female == 0 & hoursuint == 8

	* round imputed values for consistency with original hoursu1
	replace hoursu1i = round(hoursu1i,1)

	* top-code at 99, like hoursu1
	replace hoursu1i = 99 if hoursu1i > 99 & hoursu1i ~= .

	replace hoursu1i = . if hoursu1i < 0

	* clean up
	drop hourpred_ft_f hourpred_pt_f hourpred_ft_m hourpred_pt_m
	drop age2-age5
	drop orgsample
}

lab var hoursu1i "Imputed usual weekly hours, main job (ORG only)"
capture label drop hoursu1i
lab def hoursu1i 99 "99+"
lab val hoursu1i hoursu1i
notes hoursu1i: Only available 1994-present ORG
notes hoursu1i: Same as hoursu1, except for those whose usual hours vary at main job
