#delimit;
keep
	year month minsamp
	basicwgt orgwgt
	hrhhid hrhhid2 hrsample hrsersuf huhhnum pulineno
	statefips statecensus division region countyfips cbsafips
	age female wbho
	educ gradecom gradehi grade92
	lfstat emp unemp nilf schenrl
	selfemp selfinc selfany unmem uncov union samejob
	pubsec pubst publoc pubfed
	weekpay paidhre otcrec otcamt	wage1 wage2 wage3 wage4 weekpay_tc a_weekpay
;
#delimit cr;
