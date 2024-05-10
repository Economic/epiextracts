/*------------------------------------------------
  by Jean Roth Fri May  8 12:28:03 EDT 2015
	Modified by Zane Mokhiber 3/12/2020 to incorporate changes from the 2020
	dictionary file from the census CPS data site:
    https://www.census.gov/programs-surveys/cps/data/datasets.html
  NOTE:  This program is distributed under the GNU GPL.
  See end of this file and http://www.gnu.org/licenses/ for details.
----------------------------------------------- */



local dat_name "`1'"
local dct_name "`2'"

quietly infile using "`dct_name'", using("`dat_name'") clear

/*------------------------------------------------

  All items, except those with one character, also can have values
  of -1, -2, or -3 even if the values are not in the documentation
  The meaning is
       -1 .Blank or not in universe
       -2 .Don't know
       -3 .Refused

  The following changes in variable names have been made, if necessary:
      '$' to 'd';            '-' to '_';              '%' to 'p';
      ($ = unedited data;     - = edited data;         % = allocated data)

  Decimal places have been made explict in the dictionary file.
  Stata resolves a missing value of -1 / # of decimal places as a missing value.
 -----------------------------------------------*/

** These note statements incorporate variable universes into the Stata data file.
note: by Jean Roth, jroth@nber.org Fri May  8 12:28:03 EDT 2015
note hrmonth: U ALL HHLD's IN SAMPLE
note hryear4: U ALL HHLDs IN SAMPLE
note hurespli: U ALL HHLDs IN SAMPLE
note hufinal: U ALL HHLDs IN SAMPLE
note hetenure: U ALL HHLDs IN SAMPLE
note hehousut: U HRINTSTA = 1 OR HUTYPB = 1-3
note hetelhhd: U ALL HHLDs IN SAMPLE
note hetelavl: U HRINTSTA = 1
note hephoneo: U HETELHHD = 2
note hefaminc: U HETELHHD = 1 OR HETELAVL = 1
note hutypea: U HETELHHD = 1 OR HETELAVL = 1
note hutypb: U HETELHHD = 1 OR HETELAVL = 1
note hutypc: U HETELHHD = 1 OR HETELAVL = 1
note hwhhwgt: U HETELHHD = 1 OR HETELAVL = 1
note hrintsta: U HRINTSTA = 1
note hrnumhou: U ALL HHLDs IN SAMPLE
note hrhtype: U ALL HHLDs IN SAMPLE
note hrmis: U ALL HHLDs IN SAMPLE
note huinttyp: U ALL HHLDs IN SAMPLE
note huprscnt: U ALL HHLDs IN SAMPLE
note hrlonglk: U ALL HHLDs IN SAMPLE
note hrhhid2: U ALL HHLDs IN SAMPLE
note hwhhwtln: U ALL HHLD's IN SAMPLE
note hubus: U HRINTSTA = 1
note hubusl1: U HRINTSTA = 1
note hubusl2: U HRINTSTA = 1
note hubusl3: U HRINTSTA = 1
note hubusl4: U HRINTSTA = 1
note gereg: U HRINTSTA = 1
note gediv: U ALL HHLD's IN SAMPLE
note gestfips: U ALL HHLD's IN SAMPLE
note gtcbsa: U ALL HHLD's IN SAMPLE
note gtco: U ALL HHLD's IN SAMPLE
note gtcbsast: U ALL HHLD's IN SAMPLE
note gtmetsta: U ALL HHLD's IN SAMPLE
note gtindvpc: U ALL HHLD's IN SAMPLE
note gtcbsasz: U ALL HHLD's IN SAMPLE
note gtcsa: U ALL HHLD's IN SAMPLE
note perrp: U ALL HHLD's IN SAMPLE
note prtage: U EVERY PERSON
note prtfage: U PRPERTYP = 1, 2, 0R 3
note pemaritl: U PRPERTYP = 1, 2, 0R 3
note pespouse: U PRTAGE >= 15
note pesex: U PEMARITL = 1
note peafever: U PRPERTYP = 1, 2, 0R 3
note peafnow: U PRTAGE >=17
note peeduca: U PRPERTYP = 2 or 3
note ptdtrace: U PRPERTYP = 2 0R 3
note prdthsp: U PRPERTYP = 2 0R 3
note puchinhh: U PEHSPNON = 1
note pulineno: U PEHSPNON = 1
note prfamnum: U PEHSPNON = 1
note prfamrel: U PRPERTYP = 1, 2, 0R 3
note prfamtyp: U PRPERTYP = 1, 2, 0R 3
note pehspnon: U PRPERTYP = 1, 2, 0R 3
note prmarsta: U PRPERTYP = 1, 2, 0R 3
note prpertyp: U PRPERTYP = 2 0R 3
note penatvty: U ALL HOUSEHOLD MEMBERS
note pemntvty: U PRPERTYP = 1, 2, 0R 3
note pefntvty: U PRPERTYP = 1, 2, 0R 3
note prcitshp: U PRPERTYP = 1, 2, 0R 3
note prcitflg: U PRPERTYP = 1, 2, 0R 3
note prinusyr: U PRPERTYP = 1, 2, 0R 3
note puslfprx: U PRCITSHP = 2, 3, 4, OR 5
note pemlr: U PRCITSHP = 2, 3, 4, OR 5
note puwk: U PRPERTYP = 2
note pubus1: U PRPERTYP = 2
note pubus2ot: U PRPERTYP = 2
note pubusck1: U PRPERTYP = 2
note pubusck2: U PRPERTYP = 2
note pubusck3: U PRPERTYP = 2
note pubusck4: U PRPERTYP = 2
note puretot: U PRPERTYP = 2
note pudis: U PRPERTYP = 2
note peret1: U PRPERTYP = 2
note pudis1: U PEMLR = 5 AND (PURETOT = 1 OR
note pudis2: U PEMLR = 5 AND (PURETOT = 1 OR
note puabsot: U PEMLR = 5 AND (PURETOT = 1 OR
note pulay: U PEMLR = 5 AND (PURETOT = 1 OR
note peabsrsn: U PEMLR = 5 AND (PURETOT = 1 OR
note peabspdo: U PEMLR = 2
note pemjot: U PEABSRSN = 4-12, 14
note pemjnum: U PEMLR = 1, 2
note pehrusl1: U PEMJOT = 1
note pehrusl2: U PEMJOT = 1 OR 2 AND PEMLR = 1 OR 2
note pehrftpt: U PEMJOT = 1 AND PEMLR = 1 OR 2
note pehruslt: U PEHRUSL1 = -4 OR PEHRUSL2 = -4
note pehrwant: U PEMLR = 1 OR 2
note pehrrsn1: U PEMLR = 1 AND (PEHRUSLT = 0-34
note pehrrsn2: U PEHRWANT = 1 (PEMLR = 1 AND PEHRUSLT < 35)
note pehrrsn3: U PEHRWANT = 2 (PEMLR = 1 AND PEHRUSLT < 35)
note puhroff1: U PEHRACTT = 1-34 AND PUHRCK7 NE 1, 2
note puhroff2: U PEHRACTT = 1-34 AND PUHRCK7 NE 1, 2
note puhrot1: U PEHRACTT = 1-34 AND PUHRCK7 NE 1, 2
note puhrot2: U PEHRACTT = 1-34 AND PUHRCK7 NE 1, 2
note pehract1: U PEHRACTT = 1-34 AND PUHRCK7 NE 1, 2
note pehract2: U PEMLR = 1
note pehractt: U PEMLR = 1 AND PEMJOT = 1
note pehravl: U PEMLR = 1
note puhrck1: U PEHRACTT = 1-34 (PEMLR = 1 AND
note puhrck2: U PEHRACTT = 1-34 (PEMLR = 1 AND
note puhrck3: U PEHRACTT = 1-34 (PEMLR = 1 AND
note puhrck4: U PEHRACTT = 1-34 (PEMLR = 1 AND
note puhrck5: U PEHRACTT = 1-34 (PEMLR = 1 AND
note puhrck6: U PEHRACTT = 1-34 (PEMLR = 1 AND
note puhrck7: U PEHRACTT = 1-34 (PEMLR = 1 AND
note puhrck12: U PEHRACTT = 1-34 (PEMLR = 1 AND
note pulaydt: U PEHRACTT = 1-34 (PEMLR = 1 AND
note pulay6m: U PEHRACTT = 1-34 (PEMLR = 1 AND
note pelayavl: U PEHRACTT = 1-34 (PEMLR = 1 AND
note pulayavr: U PEMLR = 3
note pelaylk: U PEMLR = 3
note pelaydur: U PELAYAVL= 1, 2
note pelayfto: U PELAYLK = 1, 2
note pulayck1: U PELAYDUR = 0-120
note pulayck2: U PELAYDUR = 0-120
note pulayck3: U PELAYDUR = 0-120
note pulk: U PELAYDUR = 0-120
note pelkm1: U PELAYDUR = 0-120
note pulkm2: U PEMLR = 4
note pulkm3: U PEMLR = 4
note pulkm4: U PEMLR = 4
note pulkm5: U PEMLR = 4
note pulkm6: U PEMLR = 4
note pulkdk1: U PEMLR = 4
note pulkdk2: U PEMLR = 4
note pulkdk3: U PEMLR = 4
note pulkdk4: U PEMLR = 4
note pulkdk5: U PEMLR = 4
note pulkdk6: U PEMLR = 4
note pulkps1: U PEMLR = 4
note pulkps2: U PEMLR = 4
note pulkps3: U PEMLR = 4
note pulkps4: U PEMLR = 4
note pulkps5: U PEMLR = 4
note pulkps6: U PEMLR = 4
note pelkavl: U PEMLR = 4
note pulkavr: U PELKM1 = 1 - 13
note pelkll1o: U PELKM1 = 1 - 13
note pelkll2o: U PELKAVL = 1-2
note pelklwo: U PELKLL1O = 1 OR 3
note pelkdur: U PELKLL1O = 1 - 4
note pelkfto: U PELKLWO = 1 - 3
note pedwwnto: U PELKDUR = 0-120
note pedwrsn: U PUDWCK1 = 3, 4, -1
note pedwlko: U PUDWCK4 = 4, -1
note pedwwk: U (PUDWCK4 = 1-3) or (PEDWRSN = 1-11)
note pedw4wk: U PEDWLKO = 1
note pedwlkwk: U PEDWWK = 1
note pedwavl: U PEDW4WK = 2
note pedwavr: U (PEDWWK = 2) or (PEDWLKWK = 1)
note pudwck1: U PEDWAVL = 2
note pudwck2: U PEDWAVL = 2
note pudwck3: U PEDWAVL = 2
note pudwck4: U PEDWAVL = 2
note pudwck5: U PEDWAVL = 2
note pejhwko: U PEDWAVL = 2
note pujhdp1o: U HRMIS = 4 or 8 AND PEMLR = 5, 6, AND 7
note pejhrsn: U HRMIS = 4 or 8 AND PEMLR = 5, 6, AND 7
note pejhwant: U PEJHWKO = 1
note pujhck1: U (PEJHWKO = 2) or (PEJHRSN = 1-8)
note pujhck2: U (PEJHWKO = 2) or (PEJHRSN = 1-8)
note prabsrea: U (PEJHWKO = 2) or (PEJHRSN = 1-8)
note prcivlf: U PEMLR = 2
note prdisc: U PEMLR = 1-7
note premphrs: U PRJOBSEA = 1-4
note prempnot: U PEMLR = 1-7
note prexplf: U PEMLR = 1-7
note prftlf: U PEMLR = 1-4 AND
note prhrusl: U PEMLR = 1-4
note prjobsea: U PEMLR = 1-2
note prpthrs: U PRWNTJOB = 1
note prptrea: U PEMLR = 1 AND
note prunedur: U PEMLR = 1 AND
note pruntype: U PEMLR = 3-4
note prwksch: U PEMLR = 3-4
note prwkstat: U PEMLR = 1 - 7
note prwntjob: U PEMLR = 1-7
note pujhck3: U PEMLR = 5-7
note pujhck4: U PEMLR = 5-7
note pujhck5: U PEMLR = 5-7
note puiodp1: U PEMLR = 5-7
note puiodp2: U PEMLR = 5-7
note puiodp3: U PEMLR = 5-7
note peio1cow: U PEMLR = 5-7
note puio1mfg: U (PEMLR = 1-3) OR
note peio2cow: U (PEMLR = 1-3) OR
note puio2mfg: U PRIOELG = 1 and PEMJOT = 1 AND HRMIS = 4,8
note puiock1: U PRIOELG = 1 and PEMJOT = 1 AND HRMIS = 4,8
note puiock2: U PRIOELG = 1 and PEMJOT = 1 AND HRMIS = 4,8
note puiock3: U PRIOELG = 1 and PEMJOT = 1 AND HRMIS = 4,8
note prioelg: U PRIOELG = 1 and PEMJOT = 1 AND HRMIS = 4,8
note pragna: U PEMLR = 1-3,
note prcow1: U PRIOELG = 1
note prcow2: U PRIOELG = 1
note prcowpg: U PRIOELG = 1 AND PEMJOT = 1 AND
note prdtcow1: U PEIO1COW = 1 - 5
note prdtcow2: U PRIOELG = 1
note prdtind1: U PRIOELG = 1 AND PEMJOT = 1 AND
note prdtind2: U PRIOELG = 1
note prdtocc1: U PRIOELG = 1 AND PEMJOT = 1 AND HRMIS = 4 OR 8
note prdtocc2: U PRIOELG = 1
note premp: U PRIOELG = 1 AND PEMJOT = 1 AND HRMIS = 4 OR 8
note prmjind1: U PEMLR = 1 OR 2
note prmjind2: U PRDTIND1 = 1-51
note prmjocc1: U PRDTIND2 = 1-51
note prmjocc2: U PRDTOCC1 = 1-46
note prmjocgr: U PRDTOCC2 = 1-46
note prnagpws: U PRMJOCC = 1-11
note prnagws: U PRCOW1 = 1 AND
note prsjmj: U PEMLR = 1-4
note prerelg: U PEMLR = 1 OR 2
note peernuot: U PEMLR = 1-2 AND HRMIS = 4 OR 8
note peernper: U PRERELG = 1
note peernrt: U PRERELG = 1
note peernhry: U PEERNPER = 2-7
note pternh1c: U PRERELG = 1
note pternh2: U PRERELG = 1
note peernh1o: U PEERNRT = 1
note pternhly: U PEERNPER = 1
note pthr: U PEERNPER = 1 OR PEERNRT = 1
note peernhro: U PEERNPER = 1 OR PEERNRT = 1
note pternwa: U PEERNH1O = ENTRY
note ptwk: U PRERELG = 1
note peern: U PRERELG = 1
note ptern2: U PEERNUOT = 1 AND PEERNPER = 1
note ptot: U PEERNUOT = 1 AND PEERNPER = 1
note peernwkp: U PEERNUOT = 1 AND PEERNPER = 1
note peernlab: U PEERNPER = 6
note peerncov: U (PEIO1COW = 1-5 AND PEMLR = 1-2
note penlfjh: U (PEIO1COW = 1-5 AND PEMLR = 1-2
note penlfret: U HRMIS = 4 OR 8 AND PEMLR = 3-7
note penlfact: U PRTAGE = 50+ AND PEMLR = 3-7
note punlfck1: U (PRTAGE = 14-49) or (PENLFRET = 2)
note punlfck2: U (PRTAGE = 14-49) or (PENLFRET = 2)
note peschenr: U (PRTAGE = 14-49) or (PENLFRET = 2)
note peschft: U PRPERTYP = 2 and PRTAGE = 16-54
note peschlvl: U PESCHLVL = 1, 2
note prnlfsch: U PESCHENR = 1
note pwfmwgt: U PENLFACT = -1 OR 1-6 AND PRTAGE = 16-24
note pwlgwgt: U PRPERTYP = 1-3
note pworwgt: U PRPERTYP = 2
note pwsswgt: U PRPERTYP = 2
note pwvetwgt: U PRPERTYP = 1-3
note prchld: U PRPERTYP = 2
note prnmchld: U PRFAMREL = 1 or 2
note pxpdemp1: U PRFAMREL = 1 or 2
note prwernal: U PRFAMREL = 1 or 2
note prhernal: U PRERELG = 1
note hxtenure: U PRERNHRY = 1
note hxhousut: U PRERNHRY = 1
note hxtelhhd: U PRERNHRY = 1
note hxtelavl: U PRERNHRY = 1
note hxphoneo: U PRERNHRY = 1
note pxinusyr: U PRERNHRY = 1
note pxrrp: U PRERNHRY = 1
note pxparent: U PRERNHRY = 1
note pxage: U PRERNHRY = 1
note pxmaritl: U PRERNHRY = 1
note pxspouse: U PRERNHRY = 1
note pxsex: U PRERNHRY = 1
note pxafwhn1: U PRERNHRY = 1
note pxafnow: U PRERNHRY = 1
note pxeduca: U PRERNHRY = 1
note pxrace1: U PRERNHRY = 1
note pxnatvty: U PRERNHRY = 1
note pxmntvty: U PRERNHRY = 1
note pxfntvty: U PRERNHRY = 1
note pxnmemp1: U PRERNHRY = 1
note pxhspnon: U PRERNHRY = 1
note pxmlr: U PRERNHRY = 1
note pxret1: U PRERNHRY = 1
note pxabsrsn: U PRERNHRY = 1
note pxabspdo: U PRERNHRY = 1
note pxmjot: U PRERNHRY = 1
note pxmjnum: U PRERNHRY = 1
note pxhrusl1: U PRERNHRY = 1
note pxhrusl2: U PRERNHRY = 1
note pxhrftpt: U PRERNHRY = 1
note pxhruslt: U PRERNHRY = 1
note pxhrwant: U PRERNHRY = 1
note pxhrrsn1: U PRERNHRY = 1
note pxhrrsn2: U PRERNHRY = 1
note pxhract1: U PRERNHRY = 1
note pxhract2: U PRERNHRY = 1
note pxhractt: U PRERNHRY = 1
note pxhrrsn3: U PRERNHRY = 1
note pxhravl: U PRERNHRY = 1
note pxlayavl: U PRERNHRY = 1
note pxlaylk: U PRERNHRY = 1
note pxlaydur: U PRERNHRY = 1
note pxlayfto: U PRERNHRY = 1
note pxlkm1: U PRERNHRY = 1
note pxlkavl: U PRERNHRY = 1
note pxlkll1o: U PRERNHRY = 1
note pxlkll2o: U PRERNHRY = 1
note pxlklwo: U PRERNHRY = 1
note pxlkdur: U PRERNHRY = 1
note pxlkfto: U PRERNHRY = 1
note pxdwwnto: U PRERNHRY = 1
note pxdwrsn: U PRERNHRY = 1
note pxdwlko: U PRERNHRY = 1
note pxdwwk: U PRERNHRY = 1
note pxdw4wk: U PRERNHRY = 1
note pxdwlkwk: U PRERNHRY = 1
note pxdwavl: U PRERNHRY = 1
note pxdwavr: U PRERNHRY = 1
note pxjhwko: U PRERNHRY = 1
note pxjhrsn: U PRERNHRY = 1
note pxjhwant: U PRERNHRY = 1
note pxio1cow: U PRERNHRY = 1
note pxio1icd: U PRERNHRY = 1
note pxio1ocd: U PRERNHRY = 1
note pxio2cow: U PRERNHRY = 1
note pxio2icd: U PRERNHRY = 1
note pxio2ocd: U PRERNHRY = 1
note pxernuot: U PRERNHRY = 1
note pxernper: U PRERNHRY = 1
note pxernh1o: U PRERNHRY = 1
note pxernhro: U PRERNHRY = 1
note pxern: U PRERNHRY = 1
note pxpdemp2: U PRERNHRY = 1
note pxnmemp2: U PRERNHRY = 1
note pxernwkp: U PRERNHRY = 1
note pxernrt: U PRERNHRY = 1
note pxernhry: U PRERNHRY = 1
note pxernh2: U PRERNHRY = 1
note pxernlab: U PRERNHRY = 1
note pxerncov: U PRERNHRY = 1
note pxnlfjh: U PRERNHRY = 1
note pxnlfret: U PRERNHRY = 1
note pxnlfact: U PRERNHRY = 1
note pxschenr: U PRERNHRY = 1
note pxschft: U PRERNHRY = 1
note pxschlvl: U PRERNHRY = 1
note qstnum: U PRERNHRY = 1
note occurnum: U PRERNHRY = 1
note pedipged: U PRERNHRY = 1
note pehgcomp: U PRERNHRY = 1
note pecyc: U PRERNHRY = 1
note pxdipged: U PEEDUCA =40-42
note pxhgcomp: U PEEDUCA =40-42
note pxcyc: U PEEDUCA =40-42
note pwcmpwgt: U PEEDUCA =40-42
note peio1icd: U PRPERTYP = 2 AND
note ptio1ocd: U (PEMLR = 1-3)
note peio2icd: U (PEMLR = 1-3)
note ptio2ocd: U PEMJOT = 1 AND HRMIS = 4 OR 8
note primind1: U PEMJOT = 1 AND HRMIS = 4 OR 8
note primind2: U PRIOELG = 1
note peafwhn1: U PRIOELG = 1 AND PEMJOT = 1 AND HRMIS = 4 OR 8
note peafwhn2: U PEAFEVER = 1
note peafwhn3: U PEAFEVER = 1
note peafwhn4: U PEAFEVER = 1
note pxafever: U PEAFEVER = 1
note pepar2typ: U ALL
note pepar2typ: U ALL
note pecohab: U ALL
note pxpar2: U ALL
note pxpar1: U ALL
note pxpar2typ: U ALL
note pxpar1typ: U ALL
note pxcohab: U ALL
note pedisear: U ALL
note pediseye: U PRPERTYP = 2
note pedisrem: U PRPERTYP = 2
note pedisphy: U PRPERTYP = 2
note pedisdrs: U PRPERTYP = 2
note pedisout: U PRPERTYP = 2
note prdisflg: U PRPERTYP = 2
note pxdisear: U PEDISEAR OR
note pxdiseye: U PEDISEAR OR
note pxdisrem: U PEDISEAR OR
note pxdisphy: U PEDISEAR OR
note pxdisdrs: U PEDISEAR OR
note pxdisout: U PEDISEAR OR
note hxfaminc: U PEDISEAR OR
note prdasian: U PEDISEAR OR
note pepdemp1: U PTDTRACE = 4
note ptnmemp1: U HRMIS = 3 or 4 and
note pepdemp2: U PEPDEMP1 = 1
note ptnmemp2: U HRMIS = 3 or 4 and
*Everything below this point, aside from the final save, are value labels

#delimit ;

;
label values hufinal  hufinal;
label define hufinal
	1           "FULLY COMPLETE CATI INTERVIEW"
	2           "PARTIALLY COMPLETED CATI INTERVIEW"
	3           "COMPLETE BUT PERSONAL VISIT REQUESTED NEXT MONTH"
	4           "PARTIAL, NOT COMPLETE AT CLOSEOUT"
	5           "LABOR FORCE COMPLETE, SUPPLEMENT INCOMPLETE - CATI"
	6           "LF COMPLETE, SUPPLEMENT DK ITEMS INCOMPLETE AT CLOSEOUT-ASEC ONLY"
	20          "HH OCCUPIED ENTIRELY BY ARMED FORCES MEMBERS OR ALL UNDER 15 YEARS OF AGE"
	201         "CAPI COMPLETE"
	202         "CALLBACK NEEDED"
	203         "SUFFICIENT PARTIAL - PRECLOSEOUT"
	204         "SUFFICIENT PARTIAL - AT CLOSEOUT"
	205         "LABOR FORCE COMPLETE, - SUPPL. INCOMPLETE - CAPI"
	213         "LANGUAGE BARRIER"
	214         "UNABLE TO LOCATE"
	216         "NO ONE HOME"
	217         "TEMPORARILY ABSENT"
	218         "REFUSED"
	219         "OTHER OCCUPIED - SPECIFY"
	223         "ENTIRE HOUSEHOLD ARMED FORCES"
	224         "ENTIRE HOUSEHOLD UNDER 15"
	225         "TEMP. OCCUPIED W/PERSONS WITH URE"
	226         "VACANT REGULAR"
	227         "VACANT - STORAGE OF HHLD FURNITURE"
	228         "UNFIT, TO BE DEMOLISHED"
	229         "UNDER CONSTRUCTION, NOT READY"
	230         "CONVERTED TO TEMP BUSINESS OR STORAGE"
	231         "UNOCCUPIED TENT OR TRAILER SITE"
	232         "PERMIT GRANTED - CONSTRUCTION NOT STARTED"
	233         "OTHER - SPECIFY"
	240         "DEMOLISHED"
	241         "HOUSE OR TRAILER MOVED"
	242         "OUTSIDE SEGMENT"
	243         "CONVERTED TO PERM. BUSINESS OR STORAGE"
	244         "MERGED"
	245         "CONDEMNED"
	246         "BUILT AFTER APRIL 1, 2000"
	247         "UNUSED SERIAL NO./LISTING SHEET LINE"
	248         "OTHER - SPECIFY"
    258	        "UNLOCATABLE SAMPLE ADDRESS"
    259	        "UNIT DOES NOT EXIST/OUT OF SCOPE"
	256         "REMOVED DURING SUB-SAMPLING"
	257         "UNIT ALREADY HAD A CHANCE OF SELECTION"
;

label values hetenure hetenure;
label define hetenure
	1           "OWNED OR BEING BOUGHT BY A HH MEMBER"
	2           "RENTED FOR CASH"
	3           "OCCUPIED WITHOUT PAYMENT OF CASH RENT"
;
label values hehousut hehousut;
label define hehousut
	0           "OTHER UNIT"
	1           "HOUSE, APARTMENT, FLAT"
	2           "HU IN NONTRANSIENT HOTEL, MOTEL, ETC."
	3           "HU PERMANENT IN TRANSIENT HOTEL, MOTEL"
	4           "HU IN ROOMING HOUSE"
	5           "MOBILE HOME OR TRAILER W/NO PERM. ROOM ADDED"
	6           "MOBILE HOME OR TRAILER W/1 OR MORE PERM. ROOMS ADDED"
	7           "HU NOT SPECIFIED ABOVE"
	8           "QUARTERS NOT HU IN ROOMING OR BRDING HS"
	9           "UNIT NOT PERM. IN TRANSIENT HOTL, MOTL"
	10          "UNOCCUPIED TENT SITE OR TRLR SITE"
	11          "STUDENT QUARTERS IN COLLEGE DORM"
	12          "OTHER UNIT NOT SPECIFIED ABOVE"
;
label values hetelhhd hetelhhd;
label define hetelhhd
	1           "YES"
	2           "NO"
;
label values hetelavl hetelavl;
label define hetelavl
	1           "YES"
	2           "NO"
;
label values hephoneo hephoneo;
label define hephoneo
	1           "YES"
	0           "NO"
;
label values hefaminc hefaminc;
label define hefaminc
	1           "LESS THAN $5,000"
	2           "5,000 TO 7,499"
	3           "7,500 TO 9,999"
	4           "10,000 TO 12,499"
	5           "12,500 TO 14,999"
	6           "15,000 TO 19,999"
	7           "20,000 TO 24,999"
	8           "25,000 TO 29,999"
	9           "30,000 TO 34,999"
	10          "35,000 TO 39,999"
	11          "40,000 TO 49,999"
	12          "50,000 TO 59,999"
	13          "60,000 TO 74,999"
	14          "75,000 TO 99,999"
	15          "100,000 TO 149,999"
	16          "150,000 OR MORE"
;
label values hutypea  hutypea;
label define hutypea
	1           "NO ONE HOME (NOH)"
	2           "TEMPORARILY ABSENT (TA)"
	3           "REFUSED (REF)"
	4           "LANGUAGE BARRIER"
	5           "UNABLE TO LOCATE"
	6           "OTHER OCCUPIED - SPECIFY"
;
label values hutypb   hutypb;
label define hutypb
	1           "VACANT REGULAR"
	2           "TEMPORARILY OCCUPIED BY PERSONS W/ URE"
	3           "VACANT-STORAGE OF HHLD FURNITURE"
	4           "UNFIT OR TO BE DEMOLISHED"
	5           "UNDER CONSTRUCTION, NOT READY"
	6           "CONVERTED TO TEMP BUSINESS OR STORAGE"
	7           "UNOCCUPIED TENT SITE OR TRAILER SITE"
	8           "PERMIT GRANTED CONSTRUCTION NOT STARTED"
	9           "OTHER TYPE B - SPECIFY"
;
label values hutypc   hutypc;
label define hutypc
	1           "DEMOLISHED"
	2           "HOUSE OR TRAILER MOVED"
	3           "OUTSIDE SEGMENT"
	4           "CONVERTED TO PERM. BUSINESS OR STORAGE"
	5           "MERGED"
	6           "CONDEMNED"
    7           "UNUSED LINE OF LISTING SHEET"    
	8           "UNLOCATABLE SAMPLE ADDRESS"
	9           "UNIT DOES NOT EXIST/OUT OF SCOPE"
    10          "OTHER - SPECIFY"
;
label values hrintsta hrintsta;
label define hrintsta
	1           "INTERVIEW"
	2           "TYPE A NON-INTERVIEW"
	3           "TYPE B NON-INTERVIEW"
	4           "TYPE C NON-INTERVIEW"
;
label values hrhtype  hrhtype;
label define hrhtype
	0           "NON-INTERVIEW HOUSEHOLD"
	1           "HUSBAND/WIFE PRIMARY FAMILY (NEITHER AF)"
	2           "HUSB/WIFE PRIM. FAMILY (EITHER/BOTH AF)"
	3           "UNMARRIED CIVILIAN MALE-PRIM. FAM HHLDER"
	4           "UNMARRIED CIV. FEMALE-PRIM FAM HHLDER"
	5           "PRIMARY FAMILY HHLDER-RP IN AF, UNMAR."
	6           "CIVILIAN MALE PRIMARY INDIVIDUAL"
	7           "CIVILIAN FEMALE PRIMARY INDIVIDUAL"
	8           "PRIMARY INDIVIDUAL HHLD-RP IN AF"
	9           "GROUP QUARTERS WITH FAMILY"
	10          "GROUP QUARTERS WITHOUT FAMILY"
;
label values huinttyp huinttyp;
label define huinttyp
	0           "NONINTERVIEW/INDETERMINATE"
	1           "PERSONAL"
	2           "TELEPHONE"
;
label values hrlonglk hrlonglk;
label define hrlonglk
	0           "MIS 1 OR REPLACEMENT HH (NO LINK)"
	2           "MIS 2-4 OR MIS 6-8"
	3           "MIS 5"
;
label values hubus    hubus;
label define hubus
	1           "YES"
	2           "NO"
;
label values gereg    gereg;
label define gereg
	1           "NORTHEAST"
	2           "MIDWEST (FORMERLY NORTH CENTRAL)"
	3           "SOUTH"
	4           "WEST"
;
label values gediv    gediv;
label define gediv
	1           "NEW ENGLAND"
	2           "MIDDLE ATLANTIC"
	3           "EAST NORTH CENTRAL"
	4           "WEST NORTH CENTRAL"
	5           "SOUTH ATLANTIC"
	6           "EAST SOUTH CENTRAL"
	7           "WEST SOUTH CENTRAL"
	8           "MOUNTAIN"
	9           "PACIFIC"
;
label values gestfips gestfips;
label define gestfips
	1           "AL"
	2           "AK"
	4           "AZ"
	5           "AR"
	6           "CA"
	8           "CO"
	9           "CT"
	10          "DE"
	11          "DC"
	12          "FL"
	13          "GA"
	15          "HI"
	16          "ID"
	17          "IL"
	18          "IN"
	19          "IA"
	20          "KS"
	21          "KY"
	22          "LA"
	23          "ME"
	24          "MD"
	25          "MA"
	26          "MI"
	27          "MN"
	28          "MS"
	29          "MO"
	30          "MT"
	31          "NE"
	32          "NV"
	33          "NH"
	34          "NJ"
	35          "NM"
	36          "NY"
	37          "NC"
	38          "ND"
	39          "OH"
	40          "OK"
	41          "OR"
	42          "PA"
	44          "RI"
	45          "SC"
	46          "SD"
	47          "TN"
	48          "TX"
	49          "UT"
	50          "VT"
	51          "VA"
	53          "WA"
	54          "WV"
	55          "WI"
	56          "WY"
;
label values gtcbsa   gtcbsa;
label define gtcbsa
	10500       "Albany, GA (Baker, Terrell, and Worth Counties not in sample)"
	10580       "Albany-Schenectady-Troy, NY"
	10740       "Albuquerque, NM"
	10900       "Allentown-Bethlehem-Easton, PA-NJ"
	11020       "Altoona, PA"
	11100       "Amarillo, TX (Armstrong and Carson Counties not in sample)"
	11300       "Anderson, IN"
	11340       "Anderson, SC"
	11460       "Ann Arbor, MI"
	11500       "Anniston-Oxford, AL"
	11540       "Appleton, WI"
	11700       "Asheville, NC (Haywood and Madison Counties not in sample)"
	12020       "Athens-Clarke County, GA (Oglethorpe County not in sample)"
	12060       "Atlanta-Sandy Springs-Marietta, GA (Haralson, Heard, Jasper, Meriwether and Spalding Counties not in sample)"
	12100       "Atlantic City, NJ"
	12260       "Augusta-Richmond County, GA-SC"
	12420       "Austin-Round Rock, TX"
	12540       "Bakersfield, CA"
	12580       "Baltimore-Towson, MD"
	12940       "Baton Rouge, LA"
	13140       "Beaumont-Port Arthur, TX"
	13380       "Bellingham, WA"
	13460       "Bend, OR"
	13740       "Billings, MT (Carbon County not in sample)"
	13780       "Binghamton, NY"
	13820       "Birmingham-Hoover, AL"
	14020       "Bloomington, IN (Owen County not in sample)"
	14060       "Bloomington-Normal IL"
	14260       "Boise City-Nampa, ID (Owyhee County not in sample)"
	14500       "Boulder, CO"
	14540       "Bowling Green, KY"
	14740       "Bremerton-Silverdale, WA"
	15180       "Brownsville-Harlingen, TX"
	15380       "Buffalo-Niagara Falls, NY"
	15940       "Canton-Massillon, OH"
	15980       "Cape Coral-Fort Myers, FL"
	16300       "Cedar Rapids, IA (Benton and Jones Counties not in sample)"
	16580       "Champaign-Urbana, IL (Ford County not in sample)"
	16620       "Charleston, WV (Clay County not in sample)"
	16700       "Charleston-North Charleston, SC"
	16740       "Charlotte-Gastonia-Concord, NC-SC (Anson County, NC not in sample)"
	16860       "Chattanooga, TN-GA"
	16980       "Chicago-Naperville-Joliet, IL-IN-WI (DeKalb, IL; Jasper, IN; and Kenosha, WI Counties not in sample)"
	17020       "Chico, CA"
	17140       "Cincinnati-Middletown, OH-KY-IN (Franklin County , IN not in sample; Dearborn and Ohio Counties, IN not identified)"
	17460       "Cleveland-Elyria-Mentor, OH"
	17660       "Coeur d'Alene, ID"
	17820       "Colorado Springs, CO"
	17860       "Columbia, MO (Howard County not in sample)"
	17900       "Columbia, SC"
	17980       "Columbus, GA-AL (Harris County, GA and Russell County, Alabama not in sample)"
	18140       "Columbus, OH (Morrow County not in sample)"
	18580       "Corpus Christi, TX"
	19100       "Dallas-Fort Worth-Arlington, TX (Delta and Hunt Counties not in sample)"
	19340       "Davenport-Moline-Rock Island, IA-IL"
	19380       "Dayton, OH"
	19460       "Decatur, Al"
	19500       "Decatur, IL"
	19660       "Deltona-Daytona Beach-Ormond Beach, FL"
	19740       "Denver-Aurora, CO"
	19780       "Des Moines, IA"
	19820       "Detroit-Warren-Livonia, MI"
	20100       "Dover, DE"
	20260       "Duluth, MN-WI (Carlton County, MN not in sample, WI portion not identified)"
	20500       "Durham, NC"
	20740       "Eau Claire, WI"
	20940       "El Centro, CA"
	21340       "El Paso, TX"
	21500       "Erie, PA"
	21660       "Eugene-Springfield, OR"
	21780       "Evansville, IN-KY (Gibson County, IN and Kentucky portion not in sample)"
	22020       "Fargo, ND-MN (MN portion not identified)"
	22140       "Farmington, NM"
	22180       "Fayetteville, NC"
	22220       "Fayetteville-Springdale-Rogers, AR-MO (Madison County, AR and Missouri portion not in sample)"
	22420       "Flint, MI"
	22460       "Florence, AL"
	22660       "Fort Collins-Loveland, CO"
	22900       "Fort Smith, AR-OK (Oklahoma portion not in sample)"
	23020       "Fort Walton Beach-Crestview-Destin, FL"
	23060       "Fort Wayne, IN"
	23420       "Fresno, CA"
	23540       "Gainesville, FL (Gilchrist County not in sample)"
	24340       "Grand Rapids-Wyoming, MI"
	24540       "Greeley, CO"
	24580       "Green Bay, WI (Oconto County not in sample)"
	24660       "Greensboro-High Point, NC"
	24860       "Greenville, SC (Laurens and Pickens Counties not in sample)"
	25060       "Gulfport-Biloxi, MS (Stone County not in sample)"
	25180       "Hagerstown-Martinsburg, MD-WV (Berkeley County, WV not identified and Morgan County, WV not in sample)"
	25420       "Harrisburg-Carlisle, PA"
	25500       "Harrisonburg, VA"
	25860       "Hickory-Morganton-Lenoir, NC (Caldwell County not in sample)"
	26100       "Holland-Grand Haven, MI"
	26180       "Honolulu, HI"
	26420       "Houston-Baytown-Sugar Land, TX"
	26580       "Huntington-Ashland, WV-KY-OH (Kentucky and Ohio portions not identified)"
	26620       "Huntsville, AL"
	26900       "Indianapolis, IN"
	26980       "Iowa City, IA (Washington County not in sample)"
	27100       "Jackson, MI"
	27140       "Jackson, MS"
	27260       "Jacksonville, FL"
	27340       "Jacksonville, NC"
	27500       "Janesville, WI"
	27740       "Johnson City, TN"
	27780       "Johnstown, PA"
	27900       "Joplin, MO"
	28020       "Kalamazoo-Portage, MI"
	28100       "Kankakee-Bradley, IL"
	28140       "Kansas City, MO-KS (Franklin, KS; Leavenworth, KS; Linn, KS; Bates, MO; and Caldwell, MO Counties not in sample)"
	28660       "Killeen-Temple-Fort Hood, TX"
	28700       "Kingsport-Bristol, TN-VA (Virginia portion not identified)"
	28740       "Kingston, NY"
	28940       "Knoxville, TN (Anderson County not in sample)"
	29100       "La Crosse, WI-MN (Houston County not in sample)"
	29180       "Lafayette, LA"
	29340       "Lake Charles, LA (Cameron Parish not in sample)"
	29460       "Lakeland-Winter Haven, FL"
	29540       "Lancaster, PA"
	29620       "Lansing-East Lansing, MI"
	29700       "Laredo, TX"
	29740       "Las Cruces, NM"
	29820       "Las Vegas-Paradise, NV"
	29940       "Lawrence, KS"
	30020       "Lawton, OK"
	30460       "Lexington-Fayette, KY"
	30780       "Little Rock-North Little Rock, AR (Perry County not in sample)"
	30980       "Longview, TX (Rusk and Upshur Counties not in sample)"
	31100       "Los Angeles-Long Beach-Santa Ana, CA"
	31140       "Louisville, KY-IN (Washington, IN; Henry, KY; Nelson, KY; Shelby, KY; and Trimble, KY Counties not in sample)"
	31180       "Lubbock, TX (Crosby County not in sample)"
	31340       "Lynchburg, VA (Appomattox and Bedford Counties and Bedford City not In sample)"
	31420       "Macon, GA (Crawford, Monroe, and Twiggs Counties not in sample)"
	31460       "Madera, CA"
	31540       "Madison, WI (Iowa County not in sample)"
	32580       "McAllen-Edinburg-Pharr, TX"
	32780       "Medford, OR"
	32820       "Memphis, TN-MS-AR (Arkansas portion not identified and Tunica County, MS not in sample)"
	32900       "Merced, CA"
	33100       "Miami-Fort Lauderdale-Miami Beach, FL"
	33140       "Michigan City-La Porte, IN"
	33260       "Midland, TX"
	33340       "Milwaukee-Waukesha-West Allis, WI"
	33460       "Minneapolis-St Paul-Bloomington, MN-WI (Wisconsin portion not identified)"
	33660       "Mobile, AL"
	33700       "Modesto, CA"
	33740       "Monroe, LA"
	33780       "Monroe, MI"
	33860       "Montgomery, AL"
	34740       "Muskegon-Norton Shores, MI"
	34820       "Myrtle Beach-Conway-North Myrtle Beach, SC"
	34900       "Napa, CA"
	34940       "Naples-Marco Island, FL"
	34980       "Nashville-Davidson-Murfreesboro, TN (Cannon, Hickman and Macon Counties not in sample)"
	35380       "New Orleans-Metairie-Kenner, LA"
	35620       "New York-Northern New Jersey-Long Island, NY-NJ-PA (Pennsylvania portion not in sample. White Plains central city recoded to balance of metropolitan)"
	35660       "Niles-Benton Harbor, MI"
	36100       "Ocala, FL"
	36140       "Ocean City, NJ"
	36260       "Ogden-Clearfield, UT"
	36420       "Oklahoma City, OK"
	36500       "Olympia, WA"
	36540       "Omaha-Council Bluffs, NE-IA"
	36740       "Orlando, FL"
	36780       "Oshkosh-Neenah, WI"
	37100       "Oxnard-Thousand Oaks-Ventura, CA"
	37340       "Palm Bay-Melbourne-Titusville, FL"
	37460       "Panama City-Lynn Haven, FL"
	37860       "Pensacola-Ferry Pass-Brent, FL"
	37900       "Peoria, IL"
	37980       "Philadelphia-Camden-Wilmington, PA-NJ-DE"
	38060       "Phoenix-Mesa-Scottsdale, AZ"
	38300       "Pittsburgh, PA"
	38900       "Portland-Vancouver-Beaverton, OR-WA (Yamhill County, OR not in sample)"
	38940       "Port St. Lucie-Fort Pierce, FL"
	39100       "Poughkeepsie-Newburgh-Middletown, NY"
	39140       "Prescott, AZ"
	39340       "Provo-Orem, UT (Juab County not in sample)"
	39380       "Pueblo, CO"
	39460       "Punta Gorda, FL"
	39540       "Racine, WI"
	39580       "Raleigh-Cary, NC"
	39740       "Reading, PA"
	39900       "Reno-Sparks, NV"
	40060       "Richmond, VA (Cumberland County not in sample)"
	40140       "Riverside-San Bernardino-Ontario, CA"
	40220       "Roanoke, VA (Craig and Franklin Counties not in sample)"
	40380       "Rochester, NY"
	40420       "Rockford, IL"
	40900       "Sacramento--Arden-Arcade-Roseville, CA"
	40980       "Saginaw-Saginaw Township North, MI"
	41060       "St. Cloud, MN"
	41180       "St. Louis, MO-IL (Calhoun County, IL not in sample)"
	41420       "Salem, OR"
	41500       "Salinas, CA"
	41540       "Salisbury, MD"
	41620       "Salt Lake City, UT (Tooele County not in sample)"
	41700       "San Antonio, TX"
	41740       "San Diego-Carlsbad-San Marcos, CA"
	41860       "San Francisco-Oakland-Fremont, CA"
	41940       "San Jose-Sunnyvale-Santa Clara, CA"
	42020       "San Luis Obispo-Paso Robles, CA"
	42060       "Santa Barbara-Santa Maria-Goleta, CA"
	42100       "Santa Cruz-Watsonville, CA"
	42140       "Santa Fe, NM"
	42220       "Santa Rosa-Petaluma, CA"
	42260       "Sarasota-Bradenton-Venice, FL"
	42340       "Savannah, GA"
	42540       "Scranton-Wilkes-Barre, PA"
	42660       "Seattle-Tacoma-Bellevue, WA"
	43340       "Shreveport-Bossier City, LA"
	43620       "Sioux Falls, SD"
	43780       "South Bend-Mishawaka, IN-MI (Michigan portion not identified)"
	43900       "Spartanburg, SC"
	44060       "Spokane, WA"
	44100       "Springfield, IL"
	44180       "Springfield, MO (Dallas and Polk Counties not in sample)"
	44220       "Springfield, OH"
	44700       "Stockton, CA"
	45060       "Syracuse, NY"
	45220       "Tallahassee, FL"
	45300       "Tampa-St. Petersburg-Clearwater, FL"
	45780       "Toledo, OH (Ottawa County not in sample)"
	45820       "Topeka, KS (Jackson and Jefferson Counties not in sample)"
	45940       "Trenton-Ewing, NJ"
	46060       "Tucson, AZ"
	46140       "Tulsa, OK (Okmulgee County not in sample)"
	46220       "Tuscaloosa, AL (Greene and Hale Counties not in sample)"
	46540       "Utica-Rome, NY"
	46660       "Valdosta, GA (Lanier County not in sample)"
	46700       "Vallejo-Fairfield, CA"
	46940       "Vero Beach, FL"
	47020       "Victoria, TX"
	47220       "Vineland-Millville-Bridgeton, NJ"
	47260       "Virginia Beach-Norfolk-Newport News, VA-NC (North Carolina portion not identified)"
	47300       "Visalia-Porterville, CA"
	47380       "Waco, TX"
	47580       "Warner Robins, GA"
	47900       "Washington-Arlington-Alexandria, DC-VA-MD-WV (West Virginia portion not identified. Reston central city recoded to balance of metropolitan.)"
	47940       "Waterloo-Cedar Falls, IA (Grundy County not in sample)"
	48140       "Wausau, WI"
	48620       "Wichita, KS"
	49180       "Winston-Salem, NC"
	49420       "Yakima, WA"
	49620       "York-Hanover, PA"
	49660       "Youngstown-Warren-Boardman, OH-PA (Pennsylvania portion not in sample)"
	70750       "Bangor, ME"
	70900       "Barnstable Town, MA"
	71650       "Boston-Cambridge-Quincy, MA-NH"
	71950       "Bridgeport-Stamford-Norwalk, CT"
	72400       "Burlington-South Burlington, VT"
	72850       "Danbury, CT"
	73450       "Hartford-West Hartford-East Hartford, CT"
	74500       "Leominster-Fitchburg-Gardner, MA"
	75700       "New Haven, CT"
	76450       "Norwich-New London, CT-RI (RI portion recoded to Providence NECTA)"
	76750       "Portland-South Portland, ME"
	77200       "Providence-Fall River-Warwick, RI-MA"
	77350       "Rochester-Dover, NH-ME (Maine portion not identified)"
	78100       "Springfield, MA-CT (Connecticut portion not identified)"
	78700       "Waterbury, CT"
	79600       "Worcester, MA-CT (Connecticut portion not identified)"
;
label values gtco     gtco;
label define gtco
	0           "NOT IDENTIFIED"
;
label values gtcbsast gtcbsast;
label define gtcbsast
	1           "PRINCIPAL CITY"
	2           "BALANCE"
	3           "NONMETROPOLITAN"
	4           "NOT IDENTIFIED"
;
label values gtmetsta gtmetsta;
label define gtmetsta
	1           "METROPOLITAN"
	2           "NONMETROPOLITAN"
	3           "NOT IDENTIFIED"
;
label values gtindvpc gtindvpc;
label define gtindvpc
	0           "NOT IDENTIFIED, NONMETROPOLITAN,"
;
label values gtcbsasz gtcbsasz;
label define gtcbsasz
	0           "NOT IDENTIFIED OR NONMETROPOLITAN"
	2           "100,000 - 249,999"
	3           "250,000 - 499,999"
	4           "500,000 - 999,999"
	5           "1,000,000 - 2,499,999"
	6           "2,500,000 - 4,999,999"
	7           "5,000,000+"
;
label values gtcsa    gtcsa;
label define gtcsa
	0           "NOT IDENTIFIED OR NONMETROPOLITAN"
	118         "Appleton-Oshkosh-Neenah, WI"
	176         "Chicago-Naperville-Michigan City, IL-IN-WI (part)"
	184         "Cleveland-Akron-Elyria, OH (part)"
	212         "Dayton-Springfield-Greenville, OH (part)"
	216         "Denver-Aurora-Boulder, CO"
	220         "Detroit-Warren-Flint, MI"
	260         "Fresno-Madera, CA"
	266         "Grand Rapids-Muskegon-Holland, MI (part)"
	268         "Greensboro--Winston-Salem--High Point, NC (part)"
	272         "Greenville-Anderson-Seneca, SC (part)"
	290         "Huntsville-Decatur, AL"
	294         "Indianapolis-Anderson-Columbus, IN (part)"
	304         "Johnson City-Kingsport-Bristol, TN-VA (part)"
	348         "Los Angeles-Long Beach-Riverside, CA"
	356         "Macon-Warner Robins-Fort Valley, GA (part)"
	376         "Milwaukee-Racine-Waukesha, WI"
	378         "Minneapolis-St. Paul-St. Cloud, MN-WI (part)"
	408         "New York-Newark-Bridgeport, NY-NJ-CT-PA (part)"
	428         "Philadelphia-Camden-Vineland, PA-NJ-DE-MD (part)"
	450         "Raleigh-Durham-Cary, NC (part)"
	482         "Salt Lake City-Ogden-Clearfield, UT (part)"
	488         "San Jose-San Francisco-Oakland, CA"
	500         "Seattle-Tacoma-Olympia, WA part"
	548         "Washington-Baltimore-Northern Virginia, DC-MD-VA-WV (part)"
	715         "Boston-Worcester-Manchester, MA-NH-CT-ME (part)"
	720         "Bridgeport-New Haven-Stamford, CT"
;
label values perrp    perrp;
label define perrp
    40          "REFERENCE PERSON W/RELS."
    41          "REFERENCE PERSON W/O RELS."
    42          "OPPOSITE SEX SPOUSE"
    43          "OPPOSITE SEX PARTNER WITH RELATIVES"
    44          "OPPOSITE SEC PARTNER WITHOUT RELATIVES"
    45          "SAME SEX SPOUSE"
    46          "SAME SEX PARTNER WITH RELATIVES"
    47          "SAME SEX PARTNER WITHOUT RELATIVES"
    48          "CHILD"
    49          "GRANDCHILD"
    50          "PARENT"
    51          "BROTHER/SISTER"
    52          "OTHER REL. OR REF. PERSON"
    53          "FOSTER CHILD"
    54          "HOUSEMATE/ROOMMATE W/RELS."
    55          "HOUSEMATE/ROOMMATEW/O RELS."
    56          "ROOMER/BOARDER W/RELS."
    57          "ROOMER/BOARDER W/OUT RELS."
    58          "NONRELATIVE OF REFERENCE PERSON W/RELS."
    59          "NONRELATIVE OF REFERENCE PERSON W/OUT RELS."
;
label values pepar2 pepar2;
label define pepar2
    -1	        "NO PEPAR2"
	01	        "MIN VALUE"
	16	        "MAX VALUE"
;

label values pepar1 pepar1;
label define pepar1
    -1	        "NO PEPAR1"
	01	        "MIN VALUE"
	16	        "MAX VALUE"
;

label values pepar2typ pepar2typ;
label define pepar2typ
	-1	        "NO PEPAR1 PRESENT"
	01	        "BIOLOGICAL"
	02	        "STEP"
	03	        "ADOPTED"
;

label values pepar1typ pepar1typ;
label define pepar1typ
	-1	        "NO PEPAR2 PRESENT"
	01	        "BIOLOGICAL"
	02	        "STEP"
	03	        "ADOPTED"
;
label values prtage   prtage;
label define prtage
	80          "80-84 Years Old"
	85          "85+ Years Old"
;
label values prtfage  prtfage;
label define prtfage
	0           "NO TOP CODE"
	1           "TOP CODED VALUE FOR AGE"
;
label values pemaritl pemaritl;
label define pemaritl
	1           "MARRIED - SPOUSE PRESENT"
	2           "MARRIED - SPOUSE ABSENT"
	3           "WIDOWED"
	4           "DIVORCED"
	5           "SEPARATED"
	6           "NEVER MARRIED"
;
label values pespouse pespouse;
label define pespouse
	-1          "NO SPOUSE"
;
label values pesex    pesex;
label define pesex
	1           "MALE"
	2           "FEMALE"
;
label values peafever peafever;
label define peafever
	1           "YES"
	2           "NO"
;
label values peafnow  peafnow;
label define peafnow
	1           "YES"
	2           "NO"
;
label values peeduca  peeduca;
label define peeduca
	31          "LESS THAN 1ST GRADE"
	32          "1ST, 2ND, 3RD OR 4TH GRADE"
	33          "5TH OR 6TH GRADE"
	34          "7TH OR 8TH GRADE"
	35          "9TH GRADE"
	36          "10TH GRADE"
	37          "11TH GRADE"
	38          "12TH GRADE NO DIPLOMA"
	39          "HIGH SCHOOL GRAD-DIPLOMA OR EQUIV (GED)"
	40          "SOME COLLEGE BUT NO DEGREE"
	41          "ASSOCIATE DEGREE-OCCUPATIONAL/VOCATIONAL"
	42          "ASSOCIATE DEGREE-ACADEMIC PROGRAM"
	43          "BACHELOR'S DEGREE (EX: BA, AB, BS)"
	44          "MASTER'S DEGREE (EX: MA, MS, MEng, MEd, MSW)"
	45          "PROFESSIONAL SCHOOL DEG (EX: MD, DDS, DVM)"
	46          "DOCTORATE DEGREE (EX: PhD, EdD)"
;
label values ptdtrace ptdtrace;
label define ptdtrace
	1           "White Only"
	2           "Black Only"
	3           "American Indian, Alaskan Native Only"
	4           "Asian Only"
	5           "Hawaiian/Pacific Islander Only"
	6           "White-Black"
	7           "White-AI"
	8           "White-Asian"
	9           "White-HP"
	10          "Black-AI"
	11          "Black-Asian"
	12          "Black-HP"
	13          "AI-Asian"
	14          "AI-HP"
	15          "Asian-HP"
	16          "W-B-AI"
	17          "W-B-A"
	18          "W-B-HP"
	19          "W-AI-A"
	20          "W-AI-HP"
	21          "W-A-HP"
	22          "B-AI-A"
	23          "W-B-AI-A"
	24          "W-AI-A-HP"
	25          "Other 3 Race Combinations"
	26          "Other 4 and 5 Race Combinations"
;
label values prdthsp  prdthsp;
label define prdthsp
	1           "Mexican"
	2           "Puerto Rican"
	3           "Cuban"
	4           "Dominican"
	5           "Salvadoran"
	6           "Central American, excluding Salvadoran"
	7           "South American"
	8           "Other Spanish"
;
label values prfamnum prfamnum;
label define prfamnum
	0           "NOT A FAMILY MEMBER"
	1           "PRIMARY FAMILY MEMBER ONLY"
	2           "SUBFAMILY NO. 2 MEMBER"
	3           "SUBFAMILY NO. 3 MEMBER"
	4           "SUBFAMILY NO. 4 MEMBER"
	5           "SUBFAMILY NO. 5 MEMBER"
	6           "SUBFAMILY NO. 6 MEMBER"
	7           "SUBFAMILY NO. 7 MEMBER"
	8           "SUBFAMILY NO. 8 MEMBER"
	9           "SUBFAMILY NO. 9 MEMBER"
	10          "SUBFAMILY NO. 10 MEMBER"
	11          "SUBFAMILY NO. 11 MEMBER"
	12          "SUBFAMILY NO. 12 MEMBER"
	13          "SUBFAMILY NO. 13 MEMBER"
	14          "SUBFAMILY NO. 14 MEMBER"
	15          "SUBFAMILY NO. 15 MEMBER"
	16          "SUBFAMILY NO. 16 MEMBER"
	17          "SUBFAMILY NO. 17 MEMBER"
	18          "SUBFAMILY NO. 18 MEMBER"
	19          "SUBFAMILY NO. 19 MEMBER"
;
label values prfamrel prfamrel;
label define prfamrel
	0           "NOT A FAMILY MEMBER"
	1           "REFERENCE PERSON"
	2           "SPOUSE"
	3           "CHILD"
	4           "OTHER RELATIVE (PRIMARY FAMILY & UNREL)"
;
label values prfamtyp prfamtyp;
label define prfamtyp
	1           "PRIMARY FAMILY"
	2           "PRIMARY INDIVIDUAL"
	3           "RELATED SUBFAMILY"
	4           "UNRELATED SUBFAMILY"
	5           "SECONDARY INDIVIDUAL"
;
label values pehspnon pehspnon;
label define pehspnon
	1           "HISPANIC"
	2           "NON-HISPANIC"
;
label values prmarsta prmarsta;
label define prmarsta
	1           "MARRIED, CIVILIAN SPOUSE PRESENT"
	2           "MARRIED, ARMED FORCES SPOUSE PRESENT"
	3           "MARRIED, SPOUSE ABSENT (EXC. SEPARATED)"
	4           "WIDOWED"
	5           "DIVORCED"
	6           "SEPARATED"
	7           "NEVER MARRIED"
;
label values prpertyp prpertyp;
label define prpertyp
	1           "CHILD HOUSEHOLD MEMBER"
	2           "ADULT CIVILIAN HOUSEHOLD MEMBER"
	3           "ADULT ARMED FORCES HOUSEHOLD MEMBER"
;
label values penatvty penatvty;
label define penatvty
	57          "United States"
	60          "American Samoa"
	66          "Guam"
	69          "Northern Marianas"
	73          "Puerto Rico"
	78          "U. S. Virgin Islands"
	100         "Albania"
	102         "Austria"
	103         "Belgium"
	104         "Bulgaria"
	105         "Czechoslovakia"
	106         "Denmark"
	108         "Finland"
	109         "France"
	110         "Germany"
	116         "Greece"
	117         "Hungary"
	118         "Iceland"
	119         "Ireland"
	120         "Italy"
	126         "Netherlands"
	127         "Norway"
	128         "Poland"
	129         "Portugal"
	130         "Azores"
	132         "Romania"
	134         "Spain"
	136         "Sweden"
	137         "Switzerland"
	138         "United Kingdom"
	139         "England"
	140         "Scotland"
	142         "Northern Ireland"
	147         "Yugoslavia"
	148         "Czech Republic"
	149         "Slovakia"
	150         "Bosnia & Herzegovina"
	151         "Croatia"
	152         "Macedonia"
	154         "Serbia"
	155         "Estonia"
	156         "Latvia"
	157         "Lithuania"
	158         "Armenia"
	159         "Azerbaijan"
	160         "Belarus"
	161         "Georgia"
	162         "Moldova"
	163         "Russia"
	164         "Ukraine"
	165         "USSR"
	166         "Europe, not specified"
	168         "Montenegro"
	200         "Afghanistan"
	202         "Bangladesh"
	203         "Bhutan"
	205         "Myanmar (Burma)"
	206         "Cambodia"
	207         "China"
	209         "Hong Kong"
	210         "India"
	211         "Indonesia"
	212         "Iran"
	213         "Iraq"
	214         "Israel"
	215         "Japan"
	216         "Jordan"
	217         "Korea"
	218         "Kazakhstan"
	220         "South Korea"
	222         "Kuwait"
	223         "Laos"
	224         "Lebanon"
	226         "Malaysia"
	228         "Mongolia"
	229         "Nepal"
	231         "Pakistan"
	233         "Philippines"
	235         "Saudi Arabia"
	236         "Singapore"
	238         "Sri Lanka"
	239         "Syria"
	240         "Taiwan"
	242         "Thailand"
	243         "Turkey"
	245         "United Arab Emirates"
	246         "Uzbekistan"
	247         "Vietnam"
	248         "Yemen"
	249         "Asia, not specified"
	300         "Bermuda"
	301         "Canada"
	303         "Mexico"
	310         "Belize"
	311         "Costa Rica"
	312         "El Salvador"
	313         "Guatemala"
	314         "Honduras"
	315         "Nicaragua"
	316         "Panama"
	321         "Antigua and Barbuda"
	323         "Bahamas"
	324         "Barbados"
	327         "Cuba"
	328         "Dominica"
	329         "Dominican Republic"
	330         "Grenada"
	332         "Haiti"
	333         "Jamaica"
	338         "St. Kitts--Nevis"
	339         "St. Lucia"
	340         "St. Vincent and the Grenadines"
	341         "Trinidad and Tobago"
	343         "West Indies, not specified"
	360         "Argentina"
	361         "Bolivia"
	362         "Brazil"
	363         "Chile"
	364         "Columbia"
	365         "Ecuador"
	368         "Guyana"
	369         "Paraguay"
	370         "Peru"
	372         "Uruguay"
	373         "Venezuela"
	374         "South America, not specified"
	399         "Americas, not specified"
	400         "Algeria"
	407         "Cameroon"
	408         "Cape Verde"
	412         "Congo"
	414         "Egypt"
	416         "Ethiopia"
	417         "Eritrea"
	421         "Ghana"
	423         "Guinea"
	425         "Ivory Coast"
	427         "Kenya"
	429         "Liberia"
	430         "Libya"
	436         "Morocco"
	440         "Nigeria"
	444         "Senegal"
	447         "Sierra Leone"
	448         "Somalia"
	449         "South Africa"
	451         "Sudan"
	453         "Tanzania"
	454         "Togo"
	457         "Uganda"
	459         "Zaire"
	460         "Zambia"
	461         "Zimbabwe"
	462         "Africa, not specified"
	501         "Australia"
	508         "Fiji"
	511         "Marshall Islands"
	512         "Micronesia"
	515         "New Zealand"
	523         "Tonga"
	527         "Samoa"
	555         "Elsewhere"
;
label values pemntvty pemntvty;
label define pemntvty
	57          "UNITED STATES"
	66          "GUAM"
	73          "PUERTO RICO"
	78          "U. S. VIRGIN ISLANDS"
	96          "OTHER U. S. ISLAND AREA"
	555         "ELSEWHERE"
;
label values pefntvty pefntvty;
label define pefntvty
	57          "UNITED STATES"
	66          "GUAM"
	73          "PUERTO RICO"
	78          "U. S. VIRGIN ISLANDS"
	96          "OTHER U. S. ISLAND AREA"
	555         "ELSEWHERE"
;
label values prcitshp prcitshp;
label define prcitshp
	1           "NATIVE, BORN IN THE UNITED STATES"
	2           "NATIVE, BORN IN PUERTO RICO OR OTHER U.S. ISLAND AREAS"
	3           "NATIVE, BORN ABROAD OF AMERICAN PARENT OR PARENTS"
	4           "FOREIGN BORN, U.S. CITIZEN BY NATURALIZATION"
	5           "FOREIGN BORN, NOT A CITIZEN OF THE UNITED STATES"
;
label values prinusyr prinusyr;
label define prinusyr
	-1          "NOT IN UNIVERSE (BORN IN U.S.)"
	0           "NOT FOREIGN BORN"
	1           "BEFORE 1950"
	2           "1950-1959"
	3           "1960-1964"
	4           "1965-1969"
	5           "1970-1974"
	6           "1975-1979"
	7           "1980-1981"
	8           "1982-1983"
	9           "1984-1985"
	10          "1986-1987"
	11          "1988-1989"
	12          "1990-1991"
	12          "1990-1991"
	13          "1992-1993"
	14          "1994-1995"
	15          "1996-1997"
	16          "1998-1999"
	17          "2000-2001"
	18          "2002-2003"
	19          "2004-2005"
	20          "2006-2007"
	21          "2008-2009"
	22          "2010-2011"
	23          "2012-2013"
	24          "2014-2015"
	25          "2016-2018"
    23 	        "2012-2013"
    24	        "2014-2015"
    25	        "2016-2017"
    26	        "2018-2020"
;
label values puslfprx puslfprx;
label define puslfprx
	1           "SELF"
	2           "PROXY"
	3           "BOTH SELF AND PROXY"
;
label values pemlr    pemlr;
label define pemlr
	1           "EMPLOYED-AT WORK"
	2           "EMPLOYED-ABSENT"
	3           "UNEMPLOYED-ON LAYOFF"
	4           "UNEMPLOYED-LOOKING"
	5           "NOT IN LABOR FORCE-RETIRED"
	6           "NOT IN LABOR FORCE-DISABLED"
	7           "NOT IN LABOR FORCE-OTHER"
;
label values puwk     puwk;
label define puwk
	1           "YES"
	2           "NO"
	3           "RETIRED"
	4           "DISABLED"
	5           "UNABLE TO WORK"
;
label values pubus1   pubus1l;
label define pubus1l
	1           "YES"
	2           "NO"
;
label values pubus2ot pubus2ot;
label define pubus2ot
	1           "YES"
	2           "NO"
;
label values pubusck1 pubuscka;
label define pubuscka
	1           "GOTO PUBUS1"
	2           "GOTO PURETCK1"
;
label values pubusck2 pubusckb;
label define pubusckb
	1           "GOTO PUHRUSL1"
	2           "GOTO PUBUS2"
;
label values pubusck3 pubusckc;
label define pubusckc
	1           "GOTO PUABSRSN"
	2           "GOTO PULAY"
;
label values pubusck4 pubusckd;
label define pubusckd
	1           "GOTO PUHRUSL1"
	2           "GOTO PUABSPD"
;
label values puretot  puretot;
label define puretot
	1           "YES"
	2           "NO"
	3           "WAS NOT RETIRED LAST MONTH"
;
label values pudis    pudis;
label define pudis
	1           "YES"
	2           "NO"
	3           "DID NOT HAVE DISABILITY LAST MONTH"
;
label values peret1   peret1l;
label define peret1l
	1           "YES"
	2           "NO"
	3           "HAS A JOB"
;
label values pudis1   pudis1l;
label define pudis1l
	1           "YES"
	2           "NO"
;
label values pudis2   pudis2l;
label define pudis2l
	1           "YES"
	2           "NO"
;
label values puabsot  puabsot;
label define puabsot
	1           "YES"
	2           "NO"
	3           "RETIRED"
	4           "DISABLED"
	5           "UNABLE TO WORK"
;
label values pulay    pulay;
label define pulay
	1           "YES"
	2           "NO"
	3           "RETIRED"
	4           "DISABLED"
	5           "UNABLE TO WORK"
;
label values peabsrsn peabsrsn;
label define peabsrsn
	1           "ON LAYOFF"
	2           "SLACK WORK/BUSINESS CONDITIONS"
	3           "WAITING FOR A NEW JOB TO BEGIN"
	4           "VACATION/PERSONAL DAYS"
	5           "OWN ILLNESS/INJURY/MEDICAL PROBLEMS"
	6           "CHILD CARE PROBLEMS"
	7           "OTHER FAMILY/PERSONAL OBLIGATION"
	8           "MATERNITY/PATERNITY LEAVE"
	9           "LABOR DISPUTE"
	10          "WEATHER AFFECTED JOB"
	11          "SCHOOL/TRAINING"
	12          "CIVIC/MILITARY DUTY"
	13          "DOES NOT WORK IN THE BUSINESS"
	14          "OTHER (SPECIFY)"
;
label values peabspdo peabspdo;
label define peabspdo
	1           "YES"
	2           "NO"
;
label values pemjot   pemjot;
label define pemjot
	1           "YES"
	2           "NO"
;
label values pemjnum  pemjnum;
label define pemjnum
	2           "2 JOBS"
	3           "3 JOBS"
	4           "4 OR MORE JOBS"
;
label values pehrusl1 pehrusla;
label define pehrusla
	-4          "HOURS VARY"
;
label values pehrusl2 pehruslb;
label define pehruslb
	-4          "HOURS VARY"
;
label values pehrftpt pehrftpt;
label define pehrftpt
	1           "YES"
	2           "NO"
	3           "HOURS VARY"
;
label values pehruslt pehruslt;
label define pehruslt
	-4          "VARIES"
;
label values pehrwant pehrwant;
label define pehrwant
	1           "YES"
	2           "NO"
	3           "REGULAR HOURS ARE FULL-TIME"
;
label values pehrrsn1 pehrrsna;
label define pehrrsna
	1           "SLACK WORK/BUSINESS CONDITIONS"
	2           "COULD ONLY FIND PART-TIME WORK"
	3           "SEASONAL WORK"
	4           "CHILD CARE PROBLEMS"
	5           "OTHER FAMILY/PERSONAL OBLIGATIONS"
	6           "HEALTH/MEDICAL LIMITATIONS"
	7           "SCHOOL/TRAINING"
	8           "RETIRED/SOCIAL SECURITY LIMIT ON EARNINGS"
	9           "FULL-TIME WORKWEEK IS LESS THAN 35 HRS"
	10          "OTHER - SPECIFY"
;
label values pehrrsn2 pehrrsnb;
label define pehrrsnb
	1           "CHILD CARE PROBLEMS"
	2           "OTHER FAMILY/PERSONAL OBLIGATIONS"
	3           "HEALTH/MEDICAL LIMITATIONS"
	4           "SCHOOL/TRAINING"
	5           "RETIRED/SOCIAL SECURITY LIMIT ON EARNINGS"
	6           "FULL-TIME WORKWEEK LESS THAN 35 HOURS"
	7           "OTHER - SPECIFY"
;
label values pehrrsn3 pehrrsnc;
label define pehrrsnc
	1           "SLACK WORK/BUSINESS CONDITIONS"
	2           "SEASONAL WORK"
	3           "JOB STARTED OR ENDED DURING WEEK"
	4           "VACATION/PERSONAL DAY"
	5           "OWN ILLNESS/INJURY/MEDICAL APPOINTMENT"
	6           "HOLIDAY (LEGAL OR RELIGIOUS)"
	7           "CHILD CARE PROBLEMS"
	8           "OTHER FAMILY/PERSONAL OBLIGATIONS"
	9           "LABOR DISPUTE"
	10          "WEATHER AFFECTED JOB"
	11          "SCHOOL/TRAINING"
	12          "CIVIC/MILITARY DUTY"
	13          "OTHER REASON"
;
label values puhroff1 puhroffa;
label define puhroffa
	1           "YES"
	2           "NO"
;
label values puhrot1  puhrot1l;
label define puhrot1l
	1           "YES"
	2           "NO"
;
label values pehravl  pehravl;
label define pehravl
	1           "YES"
	2           "NO"
;
label values puhrck1  puhrck1l;
label define puhrck1l
	1           "GOTO PUHRUSL2"
	2           "GOTO PUHRUSLT"
;
label values puhrck2  puhrck2l;
label define puhrck2l
	1           "IF ENTRY OF 1 IN MJ AND ENTRY OF D, R OR V IN HRUSL1 AND ENTRY OF D, R, V OR 0-34 IN HRUSL2 GOTO HRFTPT"
	2           "IF ENTRY OF 1 IN MJ AND ENTRY OF D, R OR V IN HRUSL2 AND ENTRY OF D, R V OR 0-34 IN HRUSL1 GOTO HRFTPT"
	3           "IF ENTRY OF 2, D OR R IN MJ AND ENTRY OF D, R OR V IN HRUSL1 GOTO HRFTPT"
	4           "IF ENTRY OF 1 IN BUS1 AND ENTRY OF D, R OR V IN HRUSL1 THEN GOTO HRFTPT"
	5           "ALL OTHERS GOTO HRCK3-C"
;
label values puhrck3  puhrck3l;
label define puhrck3l
	1           "IF ENTRY OF 1 IN ABSOT OR (ENTRY OR 2 IN ABSOT AND ENTRY OF 1 IN BUS AND CURRENT R_P EQUALS BUSLST) THEN GOTO HRCK8"
	2           "IF ENTRY OF 3 IN RET1 GOTO HRCK8"
	3           "IF ENTRY IN HRUSLT IS 0-34 HOURS GOTO HRCK4-C"
	4           "IF ENTRY IN HRUSLT IS 35+ GOTO HROFF1"
	5           "ALL OTHERS GOTO HRCK4-C"
	6           "GOTO PUHRCK4"
;
label values puhrck4  puhrck4l;
label define puhrck4l
	1           "IF ENTRY OF 1, D, R OR V	IN HRFTPT THEN GOTO HRACT1"
	2           "IF ENTRY OF 2, D OR R IN BUS2 THEN GOTO HROFF1"
	3           "IF HRUSLT IS 0-34 THEN GOTO HRWANT"
	4           "IF ENTRY OF 2 IN HRFTPT THEN GOTO HRWANT"
	5           "ALL OTHERS GOTO HRACT1"
;
label values puhrck5  puhrck5l;
label define puhrck5l
	1           "IF ENTRY OF 1 IN MJOT GOTO HRACT2"
	2           "ALL OTHERS GOTO HRCK6-C"
;
label values puhrck6  puhrck6l;
label define puhrck6l
	1           "IF HRACT1 AND HRACT2 EQ 0 AND ENTRY OF 2, D, R IN BUS2 THEN GOTO LK"
	2           "IF HRACT1 AND HRACT2 EQ 0 THEN STORE 1 IN ABSOT AND GOTO ABSRSN"
	3           "ALL OTHERS GOTO HRACTT-C"
;
label values puhrck7  puhrck7l;
label define puhrck7l
	1           "(IF ENTRY OF 2, D OR R IN BUS2) AND (HRACT1 LESS THAN 15 OR D) GOTO HRCK8"
	2           "(IF ENTRY OF 2, D OR R IN BUS2) AND (HRACT1 IS 15+) GOTO HRCK8"
	3           "(IF HRUSLT IS 35+ OR IF ENTRY OF 1 IN HRFTPT) AND (HRACTT <35) AND ENTRY IN HRACT1 OR HRACT2 ISN'T D OR R THEN GOTO HRRSN3"
	4           "IF ENTRY OF 1 IN HRWANT AND HRACTT <35 AND (ENTRY OF 1, 2, 3 IN HRRSN1) GOTO HRAVL"
	5           "ALL OTHERS GOTO HRCK8"
;
label values puhrck12 puhrck1b;
label define puhrck1b
	1           "IF ENTRY OF 2, D OR R IN BUS2 AND HRACTT IS LESS THAN 15 OR D GOTO LK"
	2           "ALL OTHERS GOTO IOCK1"
;
label values pulaydt  pulaydt;
label define pulaydt
	1           "YES"
	2           "NO"
;
label values pulay6m  pulay6m;
label define pulay6m
	1           "YES"
	2           "NO"
;
label values pelayavl pelayavl;
label define pelayavl
	1           "YES"
	2           "NO"
;
label values pulayavr pulayavr;
label define pulayavr
	1           "OWN TEMPORARY ILLNESS"
	2           "GOING TO SCHOOL"
	3           "OTHER"
;
label values pelaylk  pelaylk;
label define pelaylk
	1           "YES"
	2           "NO"
;
label values pelaydur pelaydur;
label define pelaydur
	52          "52 weeks or more"
;
label values pelayfto pelayfto;
label define pelayfto
	1           "YES"
	2           "NO"
;
label values pulayck1 pulaycka;
label define pulaycka
	1           "GOTO PULAYCK3"
	2           "GOTO PULAYFT"
	3           "GOTO PULAYDR"
;
label values pulayck2 pulayckb;
label define pulayckb
	1           "GOTO PULAYDR3"
	2           "GOTO PULAYFT"
;
label values pulayck3 pulayckc;
label define pulayckc
	1           "MISCK = 5 GOTO IO1INT"
	2           "I-ICR = 1 OR I-OCR = 1, GOTO IO1INT"
	3           "ALL OTHERS GOTO SCHCK"
;
label values pulk     pulk;
label define pulk
	1           "YES"
	2           "NO"
	3           "RETIRED"
	4           "DISABLED"
	5           "UNABLE TO WORK"
;
label values pelkm1   pelkm1l;
label define pelkm1l
	1           "CONTACTED EMPLOYER DIRECTLY/INTERVIEW"
	2           "CONTACTED PUBLIC EMPLOYMENT AGENCY"
	3           "CONTACTED PRIVATE EMPLOYMENT AGENCY"
	4           "CONTACTED FRIENDS OR RELATIVES"
	5           "CONTACTED SCHOOL/UNIVERSITY EMPL CENTER"
	6           "SENT OUT RESUMES/FILLED OUT APPLICATION"
	7           "CHECKED UNION/PROFESSIONAL REGISTERS"
	8           "PLACED OR ANSWERED ADS"
	9           "OTHER ACTIVE"
	10          "LOOKED AT ADS"
	11          "ATTENDED JOB TRAINING PROGRAMS/COURSES"
	12          "NOTHING"
	13          "OTHER PASSIVE"
;
label values pulkm2   pulkm2l;
label define pulkm2l
	1           "CONTACTED EMPLOYER DIRECTLY/INTERVIEW"
	2           "CONTACTED PUBLIC EMPLOYMENT AGENCY"
	3           "CONTACTED PRIVATE EMPLOYMENT AGENCY"
	4           "CONTACTED FRIENDS OR RELATIVES"
	5           "CONTACTED SCHOOL/UNIVERSITY EMPL CENTER"
	6           "SENT OUT RESUMES/FILLED OUT APPLICATION"
	7           "CHECKED UNION/PROFESSIONAL REGISTERS"
	8           "PLACED OR ANSWERED ADS"
	9           "OTHER ACTIVE"
	10          "LOOKED AT ADS"
	11          "ATTENDED JOB TRAINING PROGRAMS/COURSES"
	13          "OTHER PASSIVE"
;
label values pulkm3   pulkm3l;
label define pulkm3l
	1           "CONTACTED EMPLOYER DIRECTLY/INTERVIEW"
	2           "CONTACTED PUBLIC EMPLOYMENT AGENCY"
	3           "CONTACTED PRIVATE EMPLOYMENT AGENCY"
	4           "CONTACTED FRIENDS OR RELATIVES"
	5           "CONTACTED SCHOOL/UNIVERSITY EMPL CENTER"
	6           "SENT OUT RESUMES/FILLED OUT APPLICATION"
	7           "CHECKED UNION/PROFESSIONAL REGISTERS"
	8           "PLACED OR ANSWERED ADS"
	9           "OTHER ACTIVE"
	10          "LOOKED AT ADS"
	11          "ATTENDED JOB TRAINING PROGRAMS/COURSES"
	13          "OTHER PASSIVE"
;
label values pulkm4   pulkm4l;
label define pulkm4l
	1           "CONTACTED EMPLOYER DIRECTLY/INTERVIEW"
	2           "CONTACTED PUBLIC EMPLOYMENT AGENCY"
	3           "CONTACTED PRIVATE EMPLOYMENT AGENCY"
	4           "CONTACTED FRIENDS OR RELATIVES"
	5           "CONTACTED SCHOOL/UNIVERSITY EMPL CENTER"
	6           "SENT OUT RESUMES/FILLED OUT APPLICATION"
	7           "CHECKED UNION/PROFESSIONAL REGISTERS"
	8           "PLACED OR ANSWERED ADS"
	9           "OTHER ACTIVE"
	10          "LOOKED AT ADS"
	11          "ATTENDED JOB TRAINING PROGRAMS/COURSES"
	13          "OTHER PASSIVE"
;
label values pulkm5   pulkm5l;
label define pulkm5l
	1           "CONTACTED EMPLOYER DIRECTLY/INTERVIEW"
	2           "CONTACTED PUBLIC EMPLOYMENT AGENCY"
	3           "CONTACTED PRIVATE EMPLOYMENT AGENCY"
	4           "CONTACTED FRIENDS OR RELATIVES"
	5           "CONTACTED SCHOOL/UNIVERSITY EMPL CENTER"
	6           "SENT OUT RESUMES/FILLED OUT APPLICATION"
	7           "CHECKED UNION/PROFESSIONAL REGISTERS"
	8           "PLACED OR ANSWERED ADS"
	9           "OTHER ACTIVE"
	10          "LOOKED AT ADS"
	11          "ATTENDED JOB TRAINING PROGRAMS/COURSES"
	13          "OTHER PASSIVE"
;
label values pulkm6   pulkm6l;
label define pulkm6l
	1           "CONTACTED EMPLOYER DIRECTLY/INTERVIEW"
	2           "CONTACTED PUBLIC EMPLOYMENT AGENCY"
	3           "CONTACTED PRIVATE EMPLOYMENT AGENCY"
	4           "CONTACTED FRIENDS OR RELATIVES"
	5           "CONTACTED SCHOOL/UNIVERSITY EMPL CENTER"
	6           "SENT OUT RESUMES/FILLED OUT APPLICATION"
	7           "CHECKED UNION/PROFESSIONAL REGISTERS"
	8           "PLACED OR ANSWERED ADS"
	9           "OTHER ACTIVE"
	10          "LOOKED AT ADS"
	11          "ATTENDED JOB TRAINING PROGRAMS/COURSES"
	13          "OTHER PASSIVE"
;
label values pulkdk1  pulkdk1l;
label define pulkdk1l
	1           "CONTACTED EMPLOYER DIRECTLY/INTERVIEW"
	2           "CONTACTED PUBLIC EMPLOYMENT AGENCY"
	3           "CONTACTED PRIVATE EMPLOYMENT AGENCY"
	4           "CONTACTED FRIENDS OR RELATIVES"
	5           "CONTACTED SCHOOL/UNIVERSITY EMPL CENTER"
	6           "SENT OUT RESUMES/FILLED OUT APPLICATION"
	7           "CHECKED UNION/PROFESSIONAL REGISTERS"
	8           "PLACED OR ANSWERED ADS"
	9           "OTHER ACTIVE"
	10          "LOOKED AT ADS"
	11          "ATTENDED JOB TRAINING PROGRAMS/COURSES"
	12          "NOTHING"
	13          "OTHER PASSIVE"
;
label values pulkdk2  pulkdk2l;
label define pulkdk2l
	1           "CONTACTED EMPLOYER DIRECTLY/INTERVIEW"
	2           "CONTACTED PUBLIC EMPLOYMENT AGENCY"
	3           "CONTACTED PRIVATE EMPLOYMENT AGENCY"
	4           "CONTACTED FRIENDS OR RELATIVES"
	5           "CONTACTED SCHOOL/UNIVERSITY EMPL CENTER"
	6           "SENT OUT RESUMES/FILLED OUT APPLICATION"
	7           "CHECKED UNION/PROFESSIONAL REGISTERS"
	8           "PLACED OR ANSWERED ADS"
	9           "OTHER ACTIVE"
	10          "LOOKED AT ADS"
	11          "ATTENDED JOB TRAINING PROGRAMS/COURSES"
	13          "OTHER PASSIVE"
;
label values pulkdk3  pulkdk3l;
label define pulkdk3l
	1           "CONTACTED EMPLOYER DIRECTLY/INTERVIEW"
	2           "CONTACTED PUBLIC EMPLOYMENT AGENCY"
	3           "CONTACTED PRIVATE EMPLOYMENT AGENCY"
	4           "CONTACTED FRIENDS OR RELATIVES"
	5           "CONTACTED SCHOOL/UNIVERSITY EMPL CENTER"
	6           "SENT OUT RESUMES/FILLED OUT APPLICATION"
	7           "CHECKED UNION/PROFESSIONAL REGISTERS"
	8           "PLACED OR ANSWERED ADS"
	9           "OTHER ACTIVE"
	10          "LOOKED AT ADS"
	11          "ATTENDED JOB TRAINING PROGRAMS/COURSES"
	13          "OTHER PASSIVE"
;
label values pulkdk4  pulkdk4l;
label define pulkdk4l
	1           "CONTACTED EMPLOYER DIRECTLY/INTERVIEW"
	2           "CONTACTED PUBLIC EMPLOYMENT AGENCY"
	3           "CONTACTED PRIVATE EMPLOYMENT AGENCY"
	4           "CONTACTED FRIENDS OR RELATIVES"
	5           "CONTACTED SCHOOL/UNIVERSITY EMPL CENTER"
	6           "SENT OUT RESUMES/FILLED OUT APPLICATION"
	7           "CHECKED UNION/PROFESSIONAL REGISTERS"
	8           "PLACED OR ANSWERED ADS"
	9           "OTHER ACTIVE"
	10          "LOOKED AT ADS"
	11          "ATTENDED JOB TRAINING PROGRAMS/COURSES"
	13          "OTHER PASSIVE"
;
label values pulkdk5  pulkdk5l;
label define pulkdk5l
	1           "CONTACTED EMPLOYER DIRECTLY/INTERVIEW"
	2           "CONTACTED PUBLIC EMPLOYMENT AGENCY"
	3           "CONTACTED PRIVATE EMPLOYMENT AGENCY"
	4           "CONTACTED FRIENDS OR RELATIVES"
	5           "CONTACTED SCHOOL/UNIVERSITY EMPL CENTER"
	6           "SENT OUT RESUMES/FILLED OUT APPLICATION"
	7           "CHECKED UNION/PROFESSIONAL REGISTERS"
	8           "PLACED OR ANSWERED ADS"
	9           "OTHER ACTIVE"
	10          "LOOKED AT ADS"
	11          "ATTENDED JOB TRAINING PROGRAMS/COURSES"
	13          "OTHER PASSIVE"
;
label values pulkdk6  pulkdk6l;
label define pulkdk6l
	1           "CONTACTED EMPLOYER DIRECTLY/INTERVIEW"
	2           "CONTACTED PUBLIC EMPLOYMENT AGENCY"
	3           "CONTACTED PRIVATE EMPLOYMENT AGENCY"
	4           "CONTACTED FRIENDS OR RELATIVES"
	5           "CONTACTED SCHOOL/UNIVERSITY EMPL CENTER"
	6           "SENT OUT RESUMES/FILLED OUT APPLICATION"
	7           "CHECKED UNION/PROFESSIONAL REGISTERS"
	8           "PLACED OR ANSWERED ADS"
	9           "OTHER ACTIVE"
	10          "LOOKED AT ADS"
	11          "ATTENDED JOB TRAINING PROGRAMS/COURSES"
	13          "OTHER PASSIVE"
;
label values pulkps1  pulkps1l;
label define pulkps1l
	1           "CONTACTED EMPLOYER DIRECTLY/INTERVIEW"
	2           "CONTACTED PUBLIC EMPLOYMENT AGENCY"
	3           "CONTACTED PRIVATE EMPLOYMENT AGENCY"
	4           "CONTACTED FRIENDS OR RELATIVES"
	5           "CONTACTED SCHOOL/UNIVERSITY EMPL CENTER"
	6           "SENT OUT RESUMES/FILLED OUT APPLICATION"
	7           "CHECKED UNION/PROFESSIONAL REGISTERS"
	8           "PLACED OR ANSWERED ADS"
	9           "OTHER ACTIVE"
	10          "LOOKED AT ADS"
	11          "ATTENDED JOB TRAINING PROGRAMS/COURSES"
	12          "NOTHING"
	13          "OTHER PASSIVE"
;
label values pulkps2  pulkps2l;
label define pulkps2l
	1           "CONTACTED EMPLOYER DIRECTLY/INTERVIEW"
	2           "CONTACTED PUBLIC EMPLOYMENT AGENCY"
	3           "CONTACTED PRIVATE EMPLOYMENT AGENCY"
	4           "CONTACTED FRIENDS OR RELATIVES"
	5           "CONTACTED SCHOOL/UNIVERSITY EMPL CENTER"
	6           "SENT OUT RESUMES/FILLED OUT APPLICATION"
	7           "CHECKED UNION/PROFESSIONAL REGISTERS"
	8           "PLACED OR ANSWERED ADS"
	9           "OTHER ACTIVE"
	10          "LOOKED AT ADS"
	11          "ATTENDED JOB TRAINING PROGRAMS/COURSES"
	13          "OTHER PASSIVE"
;
label values pulkps3  pulkps3l;
label define pulkps3l
	1           "CONTACTED EMPLOYER DIRECTLY/INTERVIEW"
	2           "CONTACTED PUBLIC EMPLOYMENT AGENCY"
	3           "CONTACTED PRIVATE EMPLOYMENT AGENCY"
	4           "CONTACTED FRIENDS OR RELATIVES"
	5           "CONTACTED SCHOOL/UNIVERSITY EMPL CENTER"
	6           "SENT OUT RESUMES/FILLED OUT APPLICATION"
	7           "CHECKED UNION/PROFESSIONAL REGISTERS"
	8           "PLACED OR ANSWERED ADS"
	9           "OTHER ACTIVE"
	10          "LOOKED AT ADS"
	11          "ATTENDED JOB TRAINING PROGRAMS/COURSES"
	13          "OTHER PASSIVE"
;
label values pulkps4  pulkps4l;
label define pulkps4l
	1           "CONTACTED EMPLOYER DIRECTLY/INTERVIEW"
	2           "CONTACTED PUBLIC EMPLOYMENT AGENCY"
	3           "CONTACTED PRIVATE EMPLOYMENT AGENCY"
	4           "CONTACTED FRIENDS OR RELATIVES"
	5           "CONTACTED SCHOOL/UNIVERSITY EMPL CENTER"
	6           "SENT OUT RESUMES/FILLED OUT APPLICATION"
	7           "CHECKED UNION/PROFESSIONAL REGISTERS"
	8           "PLACED OR ANSWERED ADS"
	9           "OTHER ACTIVE"
	10          "LOOKED AT ADS"
	11          "ATTENDED JOB TRAINING PROGRAMS/COURSES"
	13          "OTHER PASSIVE"
;
label values pulkps5  pulkps5l;
label define pulkps5l
	1           "CONTACTED EMPLOYER DIRECTLY/INTERVIEW"
	2           "CONTACTED PUBLIC EMPLOYMENT AGENCY"
	3           "CONTACTED PRIVATE EMPLOYMENT AGENCY"
	4           "CONTACTED FRIENDS OR RELATIVES"
	5           "CONTACTED SCHOOL/UNIVERSITY EMPL CENTER"
	6           "SENT OUT RESUMES/FILLED OUT APPLICATION"
	7           "CHECKED UNION/PROFESSIONAL REGISTERS"
	8           "PLACED OR ANSWERED ADS"
	9           "OTHER ACTIVE"
	10          "LOOKED AT ADS"
	11          "ATTENDED JOB TRAINING PROGRAMS/COURSES"
	13          "OTHER PASSIVE"
;
label values pulkps6  pulkps6l;
label define pulkps6l
	1           "CONTACTED EMPLOYER DIRECTLY/INTERVIEW"
	2           "CONTACTED PUBLIC EMPLOYMENT AGENCY"
	3           "CONTACTED PRIVATE EMPLOYMENT AGENCY"
	4           "CONTACTED FRIENDS OR RELATIVES"
	5           "CONTACTED SCHOOL/UNIVERSITY EMPL CENTER"
	6           "SENT OUT RESUMES/FILLED OUT APPLICATION"
	7           "CHECKED UNION/PROFESSIONAL REGISTERS"
	8           "PLACED OR ANSWERED ADS"
	9           "OTHER ACTIVE"
	10          "LOOKED AT ADS"
	11          "ATTENDED JOB TRAINING PROGRAMS/COURSES"
	13          "OTHER PASSIVE"
;
label values pelkavl  pelkavl;
label define pelkavl
	1           "YES"
	2           "NO"
;
label values pulkavr  pulkavr;
label define pulkavr
	1           "WAITING FOR NEW JOB TO BEGIN"
	2           "OWN TEMPORARY ILLNESS"
	3           "GOING TO SCHOOL"
	4           "OTHER - SPECIFY"
;
label values pelkll1o pelkll1o;
label define pelkll1o
	1           "WORKING"
	2           "SCHOOL"
	3           "LEFT MILITARY SERVICE"
	4           "SOMETHING ELSE"
;
label values pelkll2o pelkll2o;
label define pelkll2o
	1           "LOST JOB"
	2           "QUIT JOB"
	3           "TEMPORARY JOB ENDED"
;
label values pelklwo  pelklwo;
label define pelklwo
	1           "WITHIN THE LAST 12 MONTHS"
	2           "MORE THAN 12 MONTHS AGO"
	3           "NEVER WORKED"
;
label values pelkdur  pelkdur;
label define pelkdur
	119         "119 or more weeks looking"
;
label values pelkfto  pelkfto;
label define pelkfto
	1           "YES"
	2           "NO"
	3           "DOESN'T MATTER"
;
label values pedwwnto pedwwnto;
label define pedwwnto
	1           "YES, OR MAYBE, IT DEPENDS"
	2           "NO"
	3           "RETIRED"
	4           "DISABLED"
	5           "UNABLE"
;
label values pedwrsn  pedwrsn;
label define pedwrsn
	1           "BELIEVES NO WORK AVAILABLE IN AREA OF EXPERTISE"
	2           "COULDN'T FIND ANY WORK"
	3           "LACKS NECESSARY SCHOOLING/TRAINING"
	4           "EMPLOYERS THINK TOO YOUNG OR TOO OLD"
	5           "OTHER TYPES OF DISCRIMINATION"
	6           "CAN'T ARRANGE CHILD CARE"
	7           "FAMILY RESPONSIBILITIES"
	8           "IN SCHOOL OR OTHER TRAINING"
	9           "ILL-HEALTH, PHYSICAL DISABILITY"
	10          "TRANSPORTATION PROBLEMS"
	11          "OTHER - SPECIFY"
;
label values pedwlko  pedwlko;
label define pedwlko
	1           "YES"
	2           "NO"
;
label values pedwwk   pedwwk;
label define pedwwk
	1           "YES"
	2           "NO"
;
label values pedw4wk  pedw4wk;
label define pedw4wk
	1           "YES"
	2           "NO"
;
label values pedwlkwk pedwlkwk;
label define pedwlkwk
	1           "YES"
	2           "NO"
;
label values pedwavl  pedwavl;
label define pedwavl
	1           "YES"
	2           "NO"
;
label values pedwavr  pedwavr;
label define pedwavr
	1           "OWN TEMPORARY ILLNESS"
	2           "GOING TO SCHOOL"
	3           "OTHER"
;
label values pudwck1  pudwck1l;
label define pudwck1l
	1           "IF ENTRY OF 2 IN BUS2 GOTO PUSCHCK"
	2           "IF ENTRY OF 3 ON ABSRSN GOTO PUNLFCK1"
	3           "IF ENTRY OF 1 IN RET1, STORE 1 IN DWWNTO AND GOTO PUDWCK4"
	4           "ALL OTHERS GOTO PUDWWNT"
;
label values pudwck2  pudwck2l;
label define pudwck2l
	1           "IF ENTRY IN DIS1 OR DIS2 GOTO PUJHCK1-C"
	2           "IF ENTRY OF 4 IN DWWNT GOTO PUDIS1"
	3           "IF ENTRY OF 5 IN DWWNT GOTO PUDIS2"
	4           "ALL OTHERS GOTO PUDWCK4"
;
label values pudwck3  pudwck3l;
label define pudwck3l
	1           "IF AGERNG EQUALS 1-4 OR 9 GOTO PUDWCK4"
	2           "ALL OTHERS GOTO PUNLFCK2"
;
label values pudwck4  pudwck4l;
label define pudwck4l
	1           "IF ENTRY OF 10 AND/OR 11 AND/OR 13 ONLY IN LKM1-LKM3 GOTO PUDWCK5"
	2           "IF ENTRY OF 10 AND/OR 11 AND/OR 13 ONLY IN LKDK1-LKDK3 GOTO PUDWCK5"
	3           "IF ENTRY OF 10 AND/OR 11 AND/OR 13 ONLY IN LKPS1-LKPS3 GOTO PUDWCK5"
	4           "ALL OTHERS GOTO PUDWRSN"
;
label values pudwck5  pudwck5l;
label define pudwck5l
	1           "IF ENTRY OF 1 IN LK THEN STORE 1 IN DWLKO AND GOTO PUDWWK"
	2           "ALL OTHERS GOTO PUDWLK"
;
label values pejhwko  pejhwko;
label define pejhwko
	1           "YES"
	2           "NO"
;
label values pujhdp1o pujhdp1o;
label define pujhdp1o
	1           "YES"
	2           "NO"
;
label values pejhrsn  pejhrsn;
label define pejhrsn
	1           "PERSONAL/FAMILY (INCLUDING PREGNANCY)"
	2           "RETURN TO SCHOOL"
	3           "HEALTH"
	4           "RETIREMENT OR OLD AGE"
	5           "TEMP, SEASONAL OR INTERMITTENT JOB COMPLETE"
	6           "SLACK WORK/BUSINESS CONDITIONS"
	7           "UNSATISFACTORY WORK ARRANGEMENTS (HRS, PAY, ETC.)"
	8           "OTHER - SPECIFY"
;
label values pejhwant pejhwant;
label define pejhwant
	1           "YES, OR IT DEPENDS"
	2           "NO"
;
label values pujhck1  pujhck1l;
label define pujhck1l
	1           "PURET1 = 1, -2, OR -3 THEN GOTO NLFCK2"
	2           "IF MISCK EQUALS 4 OR 8 THEN GOTO PUJHCK2"
	3           "ALL OTHERS GOTO PUNLFCK1"
;
label values pujhck2  pujhck2l;
label define pujhck2l
	1           "IF ENTRY OF 1 IN DWWK AND I-MLR= 3, 4 THEN STORE 1 IN JHWKO, STORE DW4WK IN JHDP1O AND GOTO PUJHRSN"
	2           "IF ENTRY OF 2, D OR R IN DWWK THEN STORE DWWK IN JHWKO AND GOTO PUJHWANT"
	3           "ALL OTHERS GOTO PUJHWK"
;
label values prabsrea prabsrea;
label define prabsrea
	1           "FT PAID-VACATION"
	2           "FT PAID-OWN ILLNESS"
	3           "FT PAID-CHILD CARE PROBLEMS"
	4           "FT PAID-OTHER FAMILY/PERSONAL OBLIG."
	5           "FT PAID-MATERNITY/PATERNITY LEAVE"
	6           "FT PAID-LABOR DISPUTE"
	7           "FT PAID-WEATHER AFFECTED JOB"
	8           "FT PAID-SCHOOL/TRAINING"
	9           "FT PAID-CIVIC/MILITARY DUTY"
	10          "FT PAID-OTHER"
	11          "FT UNPAID-VACATION"
	12          "FT UNPAID-OWN ILLNESS"
	13          "FT UNPAID-CHILD CARE PROBLEMS"
	14          "FT UNPAID-OTHER FAM/PERSONAL OBLIGATION"
	15          "FT UNPAID-MATERNITY/PATERNITY LEAVE"
	16          "FT UNPAID-LABOR DISPUTE"
	17          "FT UNPAID-WEATHER AFFECTED JOB"
	18          "FT UNPAID-SCHOOL/TRAINING"
	19          "FT UNPAID-CIVIC/MILITARY DUTY"
	20          "FT UNPAID-OTHER"
	21          "PT PAID-VACATION"
	22          "PT PAID-OWN ILLNESS"
	23          "PT PAID-CHILD CARE PROBLEMS"
	24          "PT PAID-OTHER FAMILY/PERSONAL OBLIG."
	25          "PT PAID-MATERNITY/PATERNITY LEAVE"
	26          "PT PAID-LABOR DISPUTE"
	27          "PT PAID-WEATHER AFFECTED JOB"
	28          "PT PAID-SCHOOL/TRAINING"
	29          "PT PAID-CIVIC/MILITARY DUTY"
	30          "PT PAID-OTHER"
	31          "PT UNPAID-VACATION"
	32          "PT UNPAID-OWN ILLNESS"
	33          "PT UNPAID-CHILD CARE PROBLEMS"
	34          "PT UNPAID-OTHER FAM/PERSONAL OBLIGATION"
	35          "PT UNPAID-MATERNITY/PATERNITY LEAVE"
	36          "PT UNPAID-LABOR DISPUTE"
	37          "PT UNPAID-WEATHER AFFECTED JOB"
	38          "PT UNPAID-SCHOOL/TRAINING"
	39          "PT UNPAID-CIVIC/MILITARY DUTY"
	40          "PT UNPAID-OTHER"
;
label values prcivlf  prcivlf;
label define prcivlf
	1           "IN CIVILIAN LABOR FORCE"
	2           "NOT IN CIVILIAN LABOR FORCE"
;
label values prdisc   prdisc;
label define prdisc
	1           "DISCOURAGED WORKER"
	2           "CONDITIONALLY INTERESTED"
	3           "NOT AVAILABLE"
;
label values premphrs premphrs;
label define premphrs
	0           "UNEMPLOYED AND NILF"
	1           "W/JOB, NOT AT WORK-ILLNES"
	2           "W/JOB, NOT AT WORK-VACATION"
	3           "W/JOB, NOT AT WORK-WEATHER AFFECTED JOB"
	4           "W/JOB, NOT AT WORK-LABOR DISPUTE"
	5           "W/JOB, NOT AT WORK-CHILD CARE PROBLEMS"
	6           "W/JOB, NOT AT WORK-FAM/PERS OBLIGATION"
	7           "W/JOB, NOT AT WORK-MATERNITY/PATERNITY"
	8           "W/JOB, NOT AT WORK-SCHOOL/TRAINING"
	9           "W/JOB, NOT AT WORK-CIVIC/MILITARY DUTY"
	10          "W/JOB, NOT AT WORK-DOES NOT WORK IN BUS"
	11          "W/JOB, NOT AT WORK-OTHER"
	12          "AT WORK- 1-4 HRS"
	13          "AT WORK- 5-14 HRS"
	14          "AT WORK- 15-21 HRS"
	15          "AT WORK- 22-29 HRS"
	16          "AT WORK- 30-34 HRS"
	17          "AT WORK- 35-39 HRS"
	18          "AT WORK- 40 HRS"
	19          "AT WORK- 41-47 HRS"
	20          "AT WORK- 48 HRS"
	21          "AT WORK- 49-59 HRS"
	22          "AT WORK- 60 HRS OR MORE"
;
label values prempnot prempnot;
label define prempnot
	1           "EMPLOYED"
	2           "UNEMPLOYED"
	3           "NOT IN LABOR FORCE (NILF)-discouraged"
	4           "NOT IN LABOR FORCE (NILF)-other"
;
label values prexplf  prexplf;
label define prexplf
	1           "EMPLOYED"
	2           "UNEMPLOYED"
;
label values prftlf   prftlf;
label define prftlf
	1           "FULL TIME LABOR FORCE"
	2           "PART TIME LABOR FORCE"
;
label values prhrusl  prhrusl;
label define prhrusl
	1           "0-20 HRS"
	2           "21-34 HRS"
	3           "35-39 HRS"
	4           "40 HRS"
	5           "41-49 HRS"
	6           "50 OR MORE HRS"
	7           "VARIES-FULL TIME"
	8           "VARIES-PART TIME"
;
label values prjobsea prjobsea;
label define prjobsea
	1           "LOOKED LAST 12 MONTHS, SINCE COMPLETING PREVIOUS JOB"
	2           "LOOKED AND WORKED IN THE LAST 4 WEEKS"
	3           "LOOKED LAST 4 WEEKS - LAYOFF"
	4           "UNAVAILABLE JOB SEEKERS"
	5           "NO RECENT JOB SEARCH"
;
label values prpthrs  prpthrs;
label define prpthrs
	0           "USUALLY FT, PT FOR NONECONOMIC REASONS"
	1           "USUALLY.FT, PT ECON REASONS; 1-4 HRS"
	2           "USUALLY.FT, PT ECON REASONS; 5-14 HRS"
	3           "USUALLY.FT, PT ECON REASONS; 15-29 HRS"
	4           "USUALLY.FT, PT ECON REASONS; 30-34 HRS"
	5           "USUALLY.PT, ECON REASONS; 1-4 HRS"
	6           "USUALLY.PT, ECON REASONS; 5-14 HRS"
	7           "USUALLY.PT, ECON REASONS; 15-29 HRS"
	8           "USUALLY.PT, ECON REASONS; 30-34 HRS"
	9           "USUALLY.PT, NON-ECON REASONS; 1-4 HRS"
	10          "USUALLY.PT, NON-ECON REASONS; 5-14 HRS"
	11          "USUALLY.PT, NON-ECON REASONS; 15-29 HRS"
	12          "USUALLY.PT, NON-ECON REASONS; 30-34 HRS"
;
label values prptrea  prptrea;
label define prptrea
	1           "USU. FT-SLACK WORK/BUSINESS CONDITIONS"
	2           "USU. FT-SEASONAL WORK"
	3           "USU. FT-JOB STARTED/ENDED DURING WEEK"
	4           "USU. FT-VACATION/PERSONAL DAY"
	5           "USU. FT-OWN ILLNESS/INJURY/MEDICAL APPOINTMENT"
	6           "USU. FT-HOLIDAY (RELIGIOUS OR LEGAL)"
	7           "USU. FT-CHILD CARE PROBLEMS"
	8           "USU. FT-OTHER FAM/PERS OBLIGATIONS"
	9           "USU. FT-LABOR DISPUTE"
	10          "USU. FT-WEATHER AFFECTED JOB"
	11          "USU. FT-SCHOOL/TRAINING"
	12          "USU. FT-CIVIC/MILITARY DUTY"
	13          "USU. FT-OTHER REASON"
	14          "USU. PT-SLACK WORK/BUSINESS CONDITIONS"
	15          "USU. PT-COULD ONLY FIND PT WORK"
	16          "USU. PT-SEASONAL WORK"
	17          "USU. PT-CHILD CARE PROBLEMS"
	18          "USU. PT-OTHER FAM/PERS OBLIGATIONS"
	19          "USU. PT-HEALTH/MEDICAL LIMITATIONS"
	20          "USU. PT-SCHOOL/TRAINING"
	21          "USU. PT-RETIRED/S.S. LIMIT ON EARNINGS"
	22          "USU. PT-WORKWEEK <35 HOURS"
	23          "USU. PT-OTHER REASON"
;
label values pruntype pruntype;
label define pruntype
	1           "JOB LOSER/ON LAYOFF"
	2           "OTHER JOB LOSER"
	3           "TEMPORARY JOB ENDED"
	4           "JOB LEAVER"
	5           "RE-ENTRANT"
	6           "NEW-ENTRANT"
;
label values prwksch  prwksch;
label define prwksch
	0           "NOT IN LABOR FORCE"
	1           "AT WORK"
	2           "WITH JOB, NOT AT WORK"
	3           "UNEMPLOYED, SEEKS FT"
	4           "UNEMPLOYED, SEEKS PT"
;
label values prwkstat prwkstat;
label define prwkstat
	1           "NOT IN LABOR FORCE"
	2           "FT HOURS (35+), USUALLY FT"
	3           "PT FOR ECONOMIC REASONS, USUALLY FT"
	4           "PT FOR NON-ECONOMIC REASONS, USUALLY FT"
	5           "NOT AT WORK, USUALLY FT"
	6           "PT HRS, USUALLY PT FOR ECONOMIC REASONS"
	7           "PT HRS, USUALLY PT FOR NON-ECONOMIC REASONS"
	8           "FT HOURS, USUALLY PT FOR ECONOMIC REASONS"
	9           "FT HOURS, USUALLY PT FOR NON-ECONOMIC"
	10          "NOT AT WORK, USUALLY PART-TIME"
	11          "UNEMPLOYED FT"
	12          "UNEMPLOYED PT"
;
label values prwntjob prwntjob;
label define prwntjob
	1           "WANT A JOB"
	2           "OTHER NOT IN LABOR FORCE"
;
label values pujhck3  pujhck3l;
label define pujhck3l
	1           "IF I-MLR EQ 3 OR 4 THEN GOTO PUJHDP1"
	2           "ALL OTHERS GOTO PUJHRSN"
;
label values pujhck4  pujhck4l;
label define pujhck4l
	1           "IF ENTRY OF 2, D OR R IN PUDW4WK OR IN PUJHDP1O THEN GOTO PUJHCK5"
	2           "IF ENTRY OF 1 IN PUDW4WK OR IN PUJHDP10 THEN GOTO PUIO1INT"
	3           "IF I-MLR EQUALS 1 OR 2 AND ENTRY IN PUJHRSN THEN GOTO PUJHCK5"
	4           "IF ENTRY IN PUJHRSN THEN GOTO PUIO1INT"
	5           "ALL OTHERS GOTO PUNLFCK1"
;
label values pujhck5  pujhck5l;
label define pujhck5l
	1           "IF I-IO1ICR EQUALS 1 OR I-IO1OCR EQUALS 1 THEN GOTO PUIO1INT"
	2           "ALL OTHERS GOTO PUIOCK5"
;
label values puiodp1  puiodp1l;
label define puiodp1l
	1           "YES"
	2           "NO"
;
label values puiodp2  puiodp2l;
label define puiodp2l
	1           "YES"
	2           "NO"
;
label values puiodp3  puiodp3l;
label define puiodp3l
	1           "YES"
	2           "NO"
;
label values peio1cow peio1cow;
label define peio1cow
	1           "GOVERNMENT - FEDERAL"
	2           "GOVERNMENT - STATE"
	3           "GOVERNMENT - LOCAL"
	4           "PRIVATE, FOR PROFIT"
	5           "PRIVATE, NONPROFIT"
	6           "SELF-EMPLOYED, INCORPORATED"
	7           "SELF-EMPLOYED, UNINCORPORATED"
	8           "WITHOUT PAY"
;
label values puio1mfg puio1mfg;
label define puio1mfg
	1           "MANUFACTURING"
	2           "RETAIL TRADE"
	3           "WHOLESALE TRADE"
	4           "SOMETHING ELSE"
;
label values peio2cow peio2cow;
label define peio2cow
	1           "GOVERNMENT - FEDERAL"
	2           "GOVERNMENT - STATE"
	3           "GOVERNMENT - LOCAL"
	4           "PRIVATE, FOR PROFIT"
	5           "PRIVATE, NONPROFIT"
	6           "SELF-EMPLOYED, INCORPORATED"
	7           "SELF-EMPLOYED, UNINCORPORATED"
	8           "WITHOUT PAY"
;
label values puio2mfg puio2mfg;
label define puio2mfg
	1           "MANUFACTURING"
	2           "RETAIL TRADE"
	3           "WHOLESALE TRADE"
	4           "SOMETHING ELSE"
;
label values puiock1  puiock1l;
label define puiock1l
	1           "IF {MISCK EQ 1 OR 5) OR MISCK EQ 2-4, 6-8 AND I-MLR EQ 3-7) AND ENTRY OF 1 IN ABS} THEN GOTO PUIO1INT"
	2           "IF (MISCK EQ 1 OR 5) OR {(MISCK EQ 2-4, 6-8 AND I-MLR EQ 3-7) AND ( ENTRY OF 1 IN WK OR HRCK7-C IS BLANK, 1-3)} GOTO PUIO1INT"
	3           "IF I-IO1NAM IS D, R OR BLANK THEN GOTO PUIO1INT"
	4           "ALL OTHERS GOTO PUIODP1"
;
label values puiock2  puiock2l;
label define puiock2l
	1           "IF I-IO1ICR EQ 1 THEN GOTO PUIO1IND"
	2           "IF I-IO1OCR EQ 1 THEN GOTO PUIO1OCC"
	3           "ALL OTHERS GOTO PUIODP2"
;
label values puiock3  puiock3l;
label define puiock3l
	1           "IF I-IO1OCC EQUALS D, R OR BLANK THEN GOTO PUIO1OCC"
	2           "IF I-IO1DT1 IS D, R OR BLANK THEN GOTO PUIO1OCC"
	3           "ALL OTHERS GOTO PUIODP3"
;
label values prioelg  prioelg;
label define prioelg
	0           "NOT ELIGIBLE FOR EDIT"
	1           "ELIGIBLE FOR EDIT"
;
label values pragna   pragna;
label define pragna
	1           "AGRICULTURAL"
	2           "NON-AGRICULTURAL"
;
label values prcow1   prcow1l;
label define prcow1l
	1           "FEDERAL GOVT"
	2           "STATE GOVT"
	3           "LOCAL GOVT"
	4           "PRIVATE (INCL. SELF-EMPLOYED INCORP.)"
	5           "SELF-EMPLOYED, UNINCORP."
	6           "WITHOUT PAY"
;
label values prcow2   prcow2l;
label define prcow2l
	1           "FEDERAL GOVT"
	2           "STATE GOVT"
	3           "LOCAL GOVT"
	4           "PRIVATE (INCL. SELF-EMPLOYED INCORP.)"
	5           "SELF-EMPLOYED, UNINCORP."
	6           "WITHOUT PAY"
;
label values prcowpg  prcowpg;
label define prcowpg
	1           "PRIVATE"
	2           "GOVERNMENT"
;
label values prdtcow1 prdtcowa;
label define prdtcowa
	1           "AGRI., WAGE & SALARY, PRIVATE"
	2           "AGRI., WAGE & SALARY, GOVERNMENT"
	3           "AGRI., SELF-EMPLOYED"
	4           "AGRI., UNPAID"
	5           "NONAG, WS, PRIVATE, PRIVATE HHLDS"
	6           "NONAG, WS, PRIVATE, OTHER PRIVATE"
	7           "NONAG, WS, GOVT, FEDERAL"
	8           "NONAG, WS, GOVT, STATE"
	9           "NONAG, WS, GOVT, LOCAL"
	10          "NONAG, SELF-EMPLOYED"
	11          "NONAG, UNPAID"
;
label values prdtcow2 prdtcowb;
label define prdtcowb
	1           "AGRI., WAGE & SALARY, PRIVATE"
	2           "AGRI., WAGE & SALARY, GOVERNMENT"
	3           "AGRI., SELF-EMPLOYED"
	4           "AGRI., UNPAID"
	5           "NONAG, WS, PRIVATE, PRIVATE HHLDS"
	6           "NONAG, WS, PRIVATE, OTHER PRIVATE"
	7           "NONAG, WS, GOVT, FEDERAL"
	8           "NONAG, WS, GOVT, STATE"
	9           "NONAG, WS, GOVT, LOCAL"
	10          "NONAG, SELF-EMPLOYED"
	11          "NONAG, UNPAID"
;
label values prdtind1 prdtinda;
label define prdtinda
	1           "Agriculture"
	2           "Forestry, logging, fishing, and hunting"
	3           "Mining, quarrying, and oil and gas extraction"
	4           "Construction"
	5           "Nonmetallic mineral product manufacturing"
	6           "Primary metals and fabricated metal products"
	7           "Machinery manufacturing"
	8           "Computer and electronic product manufacturing"
	9           "Electrical equipment, appliance manufacturing"
	10          "Transportation equipment manufacturing"
	11          "Wood products"
	12          "Furniture and fixtures manufacturing"
	13          "Miscellaneous and not specified manufacturing"
	14          "Food manufacturing"
	15          "Beverage and tobacco products"
	16          "Textile, apparel, and leather manufacturing"
	17          "Paper and printing"
	18          "Petroleum and coal products manufacturing"
	19          "Chemical manufacturing"
	20          "Plastics and rubber products"
	21          "Wholesale trade"
	22          "Retail trade"
	23          "Transportation and warehousing"
	24          "Utilities"
	25          "Publishing industries (except internet)"
	26          "Motion picture and sound recording industries"
	27          "Broadcasting (except internet)"
	28          "Internet publishing and broadcasting"
	29          "Telecommunications"
	30          "Internet service providers and data processing services"
	31          "Other information services"
	32          "Finance"
	33          "Insurance"
	34          "Real estate"
	35          "Rental and leasing services"
	36          "Professional, scientific, and technical services"
	37          "Management of companies and enterprises"
	38          "Administrative and support services"
	39          "Waste management and remediation services"
	40          "Educational services"
	41          "Hospitals"
	42          "Health care services, except hospitals"
	43          "Social assistance services"
	44          "Arts, entertainment, and recreation"
	45          "Accommodation"
	46          "Food services and drinking places"
	47          "Repair and maintenance"
	48          "Personal and laundry services"
	49          "Membership associations and organizations"
	50          "Private households"
	51          "Public administration"
	52          "Armed forces"
;
label values prdtind2 prdtindb;
label define prdtindb
	1           "Agriculture"
	2           "Forestry, logging, fishing, and hunting"
	3           "Mining, quarrying, and oil and gas extraction"
	4           "Construction"
	5           "Nonmetallic mineral product manufacturing"
	6           "Primary metals and fabricated metal products"
	7           "Machinery manufacturing"
	8           "Computer and electronic product manufacturing"
	9           "Electrical equipment, appliance manufacturing"
	10          "Transportation equipment manufacturing"
	11          "Wood products"
	12          "Furniture and fixtures manufacturing"
	13          "Miscellaneous and not specified manufacturing"
	14          "Food manufacturing"
	15          "Beverage and tobacco products"
	16          "Textile, apparel, and leather manufacturing"
	17          "Paper and printing"
	18          "Petroleum and coal products manufacturing"
	19          "Chemical manufacturing"
	20          "Plastics and rubber products"
	21          "Wholesale trade"
	22          "Retail trade"
	23          "Transportation and warehousing"
	24          "Utilities"
	25          "Publishing industries (except internet)"
	26          "Motion picture and sound recording industries"
	27          "Broadcasting (except internet)"
	28          "Internet publishing and broadcasting"
	29          "Telecommunications"
	30          "Internet service providers and data processing services"
	31          "Other information services"
	32          "Finance"
	33          "Insurance"
	34          "Real estate"
	35          "Rental and leasing services"
	36          "Professional, scientific, and technical services"
	37          "Management of companies and enterprises"
	38          "Administrative and support services"
	39          "Waste management and remediation services"
	40          "Educational services"
	41          "Hospitals"
	42          "Health care services, except hospitals"
	43          "Social assistance services"
	44          "Arts, entertainment, and recreation"
	45          "Accommodation"
	46          "Food services and drinking places"
	47          "Repair and maintenance"
	48          "Personal and laundry services"
	49          "Membership associations and organizations"
	50          "Private households"
	51          "Public administration"
	52          "Armed forces"
;
label values prdtocc1 prdtocca;
label define prdtocca
	1           "Management occupations"
	2           "Business and financial operations occupations"
	3           "Computer and mathematical occupations"
	4           "Architecture and engineering occupations"
	5           "Life, physical, and social science occupations"
	6           "Community and social service occupations"
	7           "Legal occupations"
	8           "Education instruction and library occupations"
	9           "Arts, design, entertainment, sports, and media"
	10          "Healthcare practitioner and technical occupations"
	11          "Healthcare support occupations"
	12          "Protective service occupations"
	13          "Food preparation and serving related occupations"
	14          "Building and grounds cleaning and maintenance occupations"
	15          "Personal care and service occupations"
	16          "Sales and related occupations"
	17          "Office and administrative support occupations"
	18          "Farming, fishing, and forestry occupations"
	19          "Construction and extraction occupations"
	20          "Installation, maintenance, and repair occupations"
	21          "Production occupations"
	22          "Transportation and material moving occupations"
	23          "Armed Forces"
;
label values prdtocc2 prdtoccb;
label define prdtoccb
	1           "Management occupations"
	2           "Business and financial operations occupations"
	3           "Computer and mathematical occupations"
	4           "Architecture and engineering occupations"
	5           "Life, physical, and social science occupations"
	6           "Community and social service occupations"
	7           "Legal occupations"
	8           "Education instruction and library occupations"
	9           "Arts, design, entertainment, sports, and media"
	10          "Healthcare practitioner and technical occupations"
	11          "Healthcare support occupations"
	12          "Protective service occupations"
	13          "Food preparation and serving related occupations"
	14          "Building and grounds cleaning and maintenanc	occupations"
	15          "Personal care and service occupations"
	16          "Sales and related occupations"
	17          "Office and administrative support occupations"
	18          "Farming, fishing, and forestry occupations"
	19          "Construction and extraction occupations"
	20          "Installation, maintenance, and repair occupations"
	21          "Production occupations"
	22          "Transportation and material moving occupations"
	23          "Armed Forces"
;
label values prmjind1 prmjinda;
label define prmjinda
	1           "Agriculture, forestry, fishing, and hunting"
	2           "Mining"
	3           "Construction"
	4           "Manufacturing"
	5           "Wholesale and retail trade"
	6           "Transportation and utilities"
	7           "Information"
	8           "Financial activities"
	9           "Professional and business services"
	10          "Educational and health services"
	11          "Leisure and hospitality"
	12          "Other services"
	13          "Public administration"
	14          "Armed Forces"
;
label values prmjind2 prmjindb;
label define prmjindb
	1           "Agriculture, forestry, fishing, and hunting"
	2           "Mining"
	3           "Construction"
	4           "Manufacturing"
	5           "Wholesale and retail trade"
	6           "Transportation and utilities"
	7           "Information"
	8           "Financial activities"
	9           "Professional and business services"
	10          "Educational and health services"
	11          "Leisure and hospitality"
	12          "Other services"
	13          "Public administration"
	14          "Armed Forces"
;
label values prmjocc1 prmjocca;
label define prmjocca
	1           "Management, business, and financial occupations"
	2           "Professional and related occupations"
	3           "Service occupations"
	4           "Sales and related occupations"
	5           "Office and administrative support occupations"
	6           "Farming, fishing, and forestry occupations"
	7           "Construction and extraction occupations"
	8           "Installation, maintenance, and repair occupations"
	9           "Production occupations"
	10          "Transportation and material moving occupations"
	11          "Armed Forces"
;
label values prmjocc2 prmjoccb;
label define prmjoccb
	1           "Management, business, and financial occupations"
	2           "Professional and related occupations"
	3           "Service occupations"
	4           "Sales and related occupations"
	5           "Office and administrative support occupations"
	6           "Farming, fishing, and forestry occupations"
	7           "Construction and extraction occupations"
	8           "Installation, maintenance, and repair occupations"
	9           "Production occupations"
	10          "Transportation and material moving occupations"
	11          "Armed Forces"
;
label values prmjocgr prmjocgr;
label define prmjocgr
	1           "Management, professional, and related occupations"
	2           "Service occupations"
	3           "Sales and office occupations"
	4           "Farming, fishing, and forestry occupations"
	5           "Construction, and maintenance occupations"
	6           "Production, transportation, and material moving"
	7           "Armed Forces"
;
label values prsjmj  prsjmj;
label define prsjmj
	1           "SINGLE JOBHOLDER"
	2           "MULTIPLE JOBHOLDER"
;
label values prerelg  prerelg;
label define prerelg
	0           "NOT ELIGIBLE FOR EDIT"
	1           "ELIGIBLE FOR EDIT"
;
label values peernuot peernuot;
label define peernuot
	1           "YES"
	2           "NO"
;
label values peernper peernper;
label define peernper
	1           "HOURLY"
	2           "WEEKLY"
	3           "BI-WEEKLY"
	4           "TWICE MONTHLY"
	5           "MONTHLY"
	6           "ANNUALLY"
	7           "OTHER - SPECIFY"
;
label values peernrt  peernrt;
label define peernrt
	1           "YES"
	2           "NO"
;
label values peernhry peernhry;
label define peernhry
	1           "HOURLY WORKER"
	2           "NONHOURLY WORKER"
;
label values pthr     pthr;
label define pthr
	0           "NOT TOPCODED"
	1           "TOPCODED"
;
label values ptot     ptot;
label define ptot
	0           "NOT TOPCODED"
	1           "TOPCODED"
;
label values peernlab peernlab;
label define peernlab
	1           "YES"
	2           "NO"
;
label values peerncov peerncov;
label define peerncov
	1           "YES"
	2           "NO"
;
label values penlfjh  penlfjh;
label define penlfjh
	1           "WITHIN THE LAST 12 MONTHS"
	2           "MORE THAN 12 MONTHS AGO"
	3           "NEVER WORKED"
;
label values penlfret penlfret;
label define penlfret
	1           "YES"
	2           "NO"
;
label values penlfact penlfact;
label define penlfact
	1           "DISABLED"
	2           "ILL"
	3           "IN SCHOOL"
	4           "TAKING CARE OF HOUSE OR FAMILY"
	5           "IN RETIREMENT"
	6           "SOMETHING ELSE/OTHER"
;
label values punlfck1 punlfcka;
label define punlfcka
	1           "IF AGERNG EQUALS 1-4 OR 9"
	2           "ALL OTHERS GOT NLFRET"
;
label values punlfck2 punlfckb;
label define punlfckb
	1           "IF MISCK EQUALS 4 OR 8 THEN GOTO NLFJH"
	2           "ALL OTHERS GOTO LBFR-END"
;
label values peschenr peschenr;
label define peschenr
	1           "YES"
	2           "NO"
;
label values peschft  peschft;
label define peschft
	1           "FULL-TIME"
	2           "PART-TIME"
;
label values peschlvl peschlvl;
label define peschlvl
	1           "HIGH SCHOOL"
	2           "COLLEGE OR UNIVERSITY"
;
label values prnlfsch prnlfsch;
label define prnlfsch
	1           "IN SCHOOL"
	2           "NOT IN SCHOOL"
;
label values prchld   prchld;
label define prchld
	-1          "NIU (Not a parent)"
	0           "No own children under 18 years of age"
	1           "All own children 0- 2 years of age"
	2           "All own children 3- 5 years of age"
	3           "All own children 6-13 years of age"
	4           "All own children 14-17 years of age"
	5           "Own children 0- 2 and 3- 5 years of age (none 6-17)"
	6           "Own children 0- 2 and 6-13 years of age (none 3- 5 or 14-17)"
	7           "Own children 0- 2 and 14-17 years of age (none 3-13)"
	8           "Own children 3- 5 and 6-13 years of age (none 0- 2 or 14-17)"
	9           "Own children 3- 5 and 14-17 years of age (none 0- 2 or 6-13)"
	10          "Own children 6-13 and 14-17 years of age (none 0- 5)"
	11          "Own children 0- 2, 3- 5, and 6-13 years of age (none 14-17)"
	12          "Own children 0- 2, 3- 5, and 14-17 years of age (none 6-13)"
	13          "Own children 0- 2, 6-13, and 14-17 years of age (none 3- 5)"
	14          "Own children 3- 5, 6-13, and 14-17 years of age (none 0- 2)"
	15          "Own children from all age groups"
;
label values prnmchld prnmchld;
label define prnmchld
	-1          "NIU (Not a parent)"
	0           "VALUE  NO CHANGE"
	1           "BLANK  NO CHANGE"
	2           "DON'T KNOW  NO CHANGE"
	3           "REFUSED  NO CHANGE"
	10          "VALUE TO VALUE"
	11          "BLANK TO VALUE"
	12          "DON'T KNOW TO VALUE"
	13          "REFUSED TO VALUE"
	20          "VALUE TO LONGITUDINAL VALUE"
	21          "BLANK TO LONGITUDINAL VALUE"
	22          "DON'T KNOW TO LONGITUDINAL VALUE"
	23          "REFUSED TO LONGITUDINAL VALUE"
	30          "VALUE TO ALLOCATED VALUE LONG."
	31          "BLANK TO ALLOCATED VALUE LONG."
	32          "DON'T KNOW TO ALLOCATED VALUE LONG."
	33          "REFUSED TO ALLOCATED VALUE LONG."
	40          "VALUE TO ALLOCATED VALUE"
	41          "BLANK TO ALLOCATED VALUE"
	42          "DON'T KNOW TO ALLOCATED VALUE"
	43          "REFUSED TO ALLOCATED VALUE"
	50          "VALUE TO BLANK"
	52          "DON'T KNOW TO BLANK"
	53          "REFUSED TO BLANK"
;
label values pedipged pedipged;
label define pedipged
	1           "Graduation from high school"
	2           "GED or other equivalent"
;
label values pehgcomp pehgcomp;
label define pehgcomp
	1           "Less than 1st grade"
	2           "1st, 2nd, 3rd, or 4th grade"
	3           "5th or 6th grade"
	4           "7th or 8th grade"
	5           "9th grade"
	6           "10th grade"
	7           "11th grade"
	8           "12th grade (no diploma)"
;
label values pecyc    pecyc;
label define pecyc
	1           "Less than 1 year (includes 0 years completed)"
	2           "The first or Freshman year"
	3           "The second or Sophomore year"
	4           "The third or Junior year"
	5           "Four or more years"
;
label values peio1icd peio1icd;
label define peio1icd
	170         "Crop production 111"
	180         "Animal production 112"
	190         "Forestry except logging 1131, 1132"
	270         "Logging 1133"
	280         "Fishing, hunting, and trapping 114"
	290         "Support activities for agriculture and forestry 115"
	370         "Oil and gas extraction 211"
	380         "Coal mining 2121"
	390         "Metal ore mining 2122"
	470         "Nonmetallic mineral mining and quarrying 2123"
	480         "Not specified type of mining Part of 21"
	490         "Support activities for mining 213"
	570         "Electric power generation, transmission and distribution Pt. 2211"
	580         "Natural gas distribution Pt. 2212"
	590         "Electric and gas, and other combinations Pts. 2211, 2212"
	670         "Water, steam, air-conditioning, and irrigation systems 22131, 22133"
	680         "Sewage treatment facilities 22132"
	690         "Not specified utilities Part of 22"
	770         "** Construction 23 (Includes the cleaning of buildings and dwellings is incidental during construction and immediately after construction)"
	1070        "Animal food, grain and oilseed milling 3111, 3112"
	1080        "Sugar and confectionery products 3113"
	1090        "Fruit and vegetable preserving and specialty food manufacturing 3114"
	1170        "Dairy product manufacturing 3115"
	1180        "Animal slaughtering and processing 3116"
	1190        "Retail bakeries 311811"
	1270        "Bakeries, except retail 3118 exc. 311811"
	1280        "Seafood and other miscellaneous foods, n.e.c. 3117, 3119"
	1290        "Not specified food industries Part of 311"
	1370        "Beverage manufacturing 3121"
	1390        "Tobacco manufacturing 3122"
	1470        "Fiber, yarn, and thread mills 3131"
	1480        "Fabric mills, except knitting 3132 exc. 31324"
	1490        "Textile and fabric finishing and coating mills 3133"
	1570        "Carpet and rug mills 31411"
	1590        "Textile product mills, except carpets and rugs 314 exc. 31411"
	1670        "Knitting mills 31324, 3151"
	1680        "Cut and sew apparel manufacturing 3152"
	1690        "Apparel accessories and other apparel manufacturing 3159"
	1770        "Footwear manufacturing 3162"
	1790        "Leather tanning and products, except footwear manufacturing 3161, 3169"
	1870        "Pulp, paper, and paperboard mills 3221"
	1880        "Paperboard containers and boxes 32221"
	1890        "Miscellaneous paper and pulp products 32222, 32223, 32229"
	1990        "Printing and related support activities 3231"
	2070        "Petroleum refining 32411"
	2090        "Miscellaneous petroleum and coal products 32419"
	2170        "Resin, synthetic rubber and fibers, and filaments manufacturing 3252"
	2180        "Agricultural chemical manufacturing 3253"
	2190        "Pharmaceutical and medicine manufacturing 3254"
	2270        "Paint, coating, and adhesive manufacturing B46 3255"
	2280        "Soap, cleaning compound, and cosmetics manufacturing 3256"
	2290        "Industrial and miscellaneous chemicals 3251, 3259"
	2370        "Plastics product manufacturing 3261"
	2380        "Tire manufacturing 32621"
	2390        "Rubber products, except tires, manufacturing 32622, 32629"
	2470        "Pottery, ceramics, and related products manufacturing 32711"
	2480        "Structural clay product manufacturing 32712"
	2490        "Glass and glass product manufacturing 3272"
	2570        "Cement, concrete, lime, and gypsum product manufacturing 3273, 3274"
	2590        "Miscellaneous nonmetallic mineral product manufacturing 3279"
	2670        "Iron and steel mills and steel product manufacturing 3311, 3312"
	2680        "Aluminum production and processing 3313"
	2690        "Nonferrous metal, except aluminum, production and processing 3314"
	2770        "Foundries 3315"
	2780        "Metal forgings and stampings 3321"
	2790        "Cutlery and hand tool manufacturing 3322"
	2870        "Structural metals, and tank and shipping container manufacturing 3323, 3324"
	2880        "Machine shops; turned product; screw, nut and bolt manufacturing 3327"
	2890        "Coating, engraving, heat treating and allied activities 3328"
	2970        "Ordnance 332992 to 332995"
	2980        "Miscellaneous fabricated metal products manufacturing 3325, 3326, 3329 exc. 332992, 332993, 332994, 332995"
	2990        "Not specified metal industries Part of 331 and 332"
	3070        "Agricultural implement manufacturing 33311"
	3080        "Construction, mining and oil field machinery manufacturing 33312, 33313"
	3090        "Commercial and service industry machinery manufacturing 3333"
	3170        "Metalworking machinery manufacturing 3335"
	3180        "Engines, turbines, and power transmission equipment manufacturing 3336"
	3190        "Machinery manufacturing, n.e.c. 3332, 3334, 3339"
	3290        "Not specified machinery manufacturing Part of 333"
	3360        "Computer and peripheral equipment manufacturing 3341"
	3370        "Communications, audio, and video equipment manufacturing 3342, 3343"
	3380        "Navigational, measuring, electromedical, and control instruments manufacturing 3345"
	3390        "Electronic component and product manufacturing, n.e.c. 3344, 3346"
	3470        "Household appliance manufacturing 3352"
	3490        "Electrical lighting, equipment, and supplies manufacturing, n.e.c. 3351, 3353, 3359"
	3570        "Motor vehicles and motor vehicle equipment manufacturing 3361, 3362, 3363"
	3580        "Aircraft and parts manufacturing 336411 to 336413"
	3590        "Aerospace products and parts manufacturing 336414, 336415, 336419"
	3670        "Railroad rolling stock manufacturing 3365"
	3680        "Ship and boat building 3366"
	3690        "Other transportation equipment manufacturing 3369"
	3770        "Sawmills and wood preservation 3211"
	3780        "Veneer, plywood, and engineered wood products 3212"
	3790        "Prefabricated wood buildings and mobile homes 321991, 321992"
	3870        "Miscellaneous wood products 3219 exc. 321991, 321992"
	3890        "Furniture and related product manufacturing 337"
	3960        "Medical equipment and supplies manufacturing 3391"
	3970        "Toys, amusement, and sporting goods manufacturing 33992, 33993"
	3980        "Miscellaneous manufacturing, n.e.c. 3399 exc. 33992, 33993"
	3990        "Not specified manufacturing industries Part of 31, 32, 33"
	4070        "** Motor vehicles, parts and supplies, merchant wholesalers *4231"
	4080        "** Furniture and home furnishing, merchant wholesalers *4232"
	4090        "** Lumber and other construction materials, merchant wholesalers *4233"
	4170        "** Professional and commercial equipment and supplies, merchant wholesalers *4234"
	4180        "** Metals and minerals, except petroleum, merchant wholesalers *4235"
	4190        "** Electrical goods, merchant wholesalers *4236"
	4260        "** Hardware, plumbing and heating equipment, and supplies, merchant wholesalers *4237"
	4270        "** Machinery, equipment, and supplies, merchant wholesalers *4238"
	4280        "** Recyclable material, merchant wholesalers *42393"
	4290        "** Miscellaneous durable goods, merchant wholesalers *4239 exc. 42393"
	4370        "** Paper and paper products, merchant wholesalers *4241"
	4380        "** Drugs, sundries, and chemical and allied products, merchant wholesalers *4242, 4246"
	4390        "** Apparel, fabrics, and notions, merchant wholesalers *4243"
	4470        "** Groceries and related products, merchant wholesalers *4244"
	4480        "** Farm product raw materials, merchant wholesalers *4245"
	4490        "** Petroleum and petroleum products, merchant wholesalers *4247"
	4560        "** Alcoholic beverages, merchant wholesalers *4248"
	4570        "** Farm supplies, merchant wholesalers *42491"
	4580        "** Miscellaneous nondurable goods, merchant wholesalers *4249 exc. 42491"
	4585        "*** Wholesale electronic markets, agents and brokers New industry *4251"
	4590        "**Not specified wholesale trade Part of 42"
	4670        "Automobile dealers 4411"
	4680        "Other motor vehicle dealers 4412"
	4690        "Auto parts, accessories, and tire stores 4413"
	4770        "Furniture and home furnishings stores 442"
	4780        "Household appliance stores 443111"
	4790        "Radio, TV, and computer stores 443112, 44312"
	4870        "Building material and supplies dealers 4441 exc. 44413"
	4880        "Hardware stores 44413"
	4890        "Lawn and garden equipment and supplies stores 4442"
	4970        "Grocery stores 4451"
	4980        "Specialty food stores 4452"
	4990        "Beer, wine, and liquor stores 4453"
	5070        "Pharmacies and drug stores 4461"
	5080        "Health and personal care, except drug, stores 446 exc. 44611"
	5090        "Gasoline stations 447"
	5170        "Clothing and accessories, except shoe, stores 448 exc. 44821, 4483"
	5180        "Shoe stores 44821"
	5190        "Jewelry, luggage, and leather goods stores 4483"
	5270        "Sporting goods, camera, and hobby and toy stores 44313, 45111, 45112"
	5280        "Sewing, needlework, and piece goods stores 45113"
	5290        "Music stores 45114, 45122"
	5370        "Book stores and news dealers 45121"
	5380        "****Department stores and discount stores 45211"
	5390        "Miscellaneous general merchandise stores 4529"
	5470        "Retail florists 4531"
	5480        "Office supplies and stationery stores 45321"
	5490        "Used merchandise stores 4533"
	5570        "Gift, novelty, and souvenir shops 45322"
	5580        "Miscellaneous retail stores 4539"
	5590        "*** Electronic shopping New industry *454111"
	5591        "*** Electronic auctions New industry *454112"
	5592        "** Mail order houses *454113"
	5670        "Vending machine operators 4542"
	5680        "Fuel dealers 45431"
	5690        "Other direct selling establishments 45439"
	5790        "Not specified retail trade Part of 44, 45"
	6070        "Air transportation 481"
	6080        "Rail transportation 482"
	6090        "Water transportation 483"
	6170        "Truck transportation 484"
	6180        "Bus service and urban transit 4851, 4852, 4854, 4855, 4859"
	6190        "Taxi and limousine service 4853"
	6270        "Pipeline transportation 486"
	6280        "Scenic and sightseeing transportation 487"
	6290        "Services incidental to transportation 488"
	6370        "Postal Service 491"
	6380        "Couriers and messengers 492"
	6390        "Warehousing and storage 493"
	6470        "**Newspaper publishers 51111"
	6480        "**Publishing, except newspapers and software 5111 exc. 51111"
	6490        "Software publishing 5112"
	6570        "Motion pictures and video industries 5121"
	6590        "Sound recording industries 5122"
	6670        "Radio and television broadcasting and cable 5151, 5152, 5175"
	6675        "*** Internet publishing and broadcasting New industry *5161"
	6680        "Wired telecommunications carriers *5171"
	6690        "Other telecommunications services *517 exc. 5171, 5175"
	6692        "*** Internet service providers New industry *5181"
	6695        "**** Data processing, hosting, and related services *5182"
	6770        "Libraries and archives *51912"
	6780        "Other information services *5191 exc. 51912"
	6870        "Banking and related activities 521,52211, 52219"
	6880        "Savings institutions, including credit unions 52212, 52213"
	6890        "Non-depository credit and related activities 5222, 5223"
	6970        "Securities, commodities, funds, trusts, and other financial investments 523, 525"
	6990        "Insurance carriers and related activities 524"
	7070        "Real estate 531"
	7080        "Automotive equipment rental and leasing 5321"
	7170        "Video tape and disk rental 53223"
	7180        "Other consumer goods rental 53221, 53222, 53229, 5323"
	7190        "Commercial, industrial, and other intangible assets rental and leasing 5324, 533"
	7270        "Legal services 5411"
	7280        "Accounting, tax preparation, bookkeeping, and payroll services 5412"
	7290        "Architectural, engineering, and related services 5413"
	7370        "Specialized design services 5414"
	7380        "Computer systems design and related services 5415"
	7390        "Management, scientific, and technical consulting services 5416"
	7460        "Scientific research and development services 5417"
	7470        "Advertising and related services 5418"
	7480        "Veterinary services 54194"
	7490        "Other professional, scientific, and technical services 5419 exc. 54194"
	7570        "Management of companies and enterprises 551"
	7580        "Employment services 5613"
	7590        "Business support services 5614"
	7670        "Travel arrangements and reservation services 5615"
	7680        "Investigation and security services 5616"
	7690        "** Services to buildings and dwellings 5617 exc. 56173 (except cleaning during construction and immediately after construction)"
	7770        "Landscaping services 56173"
	7780        "Other administrative and other support services 5611, 5612, 5619"
	7790        "Waste management and remediation services 562"
	7860        "Elementary and secondary schools 6111"
	7870        "Colleges and universities, including junior colleges 6112, 6113"
	7880        "Business, technical, and trade schools and training 6114, 6115"
	7890        "Other schools, instruction, and educational services 6116, 6117"
	7970        "Offices of physicians 6211"
	7980        "Offices of dentists 6212"
	7990        "Offices of chiropractors 62131"
	8070        "Offices of optometrists 62132"
	8080        "Offices of other health practitioners 6213 exc. 62131, 62132"
	8090        "Outpatient care centers 6214"
	8170        "Home health care services 6216"
	8180        "Other health care services 6215, 6219"
	8190        "Hospitals 622"
	8270        "Nursing care facilities 6231"
	8290        "Residential care facilities, without nursing 6232, 6233, 6239"
	8370        "Individual and family services 6241"
	8380        "Community food and housing, and emergency services 6242"
	8390        "Vocational rehabilitation services 6243"
	8470        "Child day care services 6244"
	8560        "Independent artists, performing arts, spectator sports, and related industries 711"
	8570        "Museums, art galleries, historical sites, and similar institutions 712"
	8580        "Bowling centers 71395"
	8590        "Other amusement, gambling, and recreation industries 713 exc. 71395"
	8660        "Traveler accommodation 7211"
	8670        "Recreational vehicle parks and camps, and rooming and boarding houses 7212, 7213"
	8680        "Restaurants and other food services 722 exc. 7224"
	8690        "Drinking places, alcoholic beverages 7224"
	8770        "Automotive repair and maintenance 8111 exc. 811192"
	8780        "Car washes 811192"
	8790        "Electronic and precision equipment repair and maintenance 8112"
	8870        "Commercial and industrial machinery and equipment repair and maintenance 8113"
	8880        "Personal and household goods repair and maintenance 8114 exc. 81143"
	8890        "Footwear and leather goods repair 81143"
	8970        "Barber shops 812111"
	8980        "Beauty salons 812112"
	8990        "Nail salons and other personal care services 812113, 81219"
	9070        "Dry cleaning and laundry services 8123"
	9080        "Funeral homes, cemeteries, and crematories 8122"
	9090        "Other personal services 8129"
	9160        "Religious organizations 8131"
	9170        "Civic, social, advocacy organizations, and grant making and giving services 8132, 8133, 8134"
	9180        "Labor unions 81393"
	9190        "Business, professional, political, and similar organizations 8139 exc. 81393"
	9290        "Private households 814"
	9370        "Executive offices and legislative bodies 92111, 92112, 92114, pt. 92115"
	9380        "Public finance activities 92113"
	9390        "Other general government and support 92119"
	9470        "Justice, public order, and safety activities 922, pt. 92115"
	9480        "Administration of human resource programs 923"
	9490        "Administration of environmental quality and housing programs 924, 925"
	9570        "Administration of economic programs and space research 926, 927"
	9590        "National security and international affairs 928"
	9890        "Armed Forces"
;
label values ptio1ocd ptio1ocd;
label define ptio1ocd
	10          "Chief executives (11-1011)"
	20          "General and operations managers (11-1021)"
	40          "Advertising and promotions managers (11-2011)"
	50          "Marketing and sales managers (11-2020)"
	60          "Public relations managers (11-2031)"
	100         "Administrative services managers (11-3011)"
	110         "Computer and information systems managers (11-3021)"
	120         "Financial managers (11-3031)"
	135         "Compensation and benefits managers (11-3111)"
	136         "Human resources managers (11-3121)"
	137         "Training and development managers (11-3131)"
	140         "Industrial production managers (11-3051)"
	150         "Purchasing managers (11-3061)"
	160         "Transportation, storage, and distribution managers (11-3071)"
	205         "Farmers, ranchers, and other agricultural managers (11-9013)"
	220         "Construction managers (11-9021)"
	230         "Education administrators (11-9030)"
	300         "Engineering managers (11-9041)"
	310         "Food service managers (11-9051)"
	325         "Funeral service managers (11-9061)"
	330         "Gaming managers (11-9071)"
	340         "Lodging managers (11-9081)"
	350         "Medical and health services managers (11-9111)"
	360         "Natural sciences managers (11-9121)"
	410         "Property, real estate, and community association managers (11-9141)"
	420         "Social and community service managers (11-9151)"
	425         "Emergency management directors (11-9161)"
	430         "Managers, all other (11-9199)"
	500         "Agents and business managers of artists, performers, and athletes 13-1011"
	510         "Purchasing agents and buyers, farm products 13-1021"
	520         "Wholesale and retail buyers, except farm products 13-1022"
	530         "Purchasing agents, except wholesale, retail, and farm products 13-1023"
	540         "Claims adjusters, appraisers, examiners, and investigators 13-1030"
	565         "Compliance officers 13-1041"
	600         "Cost estimators 13-1051"
	630         "Human resource workers 13-1070"
	640         "Compensation, benefits, and job analysis specialists 13-1141"
	650         "Training and development specialists 13-1151"
	700         "Logisticians 13-1081"
	710         "Management analysts 13-1111"
	725         "Meeting, convention, and event planners 13-1121"
	726         "Fundraisers 13-1131"
	735         "Market research analysts and marketing specialists 13-1161"
	740         "Business operations specialists, all other 13-1199"
	800         "Accountants and auditors 13-2011"
	810         "Appraisers and assessors of real estate 13-2021"
	820         "Budget analysts 13-2031"
	830         "Credit analysts 13-2041"
	840         "Financial analysts 13-2051"
	850         "Personal financial advisors 13-2052"
	860         "Insurance underwriters 13-2053"
	900         "Financial examiners 13-2061"
	910         "Loan counselors and officers 13-2070"
	930         "Tax examiners, collectors, and revenue agents 13-2081"
	940         "Tax prepares 13-2082"
	950         "Financial specialists, all other 13-2099"
	1005        "Computer and information research scientists 15-1111"
	1006        "Computer systems analysts 15-1121"
	1007        "Information security analysts 15-1122"
	1010        "Computer programmers 15-1131"
	1020        "Software developers, applications and systems software 15-113X"
	1030        "Web developers 15-1134"
	1050        "Computer support specialists 15-1150"
	1060        "Database administrators 15-1141"
	1105        "Network and computer systems administrators 15-1142"
	1107        "Computer occupations, all other 15-1199"
	1200        "Actuaries 15-2011"
	1210        "Mathematicians 15-2021"
	1220        "Operations research analysts 15-2031"
	1230        "Statisticians 15-2041"
	1240        "Miscellaneous mathematical science occupations 15-2090"
	1300        "Architects, except naval 17-1010"
	1310        "Surveyors, cartographers, and photogrammetrists 17-1020"
	1320        "Aerospace engineers 17-2011"
	1330        "Agricultural engineers 17-2021"
	1340        "Biomedical engineers 17-2031"
	1350        "Chemical engineers 17-2041"
	1360        "Civil engineers 17-2051"
	1400        "Computer hardware engineers 17-2061"
	1410        "Electrical and electronic engineers 17-2070"
	1420        "Environmental engineers 17-2081"
	1430        "Industrial engineers, including health and safety 17-2110"
	1440        "Marine engineers and naval architects 17-2121"
	1450        "Materials engineers 17-2131"
	1460        "Mechanical engineers 17-2141"
	1500        "Mining and geological engineers, including mining safety engineers 17-2151"
	1510        "Nuclear engineers 17-2161"
	1520        "Petroleum engineers 17-2171"
	1530        "Engineers, all other 17-2199"
	1540        "Drafters 17-3010"
	1550        "Engineering technicians, except drafters 17-3020"
	1560        "Surveying and mapping technicians 17-3031"
	1600        "Agricultural and food scientists 19-1010"
	1610        "Biological scientists 19-1020"
	1640        "Conservation scientists and foresters 19-1030"
	1650        "Medical scientists 19-1040"
	1660        "Life scientists, all other 19-1099"
	1700        "Astronomers and physicists 19-2010"
	1710        "Atmospheric and space scientists 19-2021"
	1720        "Chemists and materials scientists 19-2030"
	1740        "Environmental scientists and geoscientists 19-2040"
	1760        "Physical scientists, all other 19-2099"
	1800        "Economists 19-3011"
	1815        "Survey researchers 19-3022"
	1820        "Psychologists 19-3030"
	1830        "Sociologists 19-3041"
	1840        "Urban and regional planners 19-3051"
	1860        "Miscellaneous social scientists and related workers 19-3090"
	1900        "Agricultural and food science technicians 19-4011"
	1910        "Biological technicians 19-4021"
	1920        "Chemical technicians 19-4031"
	1930        "Geological and petroleum technicians 19-4041"
	1940        "Nuclear technicians 19-4051"
	1950        "Social science research assistants 19-4061"
	1965        "Miscellaneous life, physical, and social science technicians 19-4090"
	2000        "Counselors 21-1010"
	2010        "Social workers 21-1020"
	2015        "Probation officers and correctional treatment specialists 21-1092"
	2016        "Social and human service assistants 21-1093"
	2025        "Miscellaneous community and social service specialists, including health educators and community health workers 21-109X"
	2040        "Clergy 21-2011"
	2050        "Directors, religious activities and education 21-2021"
	2060        "Religious workers, all other 21-2099"
	2100        "Lawyers, Judges, magistrates, and other judicial workers 23-1011"
	2105        "Judicial law clerks 23-1011"
	2145        "Paralegals and legal assistants 23-2011"
	2160        "Miscellaneous legal support workers 23-2090"
	2200        "Postsecondary teachers 25-1000"
	2300        "Preschool and kindergarten teachers 25-2010"
	2310        "Elementary and middle school teachers 25-2020"
	2320        "Secondary school teachers 25-2030"
	2330        "Special education teachers 25-2040"
	2340        "Other teachers and instructors 25-3000"
	2400        "Archivists, curators, and museum technicians 25-4010"
	2430        "Librarians 25-4021"
	2440        "Library technicians 25-4031"
	2540        "Teacher assistants 25-9041"
	2550        "Other education, training, and library workers 25-90XX"
	2600        "Artists and related workers 27-1010"
	2630        "Designers 27-1020"
	2700        "Actors 27-2011"
	2710        "Producers and directors 27-2012"
	2740        "Dancers and choreographers 27-2030"
	2750        "Musicians, singers, and related workers 27-2040"
	2760        "Entertainers and performers, sports and related workers, all other 27-2099"
	2800        "Announcers 27-3010"
	2810        "News analysts, reporters and correspondents 27-3020"
	2825        "Public relations specialists 27-3031"
	2830        "Editors 27-3041"
	2840        "Technical writers 27-3042"
	2850        "Writers and authors 27-3043"
	2860        "Miscellaneous media and communication workers 27-3090"
	2900        "Broadcast and sound engineering technicians and radio operators 27-4010"
	2910        "Photographers 27-4021"
	2920        "Television, video, and motion picture camera operators and editors 27-4030"
	2960        "Media and communication equipment workers, all other 27-4099"
	3000        "Chiropractors 29-1011"
	3010        "Dentists 29-1020"
	3030        "Dietitians and nutritionists 29-1031"
	3040        "Optometrists 29-1041"
	3050        "Pharmacists 29-1051"
	3060        "Physicians and surgeons 29-1060"
	3110        "Physician assistants 29-1071"
	3120        "Podiatrists 29-1081"
	3130        "Registered nurses 29-1111"
	3140        "Audiologists 29-1121"
	3150        "Occupational therapists 29-1122"
	3160        "Physical therapists 29-1123"
	3200        "Radiation therapists 29-1124"
	3210        "Recreational therapists 29-1125"
	3220        "Respiratory therapists 29-1126"
	3230        "Speech-language pathologists 29-1127"
	3235        "Exercise physiologists 29-1128"
	3245        "Therapists, all other 29-1129"
	3250        "Veterinarians 29-1131"
	3255        "Registered nurses 29-1141"
	3256        "Nurse anesthetists 29-1151"
	3257        "Nurse midwives 29-1161"
	3258        "Nurse practitioners 29-1171"
	3260        "Health diagnosing and treating practitioners, all other 29-1199"
	3300        "Clinical laboratory technologists and technicians 29-2010"
	3310        "Dental hygienists 29-2021"
	3320        "Diagnostic related technologists and technicians 29-2030"
	3400        "Emergency medical technicians and paramedics 29-2041"
	3420        "Health diagnosing and treating practitioner support technicians 29-2050"
	3500        "Licensed practical and licensed vocational nurses 29-2061"
	3510        "Medical records and health information technicians 29-2071"
	3520        "Opticians, dispensing 29-2081"
	3535        "Miscellaneous health technologists and technicians 29-2090"
	3540        "Other healthcare practitioners and technical occupations 29-9000"
	3600        "Nursing, psychiatric, and home health aides 31-1010"
	3610        "Occupational therapist assistants and aides 31-2010"
	3620        "Physical therapist assistants and aides 31-2020"
	3630        "Massage therapists 31-9011"
	3640        "Dental assistants 31-9091"
	3645        "Medical assistants 31-9092"
	3646        "Medical transcriptionists 31-9094"
	3647        "Pharmacy aides 31-9095"
	3648        "Veterinary assistants and laboratory animal caretakers 31-9096"
	3649        "Phlebotomists 31-9097"
	3655        "Miscellaneous healthcare support occupations, including medical equipment preparers 31-909X"
	3700        "First-line supervisors/managers of correctional officers 33-1011"
	3710        "First-line supervisors/managers of police and detectives 33-1012"
	3720        "First-line supervisors/managers of fire fighting and prevention workers 33-1021"
	3730        "Supervisors, protective service workers, all other 33-1099"
	3740        "Fire fighters 33-2011"
	3750        "Fire inspectors 33-2020"
	3800        "Bailiffs, correctional officers, and jailers 33-3010"
	3820        "Detectives and criminal investigators 33-3021"
	3830        "Fish and game wardens 33-3031"
	3840        "Parking enforcement workers 33-3041"
	3850        "Police and sheriff's patrol officers 33-3051"
	3860        "Transit and railroad police 33-3052"
	3900        "Animal control workers 33-9011"
	3910        "Private detectives and investigators 33-9021"
	3920        "Security guards and gaming surveillance officers 33-9030"
	3940        "Crossing guards 33-9091"
	3945        "Transportation security screeners 33-9093"
	3955        "Lifeguards and other recreational and all other protective service workers 33-909X"
	4000        "Chefs and head cooks 35-1011"
	4010        "First-line supervisors/managers of food preparation and serving workers 35-1012"
	4020        "Cooks 35-2010"
	4030        "Food preparation workers 35-2021"
	4040        "Bartenders 35-3011"
	4050        "Combined food preparation and serving workers, including fast food 35-3021"
	4060        "Counter attendants, cafeteria, food concession, and coffee shop 35-3022"
	4110        "Waiters and waitresses 35-3031"
	4120        "Food servers, nonrestaurant 35-3041"
	4130        "Dining room and cafeteria attendants and bartender helpers 35-9011"
	4150        "Hosts and hostesses, restaurant, lounge, and coffee shop 35-9031"
	4160        "Food preparation and serving related workers, all other 35-9099"
	4200        "First-line supervisors/managers of housekeeping and janitorial workers 37-1011"
	4210        "First-line supervisors/managers of landscaping, lawn service, and groundskeeping workers 37-1012"
	4220        "Janitors and building cleaners 31-201X"
	4230        "Maids and housekeeping cleaners 37-2012"
	4240        "Pest control workers 37-2021"
	4250        "Grounds maintenance workers 37-3010"
	4300        "First-line supervisors/managers of gaming workers 39-1010"
	4320        "First-line supervisors/managers of personal service workers 39-1021"
	4340        "Animal trainers 39-2011"
	4350        "Nonfarm animal caretakers 39-2021"
	4400        "Gaming services workers 39-3010"
	4410        "Motion picture projectionists 39-3021"
	4420        "Ushers, lobby attendants, and ticket takers 39-3031"
	4430        "Miscellaneous entertainment attendants and related workers 39-3090"
	4460        "Embalmers and funeral attendants 39-40XX"
	4465        "Morticians, undertakers, and funeral directors 39-4031"
	4500        "Barbers 39-5011"
	4510        "Hairdressers, hairstylists, and cosmetologists 39-5012"
	4520        "Miscellaneous personal appearance workers 39-5090"
	4530        "Baggage porters, bellhops, and concierges 39-6010"
	4540        "Tour and travel guides 39-6020"
	4550        "Transportation attendants 39-6030"
	4600        "Child care workers 39-9011"
	4610        "Personal and home care aides 39-9021"
	4620        "Recreation and fitness workers 39-9030"
	4640        "Residential advisors 39-9041"
	4650        "Personal care and service workers, all other 39-9099"
	4700        "First-line supervisors/managers of retail sales workers 41-1011"
	4710        "First-line supervisors/managers of non-retail sales workers 41-1012"
	4720        "Cashiers 41-2010"
	4740        "Counter and rental clerks 41-2021"
	4750        "Parts salespersons 41-2022"
	4760        "Retail salespersons 41-2031"
	4800        "Advertising sales agents 41-3011"
	4810        "Insurance sales agents 41-3021"
	4820        "Securities, commodities, and financial services sales agents 41-3031"
	4830        "Travel agents 41-3041"
	4840        "Sales representatives, services, all other 41-3099"
	4850        "Sales representatives, wholesale and manufacturing 41-4010"
	4900        "Models, demonstrators, and product promoters 41-9010"
	4920        "Real estate brokers and sales agents 41-9020"
	4930        "Sales engineers 41-9031"
	4940        "Telemarketers 41-9041"
	4950        "Door-to-door sales workers, news and street vendors, and related workers 41-9091"
	4965        "Sales and related workers, all other 41-9099"
	5000        "First-line supervisors/managers of office and administrative support workers 43-1011"
	5010        "Switchboard operators, including answering service 43-2011"
	5020        "Telephone operators 43-2021"
	5030        "Communications equipment operators, all other 43-2099"
	5100        "Bill and account collectors 43-3011"
	5110        "Billing and posting clerks and machine operators 43-3021"
	5120        "Bookkeeping, accounting, and auditing clerks 43-3031"
	5130        "Gaming cage workers 43-3041"
	5140        "Payroll and timekeeping clerks 43-3051"
	5150        "Procurement clerks 43-3061"
	5160        "Tellers 43-3071"
	5165        "Financial clerks, all other 43-3099"
	5200        "Brokerage clerks 43-4011"
	5210        "Correspondence clerks 43-4021"
	5220        "Court, municipal, and license clerks 43-4031"
	5230        "Credit authorizers, checkers, and clerks 43-4041"
	5240        "Customer service representatives 43-4051"
	5250        "Eligibility interviewers, government programs 43-4061"
	5260        "File Clerks 43-4071"
	5300        "Hotel, motel, and resort desk clerks 43-4081"
	5310        "Interviewers, except eligibility and loan 43-4111"
	5320        "Library assistants, clerical 43-4121"
	5330        "Loan interviewers and clerks 43-4131"
	5340        "New accounts clerks 43-4141"
	5350        "Order clerks 43-4151"
	5360        "Human resources assistants, except payroll and timekeeping 43-4161"
	5400        "Receptionists and information clerks 43-4171"
	5410        "Reservation and transportation ticket agents and travel clerks 43-4181"
	5420        "Information and record clerks, all other 43-4199"
	5500        "Cargo and freight agents 43-5011"
	5510        "Couriers and messengers 43-5021"
	5520        "Dispatchers 43-5030"
	5530        "Meter readers, utilities 43-5041"
	5540        "Postal service clerks 43-5051"
	5550        "Postal service mail carriers 43-5052"
	5560        "Postal service mail sorters, processors, and processing machine operators 43-5053"
	5600        "Production, planning, and expediting clerks 43-5061"
	5610        "Shipping, receiving, and traffic clerks 43-5071"
	5620        "Stock clerks and order fillers 43-5081"
	5700        "Secretaries and administrative assistants 43-6010"
	5800        "Computer operators 43-9011"
	5810        "Data entry keyers 43-9021"
	5820        "Word processors and typists 43-9022"
	5830        "Desktop publishers 43-9031"
	5840        "Insurance claims and policy processing clerks 43-9041"
	5850        "Mail clerks and mail machine operators, except postal service 43-9051"
	5860        "Office clerks, general 43-9061"
	5900        "Office machine operators, except computer 43-9071"
	5910        "Proofreaders and copy markers 43-9081"
	5920        "Statistical assistants 43-9111"
	5940        "Office and administrative support workers, all other 43-9199"
	6005        "First-line supervisors of farming, fishing, and forestry workers 45-1011"
	6010        "Agricultural inspectors 45-2011"
	6020        "Animal breeders 45-2021"
	6040        "Graders and sorters, agricultural products 45-2041"
	6050        "Miscellaneous agricultural workers 45-2090"
	6100        "Fishers and related fishing workers 45-3011"
	6110        "Hunters and trappers 45-3021"
	6120        "Forest and conservation workers 45-4011"
	6130        "Logging workers 45-4020"
	6200        "First-line supervisors/managers of construction trades and extraction workers 47-1011"
	6210        "Boilermakers 47-2011"
	6220        "Brickmasons, blockmasons, and stonemasons 47-2020"
	6230        "Carpenters 47-2031"
	6240        "Carpet, floor, and tile installers and finishers 47-2040"
	6250        "Cement masons, concrete finishers, and terrazzo workers 47-2050"
	6260        "Construction laborers 47-2061"
	6300        "Paving, surfacing, and tamping equipment operators 47-2071"
	6310        "Pile-driver operators 47-2072"
	6320        "Operating engineers and other construction equipment operators 47-2073"
	6330        "Drywall installers, ceiling tile installers, and tapers 47-2080"
	6355        "Electricians 47-2111"
	6360        "Glaziers 47-2121"
	6400        "Insulation workers 47-2130"
	6420        "Painters, construction and maintenance 47-2141"
	6430        "Paperhangers 47-2142"
	6440        "Pipelayers, plumbers, pipefitters, and steamfitters 47-2150"
	6460        "Plasterers and stucco masons 47-2161"
	6500        "Reinforcing iron and rebar workers 47-2171"
	6515        "Roofers 47-2181"
	6520        "Sheet metal workers 47-2211"
	6530        "Structural iron and steel workers 47-2221"
	6600        "Helpers, construction trades 47-3010"
	6660        "Construction and building inspectors 47-4011"
	6700        "Elevator installers and repairers 47-4021"
	6710        "Fence erectors 47-4031"
	6720        "Hazardous materials removal workers 47-4041"
	6730        "Highway maintenance workers 47-4051"
	6740        "Rail-track laying and maintenance equipment operators 47-4061"
	6750        "Septic tank servicers and sewer pipe cleaners 47-4071"
	6765        "Miscellaneous construction and related workers 47-4090"
	6800        "Derrick, rotary drill, and service unit operators, oil, gas, and mining 47-5010"
	6820        "Earth drillers, except oil and gas 47-5021"
	6830        "Explosives workers, ordnance handling experts, and blasters 47-5031"
	6840        "Mining machine operators 47-5040"
	6910        "Roof bolters, mining 47-5061"
	6920        "Roustabouts, oil and gas 47-5071"
	6930        "Helpers--extraction workers 47-5081"
	6940        "Other extraction workers 47-50XX"
	7000        "First-line supervisors/managers of mechanics, installers, and repairers 49-1011"
	7010        "Computer, automated teller, and office machine repairers 49-2011"
	7020        "Radio and telecommunications equipment installers and repairers 49-2020"
	7030        "Avionics technicians 49-2091"
	7040        "Electric motor, power tool, and related repairers 49-2092"
	7050        "Electrical and electronics installers and repairers, transportation equipment 49-2093"
	7100        "Electrical and electronics repairers, industrial and utility 49-209X"
	7110        "Electronic equipment installers and repairers, motor vehicles 49-2096"
	7120        "Electronic home entertainment equipment installers and repairers 49-2097"
	7130        "Security and fire alarm systems installers 49-2098"
	7140        "Aircraft mechanics and service technicians 49-3011"
	7150        "Automotive body and related repairers 49-3021"
	7160        "Automotive glass installers and repairers 49-3022"
	7200        "Automotive service technicians and mechanics 49-3023"
	7210        "Bus and truck mechanics and diesel engine specialists 49-3031"
	7220        "Heavy vehicle and mobile equipment service technicians and mechanics 49-3040"
	7240        "Small engine mechanics 49-3050"
	7260        "Miscellaneous vehicle and mobile equipment mechanics, installers, and repairers 49-3090"
	7300        "Control and valve installers and repairers 49-9010"
	7315        "Heating, air conditioning, and refrigeration mechanics and installers 49-9021"
	7320        "Home appliance repairers 49-9031"
	7330        "Industrial and refractory machinery mechanics 49-904X"
	7340        "Maintenance and repair workers, general 49-9042"
	7350        "Maintenance workers, machinery 49-9043"
	7360        "Millwrights 49-9044"
	7410        "Electrical power-line installers and repairers 49-9051"
	7420        "Telecommunications line installers and repairers 49-9052"
	7430        "Precision instrument and equipment repairers 49-9060"
	7510        "Coin, vending, and amusement machine servicers and repairers 49-9091"
	7520        "Commercial divers 49-9092"
	7540        "Locksmiths and safe repairers 49-9094"
	7550        "Manufactured building and mobile home installers 49-9095"
	7560        "Riggers 49-9096"
	7600        "Signal and track switch repairers 49-9097"
	7610        "Helpers--installation, maintenance, and repair workers 49-9098"
	7630        "Other installation, maintenance, and repair workers 49-909X"
	7700        "First-line supervisors/managers of production and operating workers 51-1011"
	7710        "Aircraft structure, surfaces, rigging, and systems assemblers 51-2011"
	7720        "Electrical, electronics, and electromechanical assemblers 51-2020"
	7730        "Engine and other machine assemblers 51-2031"
	7740        "Structural metal fabricators and fitters 51-2041"
	7750        "Miscellaneous assemblers and fabricators 51-2090"
	7800        "Bakers 51-3011"
	7810        "Butchers and other meat, poultry, and fish processing workers 51-3020"
	7830        "Food and tobacco roasting, baking, and drying machine operators and tenders 51-3091"
	7840        "Food batchmakers 51-3092"
	7850        "Food cooking machine operators and tenders 51-3093"
	7855        "Food processing workers, all other 51-3099"
	7900        "Computer control programmers and operators 51-4010"
	7920        "Extruding and drawing machine setters, operators, and tenders, metal and plastic 51-4021"
	7930        "Forging machine setters, operators, and tenders, metal and plastic 51-4022"
	7940        "Rolling machine setters, operators, and tenders, metal and plastic 51-4023"
	7950        "Cutting, punching, and press machine setters, operators, and tenders, metal and plastic 51-4031"
	7960        "Drilling and boring machine tool setters, operators, and tenders, metal and plastic 51-4032"
	8000        "Grinding, lapping, polishing, and buffing machine tool setters, operators, and tenders, metal and plastic 51-4033"
	8010        "Lathe and turning machine tool setters, operators, and tenders, metal and plastic 51-4034"
	8020        "Milling and planing machine setters, operators, and tenders, metal and plastic 51-4035"
	8030        "Machinists 51-4041"
	8040        "Metal furnace and kiln operators and tenders 51-4050"
	8060        "Model makers and patternmakers, metal and plastic 51-4060"
	8100        "Molders and molding machine setters, operators, and tenders, metal and plastic 51-4070"
	8120        "Multiple machine tool setters, operators, and tenders, metal and plastic 51-4081"
	8130        "Tool and die makers 51-4111"
	8140        "Welding, soldering, and brazing workers 51-4120"
	8150        "Heat treating equipment setters, operators, and tenders, metal and plastic 51-4191"
	8160        "Lay-out workers, metal and plastic 51-4192"
	8200        "Plating and coating machine setters, operators, and tenders, metal and plastic 51-4193"
	8210        "Tool grinders, filers, and sharpeners 51-4194"
	8220        "Metalworkers and plastic workers, all other 51-4199"
	8250        "Prepress technicians and workers 51-5111"
	8255        "Printing press operators 51-5112"
	8256        "Print binding and finishing workers 51-5113"
	8300        "Laundry and dry-cleaning workers 51-6011"
	8310        "Pressers, textile, garment, and related materials 51-6021"
	8320        "Sewing machine operators 51-6031"
	8330        "Shoe and leather workers and repairers 51-6041"
	8340        "Shoe machine operators and tenders 51-6042"
	8350        "Tailors, dressmakers, and sewers 51-6050"
	8360        "Textile bleaching and dyeing machine operators and tenders 51-6061"
	8400        "Textile cutting machine setters, operators, and tenders 51-6062"
	8410        "Textile knitting and weaving machine setters, operators, and tenders 51-6063"
	8420        "Textile winding, twisting, and drawing out machine setters, operators, and tenders 51-6064"
	8430        "Extruding and forming machine setters, operators, and tenders, synthetic and glass fibers 51-6091"
	8440        "Fabric and apparel patternmakers 51-6092"
	8450        "Upholsterers 51-6093"
	8460        "Textile, apparel, and furnishings workers, all other 51-6099"
	8500        "Cabinetmakers and bench carpenters 51-7011"
	8510        "Furniture finishers 51-7021"
	8520        "Model makers and patternmakers, wood 51-7030"
	8530        "Sawing machine setters, operators, and tenders, wood 51-7041"
	8540        "Woodworking machine setters, operators, and tenders, except sawing 51-7042"
	8550        "Woodworkers, all other 51-7099"
	8600        "Power plant operators, distributors, and dispatchers 51-8010"
	8610        "Stationary engineers and boiler operators 51-8021"
	8620        "Water and liquid waste treatment plant and system operators 51-8031"
	8630        "Miscellaneous plant and system operators 51-8090"
	8640        "Chemical processing machine setters, operators, and tenders 51-9010"
	8650        "Crushing, grinding, polishing, mixing, and blending workers 51-9020"
	8710        "Cutting workers 51-9030"
	8720        "Extruding, forming, pressing, and compacting machine setters, operators, and tenders 51-9041"
	8730        "Furnace, kiln, oven, drier, and kettle operators and tenders 51-9051"
	8740        "Inspectors, testers, sorters, samplers, and weighers 51-9061"
	8750        "Jewelers and precious stone and metal workers 51-9071"
	8760        "Medical, dental, and ophthalmic laboratory technicians 51-9080"
	8800        "Packaging and filling machine operators and tenders 51-9111"
	8810        "Painting workers 51-9120"
	8830        "Photographic process workers and processing machine operators 51-9130"
	8840        "Semiconductor processors 51-9141"
	8850        "Cementing and gluing machine operators and tenders 51-9191"
	8860        "Cleaning, washing, and metal pickling equipment operators and tenders 51-9192"
	8900        "Cooling and freezing equipment operators and tenders 51-9193"
	8910        "Etchers and engravers 51-9194"
	8920        "Molders, shapers, and casters, except metal and plastic 51-9195"
	8930        "Paper goods machine setters, operators, and tenders 51-9196"
	8940        "Tire builders 51-9197"
	8950        "Helpers--production workers 51-9198"
	8965        "Production workers, all other 51-9199"
	9000        "Supervisors, transportation and material moving workers 53-1000"
	9030        "Aircraft pilots and flight engineers 53-2010"
	9040        "Air traffic controllers and airfield operations specialists 53-2020"
	9110        "Ambulance drivers and attendants, except emergency medical technicians 53-3011"
	9120        "Bus drivers 53-3020"
	9130        "Driver/sales workers and truck drivers 53-3030"
	9140        "Taxi drivers and chauffeurs 53-3041"
	9150        "Motor vehicle operators, all other 53-3099"
	9200        "Locomotive engineers and operators 53-4010"
	9230        "Railroad brake, signal, and switch operators 53-4021"
	9240        "Railroad conductors and yardmasters 53-4031"
	9260        "Subway, streetcar, and other rail transportation workers 53-40XX"
	9300        "Sailors and marine oilers 53-5011"
	9310        "Ship and boat captains and operators 53-5020"
	9330        "Ship engineers 53-5031"
	9340        "Bridge and lock tenders 53-6011"
	9350        "Parking lot attendants 53-6021"
	9360        "Service station attendants 53-6031"
	9410        "Transportation inspectors 53-6051"
	9415        "Transportation attendants, except flight attendants 53-6061"
	9420        "Other transportation workers 53-60XX"
	9500        "Conveyor operators and tenders 53-7011"
	9510        "Crane and tower operators 53-7021"
	9520        "Dredge, excavating, and loading machine operators 53-7030"
	9560        "Hoist and winch operators 53-7041"
	9600        "Industrial truck and tractor operators 53-7051"
	9610        "Cleaners of vehicles and equipment 53-7061"
	9620        "Laborers and freight, stock, and material movers, hand 53-7062"
	9630        "Machine feeders and offbearers 53-7063"
	9640        "Packers and packagers, hand 53-7064"
	9650        "Pumping station operators 53-7070"
	9720        "Refuse and recyclable material collectors 53-7081"
	9730        "Shuttle car operators 53-7111"
	9740        "Tank car, truck, and ship loaders 53-7121"
	9750        "Material moving workers, all other 53-7199"
	9840        "Armed Forces"
;
label values primind1 priminda;
label define priminda
	1           "AGRICULTURE, FORESTRY, FISHING, and HUNTING"
	2           "MINING"
	3           "CONSTRUCTION"
	4           "MANUFACTURING - DURABLE GOODS"
	5           "MANUFACTURING - NON-DURABLE GOODS"
	6           "WHOLESALE TRADE"
	7           "RETAIL TRADE"
	8           "TRANSPORTATION AND WAREHOUSING"
	9           "UTILITIES"
	10          "INFORMATION"
	11          "FINANCE AND INSURANCE"
	12          "REAL ESTATE AND RENTAL AND LEASING"
	13          "PROFESSIONAL AND TECHNICAL SERVICES"
	14          "MANAGEMENT, ADMINISTRATIVE AND WASTE MANAGEMENT SERVICES"
	15          "EDUCATIONAL SERVICES"
	16          "HEALTH CARE AND SOCIAL SERVICES"
	17          "ARTS, ENTERTAINMENT, AND RECREATION"
	18          "ACCOMMODATION AND FOOD SERVICES"
	19          "PRIVATE HOUSEHOLDS"
	20          "OTHER SERVICES, EXCEPT PRIVATE HOUSEHOLDS"
	21          "PUBLIC ADMINISTRATION"
	22          "ARMED FORCES"
;
label values primind2 primindb;
label define primindb
	1           "AGRICULTURE, FORESTRY, FISHING, and HUNTING"
	2           "MINING"
	3           "CONSTRUCTION"
	4           "MANUFACTURING - DURABLE GOODS"
	5           "MANUFACTURING - NON-DURABLE GOODS"
	6           "WHOLESALE TRADE"
	7           "RETAIL TRADE"
	8           "TRANSPORTATION AND WAREHOUSING"
	9           "UTILITIES"
	10          "INFORMATION"
	11          "FINANCE AND INSURANCE"
	12          "REAL ESTATE AND RENTAL AND LEASING"
	13          "PROFESSIONAL AND TECHNICAL SERVICES"
	14          "MANAGEMENT, ADMINISTRATIVE AND WASTE MANAGEMENT SERVICES"
	15          "EDUCATIONAL SERVICES"
	16          "HEALTH CARE AND SOCIAL SERVICES"
	17          "ARTS, ENTERTAINMENT, AND RECREATION"
	18          "ACCOMMODATION AND FOOD SERVICES"
	19          "PRIVATE HOUSEHOLDS"
	20          "OTHER SERVICES, EXCEPT PRIVATE HOUSEHOLDS"
	21          "PUBLIC ADMINISTRATION"
	22          "ARMED FORCES"
;
label values peafwhn1 peafwhna;
label define peafwhna
	1           "SEPTEMBER 2001 OR LATER"
	2           "AUGUST 1990 TO AUGUST 2001"
	3           "MAY 1975 TO JULY 1990"
	4           "VIETNAM ERA (AUGUST 1964 TO APRIL 1975)"
	5           "FEBRUARY 1955 TO JULY 1964"
	6           "KOREAN WAR (JULY 1950 TO JANUARY 1955)"
	7           "JANUARY 1947 TO JUNE 1950"
	8           "WORLD WAR II (DECEMBER 1941 TO DECEMBER 1946)"
	9           "NOVEMBER 1941 OR EARLIER"
;
label values peafwhn2 peafwhnb;
label define peafwhnb
	1           "SEPTEMBER 2001 OR LATER"
	2           "AUGUST 1990 TO AUGUST 2001"
	3           "MAY 1975 TO JULY 1990"
	4           "VIETNAM ERA (AUGUST 1964 TO APRIL 1975)"
	5           "FEBRUARY 1955 TO JULY 1964"
	6           "KOREAN WAR (JULY 1950 TO JANUARY 1955)"
	7           "JANUARY 1947 TO JUNE 1950"
	8           "WORLD WAR II (DECEMBER 1941 TO DECEMBER 1946)"
	9           "NOVEMBER 1941 OR EARLIER"
;
label values peafwhn3 peafwhnc;
label define peafwhnc
	1           "SEPTEMBER 2001 OR LATER"
	2           "AUGUST 1990 TO AUGUST 2001"
	3           "MAY 1975 TO JULY 1990"
	4           "VIETNAM ERA (AUGUST 1964 TO APRIL 1975)"
	5           "FEBRUARY 1955 TO JULY 1964"
	6           "KOREAN WAR (JULY 1950 TO JANUARY 1955)"
	7           "JANUARY 1947 TO JUNE 1950"
	8           "WORLD WAR II (DECEMBER 1941 TO DECEMBER 1946)"
	9           "NOVEMBER 1941 OR EARLIER"
;
label values peafwhn4 peafwhnd;
label define peafwhnd
	1           "SEPTEMBER 2001 OR LATER"
	2           "AUGUST 1990 TO AUGUST 2001"
	3           "MAY 1975 TO JULY 1990"
	4           "VIETNAM ERA (AUGUST 1964 TO APRIL 1975)"
	5           "FEBRUARY 1955 TO JULY 1964"
	6           "KOREAN WAR (JULY 1950 TO JANUARY 1955)"
	7           "JANUARY 1947 TO JUNE 1950"
	8           "WORLD WAR II (DECEMBER 1941 TO DECEMBER 1946)"
	9           "NOVEMBER 1941 OR EARLIER"
;
label values pecohab  pecohab;
label define pecohab
	-1          "NO PARTNER PRESENT"
;
label values pedisear pedisear;
label define pedisear
	1           "Yes"
	2           "No"
;
label values pediseye pediseye;
label define pediseye
	1           "Yes"
	2           "No"
;
label values pedisrem pedisrem;
label define pedisrem
	1           "Yes"
	2           "No"
;
label values pedisphy pedisphy;
label define pedisphy
	1           "Yes"
	2           "No"
;
label values pedisdrs pedisdrs;
label define pedisdrs
	1           "Yes"
	2           "No"
;
label values pedisout pedisout;
label define pedisout
	1           "Yes"
	2           "No"
;
label values prdisflg prdisflg;
label define prdisflg
	1           "Yes"
	2           "No"
;
label values prdasian prdasian;
label define prdasian
	1           "Asian Indian"
	2           "Chinese"
	3           "Filipino"
	4           "Japanese"
	5           "Korean"
	6           "Vietnamese"
	7           "Other"
;
label values pepdemp1 pepdempa;
label define pepdempa
	1           "YES"
	2           "NO"
;
label values ptnmemp1 ptnmempa;
label define ptnmempa
	75          "75 or more employees"
;
label values pepdemp2 pepdempb;
label define pepdempb
	1           "YES"
	2           "NO"
;
label values ptnmemp2 ptnmempb;
label define ptnmempb
	10          "10 or more employees"
;

#delimit cr
compress

/*
Copyright 2015 shared by the National Bureau of Economic Research and Jean Roth

National Bureau of Economic Research.
1050 Massachusetts Avenue
Cambridge, MA 02138
jroth@nber.org

This program and all programs referenced in it are free software. You
can redistribute the program or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation;
either version 2 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
USA.
*/
