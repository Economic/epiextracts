*******************************************************************************
* Reason not at work or hours last week
*******************************************************************************
capture rename emphrs orig_emphrs
gen byte emphrs = .

if $monthlycps == 1 {
    if tm(1994m1) <= $date {
        replace emphrs = premphrs
        replace emphrs = . if emphrs == -1
    }
}

lab var emphrs "Reason not at work/hours last week"
#delimit ;
lab def emphrs
0 "Unemployed and nilf"
1 "w/job, not at work-illnes"
2 "w/job, not at work-vacation"
3 "w/job, not at work-weather affected job"
4 "w/job, not at work-labor dispute"
5 "w/job, not at work-child care problems"
6 "w/job, not at work-fam/pers obligation"
7 "w/job, not at work-maternity/paternity"
8 "w/job, not at work-school/training"
9 "w/job, not at work-civic/military duty"
10 "w/job, not at work-does not work in bus"
11 "w/job, not at work-other"
12 "At work- 1-4 hrs"
13 "At work- 5-14 hrs"
14 "At work- 15-21 hrs"
15 "At work- 22-29 hrs"
16 "At work- 30-34 hrs"
17 "At work- 35-39 hrs"
18 "At work- 40 hrs"
19 "At work- 41-47 hrs"
20 "At work- 48 hrs"
21 "At work- 49-59 hrs"
22 "At work- 60 hrs or more"
;
#delimit cr
lab val emphrs emphrs
notes emphrs: 1994-present CPS: premphrs
