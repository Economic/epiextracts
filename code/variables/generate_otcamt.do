********************************************************************************
* Weekly earnings from overtime, tips, commissions 1994-
********************************************************************************
gen byte otcamt = .
if $earnerinfo == 1 {
	if tm(1994m1) <= $date & $date <= tm(2018m5) {
		replace otcamt = peern/100 if paidhre == 1 & otcrec == 1
	}
}
replace otcamt = . if otcamt < 0
lab var otcamt "Weekly earnings overtime, tips, commissions"
notes otcamt: Hourly workers only
notes otcamt: 1994-present, CPS: derived from peern, otcrec
