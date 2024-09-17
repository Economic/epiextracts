********************************************************************************
* mocc10: Consistent major occupation variable
********************************************************************************
gen byte mocc10 = .

#delimit ;
if $monthlycps == 1 | $maycps == 1 {;
	/*
	Occupation coding for:
	CPS Basic 1976-1982
	CPS ORG 1979-1982
	CPS May 1973-1982
	*/

	if tm(1973m1) <= $date & $date <= tm(1982m12){;
		/* Managers and professionals */
		replace mocc10 = 1 if (
				/* managers */
				(occcode == 1) |
				(occcode == 192) |
				(occcode >= 195 & occcode <= 220) |
				(occcode >= 222 & occcode <= 225) |
				(occcode >= 230 & occcode <= 245) |
				/* professionals */
				(occcode == 2) |
				(occcode == 84) |
				(occcode == 425) |
				(occcode == 954) |
				(occcode >= 4 & occcode <= 21) |
				(occcode >= 23 & occcode <= 55) |
				(occcode >= 61 & occcode <= 76) |
				(occcode >= 86 & occcode <= 101) |
				(occcode >= 102 & occcode <= 145) |
				(occcode >= 174 & occcode <= 191) |
				(occcode >= 193 & occcode <= 194) |
				(occcode >= 923 & occcode <=924)
				);
		/* Technicians */
		replace mocc10 = 2 if (
				(occcode == 85) |
				(occcode == 926) |
				(occcode >= 80 & occcode <= 83) |
				(occcode >= 150 & occcode <= 173)
				);
		/* Sales */
		replace mocc10 = 3 if (
				(occcode == 22) |
				(occcode == 310) |
				(occcode == 314) |
				(occcode == 363) |
				(occcode >= 260 & occcode <= 285)
				);
		/* Office and admin */
		replace mocc10 = 4 if (
				(occcode == 56) |
				(occcode >= 301 & occcode <= 305) |
				(occcode >= 311 & occcode <= 313) |
				(occcode >= 315 & occcode <= 362) |
				(occcode >= 364 & occcode <= 395)
			);
		/* Personal care and personal services */
		replace mocc10 = 5 if (
				(occcode == 101) |
				(occcode == 505) |
				(occcode == 611) |
				(occcode == 630) |
				(occcode == 925) |
				(occcode == 980) |
				(occcode >= 901 & occcode <= 902) |
				(occcode >= 921 & occcode <= 922) |
				(occcode >= 931 & occcode <= 953) |
				(occcode >= 982 & occcode <= 984)
			);
		/* Protective service */
		replace mocc10 = 6 if (
				(occcode >= 960 & occcode <= 965)
			);
		/* Service (Food prep, buildings and grounds, cleaning) */
		replace mocc10 = 7 if (
				(occcode == 755) |
				(occcode == 981) |
				(occcode >= 903 & occcode <= 916)
			);
		/* Precision production, craft and repair */
		replace mocc10 = 8 if (
				(occcode == 435) |
				(occcode == 453) |
				(occcode == 502) |
				(occcode == 603) |
				(occcode == 642) |
				(occcode >= 401 & occcode <= 421) |
				(occcode >= 426 & occcode <= 433) |
				(occcode >= 440 & occcode <= 441) |
				(occcode >= 443 & occcode <= 445) |
				(occcode >= 461 & occcode <= 495) |
				(occcode >= 506 & occcode <= 514) |
				(occcode >= 516 & occcode <= 525) |
				(occcode >= 534 & occcode <= 542) |
				(occcode >= 545 & occcode <= 601) |
				(occcode >= 613 & occcode <= 615) |
				(occcode >= 631 & occcode <= 633) |
				(occcode >= 636 & occcode <= 640)
			);
		/* Operators, fabricators and laborers */
		replace mocc10 = 9 if (
				(occcode == 221) |
				(occcode == 226) |
				(occcode == 434) |
				(occcode == 436) |
				(occcode == 442) |
				(occcode == 446) |
				(occcode == 452) |
				(occcode == 501) |
				(occcode == 515) |
				(occcode == 543) |
				(occcode == 602) |
				(occcode == 612) |
				(occcode == 641) |
				(occcode == 760) |
				(occcode >= 422 & occcode <= 424) |
				(occcode >= 454 & occcode <= 456) |
				(occcode >= 503 & occcode <= 504) |
				(occcode >= 530 & occcode <= 533) |
				(occcode >= 604 & occcode <= 610) |
				(occcode >= 620 & occcode <= 626) |
				(occcode >= 634 & occcode <= 635) |
				(occcode >= 643 & occcode <= 715) |
				(occcode >= 750 & occcode <= 751) |
				(occcode >= 753 & occcode <= 754) |
				(occcode >= 762 & occcode <= 785)
			);
		/* Agriculture */
		replace mocc10 = 10 if (
				(occcode == 450) |
				(occcode == 740) |
				(occcode == 752) |
				(occcode == 761) |
				(occcode >= 801 & occcode <= 824)
			);
	};

	/*
	Occupation coding for:
	CPS Basic 1983-1991
	CPS ORG 1983-1991
	*/

	if tm(1983m1) <= $date & $date <= tm(1991m12){;
		/* armed forces & NIU */
		replace mocc10 = . if (
			(occcode == -1) |
			(occcode == 905) /*armed forces */
		);
		/* Managers annd professionals  */
		replace mocc10 = 1 if (
				/* managers */
				(occcode == 197) |
				(occcode >= 3 & occcode <= 5) |
				(occcode >= 7 & occcode <= 37) |
				/* professionals */
				(occcode == 467) |
				(occcode >= 43 & occcode <= 59) |
				(occcode >= 64 & occcode <= 174) |
				(occcode >= 176 & occcode <= 195) |
				(occcode >= 198 & occcode <= 199)
			);
		/* Technicians */
		replace mocc10 = 2 if (
				(occcode == 63) |
				(occcode == 867) |
				(occcode >= 203 & occcode <= 235)
			);
		/* Sales */
		replace mocc10 = 3 if (
				(occcode >= 243 & occcode <= 285)
			);
		/* Office and admin */
		replace mocc10 = 4 if (
				(occcode >= 303 & occcode <= 389)
			);
		/* Personal care and personal services */
		replace mocc10 = 5 if (
				(occcode == 175) |
				(occcode == 403) |
				(occcode == 449) |
				(occcode == 454) |
				(occcode == 748) |
				(occcode == 773) |
				(occcode >= 405 & occcode <= 407) |
				(occcode >= 445 & occcode <= 447) |
				(occcode >= 456 & occcode <= 466) |
				(occcode >= 468 & occcode <= 469)
			);
		 /* Protective service */
		replace mocc10 = 6 if (
				(occcode == 6) |
				(occcode >= 413 & occcode <= 427)
			);
		/* Services (Food prep, buildings and grounds, cleaning) */
		replace mocc10 = 7 if (
				(occcode == 404) |
				(occcode == 448) |
				(occcode == 453) |
				(occcode == 455) |
				(occcode >= 433 & occcode <= 444) |
				(occcode >= 485 & occcode <= 486)
			);
		/* Precision production, craft and repair */
		replace mocc10 = 8 if (
				(occcode == 855) |
				(occcode >= 503 & occcode <= 635) |
				(occcode >= 637 & occcode <= 669) |
				(occcode >= 674 & occcode <= 679) |
				(occcode >= 684 & occcode <= 688) |
				(occcode >= 694 & occcode <= 699) |
				(occcode >= 786 & occcode <= 787) |
				(occcode >= 793 & occcode <= 795) |
				(occcode >= 863 & occcode <= 864)
			);
		/* Operators, fabricators and laborers */
		replace mocc10 = 9 if (
				(occcode == 497) |
				(occcode == 636) |
				(occcode == 673) |
				(occcode == 683) |
				(occcode == 789) |
				(occcode >= 689 & occcode <= 693) |
				(occcode >= 703 & occcode <= 747) |
				(occcode >= 749 & occcode <= 769) |
				(occcode >= 774 & occcode <= 785) |
				(occcode >= 796 & occcode <= 853) |
				(occcode >= 856 & occcode <= 859) |
				(occcode >= 865 & occcode <= 866) |
				(occcode >= 869 & occcode <= 889)
			);
		/* Agriculture */
		replace mocc10 = 10 if (
				(occcode >= 473 & occcode <= 484) |
				(occcode >= 487 & occcode <= 496) |
				(occcode >= 498 & occcode <= 499)
			);
	};

	/*
	Occupation coding for:
	CPS Basic 1992-2002
	CPS ORG 1992-2002
	*/

	if tm(1992m1) <= $date & $date <= tm(2002m12){;
		replace mocc10 = . if (
			(occcode == -1) |
			(occcode == 905) /*armed forces */
		);
		/* Managers and professionals */
		replace mocc10 = 1 if (
				/* managers */
				(occcode == 197) |
				(occcode >= 3 & occcode <= 5) |
				(occcode >= 7 & occcode <= 37) |
				/* professionals */
				(occcode == 465) |
				(occcode >= 43 & occcode <= 59) |
				(occcode >= 64 & occcode <= 174) |
				(occcode >= 176 & occcode <= 195) |
				(occcode >= 198 & occcode <= 199)
			);
		/* Technicians */
		replace mocc10 = 2 if (
				(occcode == 63) |
				(occcode == 867) |
				(occcode >= 203 & occcode <= 235)
			);
		/* Sales */
		replace mocc10 = 3 if (
				(occcode >= 243 & occcode <= 285)
			);
		/* Office and admin */
		replace mocc10 = 4 if (
				(occcode == 467) |
				(occcode >= 303 & occcode <= 389)
			);
		/* Personal care and personal services */
		replace mocc10 = 5 if (
				(occcode == 175) |
				(occcode == 403) |
				(occcode == 449) |
				(occcode == 454) |
				(occcode == 466) |
				(occcode == 748) |
				(occcode == 773) |
				(occcode >= 405 & occcode <= 407) |
				(occcode >= 445 & occcode <= 447) |
				(occcode >= 456 & occcode <= 464) |
				(occcode >= 468 & occcode <= 469)
			);
		/* Protective service */
		replace mocc10 = 6 if (
				(occcode == 6) |
				(occcode >= 413 & occcode <= 427)
			);
		/* Service (Food prep, buildings and grounds, cleaning) */
		replace mocc10 = 7 if (
				(occcode == 404) |
				(occcode == 448) |
				(occcode == 453) |
				(occcode == 455) |
				(occcode >= 433 & occcode <= 444) |
				(occcode >= 485 & occcode <= 486)
			);
		/* Precision production, craft and repair */
		replace mocc10 = 8 if (
				(occcode == 855) |
				(occcode >= 503 & occcode <= 635) |
				(occcode >= 637 & occcode <= 679) |
				(occcode >= 684 & occcode <= 688) |
				(occcode >= 694 & occcode <= 699) |
				(occcode >= 786 & occcode <= 787) |
				(occcode >= 793 & occcode <= 795)
			);
		/* Operators, fabricators and laborers */
		replace mocc10 = 9 if (
				(occcode == 497) |
				(occcode == 636) |
				(occcode == 683) |
				(occcode == 789) |
				(occcode >= 689 & occcode <= 693) |
				(occcode >= 703 & occcode <= 747) |
				(occcode >= 749 & occcode <= 769) |
				(occcode >= 774 & occcode <= 785) |
				(occcode >= 796 & occcode <= 853) |
				(occcode >= 856 & occcode <= 866) |
				(occcode >= 868 & occcode <= 869) |
				(occcode >= 869 & occcode <= 889)
			);
		/* Agriculture */
		replace mocc10 = 10 if (
				(occcode >= 473 & occcode <= 484) |
				(occcode >= 487 & occcode <= 496) |
				(occcode >= 498 & occcode <= 499)
			);
	};

	/*
	Occupation coding for:
	CPS Basic 2003-2010m12
	CPS ORG 2003-2010m12
	CPS May 2003-2010m12
	*/

	if tm(2003m1) <= $date & $date <= tm(2010m12){;
		replace mocc10 = . if (
			(occcode == -1) |
			(occcode == 9840)
		);
		/* Managers and professionals */
		replace mocc10 = 1 if (
				/* managers */
				(occcode	== 1310) |
				(occcode	== 2710) |
				(occcode	== 2820) |
				(occcode	== 5000) |
				(occcode	== 6660) |
				(occcode	== 7000) |
				(occcode	== 9000) |
				(occcode 	== 9040) |
				(occcode	>= 10 & occcode <= 160) |
				(occcode	>= 220 & occcode <= 530) |
				(occcode	>= 560 & occcode <= 620) |
				(occcode	>= 710 & occcode <= 800) |
				(occcode	>= 820 & occcode <= 950) |
				/* professionals */
				(occcode	== 700) |
				(occcode	== 1000) |
				(occcode	>= 1040	& occcode <= 1300) |
				(occcode	>= 1320	& occcode <= 1530) |
				(occcode	>= 1600	& occcode <= 1860) |
				(occcode	>= 2000	& occcode <= 2100) |
				(occcode	>= 2200	& occcode <= 2430) |
				(occcode	>= 2550	& occcode <= 2700) |
				(occcode	>= 2720	& occcode <= 2810) |
				(occcode	>= 2830	& occcode <= 2860) |
				(occcode	>= 2910	& occcode <= 3260)
			);
		/* Technicians */
		replace mocc10 = 2 if (
				(occcode	== 2900	) |
				(occcode	== 7900	) |
				(occcode	== 9030 ) |
				(occcode	>= 1010	& occcode <= 1020) |
				(occcode	>= 1540	& occcode <= 1560) |
				(occcode	>= 1900	& occcode <= 1960) |
				(occcode	>= 2140	& occcode <= 2150) |
				(occcode	>= 3300	& occcode <= 3400) |
				(occcode	>= 3500	& occcode <= 3510) |
				(occcode	>= 3530	& occcode <= 3540)
			);
		/* Sales */
		replace mocc10 = 3 if (
				(occcode	== 810	) |
				(occcode	== 5130	) |
				(occcode	>= 4700	& occcode <= 4820) |
				(occcode	>= 4840	& occcode <= 4960)
			);
		/* Office and admin */
		replace mocc10 = 4 if (
				(occcode	== 540) |
				(occcode	== 4830) |
				(occcode	>= 2440	& occcode <= 2540) |
				(occcode	>= 5010	& occcode <= 5120) |
				(occcode	>= 5140	& occcode <= 5930)
			);
		/* Precision production, craft and repair */
		replace mocc10 = 8 if (
				(occcode	== 3410) |
				(occcode	== 3520) |
				(occcode	== 6300) |
				(occcode	== 7740) |
				(occcode	== 7840) |
				(occcode	== 8030) |
				(occcode	== 8060) |
				(occcode	== 8130) |
				(occcode	== 8160) |
				(occcode	== 8330) |
				(occcode	== 8350) |
				(occcode	== 8450) |
				(occcode	>= 6200	& occcode <= 6250) |
				(occcode	>= 6330	& occcode <= 6530) |
				(occcode	>= 6700	& occcode <= 6720) |
				(occcode	>= 6750	& occcode <= 6940) |
				(occcode	>= 7010	& occcode <= 7560) |
				(occcode	>= 7600	& occcode <= 7700) |
				(occcode	>= 7800	& occcode <= 7810) |
				(occcode	>= 8210	& occcode <= 8230) |
				(occcode	>= 8500	& occcode <= 8520) |
				(occcode	>= 8600	& occcode <= 8630) |
				(occcode	>= 8750	& occcode <= 8760) |
				(occcode	>= 8910	& occcode <= 8920)
			);
		/* Operators, fabricators and laborers */
		replace mocc10 = 9 if (
				(occcode	== 6260) |
				(occcode	== 6600) |
				(occcode	== 7750) |
				(occcode	== 7830) |
				(occcode	== 7850) |
				(occcode 	== 8020) |
				(occcode	== 8040) |
				(occcode	== 8200) |
				(occcode	== 8340) |
				(occcode	== 8460) |
				(occcode 	== 8900) |
				(occcode 	== 9410) |
				(occcode 	>= 8100 & occcode <= 8120) |
				(occcode 	>= 6310 & occcode <= 6320) |
				(occcode	>= 6730	& occcode <= 6740) |
				(occcode	>= 7710	& occcode <= 7730) |
				(occcode	>= 7920	& occcode <= 8010) |
				(occcode	>= 8140	& occcode <= 8150) |
				(occcode	>= 8240	& occcode <= 8260) |
				(occcode	>= 8310	& occcode <= 8320) |
				(occcode	>= 8360	& occcode <= 8440) |
				(occcode	>= 8530	& occcode <= 8550) |
				(occcode	>= 8640	& occcode <= 8740) |
				(occcode	>= 8800	& occcode <= 8860) |
				(occcode	>= 8930	& occcode <= 8960) |
				(occcode	>= 9110	& occcode <= 9360) |
				(occcode	>= 9420	& occcode <= 9750)
			);
		 /* Protective service */
		replace mocc10 = 6 if (
				(occcode	>= 3700	& occcode <= 3950)
			);
		/* Service (Food prep, buildings and grounds, cleaning) */
		replace mocc10 = 7 if (
				(occcode	>= 4000	& occcode <= 4220) |
				(occcode	>= 4240	& occcode <= 4250)
			);
		/* Personal care and personal services */
		replace mocc10 = 5 if (
				(occcode	== 4230) |
				(occcode	== 8300) |
				(occcode	>= 3600	& occcode <= 3650) |
				(occcode	>= 4300	& occcode <= 4320) |
				(occcode	>= 4400	& occcode <= 4650)
			);
		/* Agriculture */
		replace mocc10 = 10 if (
				(occcode	>= 200	& occcode <= 210	) |
				(occcode	>= 4340	& occcode <= 4350) |
				(occcode	>= 6000	& occcode <= 6130)
			);
	};

	if tm(2011m1) <= $date & $date <= tm(2019m12){;
		replace mocc10 = . if (
			(occcode == -1) |
			(occcode == 9840) /*armed forces */
		);
		/* Managers and professionals */
		replace mocc10 = 1 if (
				/* managers */
				(occcode	== 1310) |
				(occcode	== 2710) |
				(occcode	== 2825) |
				(occcode	== 5000) |
				(occcode	== 6660) |
				(occcode	== 7000) |
				(occcode	== 9000) |
				(occcode	== 9040) |
				(occcode	== 9050) |
				(occcode	>= 10 & occcode <= 160) |
				(occcode	>= 220 & occcode <= 530) |
				(occcode	>= 560 & occcode <= 650) |
				(occcode	>= 710 & occcode <= 800) |
				(occcode	>= 820 & occcode <= 960) |
				/* professionals */
				(occcode	== 700) |
				(occcode	== 705) |
				(occcode	== 1000) |
				(occcode	>= 1005	& occcode <= 1306) |
				(occcode	>= 1320	& occcode <= 1530) |
				(occcode	>= 1600	& occcode <= 1860) |
				(occcode	>= 2000	& occcode <= 2105) |
				(occcode	>= 2200	& occcode <= 2435) |
				(occcode	>= 2550	& occcode <= 2700) |
				(occcode	>= 2720	& occcode <= 2810) |
				(occcode	>= 2830	& occcode <= 2865) |
				(occcode	>= 2910	& occcode <= 3270)
			);
		/* Technicians */
		replace mocc10 = 2 if (
				(occcode	== 2900	) |
				(occcode	== 7900	) |
				(occcode	== 7905	) |
				(occcode	== 9030 ) |
				(occcode	>= 1010	& occcode <= 1021) |
				(occcode	>= 1540	& occcode <= 1560) |
				(occcode	>= 1900	& occcode <= 1980) |
				(occcode	>= 2145	& occcode <= 2160) |
				(occcode	>= 3300	& occcode <= 3402) |
				(occcode	>= 3500	& occcode <= 3515) |
				(occcode	>= 3530	& occcode <= 3550)
			);
		/* Sales */
		replace mocc10 = 3 if (
				(occcode	== 810	) |
				(occcode	== 5130	) |
				(occcode	>= 4700	& occcode <= 4820) |
				(occcode	>= 4840	& occcode <= 4965)
			);
		/* Office and admin */
		replace mocc10 = 4 if (
				(occcode	== 540) |
				(occcode	== 4830) |
				(occcode	>= 2440	& occcode <= 2545) |
				(occcode	>= 5010	& occcode <= 5120) |
				(occcode	>= 5140	& occcode <= 5940)
			);
		/* Precision production, craft and repair */
		replace mocc10 = 8 if (
				(occcode	== 3420) |
				(occcode	== 3545) |
				(occcode	== 3520) |
				(occcode	== 6300) |
				(occcode	== 6540) |
				(occcode	== 7740) |
				(occcode	== 7840) |
				(occcode	== 8030) |
				(occcode	== 8060) |
				(occcode	== 8130) |
				(occcode	== 8160) |
				(occcode	== 8330) |
				(occcode	== 8350) |
				(occcode	== 8450) |
				(occcode 	>= 3421 & occcode <= 3430) |
				(occcode	>= 6200	& occcode <= 6250) |
				(occcode	>= 6330	& occcode <= 6530) |
				(occcode	>= 6700	& occcode <= 6720) |
				(occcode	>= 6750	& occcode <= 6950) |
				(occcode	>= 7010	& occcode <= 7560) |
				(occcode	>= 7600	& occcode <= 7700) |
				(occcode	>= 7800	& occcode <= 7810) |
				(occcode	>= 8210	& occcode <= 8230) |
				(occcode	>= 8500	& occcode <= 8520) |
				(occcode	>= 8600	& occcode <= 8630) |
				(occcode	>= 8750	& occcode <= 8760) |
				(occcode	>= 8910	& occcode <= 8920)
			);
		/* Operators, fabricators and laborers */
		replace mocc10 = 9 if (
				(occcode	== 6260) |
				(occcode	== 6305) |
				(occcode	== 6600) |
				(occcode	== 7750) |
				(occcode	== 7830) |
				(occcode	== 7850) |
				(occcode	== 7855) |
				(occcode	== 8040) |
				(occcode	== 8200) |
				(occcode	== 8340) |
				(occcode	== 8460) |
				(occcode 	== 8900) |
				(occcode 	== 9410) |
				(occcode 	>= 6310 & occcode <= 6320) |
				(occcode	>= 6730	& occcode <= 6740) |
				(occcode	>= 7710	& occcode <= 7730) |
				(occcode	>= 7920	& occcode <= 8025) |
				(occcode 	>= 8100 & occcode <= 8120) |
				(occcode	>= 8140	& occcode <= 8150) |
				(occcode	>= 8240	& occcode <= 8260) |
				(occcode	>= 8310	& occcode <= 8320) |
				(occcode	>= 8360	& occcode <= 8440) |
				(occcode	>= 8530	& occcode <= 8550) |
				(occcode	>= 8640	& occcode <= 8740) |
				(occcode	>= 8800	& occcode <= 8860) |
				(occcode	>= 8930	& occcode <= 8965) |
				(occcode	>= 9110	& occcode <= 9365) |
				(occcode	>= 9420	& occcode <= 9760)
			);
		 /* Protective service */
		replace mocc10 = 6 if (
				(occcode	>= 3700	& occcode <= 3960)
			);
		/* Service (Food prep, buildings and grounds, cleaning) */
		replace mocc10 = 7 if (
				(occcode	>= 4000	& occcode <= 4220) |
				(occcode	>= 4240	& occcode <= 4255)
			);
		/* Personal care and personal services */
		replace mocc10 = 5 if (
				(occcode	== 4230) |
				(occcode	== 8300) |
				(occcode 	== 9005) |
				(occcode	== 9415) |
				(occcode	>= 3600	& occcode <= 3655) |
				(occcode	>= 4300	& occcode <= 4320) |
				(occcode	>= 4400	& occcode <= 4655)
			);
		/* Agriculture */
		replace mocc10 = 10 if (
				(occcode	>= 200	& occcode <= 210)  |
				(occcode	>= 4340	& occcode <= 4350) |
				(occcode	>= 6000	& occcode <= 6130)
			);
	};
	
	if tm(2020m1) <= $date {;

		replace mocc10 = . if (
				(occcode == -1) |
				(occcode == 9840) /*armed forces */
		);
		/* Managers and professionals */
		replace mocc10 = 1 if (
				/* managers */
				(occcode	== 1310) |
				(occcode	== 2710) |
				(occcode	== 2825) |
				(occcode	== 5000) |
				(occcode	== 6660) |
				(occcode	== 7000) |
				(occcode	== 9005) |
				(occcode	== 9040) |
				(occcode	== 9050) |
				(occcode	>= 10 & occcode <= 160) |
				(occcode	>= 220 & occcode <= 530) |
				(occcode	>= 560 & occcode <= 650) |
				(occcode	>= 710 & occcode <= 800) |
				(occcode	>= 820 & occcode <= 960) |
				/* professionals */
				(occcode	== 700) |
				(occcode	== 705) |
				(occcode	== 1000) |
				(occcode	>= 1005	& occcode <= 1306) |
				(occcode	>= 1320	& occcode <= 1530) |
				(occcode	>= 1600	& occcode <= 1860) |
				(occcode	>= 2000	& occcode <= 2105) |
				(occcode	>= 2200	& occcode <= 2435) |
				(occcode	>= 2550	& occcode <= 2700) |
				(occcode	>= 2720	& occcode <= 2810) |
				(occcode	>= 2830	& occcode <= 2865) |
				(occcode	>= 2910	& occcode <= 3270)
			);
		/* Technicians */
		replace mocc10 = 2 if (
				(occcode	== 2905	) |
				(occcode	== 7900	) |
				(occcode	== 7905	) |
				(occcode	== 9030 ) |
				(occcode	>= 1010	& occcode <= 1021) |
				(occcode	>= 1540	& occcode <= 1560) |
				(occcode	>= 1900	& occcode <= 1980) |
				(occcode	>= 2145	& occcode <= 2180) |
				(occcode	>= 3300	& occcode <= 3402) |
				(occcode	>= 3500	& occcode <= 3515) |
				(occcode	>= 3530	& occcode <= 3550)
			);
		/* Sales */
		replace mocc10 = 3 if (
				(occcode	== 810	) |
				(occcode	== 5130	) |
				(occcode	>= 4700	& occcode <= 4820) |
				(occcode	>= 4840	& occcode <= 4965)
			);
		/* Office and admin */
		replace mocc10 = 4 if (
				(occcode	== 540) |
				(occcode	== 4830) |
				(occcode	>= 2440	& occcode <= 2545) |
				(occcode	>= 5010	& occcode <= 5120) |
				(occcode	>= 5140	& occcode <= 5940)
			);
		/* Precision production, craft and repair */
		replace mocc10 = 8 if (
				(occcode	== 3545) |
				(occcode	== 3520) |
				(occcode	== 6300) |
				(occcode	== 6540) |
				(occcode	== 7740) |
				(occcode	== 7840) |
				(occcode	== 8030) |
				(occcode	== 8060) |
				(occcode	== 8130) |
				(occcode	== 8160) |
				(occcode	== 8335) |
				(occcode	== 8350) |
				(occcode	== 8450) |
				(occcode 	>= 3421 & occcode <= 3430) |
				(occcode	>= 6200	& occcode <= 6250) |
				(occcode	>= 6330	& occcode <= 6530) |
				(occcode	>= 6700	& occcode <= 6720) |
				(occcode	>= 6750	& occcode <= 6950) |
				(occcode	>= 7010	& occcode <= 7560) |
				(occcode	>= 7600	& occcode <= 7700) |
				(occcode	>= 7800	& occcode <= 7810) |
				(occcode	>= 8210	& occcode <= 8230) |
				(occcode	>= 8500	& occcode <= 8510) |
				(occcode	>= 8600	& occcode <= 8630) |
				(occcode	>= 8750	& occcode <= 8760) |
				(occcode	>= 8910	& occcode <= 8920)
			);
		/* Operators, fabricators and laborers */
		replace mocc10 = 9 if (
				(occcode	== 6260) |
				(occcode	== 6305) |
				(occcode	== 6600) |
				(occcode	== 7750) |
				(occcode	== 7830) |
				(occcode	== 8040) |
				(occcode	== 8200) |
				(occcode 	== 8365) |
				(occcode	== 8465) |
				(occcode 	== 8990) |
				(occcode 	== 9410) |
				(occcode 	>= 6310 & occcode <= 6320) |
				(occcode	>= 6730	& occcode <= 6740) |
				(occcode	>= 7710	& occcode <= 7730) |
				(occcode 	>= 7850 & occcode <= 7855) |
				(occcode	>= 7920	& occcode <= 8025) |
				(occcode 	>= 8100 & occcode <= 8120) |
				(occcode	>= 8140	& occcode <= 8150) |
				(occcode	>= 8240	& occcode <= 8260) |
				(occcode	>= 8310	& occcode <= 8320) |
				(occcode	>= 8530	& occcode <= 8555) |
				(occcode	>= 8640	& occcode <= 8740) |
				(occcode	>= 8800	& occcode <= 8865) |
				(occcode	>= 8930	& occcode <= 8965) |
				(occcode	>= 9110	& occcode <= 9365) |
				(occcode	>= 9420	& occcode <= 9760)
			);
		 /* Protective service */
		replace mocc10 = 6 if (
				(occcode	>= 3700	& occcode <= 3960)
			);
		/* Service (Food prep, buildings and grounds, cleaning) */
		replace mocc10 = 7 if (
				(occcode	>= 4000	& occcode <= 4220) |
				(occcode	>= 4240	& occcode <= 4255)
			);
		/* Personal care and personal services */
		replace mocc10 = 5 if (
				(occcode	== 4230) |
				(occcode	== 8300) |
				(occcode	== 9415) |
				(occcode	>= 3600	& occcode <= 3655) |
				(occcode	>= 4300	& occcode <= 4330) |
				(occcode	>= 4400	& occcode <= 4655)
			);
		/* Agriculture */
		replace mocc10 = 10 if (
				(occcode	>= 200	& occcode <= 210)  |
				(occcode	>= 4340	& occcode <= 4350) |
				(occcode	>= 6000	& occcode <= 6130)
			);
	
	};
	
};
#delimit cr ;

#delimit ;
label define occ_lab
1 "Managers and professionals"
2 "Technicians"
3 "Sales"
4 "Office and admin"
5 "Personal care and personal services"
6 "Protective service"
7 "Services"
8 "Precision production, craft and repair"
9 "Operators, fabricators and laborers"
10 "Agriculture"
;
label values mocc10 occ_lab;
#delimit cr ;

label var mocc10 "Major occupation (consistent)"
notes mocc10: Major occupation classification, consistent for 1973-present
notes mocc10: 1973-1982: occ70
notes mocc10: 1983-1991: occ80
notes mocc10: 1992-2002: occ90
notes mocc10: 2003-2010m12: occ00
notes mocc10: 2011m1-2019m12: occ10
notes mocc10: 2020m1-present: occ18
