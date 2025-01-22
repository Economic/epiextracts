********************************************************************************
* Weekly earnings top-coded
********************************************************************************
gen byte tc_weekpay = .

if $monthlycps == 1 | $maycps == 1 {
	if $earnerinfo == 1 {
		replace tc_weekpay = 0 if weekpay >= 0 & weekpay ~= .
		if tm(1973m1) <= $date & $date <= tm(1988m12) {
			replace tc_weekpay = 1 if weekpay >= 999 & weekpay ~= .
		}
		if tm(1989m1) <= $date & $date <= tm(1997m12) {
			replace tc_weekpay = 1 if weekpay >= 1923 & weekpay ~= .
		}
		if tm(1998m1) <= $date & $date <= tm(2023m3) {
			* going to use 2884.60 instead of actual topcode of 2884.61 to avoid precision issues
			replace tc_weekpay = 1 if weekpay >= 2884.60 & weekpay ~= .
		}
		if tm(2023m4) <= $date {
			replace tc_weekpay = ptwk if weekpay ~= .
		}
	}
}

lab var tc_weekpay "Weekly pay top-coded by BLS"
lab def tc_weekpay 0 "Not top-coded" 1 "Top-coded"
lab val tc_weekpay tc_weekpay
notes tc_weekpay: Top-code for weekpay: 1973-88: 999; 1989-97: 1923; 1998-: 2884.61
