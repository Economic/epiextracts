#delimit;
keep
	year month minsamp
	basicwgt orgwgt
	hrhhid hrhhid2 hrsample hrsersuf huhhnum pulineno
	statefips statecensus division region countyfips cbsafips
	age female wbho
	educ
	lfstat emp unemp nilf
	selfemp selfinc selfany unmem uncov union
	weekpay paidhre otcrec otcamt	wage1 wage2 wage3 wage4
;
#delimit cr;
