local date = `1'

***************
* Paid hourly *
***************
gen paidhre = .
if tm(1994m1) <= `date' & `date' <= tm(2017m12) {
	replace paidhre = 0 if peernhry == 2
	replace paidhre = 1 if peernhry == 1
}
lab var paidhre "Paid by hour"
lab def paidhre 0 "Nonhourly worker" 1 "Hourly worker"
lab val paidhre paidhre
notes paidhre: Indicates BLS records respondent's earnings by hour
notes paidhre: Not a consistent indicator of "hourly worker" status
notes paidhre: CPS: derived from peernhry


**************************************************
* Hourly earnings if "paid by hour" (paidhre==1) *
**************************************************
gen wage1 = .
if tm(1994m1) <= `date' & `date' <= tm(2017m12) {
	* convert from pennies to dollars
	replace wage1 = prernhly / 100 if paidhre == 1
	replace wage1 = . if prernhly < 0
}
lab var wage1 "Hourly wage (if hourly worker)"
notes wage1: Dollars per hour
notes wage1: For hourly workers only
notes wage1: Excludes overtime, tips, commissions
notes wage1: Top-code 1979-84: 99.00
notes wage1: Top-code 1985-98: set so that hours worked times earnhre /*
*/ < weekly earnings top-code
notes wage1: Top-code 1998-: set so that hours worked times earnhre /*
*/ < 1,998, which is less than the weekly earnings top-code of 2,884 /*
*/ [BLS documentation; check]
notes wage1: Top-code 1985-: NBER states that top-code not applied /*
*/ to all observations
notes wage1: Bottom-code: 1979-88: 0.50; 1994: 0.10; 1995: 0.20
notes wage1: set to missing if prernhly<0 to get rid of neg values
notes wage1: derived from paidhre=1 & CPS: prernhly


/* Usual weekly earnings including overtime, tips, commissions
   nonhourly workers (paidhre==0) and hourly workers (paidhre==1)
*/

/* The NBER extract contains three usual weekly earnings variables,
which we include here for 1979-1993.

The first two are uearnwk ("unedited," available 1979-1993) and uearnwke
("edited," available 1979-1988 only). For *hourly* workers, these variables
give the usual weekly earnings *including* overtime, tips, and commissions.
Between 1989 and 1993, when uearnwke is not available, few observations on
hourly workers show uearnwk greater than the product of earnhre (usual
hourly pay) times uhourse (usual weekly hours), suggesting that the CPS may
not have reliably captured the overtime, tips, and commissions received by
hourly workers between 1989 and 1993.

For hourly workers in 1979-1988, the CEPR extract uses uearnwke for usual
weekly earnings including overtime, tips, and commissions. For hourly workers
1989-1993, the CEPR extract uses uearnwk, which does appear to capture well
overtime, tips, and commissions.

The third variable is earnwke ("edited," available 1979-1993). For hourly
workers, this variable contains the product of earnhre (usual hourly pay)
times uhourse (usual weekly hours); so, by definition, it excludes overtime,
tips, and commissions for hourly workers. For nonhourly workers, earnwke
does include overtime, tips, and commissions.
*/

/*
if 1979<=`year' & `year'<=1988 {
replace uearnwk=. if uearnwk<0
replace weekpay=earnwke if paidhre==0
replace weekpay=uearnwke if paidhre==1
replace weekpay=. if earnwke<0
}
if 1989<=`year' & `year'<=1993 {
replace uearnwk=. if uearnwk<0
gen byte uearnwke=.
replace weekpay=earnwke if paidhre==0
replace weekpay=uearnwk if paidhre==1 /* note shift from uearnwke to uearnwk */
}

lab var uearnwk "Weekly pay"
notes uearnwk: Dollars per week
notes uearnwk: Includes overtime, tips, commissions
notes uearnwk: Intended for hourly workers only
notes uearnwk: Available 1979-93 only
notes uearnwk: Top-code: 1979-88: 999; 1989-93: 1999
notes uearnwk: set to missing if neg value
notes uearnwk: CPS: a$grwkel1-4; prernwa

lab var uearnwke "Weekly pay"
notes uearnwke: Dollars per week
notes uearnwke: Includes overtime, tips, commissions
notes uearnwke: Intended for hourly workers only
notes uearnwke: Available 1979-88 only
notes uearnwke: Top-code: 1999
notes uearnwke: CPS: a-brswk (locations 427-429)

lab var earnwke "Weekly pay"
notes earnwke: Dollars per week
notes earnwke: Includes overtime, tips, commissions
notes earnwke: Intended for nonhourly workers
notes earnwke: For paidhre=1: earnhre*uhourse; for paidhre=0: uearnwke
notes earnwke: Top-code: 1979-88: 999; 1989-97: 1923; 1998-: 2884
notes earnwke: CPS: a-werntp, prernwa, pternwa
notes earnwke: CPS: 1979-88: location 417-419
*/

gen weekpay = .
/*
if 1979<=`year' & `year'<=1988 {
replace uearnwk=. if uearnwk<0
replace weekpay=earnwke if paidhre==0
replace weekpay=uearnwke if paidhre==1
replace weekpay=. if earnwke<0
}
if 1989<=`year' & `year'<=1993 {
replace uearnwk=. if uearnwk<0
gen byte uearnwke=.
replace weekpay=earnwke if paidhre==0
replace weekpay=uearnwk if paidhre==1 /* note shift from uearnwke to uearnwk */
}
*/
if tm(1994m1) <= `date' & `date' <= tm(2017m12) {
	replace weekpay=prernwa/100 if paidhre==0 /* convert from pennies to dollars */
	replace weekpay=prernwa/100 if paidhre==1
	replace weekpay=. if prernwa<0
}
lab var weekpay "Weekly pay"
notes weekpay: Dollars per week
notes weekpay: For nonhourly and hourly workers
notes weekpay: Includes overtime, tips, commissions
notes weekpay: Top-code: 1979-88: 999; 1989-97: 1923; 1998-: 2884
notes weekpay: CPS 1994-: prernwa
notes weekpay: CPS 1979-88: location 417-419

/* Usual hourly earnings including overtime, tips, commissions
   nonhourly workers (paidhre==0)
*/

gen wage2 = .
/*
if 1979<=`year' & `year'<=1993 {
replace wage2=weekpay/uhourse if paidhre==0
replace wage2=. if wage2<0
}
*/
if tm(1994m1) <= `date' & `date' <= tm(2017m12) {
	replace wage2=weekpay/pehrusl1 if paidhre==0
	replace wage2=. if wage2<0
}
lab var wage2 "Hourly wage (if nonhourly worker)"
notes wage2: Dollars per hour
notes wage2: For nonhourly workers only
notes wage2: Includes overtime, tips, commissions
notes wage2: Usual weekly earnings / usual weekly hours
notes wage2: 1979-1993: weekpay/uhourse; 1994-present: weekpay/pehrusl1

/* NBER-style wage variable usual hourly earnings
   INcluding overtime, tips, commissions for nonhourly workers
   EXcluding overtime, tips, commissions for hourly workers
*/
gen wage3 = wage1 if paidhre == 1
replace wage3 = wage2 if paidhre == 0
lab var wage3 "Hourly wage"
notes wage3: Dollars per hour
notes wage3: For hourly and nonhourly workers
notes wage3: Approximates NBER's recommended wage variable
notes wage3: Includes overtime, tips, commissions for nonhourly
notes wage3: Excludes overtime, tips, commissions for hourly
notes wage3: No adjustments for top-coding
notes wage3: No trimming of outliers
notes wage3: Excludes nonhourly workers whose usual hours vary
