*******************************************************************************
* Weeks unemployed looking last year
*******************************************************************************
gen int lookdurly = .

if $marchcps == 1 {
	if tm(1968m1) <= $date & $date <= tm(1997m12) {
		replace lookdurly = wklknw - 1 if 0 < wklknw & wklknw < 7
		replace lookdurly = . if lookdurly < 0 | lookdurly == 7

		* universe is persons 14+ through 1979 and 15+ from 1980; 1994 Unicon
		* codes some children as civilian adults (_popstat == 1) with weeks
		* looking values
		if $date <= tm(1979m12) {
			replace lookdurly = . if age < 14
		}
		else {
			replace lookdurly = . if age < 15
		}
	}
	if tm(1998m1) <= $date {
		replace lookdurly = welknw - 1 if 0 < welknw & welknw < 7
		replace lookdurly = . if welknw < 0 | welknw == 7

		* defer to detailed weeks looking (nwlkwk) where the Census recode
		* disagrees: one record each in 2011, 2013, and 2014 has welknw == 2
		* (1-4 weeks) but nwlkwk == 0, consistent with IPUMS NWLOOKWK
		capture confirm variable nwlkwk
		if _rc == 0 {
			replace lookdurly = 0 if nwlkwk == 0 & lookdurly > 0 & !missing(lookdurly)
		}
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
notes lookdurly: 1968-1997 Unicon March: missing for persons under 14 (1968-1979) or 15 (1980-1997); 1994 children miscoded as civilian adults
notes lookdurly: 1998-present CPS March: not looking if detailed weeks looking (nwlkwk) is 0 (one record each in 2011, 2013, 2014)

