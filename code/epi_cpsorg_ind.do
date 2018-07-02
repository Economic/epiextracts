local date = `1'


**************************************
* Industry variables for each period *
**************************************

/* 1976-1982: 1970 census industry codes */
gen ind_70 = .
replace ind_70 = indcode if tm(1979m1) <= `date' & `date' <= tm(1982m12) /* check on 1983*/

/* 1983-1992: 1980 census industry codes */ /* check on 1983*/
gen ind_80 = .
replace ind_80 = indcode if tm(1983m1) <= `date' & `date' <= tm(1992m12)


/* 1992-1999: 1990 census industry codes */
gen ind_90 = .
replace ind_90 = indcode if tm(1992m1) <= `date' & `date' <= tm(1999m12)

/* 2000-present: 2000 census industry codes */
gen ind_00 = .
replace ind_00 = indcode if tm(2000m1) <= `date' & `date' <= tm(2018m5)


****************************************
* Occupation variables for each period *
****************************************

**************************************
* Consistent major industry variable *
**************************************

gen mind_16 = .

#delimit ;

/* 1979-1982, sort of fact checked, a few suggested changes */
/*note: Major ind codes are from appendix I.3 of Unicon, aggregated from appendix K.5*/
/* Looks like it is only good post-may cps */

	if tm(1976m1) <= `date' & `date' <= tm(1982m12){
	/* Agriculture, mining, forestry and fisheries */
	replace mind_16 = 1 if (
		(indcode == 17) |
		(indcode == 18) |
		(indcode == 19) |
		(indcode == 29) |
		(indcode >= 27 & indcode <= 28) | /* forestry and fisheries*/
		(indcode >= 47 & indcode <= 58) /* mining */
	);
	/* Construction */
	replace mind_16 = 2 if
		(indcode >= 67 & indcode <= 78);
	/* Manufacturing, durable goods */
	replace mind_16 = 3 if
		(indcode >= 107 & indcode <= 267);
	/* Manufacturing, nondurable goods (incl publishing 338, 339) */
	replace mind_16 = 4 if
		(indcode >= 268 & indcode <= 399);
	/* Transportation */
	replace mind_16 = 5 if
		(indcode >= 407 & indcode <= 429);
	/* Communications and utilities */
	replace mind_16 = 6 if	(
		(indcode >= 447 & indcode <= 449) | /* communications (excl publishing 338, 339) */
		(indcode >= 467 & indcode <= 499) /* utilities */
	);
	/* Wholesale trade */
	replace mind_16 = 7 if
		(indcode >= 507 & indcode <= 599);
	/* Retail trade (excl eating and drinking 669) */
	replace mind_16 = 8 if	(
		(indcode >= 607 & indcode <= 668) |
		(indcode >= 677 & indcode <= 699)
	);
	/* Finance, insurance and real estate. Business, auto and repair services, and other professional. */
	replace mind_16 = 9 if	(
		(indcode >= 707 & indcode <= 719) | /*finance, insurance, and real estate */
		(indcode >= 727 & indcode <= 767) | /* business and repair services */
		(indcode == 849) | /* legal services */
		(indcode == 877) | /* religious orgs */
		(indcode == 887) | /* nonprofit membership orgs */
		(indcode >= 888 & indcode <= 899) /* professional and related */
	);
	/* Personal services, including household */
	replace mind_16 = 10 if (
		(indcode == 769) | /* private households */
		(indcode >= 779 & indcode <= 799) /* personal services excl priv households (excl hotels and lodging) */
	);
	/* Entertainment and recreation */
	replace mind_16 = 11 if	(
		(indcode == 669) | /* eating and drinking places */
		(indcode == 869) | /* museums */
		(indcode >= 777 & indcode <= 778) | /* hotels and lodging */
		(indcode >= 807 & indcode <= 817)
	);
	/* Hospital */
	replace mind_16 = 12 if
		(indcode == 838);
	/* Medical, except hospital */
	replace mind_16 = 13 if	(
		(indcode >= 828 & indcode <= 837) |
		(indcode >= 839 & indcode <= 848)
	);
	/* Educational */
	replace mind_16 = 14 if
		(indcode >= 857 & indcode <= 868);
	/* Social services */ /* changed to just welfare and res welfare- moved membership/rel to other prof */
	replace mind_16 = 15 if
		(indcode >= 878 & indcode <= 879);
	/* Public administration */
	replace mind_16 = 16 if
		(indcode >= 907 & indcode <= 947);
};

