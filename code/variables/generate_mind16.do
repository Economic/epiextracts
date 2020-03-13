********************************************************************************
* mind16: Consistent major industry variable
********************************************************************************
gen byte mind16 = .

#delimit ;
if $monthlycps == 1 | $maycps == 1 {;

	/*
	Industry coding for:
	CPS Basic 1976-1982
	CPS ORG 1979-1982
	CPS May 1973-1982
	*/
	if tm(1973m1) <= $date & $date <= tm(1982m12){;
		/* There are no "-1" or "military" observations during this period */

		/* Agriculture, mining, forestry and fisheries */
		replace mind16 = 1 if (
			(indcode == 17) |
			(indcode == 18) |
			(indcode == 19) |
			(indcode == 29) |
			(indcode >= 27 & indcode <= 28) | /* forestry and fisheries*/
			(indcode >= 47 & indcode <= 58) /* mining */
		);
		/* Construction */
		replace mind16 = 2 if
			(indcode >= 67 & indcode <= 78);
		/* Manufacturing, durable goods */
		replace mind16 = 3 if
			(indcode >= 107 & indcode <= 267);
		/* Manufacturing, nondurable goods (incl publishing 338, 339) */
		replace mind16 = 4 if
			(indcode >= 268 & indcode <= 399);
		/* Transportation */
		replace mind16 = 5 if
			(indcode >= 407 & indcode <= 429);
		/* Communications and utilities */
		replace mind16 = 6 if	(
			(indcode >= 447 & indcode <= 449) | /* communications (excl publishing 338, 339) */
			(indcode >= 467 & indcode <= 499) /* utilities */
		);
		/* Wholesale trade */
		replace mind16 = 7 if
			(indcode >= 507 & indcode <= 599);
		/* Retail trade (excl eating and drinking 669) */
		replace mind16 = 8 if	(
			(indcode >= 607 & indcode <= 668) |
			(indcode >= 677 & indcode <= 699)
		);
		/* Finance, insurance and real estate. Business, auto and repair services, and other professional. */
		replace mind16 = 9 if	(
			(indcode >= 707 & indcode <= 719) | /*finance, insurance, and real estate */
			(indcode >= 727 & indcode <= 767) | /* business and repair services */
			(indcode == 849) | /* legal services */
			(indcode == 877) | /* religious orgs */
			(indcode == 887) | /* nonprofit membership orgs */
			(indcode >= 888 & indcode <= 899) /* professional and related */
		);
		/* Personal services, including household */
		replace mind16 = 10 if (
			(indcode == 769) | /* private households */
			(indcode >= 779 & indcode <= 799) /* personal services excl priv households (excl hotels and lodging) */
		);
		/* Entertainment and recreation */
		replace mind16 = 11 if	(
			(indcode == 669) | /* eating and drinking places */
			(indcode == 869) | /* museums */
			(indcode >= 777 & indcode <= 778) | /* hotels and lodging */
			(indcode >= 807 & indcode <= 817)
		);
		/* Hospital */
		replace mind16 = 12 if
			(indcode == 838);
		/* Medical, except hospital */
		replace mind16 = 13 if	(
			(indcode >= 828 & indcode <= 837) |
			(indcode >= 839 & indcode <= 848)
		);
		/* Educational */
		replace mind16 = 14 if
			(indcode >= 857 & indcode <= 868);
		/* Social services */ /* changed to just welfare and res welfare- moved membership/rel to other prof */
		replace mind16 = 15 if
			(indcode >= 878 & indcode <= 879);
		/* Public administration */
		replace mind16 = 16 if
			(indcode >= 907 & indcode <= 947);
	};

	/*
	Industry coding for:
	CPS Basic 1983-1991
	CPS ORG 1983-1991
	*/

	if tm(1983m1) <= $date & $date <= tm(1991m12){;
		/* armed forces & NIU */
		replace mind16 = . if (
			(indcode == -1) |
			(indcode == 991) /*armed forces */
		);
		/* Agriculture, mining, forestry and fisheries*/
		replace mind16 = 1 if	(
			(indcode >= 10 & indcode <= 21) |
			(indcode >= 30 & indcode <= 31) | /* forestry and fishing */
			(indcode >= 40 & indcode <= 50) /* mining */
		);
		/* Construction */
		replace mind16 = 2 if
			(indcode == 60);
		/* Manufacturing, durable goods */
		replace mind16 = 3 if
			(indcode >= 230 & indcode <= 392);
		/* Manufacturing, nondurable goods */
		replace mind16 = 4 if
			(indcode >= 100 & indcode <= 222);
		/* Transportation (incl usps) */
		replace mind16 = 5 if
			(indcode >= 400 & indcode <= 432);
		/* Communications and utilities */
		replace mind16 = 6 if (
			(indcode >= 440 & indcode <= 442) | /* communications (excl publishing)*/
			(indcode >= 460 & indcode <= 472) /*utilities */
		);
		/* Wholesale trade */
		replace mind16 = 7 if
			(indcode >= 500 & indcode <= 571);
		/* Retail trade (excl food and drinking 641 */
		replace mind16 = 8 if (
			(indcode >= 580 & indcode <= 640) |
			(indcode >= 642 & indcode <= 691)
		);
		/* Finance, insurance and real estate. Business, auto and repair services, and other professional. */
		replace mind16 = 9 if	(
			(indcode == 841) | /* legal services */
			(indcode >= 700 & indcode <= 712) | /* finance, insurance and real estate */
			(indcode >= 721 & indcode <= 760) | /* business and repaire services */
			(indcode >= 873 & indcode <= 892) /* professional and related serivces (incl religious, membership) */
		);
		/* Personal services, including household */
		replace mind16 = 10 if	(
			(indcode == 761) | /* private households */
			(indcode >= 771 & indcode <= 791) /* personal services excl private households (excl hotels and lodging) */
		);
		/* Entertainment and recreation */ /* museums=872, accom=762,770 , food=641 */
		replace mind16 = 11 if	(
			(indcode == 872) | /* museums */
			(indcode == 641) | /* eating and drinking places */
			(indcode == 762) | /* hotels/motels */
			(indcode == 770) | /* other lodging */
			(indcode >= 800 & indcode <= 802)
		);
		/* Hospital */
		replace mind16 = 12 if
			(indcode == 831);
		/* Medical, except hospital */
		replace mind16 = 13 if	(
			(indcode >= 812 & indcode <= 830) |
			(indcode >= 832 & indcode <= 840)
		);
		/* Educational */
		replace mind16 = 14 if
			(indcode >= 842 & indcode <= 860);
		/* Social services */
		replace mind16 = 15 if
			(indcode >= 861 & indcode <= 871);
		/* Public administration */
		replace mind16 = 16 if
			(indcode >= 900 & indcode <= 932);
	};

	/*
	Industry coding for:
	CPS Basic 1992-2002
	CPS ORG 1992-2002
	*/

	if tm(1992m1) <= $date & $date <= tm(2002m12){;

		replace mind16 = . if (
			(indcode == -1) |
			(indcode == 991) /*armed forces */
		);

		/* Agriculture, mining, forestry and fisheries */
		replace mind16 = 1 if	(
			(indcode >= 10 & indcode <= 30) |
			(indcode >= 31 & indcode <= 32) | /* forestry and fishing */
			(indcode >= 40 & indcode <= 50) /* mining */
		);
		/* Construction */
		replace mind16 = 2 if
			(indcode == 60);
		/* Manufacturing, durable goods */
		replace mind16 = 3 if
			(indcode >= 230 & indcode <= 392);
		/* Manufacturing, nondurable goods (incl publishing 171, 172) */
		replace mind16 = 4 if
			(indcode >= 100 & indcode <= 222);
		/* Transportation */
		replace mind16 = 5 if
			(indcode >= 400 & indcode <= 432);
		/* Communications and utilities */
		replace mind16 = 6 if	(
			(indcode >= 440 & indcode <= 442) | /* communication (excl publishing 171, 172) */
			(indcode >= 450 & indcode <= 472) /* utilities */
		);
		/* Wholesale trade */
		replace mind16 = 7 if
			(indcode >= 500 & indcode <= 571);
		/* Retail trade (excl food and drinking places 641) */
		replace mind16 = 8 if	(
			(indcode >= 580 & indcode <= 640) |
			(indcode >= 642 & indcode <= 691)
		);
		/* Finance, insurance and real estate. Business, auto and repair services, and other professional. */
		replace mind16 = 9 if	(
			(indcode == 12) | /* vetrinary services */
			(indcode == 841) | /* legal services */
			(indcode >= 700 & indcode <= 712) | /* finance, insurance, and real estate */
			(indcode >= 721 & indcode <= 760) | /* business and repair services */
			(indcode >= 873 & indcode <= 893) /* professional and related services (incl religious and membership) */
		);
		/* Personal services, including household */
		replace mind16 = 10 if	(
			(indcode == 761) | /* private households */
			(indcode >= 771 & indcode <= 791) /* personal services, excluding private households (excl hotels/lodging) */
		);
		/* Entertainment and recreation */
		replace mind16 = 11 if	(
			(indcode == 872) | /* museums */
			(indcode == 641) | /* food and drinking places */
			(indcode == 762) | /* hotels/motels */
			(indcode == 770) | /* other lodging */
			(indcode >= 800 & indcode <= 810)
		);
		/* Hospital */
		replace mind16 = 12 if
			(indcode == 831);
		/* Medical, except hospital */
		replace mind16 = 13 if	(
			(indcode >= 812 & indcode <= 830) |
			(indcode >= 832 & indcode <= 840)
		);
		/* Educational */
		replace mind16 = 14 if
			(indcode >= 842 & indcode <= 860);
		/* Social services */
		replace mind16 = 15 if
			(indcode >= 861 & indcode <= 871);
		/* Public administration */
		replace mind16 = 16 if
			(indcode >= 900 & indcode <= 932);
	};

	/* 2003-present */
	/* I don't think that 2010 census recoding affects major industry */

	if tm(2003m1) <= $date {;

		replace mind16 = . if (
			(indcode == -1) |
			(indcode == 9890) /*armed forces */
		);

		/* Agriculture, mining, forestry and fisheries */
		replace mind16 = 1 if	(
			(indcode >= 0170 & indcode <= 0180) |
			(indcode == 0290) |
			(indcode == 7480) | /* veterinary services */
			(indcode >= 0190 & indcode <= 0280) | /* forestry and fishing */
			(indcode >= 0370 & indcode <= 0490) /* mining */
		);
		/* Construction */
		replace mind16 = 2 if
			(indcode == 0770);
		/* Manufacturing, durable goods */
		replace mind16 = 3 if
			(indcode >= 2470 & indcode <= 3990);
		/* Manufacturing, nondurable goods (incl publishing)  */
		replace mind16 = 4 if	(
			(indcode >= 1070 & indcode <= 2390) |
			(indcode >= 6470 & indcode <= 6480) /* publishing (excl software*/
		);
		/* Transportation */
		replace mind16 = 5 if
			(indcode >= 6070 & indcode <= 6390);
		/* Communications and utilities (treated information as communication) */
		replace mind16 = 6 if	(
			(indcode >= 0570 & indcode <= 0690) | /* utilities */
			(indcode >= 6490 & indcode <= 6780) /* information (excl publishing, incl software publishing */
		);
		/* Wholesale trade */
		replace mind16 = 7 if
			(indcode >= 4070 & indcode <= 4590);
		/* Retail trade */
		replace mind16 = 8 if
			(indcode >= 4670 & indcode <= 5790);
		/* Finance, insurance and real estate. Business, auto and repair services, and other professional. */
		replace mind16 = 9 if	(
			(indcode >= 6870 & indcode <= 7190) | /* finance, insurance, and real estate */
			(indcode >= 7270 & indcode <= 7470) | /* professional serivces (excl veterinary) */
			(indcode >= 7490 & indcode <= 7790) | /* professional serivces (excl veterinary) */
			(indcode >= 8770 & indcode <= 8891) | /* other services (repair) (includes shoe repair after mid 2000's, which used to be in personal services) */
			(indcode >= 9160 & indcode <= 9190) /* other services (religious, membership) */
		);
		/* Personal services, including household */
		replace mind16 = 10 if	(
			(indcode == 9290) | /* private households */
			(indcode >= 8970 & indcode <= 9090) /* personal serivces, excl private households */
		);
		/* Entertainment and recreation (incl food/drinking places, lodging, museums) */
		replace mind16 = 11 if
			(indcode >= 8560 & indcode <= 8690);
		/* Hospital */
		replace mind16 = 12 if
			(indcode == 8190) |
			(indcode == 8191 & year == 2020) |
			(indcode == 8192 & year == 2020); 
		/* Medical, except hospital */
		replace mind16 = 13 if	(
			(indcode >= 7970 & indcode <= 8180) |
			(indcode >= 8270 & indcode <= 8290)
		);
		/* Educational */
		replace mind16 = 14 if
			(indcode >= 7860 & indcode <= 7890);
		/* Social services */
		replace mind16 = 15 if
			(indcode >= 8370 & indcode <= 8470);
		/* Public administration */
		replace mind16 = 16 if
			(indcode >= 9370 & indcode <= 9590);
	};
};
#delimit cr;

/* Confirm major industry is assigned if industry isn't missing or "armed forces" */
assert (mind16 > 0 & mind16 != .) if (indcode > 0 & indcode != . & indcode != 991 & indcode != 9890)

* Add labels
#delimit ;
label define mind16
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
label value mind16 mind16;
#delimit cr ;

label var mind16 "Major industry (consistent)"
notes mind16: Major industry classification, consistent for 1973-present
notes mind16: 1973-1982: ind70
notes mind16: 1983-1991: ind80
notes mind16: 1992-2002: ind90
notes mind16: 2003-2008: ind02
notes mind16: 2009-2013: ind07
notes mind16: 2014-2019: ind12
notes mind16: 2020-present: ind17
