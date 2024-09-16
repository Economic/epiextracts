#delimit;
keep
	year month minsamp
	hrhhid hrhhid2 hrsample hrsersuf huhhnum pulineno unicon_recnum
	hhid famid personid proxy hhtype famtype
	finalwgt cmpwgt basicwgt orgwgt hhwgt famwgt
	statefips statecensus division region countyfips cbsafips metstat cbsasize
	age female hispanic wbho wbhao wbhom wbhaom raceorig wbo_only wbho_only
	citistat citizen married veteran
	gradecom gradehi gradeatn educ
	dlfstat lfstat emp emphrs unemp nilf schenrl samejob whyabsent whyunemp 	
	selfemp selfinc cow1 cow2
	multjobs numjobs
	unmem uncov union
	pubsec publoc pubst pubfed
	unempdur lookdur discwork
	ptecon ftptstat
	paidhre
	hoursu1 hoursu2 hoursut hourslw1 hourslw2 hourslwt hoursumay hoursuorg
	hoursvary hoursuint
	indcode ind70 ind80 ind90 ind02 ind07 ind12 ind17 mind16 manuf dind03 mind03
	occcode occ70 occ80 occ90 occ00 occ10 occ18 mocc10 docc03 mocc03
	weekpay_noadj tc_weekpay a_weekpay
	earnhour a_earnhour
	otcrec
	otcamt wage_noadj wageotc_noadj
	faminc
	ownchild famrel agechild
;
#delimit cr;
