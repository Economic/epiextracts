********************************************************************************
* Weekly earnings (top-code adjusted)
********************************************************************************

capture confirm variable weekpay, exact
if _rc == 0 {
	drop weekpay
}
gen weekpay = .

if $monthlycps == 1 | $maycps == 1 {
	if $earnerinfo == 1 {
		* determine top-code thresholds
		if tm(1973m1) <= $date & $date <= tm(1988m12) {
			local topcodeval 999
		}
		if tm(1989m1) <= $date & $date <= tm(1997m12) {
			local topcodeval 1923
		}
		if tm(1998m1) <= $date & $date <= tm(2024m3) {
			* going to use 2884.60 instead of actual topcode of 2884.61 to avoid precision issues
			local topcodeval 2884.60
		}

		* determine sample weights to use
		if $monthlycps == 1 & $maycps == 0 local weightvar orgwgt
		if $monthlycps == 0 & $maycps == 1 local weightvar basicwgt


		* Do top-code adjustment
		* there seems to be something wrong with ernwk and ernwkc in 1980 may data
		* coding weekpay in these data as missing for now
		if $maycps == 1 & tm(1980m1) <= $date & $date <= tm(1980m12) {
			replace weekpay = .
		}
		if tm(2024m4) <= $date {
			weekpay = weekpay_noadj
		}
		else {
			* males: generate top-code adjusted weekly earnings
			topcode_impute weekpay_noadj if weekpay_noadj ~= . & female == 0 & age >= 16 & age ~= . [pw=`weightvar'], generate(weekpay_male) method(Pareto) threshold(80) topcodeval(`topcodeval')

			* females: generate top-code adjusted weekly earnings
			topcode_impute weekpay_noadj if weekpay_noadj ~= . & female == 1 & age >= 16 & age ~= . [pw=`weightvar'], generate(weekpay_female) method(pareto) threshold(80) topcodeval(`topcodeval')

			replace weekpay = weekpay_male if female == 0
			replace weekpay = weekpay_female if female == 1

			drop weekpay_male weekpay_female
		}
		*account for topcoding change in 2023/2024 where outgoing rotation groups are making their way through the changed procedure
		replace weekpay = weekpay_noadj if (year == 2023 & month >= 4 | year == 2024) & minsamp == 4 
	}
}

lab var weekpay "Weekly pay (top-code adjusted)"
notes weekpay: Dollars per week for nonhourly and hourly workers
notes weekpay: Includes overtime, tips, commissions
notes weekpay: Original top-code values replaced with Pareto-distribution implied mean above top-code
notes weekpay: Separate imputations for men and women
notes weekpay: Original top-code: 1973-88: 999; 1986-97: 1923; 1998-2023: 2884.61
notes weekpay: Beginning in 2023, top-code value is the weighted average of the top 3% of earners in a given month
notes weekpay: Derived from weekpay_noadj and tc_weekpay
