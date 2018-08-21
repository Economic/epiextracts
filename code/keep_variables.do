#delimit;
keep
	year month minsamp
	hrhhid hrhhid2 hrsample hrsersuf huhhnum pulineno unicon_recnum
	finalwgt cmpwgt basicwgt orgwgt
	statefips statecensus division region countyfips cbsafips
	age female wbho
	gradecom gradehi grade92 educ
	lfstat emp unemp nilf schenrl samejob
	selfemp selfinc cow1 cow2
	multjobs numjobs
	unmem uncov union
	pubsec publoc pubst pubfed
	unempdur lookdur discwork
	ptecon
	hoursumay hoursuorg hoursu1 hoursu2 hoursut hourslw1 hourslw2 hourslwt hoursvary
	ind70 ind80 ind90 ind00 ind10 mind16
	occcode
	weekpay tc_weekpay a_weekpay
	paidhre otcrec
	otcamt wage wageotc
;
#delimit cr;
