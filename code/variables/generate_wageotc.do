********************************************************************************
* wageotc
* NBER-style wage variable usual hourly earnings
* INcluding overtime, tips, commissions for hourly workers
* adjusted for top-coding, hours vary imputations, and trimmed of extreme values
********************************************************************************

* for now, identical wageotc and wageotc_noadj
gen wageotc = wageotc_noadj

lab var wageotc "Hourly wage (adjusted) - OTC consistent"
notes wageotc: Dollars per hour, for hourly and nonhourly workers
notes wageotc: Includes overtime, tips, commissions for nonhourly and hourly
notes wageotc: Adjustments for top-coding, trimming of outliers
notes wageotc: Includes nonhourly workers whose usual hours vary
notes wageotc: Covers only hourly workers who report hourly rate of pay
notes wageotc: 1994-present, CPS: derived from wage, weekpay, phersul1, otcamt, otrec, peernhro
