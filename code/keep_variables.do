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
	dlfstat lfstat emp emphrs unemp nilf samejob whyabsent whyunemp 	
	selfemp selfinc cow1 cow2
	multjobs numjobs
	unmem uncov union
	pubsec publoc pubst pubfed
	unempdur lookdur discwork
	ptecon ftptstat
	paidhre
	hoursu1 hoursu2 hoursut hourslw1 hourslw2 hourslwt hoursumay hoursuorg
	hoursvary hoursuint
  hourslyr
  ind70 ind80 ind90 ind02 ind07 ind12 ind17 mind16 manuf dind03 mind03
  occ70 occ80 occ90 occ00 occ10 occ18 mocc10 mocc03 docc03
  weekpay_noadj tc_weekpay a_weekpay
	earnhour a_earnhour
  otcrec
  otcamt wage_noadj wageotc_noadj
	telework hourslwtw
  ownchild famrel agechild 
  income
  famern famiws
  hhinc_c
  wkslyr wkslyr_binned
	faminc faminc_c
  earn
  povlev povrate
  schenrl
  wrkly
  hicov hiemp hipaid
  penplan penincl
  foodstamps
  medicaid medicaidcov
  pubhouse hhtenure rentsub
  eitc
  offpov offpovcut
  spmpov spmpovcut
  fedtax statetax
  schlunch snap wic mortgage
  spmfamtype
  cowlj indcode
  dhhtype famkind 
  disability parent
  migarea migstatus migmetro
  lookdurbin spmwgt
  hhstatus famlis 
  ftotval fpovcut
  p_seq h_seq peridnum a_famrel
  a_dtocc a_dtind peioocc occcode
;
#delimit cr;

if $monthlycps == 1 | $maycps == 1 {
  #delimit;
  drop asecwgt
  hourslyr
    famern
    famiws
    hhinc_c
    wkslyr wkslyr_binned
	  faminc_c
    earn
    povlev povrate
    schenrl
    wrkly
    hicov hiemp hipaid
    penplan penincl
    foodstamps
    medicaid medicaidcov
    pubhouse hhtenure rentsub
    eitc
    offpov offpovcut
    spmpov spmpovcut
    fedtax statetax
    schlunch snap wic mortgage
    spmfamtype
    cowlj indcode
    dhhtype famkind 
    disability parent
    migarea migstatus migmetro
    lookdurbin spmwgt
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
