#delimit;
keep
	year month minsamp
	basicwgt cmpwgt finalwgt orgwgt
	hrhhid hrhhid2 hrsample hrsersuf huhhnum pulineno
	statefips statecensus division region countyfips cbsafips
	age female wbho
	educ gradecom gradehi grade92
	lfstat emp unemp nilf schenrl samejob
	selfemp selfinc cow1 cow2
	unmem uncov union
	pubsec pubst publoc pubfed
	mind16 ind70 ind80 ind90 ind00
	unempdur lookdur discwork ptecon
	paidhre otcrec
	weekpay tc_weekpay a_weekpay
	otcamt wage wageotc
;
#delimit cr;
