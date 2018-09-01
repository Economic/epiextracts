********************************************************************************
* Weekly earnings (top-code adjusted)
********************************************************************************

* for now, identical weekpay and weekpay_noadj
gen weekpay = weekpay_noadj
lab var weekpay "Weekly pay (top-code adjusted)"
notes weekpay: Dollars per week for nonhourly and hourly workers
notes weekpay: Includes overtime, tips, commissions
notes weekpay: Original top-code values replaced with Pareto-distribution implied mean above top-code
notes weekpay: Original top-code: 1973-85: 999; 1986-97: 1923; 1998-: 2884.61
notes weekpay: Derived from weekpay_noadj and tc_weekpay
