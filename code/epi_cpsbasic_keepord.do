#delimit;
keep
	year month minsamp
	basicwgt cmpwgt finalwgt orgwgt
	hrhhid hrhhid2 hrsample hrsersuf huhhnum pulineno
	statefips statecensus division region countyfips cbsafips
	age female wbho
	educ gradecom gradehi grade92
	lfstat emp unemp nilf schenrl samejob
	selfemp selfinc selfany unmem uncov union
	pubsec pubst publoc pubfed
	mind16 ind70 ind80 ind90 ind00
	unempdur lookdur discwork ptecon
	paidhre otcrec
	weekpay weekpay_tc a_weekpay
	otcamt wage1 wage2 wage3 wage4
;
#delimit cr;
