local date = `1'

**************************
* ORG SAMPLE RESTRICTION *
**************************
if tm(1979m1) <= `date' & `date' <= tm(1993m1) {

}
if tm(1994m1) <= `date' & `date' <= tm(2017m12) {
	keep if minsamp == 4 | minsamp == 8
}
