#delimit;
keep
	year month minsamp
	hrhhid hrhhid2 hrsample hrsersuf huhhnum pulineno unicon_recnum
	hhid famid personid proxy
	finalwgt cmpwgt basicwgt orgwgt famwgt
	statefips statecensus division region countyfips cbsafips metstat cbsasize
	age female hispanic wbho wbhao wbhom wbhaom raceorig wbo_only wbho_only
	citistat citizen married veteran
	gradecom gradehi gradeatn educ
	lfstat emp unemp nilf schenrl samejob
	selfemp selfinc cow1 cow2
	multjobs numjobs
	unmem uncov union
	pubsec publoc pubst pubfed
	unempdur lookdur discwork
	ptecon
	paidhre
	hoursu1 hoursu2 hoursut hourslw1 hourslw2 hourslwt hoursumay hoursuorg
	hoursvary hoursuint
	ind70 ind80 ind90 ind02 ind07 ind12 mind16 manuf dind03 mind03
	occ70 occ80 occ90 occ00 occ10 mocc10 docc03 mocc03
	weekpay_noadj tc_weekpay a_weekpay
	earnhour a_earnhour
	otcrec
	otcamt wage_noadj wageotc_noadj
	ownchild famrel
;
#delimit cr;
