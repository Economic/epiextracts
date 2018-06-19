#delimit;
keep
	year month minsamp
	basicwgt orgwgt
	hrhhid hrhhid2 hrsample hrsersuf huhhnum pulineno
	statefips statecensus division region countyfips
	age female wbho
	educ
	lfstat emp unemp nilf
	selfemp selfinc selfany
	paidhre wage1 weekpay wage2 wage3
;
#delimit cr;
