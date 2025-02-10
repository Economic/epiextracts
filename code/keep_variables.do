#delimit;
keepifexist
	year month minsamp
	hrhhid hrhhid2 hrsample hrsersuf huhhnum pulineno unicon_recnum
	hhid famid personid proxy hhtype asecwgt famtype
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
	faminc faminc_det faminc_c
	ownchild famrel agechild
	telework hourslwtw
	diffdress differrands diffhear diffmemory diffphysical diffvision
    difficulty
	famern
	famiws
	hhinc_c
	povlev povrate
	schenrl schenrl_type
	earn income
	hoursly wrkly wksly_binned
	hicovly hicov
	penplan penincl
	foodstamps
	medicaid medicaidcov
	pubhouse hhtenure rentsub
	eitc
	hhstatus famlis
	hmcaid now_hmcaid mcaid now_mcaid caid now_caid
	ftotval
	offpov offpovcut
	spmpov spmpovcut spmeitc
	spm_fedtax spm_statetax
	spm_schlunch schlunch spm_snap spm_wic spm_mortgage
	spmfamtype
	cowly
	dhhtype famkind
	disability parent
	migarea migstatus migmetro
	lookdurly spmwgt childtaxcredit
	redesign hiyn mcare champ
;
#delimit cr;

if $monthlycps == 1 | $maycps == 1 {
  #delimit;
  drop asecwgt
  hoursly
    famern
    famiws
    hhinc_c
    wrkly wksly_binned
	  faminc_c
    earn
    povlev povrate
    schenrl
    hicovly hicov
    penplan penincl
    foodstamps
    medicaid medicaidcov
    pubhouse hhtenure rentsub
    eitc
    offpov offpovcut
    spmpov spmpovcut spmeitc
    spm_fedtax spm_statetax
    spm_schlunch schlunch spm_snap spm_wic spm_mortgage
    spmfamtype
    cowly indcode
    dhhtype famkind 
    disability parent
    migarea migstatus migmetro
    lookdurly spmwgt childtaxcredit
    redesign
  ;
  #delimit cr;
}

if $marchcps == 1 {
  #delimit;
  drop agechild
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
