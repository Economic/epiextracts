********************************************************************************
* hrhhid
********************************************************************************
if tm(1973m1) <= $date & $date <= tm(1993m12) {
  gen hrhhid = hhid
}
if tm(1994m1) <= $date & $date <= tm(2018m5) {
  * use already existing hrhhid
}

lab var hrhhid "CPS: Household identifier (Part 1)"
notes hrhhid: 1973-1993: Unicon hhid
notes hrhhid: 1994-present: CPS household identifier
notes hrhhid: Used for joining EPI extracts to BLS/Census raw data
