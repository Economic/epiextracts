*******************************************************************************
* Detailed class of worker, longest job
*******************************************************************************
gen byte cowlj = .

if $marchcps == 1 {
	if tm(1988m1) <= $date {
		replace cowlj = ljcw
		replace cowlj = . if ljcw <= 0
	}
}

lab var cowlj "Class of Worker, longest job"
#delimit ;
lab def cowlj
1 "Private"
2 "Government - Federal"
3 "Government - State"
4 "Government - Local"
5 "Self-employed, incorporated"
6 "Self-employed, unincorporated"
7 "Without pay"
;
#delimit cr
lab val cowlj cowlj
notes cowlj: Universe inlcudes all persons age 15 and over
notes cowlj: 1988-present CPS: ljcw