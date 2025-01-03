*******************************************************************************
* Weeks unemployed looking last year
*******************************************************************************
gen int lookdurly = .

if $marchcps == 1 {
	if tm(1968m1) <= $date & $date <= tm(1997m12) {
		replace lookdurly = wklknw - 1
		replace lookdurly = . if lookdurly < 0 | lookdurly == 7
	}
	if tm(1998m1) <= $date {
		replace lookdurly = welknw - 1
		replace lookdurly = . if welknw < 0 | welknw == 7

	}

}

lab var lookdurly "Job seeking duration last year (weeks)"
#delimit ;
lab def lookdurly
0 "Not looking"
1 "1–4 weeks"
2 "5–14 weeks"
3 "15–26 weeks"
4 "27–39 weeks"
5 "40 or more weeks"
;
#delimit cr;
label value lookdurly lookdurly
notes lookdurly: 1968-1997 Unicon March: wklknw
notes lookdurly: 1998-present CPS March: welknw

