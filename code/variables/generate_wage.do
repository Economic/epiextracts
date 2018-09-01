********************************************************************************
* wage
* NBER-style wage variable usual hourly earnings
* EXcluding overtime, tips, commissions for hourly workers
* adjusted for top-coding, hours vary imputations, and trimmed of extreme values
********************************************************************************

* for now, identical wage and wage_noadj
gen wage = wage_noadj

lab var wage "Hourly wage (adjusted)"
notes wage: Dollars per hour, for hourly and nonhourly workers
notes wage: Approximates NBER's recommended wage variable
notes wage: Adjustments for top-coding, trimming of outliers
notes wage: Includes nonhourly workers whose usual hours vary
notes wage: Includes overtime, tips, commissions for nonhourly
notes wage: Excludes overtime, tips, commissions for hourly
