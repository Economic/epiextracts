*******************************************************************************
* Weeks unemployed looking, binned
*******************************************************************************
gen int lookdurbin = .

if $marchcps == 1 {
	if tm(1976m1) <= $date & $date <= tm(1987m12) {
		replace lookdurbin = r_welknw - 1 if r_welknw > 0
		replace lookdurbin = . if r_welknw == 0
	}
	if tm(1998m1) <= $date {
		replace lookdurbin = welknw - 1 if welknw > 0
		replace lookdurbin = . if welknw == 0 | welknw == 7

	}

}

lab var lookdurbin "Job seeking duration (weeks)"
#delimit ;
lab def lookdurbin
0 "Not looking"
1 "1–4 weeks"
2 "5–14 weeks"
3 "15–26 weeks"
4 "27–39 weeks"
5 "40 or more weeks"
;
#delimit cr;
label value lookdurbin lookdurbin
notes lookdurbin: 1976-present CPS: welknw
