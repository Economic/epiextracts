*******************************************************************************
* Indian health servces last year
*******************************************************************************
gen byte hiihsly = .

if $marchcps == 1 {
	if tm(1995m1) <= $date & $date <= tm(1997m12) {
		replace hiihsly = 1 if otyp4 == 1
        replace hiihsly = 1 if othstyp1 == 7
        replace hiihsly = 1 if othstyp2 == 7
        replace hiihsly = 1 if othstyp3 == 7
        replace hiihsly = 1 if othstyp4 == 7
        replace hiihsly = 1 if othstyp5 == 7
        replace hiihsly = 1 if othstyp6 == 7	
        replace hiihsly = 0 if hiihsly == .	
	} 
    if tm(1998m1) <= $date & $date <= tm(2000m12) {
		replace hiihsly = 1 if otyp_4 == 1
        replace hiihsly = 1 if othstyp1 == 7
        replace hiihsly = 1 if othstyp2 == 7
        replace hiihsly = 1 if othstyp3 == 7
        replace hiihsly = 1 if othstyp4 == 7
        replace hiihsly = 1 if othstyp5 == 7
        replace hiihsly = 1 if othstyp6 == 7	
        replace hiihsly = 0 if hiihsly == .	
	}
    if tm(2001m1) <= $date & $date <= tm(2018m12) {
		replace hiihsly = 1 if ihsflg == 1
        replace hiihsly = 0 if ihsflg == 2
	}    
	if tm(2019m1) <= $date {
		replace hiihsly = 1 if ihsflg == 1
		replace hiihsly = 0 if ihsflg == 2 
	}
}

lab var hiihsly "Indian health services last year"
lab def hiihsly 1 "Covered" 0 "Not covered"
lab val hiihsly hiihsly
notes hiihsly: Available 1998-present
notes hiihsly: 1988-present universe: All persons (not infants born after calendar year)
notes hiihsly: 1998-2018 Unicon: otyp_4, othstyp1-6
notes hiihsly: 2019-present CPS: ihsflg