/* 1983-1991*/
/*note: Major ind codes are from appendix I.3 of Unicon, aggregated from appendix K.2*/
/* NEED TO assign mind_16 for indcode== 991 in 1983. Armed forces I think. We should drop them? */

if tm(1983m1) <= `date' & `date' <= tm(1991m12){
	/* Agriculture, mining, forestry and fisheries*/
	replace mind_16 = 1 if	(
		(indcode >= 10 & indcode <= 21) |
		(indcode >= 30 & indcode <= 31) | /* forestry and fishing */
		(indcode >= 40 & indcode <= 50) /* mining */
	);
	/* Construction */
	replace mind_16 = 2 if
		(indcode == 60);
	/* Manufacturing, durable goods */
	replace mind_16 = 3 if
		(indcode >= 230 & indcode <= 392);
	/* Manufacturing, nondurable goods */
	replace mind_16 = 4 if
		(indcode >= 100 & indcode <= 222);
	/* Transportation (incl usps) */
	replace mind_16 = 5 if
		(indcode >= 400 & indcode <= 432);
	/* Communications and utilities */
	replace mind_16 = 6 if (
		(indcode >= 440 & indcode <= 442) | /* communications (excl publishing)*/
		(indcode >= 460 & indcode <= 472) /*utilities */
	);
	/* Wholesale trade */
	replace mind_16 = 7 if
		(indcode >= 500 & indcode <= 571);
	/* Retail trade (excl food and drinking 641 */
	replace mind_16 = 8 if (
		(indcode >= 580 & indcode <= 640) |
		(indcode >= 642 & indcode <= 691)
	);
	/* Finance, insurance and real estate. Business, auto and repair services, and other professional. */
	replace mind_16 = 9 if	(
		(indcode == 841) | /* legal services */
		(indcode >= 700 & indcode <= 712) | /* finance, insurance and real estate */
		(indcode >= 721 & indcode <= 760) | /* business and repaire services */
		(indcode >= 873 & indcode <= 892) /* professional and related serivces (incl religious, membership) */
	);
	/* Personal services, including household */
	replace mind_16 = 10 if	(
		(indcode == 761) | /* private households */
		(indcode >= 771 & indcode <= 791) /* personal services excl private households (excl hotels and lodging) */
	);
	/* Entertainment and recreation */ /* museums=872, accom=762,770 , food=641 */
	replace mind_16 = 11 if	(
		(indcode == 872) | /* museums */
		(indcode == 641) | /* eating and drinking places */
		(indcode == 762) | /* hotels/motels */
		(indcode == 770) | /* other lodging */
		(indcode >= 800 & indcode <= 802)
	);
	/* Hospital */
	replace mind_16 = 12 if
		(indcode == 831);
	/* Medical, except hospital */
	replace mind_16 = 13 if	(
		(indcode >= 812 & indcode <= 830) |
		(indcode >= 832 & indcode <= 840)
	);
	/* Educational */
	replace mind_16 = 14 if
		(indcode >= 842 & indcode <= 860);
	/* Social services */
	replace mind_16 = 15 if
		(indcode >= 861 & indcode <= 871);
	/* Public administration */
	replace mind_16 = 16 if
		(indcode >= 900 & indcode <= 932);
};

/* 1992-1999? 2002?*/
/*note: Major ind codes are from appendix I.3 of Unicon, aggregated from appendix K.3*/

