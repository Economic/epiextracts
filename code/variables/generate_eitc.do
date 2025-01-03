*******************************************************************************
* Earned income tax credit
*******************************************************************************
gen byte eitc = .

if $marchcps == 1 {
	* check underlying Unicon data, what does added mean?
	if tm(1991m1) <= $date & $date <= tm(1997m12) {
		replace eitc = eitcrd
	}  
	if tm(1998m1) <= $date {
		replace eitc = eit_cred
	}  
}

lab var eitc "Earned income tax credit"
lab val eitc eitc
notes eitc: Available 1991-present
notes eitc: 1991-1997 Unicon: eitcrd
notes eitc: 1998-present CPS: eit_cred
