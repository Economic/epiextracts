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

lab var eitc "Earned income tax credit"
lab val eitc eitc
notes eitc: Available 1991-present
notes eitc: 1991-1997 Unicon: eit_cred
notes eitc: 1998-2018 CPS: eit_cred
notes eitc: 2019-present CPS: spm_eitc
