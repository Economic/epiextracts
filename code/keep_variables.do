#delimit;
keep
	year month minsamp
	hrhhid hrhhid2 hrsample hrsersuf huhhnum pulineno unicon_recnum
	finalwgt cmpwgt basicwgt orgwgt
	statefips statecensus division region countyfips cbsafips
	age female wbho citistat citizen married
	gradecom gradehi grade92 educ
	lfstat emp unemp nilf schenrl samejob
	selfemp selfinc cow1 cow2
	multjobs numjobs
	unmem uncov union
	pubsec publoc pubst pubfed
	unempdur lookdur discwork
	ptecon
	hoursumay hoursuorg hoursu1 hoursu2 hoursut hourslw1 hourslw2 hourslwt
	hoursvary hoursuint
	ind70 ind80 ind90 ind00 ind10 mind16 manuf
	occcode
	weekpay_noadj tc_weekpay a_weekpay
	earnhour a_earnhour
	paidhre otcrec
	otcamt wage_noadj wageotc_noadj
;
#delimit cr;