if tm(1992m1) <= `date' & `date' <= tm(1999m12){
	/* Agriculture, mining, forestry and fisheries */
	replace mind_16 = 1 if	(
		(indcode >= 10 & indcode <= 30) |
		(indcode >= 31 & indcode <= 32) | /* forestry and fishing */
		(indcode >= 40 & indcode <= 50) /* mining */
	);
	/* Construction */
	replace mind_16 = 2 if
		(indcode == 60);
	/* Manufacturing, durable goods */
	replace mind_16 = 3 if
		(indcode >= 230 & indcode <= 392);
	/* Manufacturing, nondurable goods (incl publishing 171, 172) */
	replace mind_16 = 4 if
		(indcode >= 100 & indcode <= 222);
	/* Transportation */
	replace mind_16 = 5 if
		(indcode >= 400 & indcode <= 432);
	/* Communications and utilities */
	replace mind_16 = 6 if	(
		(indcode >= 440 & indcode <= 442) | /* communication (excl publishing 171, 172) */
		(indcode >= 450 & indcode <= 472) /* utilities */
	);
	/* Wholesale trade */
	replace mind_16 = 7 if
		(indcode >= 500 & indcode <= 571);
	/* Retail trade (excl food and drinking places 641) */
	replace mind_16 = 8 if	(
		(indcode >= 580 & indcode <= 640) |
		(indcode >= 642 & indcode <= 691)
	);
	/* Finance, insurance and real estate. Business, auto and repair services, and other professional. */
	replace mind_16 = 9 if	(
		(indcode == 12) | /* vetrinary services */
		(indcode == 841) | /* legal services */
		(indcode >= 700 & indcode <= 712) | /* finance, insurance, and real estate */
		(indcode >= 721 & indcode <= 760) | /* business and repair services */
		(indcode >= 873 & indcode <= 893) /* professional and related services (incl religious and membership) */
	);
	/* Personal services, including household */
	replace mind_16 = 10 if	(
		(indcode == 761) | /* private households */
		(indcode >= 771 & indcode <= 791) /* personal services, excluding private households (excl hotels/lodging) */
	);
	/* Entertainment and recreation */
	replace mind_16 = 11 if	(
		(indcode == 872) | /* museums */
		(indcode == 641) | /* food and drinking places */
		(indcode == 762) | /* hotels/motels */
		(indcode == 770) | /* other lodging */
		(indcode >= 800 & indcode <= 810)
	);
	/* Hospital */
	replace mind_16 = 12 if
		(indcode == 831);
	/* Medical, except hospital */
	replace mind_16 = 13 if	(
		(indcode >= 812 & indcode <= 830) |
		(indcode >= 832 & indcode <= 840)
	);
	/* Educational */
	replace mind_16 = 14 if
		(indcode >= 842 & indcode <= 860);
	/* Social services */
	replace mind_16 = 15 if
		(indcode >= 861 & indcode <= 871);
	/* Public administration */
	replace mind_16 = 16 if
		(indcode >= 900 & indcode <= 932);
};

/* 2000-? or 2002-?*/
/*note: Major ind codes are from appendix I.2 of Unicon, aggregated from appendix K.1 and census website*/

