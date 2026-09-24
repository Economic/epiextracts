*******************************************************************************
* Other government health insurance coverage
*******************************************************************************
gen byte higotherly = .

if $marchcps == 1 {
	if tm(1980m1) <= $date & $date <= tm(1994m12) {
		replace higotherly = 1 if champ == 1 /* military/veteran health insurance */
		replace higotherly = 0 if champ == 2

	}
	if tm(1995m1) <= $date & $date <= tm(1997m12) {
		replace higotherly = 1 if champ == 1
		replace higotherly = 1 if hiihsly == 1
		replace higotherly = 0 if champ == 2 & hiihsly == 0
	}
	if tm(1998m1) <= $date & $date <= tm(2018m12) {
		replace higotherly = 1 if champ == 1
		replace higotherly = 1 if hiihsly == 1
		replace higotherly = 0 if champ == 2 & hiihsly == 0
		
	}    
	if tm(2019m1) <= $date {
		replace higotherly = 1 if ihsflg == 1 /* Indian health services coverage */
		replace higotherly = 1 if mil == 1 /* active duty VA/TRICARE coverage */
		replace higotherly = 1 if champva == 1 /* civilian VA coverage */
		replace higotherly = 1 if vacare == 1 /* veteran VA coverage */
		replace higotherly = 0 if ihsflg == 2 & mil == 2 & champva == 2 & vacare == 2
	}
}

lab var higotherly "Other government health insurance coverage last year"
lab def higotherly 1 "Covered" 0 "Not covered"
lab val higotherly higotherly
notes higotherly: Available 1988-present
notes higotherly: 1988-present universe: All persons (not infants born after calendar year)
notes higotherly: 1988-1994 Unicon: champ
notes higotherly: 1995-1997 Unicon: oth, othstper
notes higotherly: 1998-2018 CPS: oth, othstper
notes higotherly: 2019-present CPS: ihsflg, mil, champva, vacare
