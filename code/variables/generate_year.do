***************************
* Calendar interview year *
***************************
cap drop year
gen int year = year(dofm($date))
lab var year "Year"
notes year: Generated from file date
