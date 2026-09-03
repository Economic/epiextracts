#delimit;
keepifexist
	year month minsamp
	hrhhid hrhhid2 hrsample hrsersuf huhhnum pulineno unicon_recnum
	hserial hhid famid personid proxy hhtype asecwgt famtype
	finalwgt cmpwgt basicwgt orgwgt hhwgt famwgt
	statefips statecensus division region countyfips cbsafips metstat cbsasize
	age female hispanic wbho wbhao wbhom wbhaom raceorig wbo_only wbho_only
	citistat citizen married veteran
	gradecom gradehi gradeatn educ
	dlfstat lfstat emp emphrs unemp nilf samejob whyabsent whyunemp 	
	selfemp selfinc cow1 cow2
	multjobs numjobs
	unmem uncov union
	pubsec publoc pubst pubfed
	unempdur lookdur discwork
	ptecon ftptstat
	paidhre
	hoursu1 hoursu2 hoursut hourslw1 hourslw2 hourslwt hoursumay hoursuorg
	hoursvary1 hoursvary2 hoursvaryt hoursuint hoursvary
	indcode ind70 ind80 ind90 ind02 ind07 ind12 ind17 ind22 mind16 manuf dind03 mind03
	occcode occ70 occ80 occ90 occ00 occ10 occ18 mocc10 docc03 mocc03
	weekpay_noadj tc_weekpay a_weekpay
	earnhour a_earnhour
	otcrec
	otcamt wage_noadj wageotc_noadj tc_earnhour
	faminc faminci faminc_det
	ownchild famrel agechild
	telework hourslwtw
	diffdress differrands diffhear diffmemory diffphysical diffvision
    difficulty
	famern
	famiws
	hhinc hhpct
	povlev povrate
	schenrl
	earn income
	hoursly wrkly wkswrklyi
	hicovly hicov hicovlyi
	penplan penincl
	foodstamps
	medicaid medicaidcov
	pubhouse hhtenure rentsub
	eitc
	offpovuniverse offpov offpovcut offfaminc
	spmpov spmpovcut spmeitc
	spmfedtax spmstatetax
	spmschlunch schlunch spmsnap spmwic spmmortgage
	spmfamtype
	cowly
	dhhtype famkind
	disability parent
	migarea migstatus migmetro
	lookdurly spmwgt childtaxcredit
	redesign
	hiownemp hiownemply hiownpaidly
;
#delimit cr;

if $monthlycps == 1 | $maycps == 1 {
  #delimit;
  drop asecwgt hserial
    hoursly
    famern
    famiws
    hhinc hhpct
    wrkly wkswrklyi
	income
	faminc
    earn
    povlev povrate
    schenrl
    hicovly hicov
    penplan penincl
    foodstamps
    medicaid medicaidcov
    pubhouse hhtenure rentsub
    eitc
    offpovuniverse offpov offpovcut offfaminc
    spmpov spmpovcut spmeitc
    spmfedtax spmstatetax
    spmschlunch schlunch spmsnap spmwic spmmortgage
    spmfamtype
    cowly indcode
    dhhtype famkind 
    disability parent
    migarea migstatus migmetro
    lookdurly spmwgt childtaxcredit
    hiemp hiownemply hiownpaidly
	redesign
  ;
  #delimit cr;
}

if $marchcps == 1 {
  #delimit;
  drop hrsersuf agechild
    basicwgt cmpwgt orgwgt
    cow2
    emphrs gradecom
    hourslw1 hourslw2 hourslwtw 
    hoursu2 hoursuint hoursumay
    hrsample hrsersuf huhhnum
    lookdur multjobs numjobs
    otcamt otcrec
    proxy
    ptecon samejob telework
    wage_noadj wageotc_noadj wageotc
    weekpay weekpay_noadj tc_weekpay
  ;
  #delimit cr;
}
