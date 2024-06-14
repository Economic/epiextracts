*******************************************************************************
* Earned income tax credit
*******************************************************************************
gen byte eitc = .

if $marchcps == 1 {
	* check underlying Unicon data, what does added mean?
	if tm(1991m1) <= $date & $date <= tm(2018m12) {
		replace eitc = eit_cred
	}  
	if tm(2019m1) <= $date {
		replace eitc = spm_eitc
	}  
}

lab var eitc "Employer-provided pension plan"
lab def eitc 1 "Employer provides pension" 0 "Employer does not provide pension"
lab val eitc eitc
notes eitc: Available 1980-present
notes eitc: 1980-present universe: Those who worked last year
*notes eitc: 1980-1988 Unicon: eitcrd
notes eitc: 1991-1997 Unicon: eit_cred
notes eitc: 1998-2018 CPS: eit_cred
notes eitc: 2019-present CPS: spm_eitc