if tm(2000m1) <= `date' & `date' <= tm(2018m5){
	/* Agriculture, mining, forestry and fisheries */
	replace mind_16 = 1 if	(
		(indcode >= 0170 & indcode <= 0180) |
		(indcode == 0290) |
		(indcode == 7480) | /* veterinary services */
		(indcode >= 0190 & indcode <= 0280) | /* forestry and fishing */
		(indcode >= 0370 & indcode <= 0490) /* mining */
	);
	/* Construction */
	replace mind_16 = 2 if
		(indcode == 0770);
	/* Manufacturing, durable goods */
	replace mind_16 = 3 if
		(indcode >= 2470 & indcode <= 3990);
	/* Manufacturing, nondurable goods (incl publishing)  */
	replace mind_16 = 4 if	(
		(indcode >= 1070 & indcode <= 2390) |
		(indcode >= 6470 & indcode <= 6480) /* publishing (excl software*/
	);
	/* Transportation */
	replace mind_16 = 5 if
		(indcode >= 6070 & indcode <= 6390);
	/* Communications and utilities (treated information as communication) */
	replace mind_16 = 6 if	(
		(indcode >= 0570 & indcode <= 0690) | /* utilities */
		(indcode >= 6490 & indcode <= 6780) /* information (excl publishing, incl software publishing */
	);
	/* Wholesale trade */
	replace mind_16 = 7 if
		(indcode >= 4070 & indcode <= 4590);
	/* Retail trade */
	replace mind_16 = 8 if
		(indcode >= 4670 & indcode <= 5790);
	/* Finance, insurance and real estate. Business, auto and repair services, and other professional. */
	replace mind_16 = 9 if	(
		(indcode >= 6870 & indcode <= 7190) | /* finance, insurance, and real estate */
		(indcode >= 7270 & indcode <= 7470) | /* professional serivces (excl veterinary) */
		(indcode >= 7490 & indcode <= 7790) | /* professional serivces (excl veterinary) */
		(indcode >= 8770 & indcode <= 8890) | /* other services (repair) (includes shoe repair after mid 2000's, which used to be in personal services) */
		(indcode >= 9160 & indcode <= 9190) /* other services (religious, membership) */
	);
	/* Personal services, including household */
	replace mind_16 = 10 if	(
		(indcode == 9290) | /* private households */
		(indcode >= 8970 & indcode <= 9090) /* personal serivces, excl private households */
	);
	/* Entertainment and recreation (incl food/drinking places, lodging, museums) */
	replace mind_16 = 11 if
		(indcode >= 8560 & indcode <= 8690);
	/* Hospital */
	replace mind_16 = 12 if
		(indcode == 8190);
	/* Medical, except hospital */
	replace mind_16 = 13 if	(
		(indcode >= 7970 & indcode <= 8180) |
		(indcode >= 8270 & indcode <= 8290)
	); 
	/* Educational */
	replace mind_16 = 14 if
		(indcode >= 7860 & indcode <= 7890);
	/* Social services */
	replace mind_16 = 15 if
		(indcode >= 8370 & indcode <= 8470);
	/* Public administration */
	replace mind_16 = 16 if
		(indcode >= 9370 & indcode <= 9590);
};

#delimit cr ;

/* add labels */
label define ind_lab 
1 "Agriculture, mining, forestry and fisheries" 
2 "Construction" 
3 "Manufacturing, durable goods" 
4 "Manufacturing, nondurable goods" 
5 "Transportation" 
6 "Communications and utilities" 
7 "Wholesale trade" 
8 "Retail trade" 
9 "Finance, insurance and real estate. Business, auto, repair, and other professional services." 
10 "Personal services, including private household" 
11 "Entertainment and recreation" 
12 "Hospital" 
13 "Medical, except hospital" 
14 "Educational" 
15 "Social Services" 
16 "Public administration"
;
label value mind_16 ind_lab;

/*
tostring mind_16, replace
replace mind_16 = "Ag_for_fish_min" if mind_16 == "1"
replace mind_16 = "Construction" if mind_16 == "2"
replace mind_16 = "Manufacturing_durable" if mind_16 == "3"
replace mind_16 = "Manufacturing_nondur" if mind_16 == "4"
replace mind_16 = "Transportation" if mind_16 == "5"
replace mind_16 = "Communications_util" if mind_16 == "6"
replace mind_16 = "Wholesale_trade" if mind_16 == "7"
replace mind_16 = "Retail_trade" if mind_16 == "8"
replace mind_16 = "Fin_bus_rep_prof" if mind_16 == "9"
replace mind_16 = "Personal_services_incl_house" if mind_16 == "10"
replace mind_16 = "Entertainment_recreation" if mind_16 == "11"
replace mind_16 = "Hospital" if mind_16 == "12"
replace mind_16 = "Medical_except_hospital" if mind_16 == "13"
replace mind_16 = "Educational" if mind_16 == "14"
replace mind_16 = "Social_services" if mind_16 == "15"
replace mind_16 = "Public_administration" if mind_16 == "16"
replace mind_16 = "missing" if mind_16 == "."
*/


****************************************
* Consistent major occupation variable *
****************************************
