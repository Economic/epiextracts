***************************
* Calendar interview year *
***************************
cap drop year
gen int year = year(dofm($date))
lab var year "Year"
notes year: Generated from file date
* March ASEC: year is survey year, but income/coverage questions refer to the prior calendar year
if $marchcps == 1 {
	notes year: March CPS: year is the survey year, not the reference year; use year - 1 for the calendar year referenced by prior-year variables (e.g., povrate, povlev, offpov)
}
