*******************************************************************************
* Reason absent from work last week
*******************************************************************************
gen byte whyabsent = .

if $marchcps == 1 {
    if tm(1994m1) <= $date & $date <= tm(1997m12)  {
        replace whyabsent = absrsn
        replace whyabsent = . if whyabsent == -1
	}
	if tm(1998m1) <= $date {
        replace whyabsent = peabsrsn
        replace whyabsent = . if whyabsent == -1
	}
}

if $monthlycps == 1 {
    if tm(1994m1) <= $date {
        replace whyabsent = peabsrsn
        replace whyabsent = . if whyabsent == -1
    }
}


lab var whyabsent "Reason absent from work"
#delimit ;
lab def whyabsent
1 "On layoff"
2 "Slack work/business conditions"
3 "Waiting for a new job to begin "
4 "Vacation/personal days"
5 "Own illness/injury/medical problems"
6 "Child care problems"
7 "Other family/personal obligation"
8 "Maternity/paternity leave"
9 "Labor dispute"
10 "Weather affected job"
11 "School/training"
12 "Civic/military duty"
13 "Does not work in the business"
14 "Other (specify)"
;
#delimit cr
lab val whyabsent whyabsent
notes whyabsent: 1994-present CPS: peabsrsn
