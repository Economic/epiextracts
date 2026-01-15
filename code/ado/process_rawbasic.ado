*************************************************************************
* NAME: process_rawbasic
* DESC: Processes raw Basic data from Unicon or Census and converts to Stata
* format.
* Called by master.do
*************************************************************************
capture program drop process_rawbasic
program define process_rawbasic
syntax, begin(string) end(string)

* numeric codes beginning and end dates
local begindate = tm(`begin')
local enddate = tm(`end')

* No data prior to 1973: otherwise exit with error
if `begindate' < tm(1973m1) {
  di "No data prior to 1973"
  exit
}

* Begin date must be lte end date: otherwise exit with error
if `begindate' > `enddate' {
  di "Begin date must be prior to end date"
  exit
}

* Process unicon extracts for all years before 1994
if `begindate' <= tm(1993m12) {
  if `enddate' <= tm(1993m12) local tempenddate = `endate'
  else local tempenddate = tm(1993m12)
  foreach date of numlist `begindate'/`tempenddate' {
    di "Unicon " %tm `date' " ... already converted to Stata"
  }
}

* Process Census data all years 1994-present
if `begindate' >= tm(1994m1) | `enddate' >= tm(1994m1) {
  if `begindate' >= tm(1994m1) local tempbegindate = `begindate'
  else local tempbegindate = tm(1994m1)
  foreach date of numlist `tempbegindate'/`enddate' {
	* skip the 10th month of 2025
	if `date' == tm(2025m10) {
		continue
	}
    di "Census CPS " %tm `date' " ... converting to Stata"
		* Use process_censusbasic function to convert the data to Stata
    qui process_censusbasic, datenum(`date')
  }
}

end



*************************************************************************
* NAME: process_censusbasic
* DESC: Processes raw data from Unicon or Census and converts to Stata
* format. Relies on dictionaries and do-files from NBER:
* https://www.nber.org/data/cps_basic_progs.html
* Called by process_rawbasic
*************************************************************************
* use raw Census data and NBER dictionaries for 1994+
capture program drop process_censusbasic
program define process_censusbasic
syntax, datenum(string)

* deal with dates
local month = month(dofm(`datenum'))
local year = year(dofm(`datenum'))
local shortyear: di substr("`year'",3,.)
if `month' == 1 local monthname jan
if `month' == 2 local monthname feb
if `month' == 3 local monthname mar
if `month' == 4 local monthname apr
if `month' == 5 local monthname may
if `month' == 6 local monthname jun
if `month' == 7 local monthname jul
if `month' == 8 local monthname aug
if `month' == 9 local monthname sep
if `month' == 10 local monthname oct
if `month' == 11 local monthname nov
if `month' == 12 local monthname dec

* process revised 2000 Census based weights if necessary
if `year' >= 2000 & `year' <= 2002 {
	if `month' < 10 local month2d 0`month'
	else local month2d `month'
	tempfile rwdat
	!unzip -p ${censusbasicraw}rw`shortyear'.zip rw`shortyear'`month2d'.dat > `rwdat'
	clear
	do ${reweights}rw`shortyear'`month2d'.do `rwdat' ${reweights}rw`shortyear'`month2d'.dct
	tostring occurnum, replace format(%2.0f)
	tostring qstnum, replace format(%5.0f)
	tempfile rwdta
	save `rwdta'
}

* process telework-covid supplement
if `datenum' >= tm(2022m10) & `datenum' <= tm(2024m5) {
	tempfile twdat

	* unzip telework supplement and store as temp data
    if `datenum' >= tm(2023m11) & `datenum' <= tm(2024m2) | `datenum' == tm(2024m5) {
        !unzip -p ${censusbasicraw}`monthname'`shortyear'cpucvr_pub.zip `monthname'`shortyear'cpucvr_puf.dat > `twdat'
    }
    else {
        !unzip -p ${censusbasicraw}`monthname'`shortyear'cpucvr_pub.zip `monthname'`shortyear'cpucvr_pub.dat > `twdat'
    }
	clear

	if `datenum' >= tm(2022m10) & `datenum' <= tm(2023m11) {
    	quietly infile using ${dictionaries}twoct2022.dct, using(`twdat') clear

	}

	else if `datenum' >= tm(2023m12) & `datenum' <= tm(2024m5) {
    	quietly infile using ${dictionaries}twdec2023.dct, using(`twdat') clear
	}

	* map data dictionary to data
	tostring occurnum, replace format(%2.0f)
	tostring qstnum, replace format(%5.0f)
	replace hryear4 = hryear4 + 2000
	tempfile twdta
	save `twdta' 
}


* determine dictionary/NBER do-file to use
* June 2024 - present
if tm(2024m6) <= `datenum' & `datenum' <= tm(2025m12) local nberprogname cpsbjun2024
* March 2021 - May 2024
if  tm(2021m3) <= `datenum' & `datenum' <= tm(2024m5) local nberprogname cpsbmar2021
* January 2020 - February 2021
if  tm(2020m1) <= `datenum' & `datenum' <= tm(2021m2) local nberprogname cpsbjan2020
* January 2017 - December 2019
if  tm(2017m1) <= `datenum' & `datenum' <= tm(2019m12) local nberprogname cpsbjan2017
* January 2015 - December 2016
if  tm(2015m1) <= `datenum' & `datenum' <= tm(2016m12) local nberprogname cpsbjan2015
* April 2014 - December 2014
if  tm(2014m4) <= `datenum' & `datenum' <= tm(2014m12) local nberprogname cpsbapr2014
* January 2014 - March 2014
if  tm(2014m1) <= `datenum' & `datenum' <= tm(2014m3) local nberprogname cpsbjan2014
* January 2013 - December 2013
if  tm(2013m1) <= `datenum' & `datenum' <= tm(2013m12) local nberprogname cpsbjan13
* May 2012 - December 2012
if  tm(2012m5) <= `datenum' & `datenum' <= tm(2012m12) local nberprogname cpsbmay12
* January 2010 - April 2012
if  tm(2010m1) <= `datenum' & `datenum' <= tm(2012m4) local nberprogname cpsbjan10
* January 2009 - December 2009
if  tm(2009m1) <= `datenum' & `datenum' <= tm(2009m12) local nberprogname cpsbjan09
***** revised weights dec 2007? *****
* January 2007 - December 2008
if  tm(2007m1) <= `datenum' & `datenum' <= tm(2008m12) local nberprogname cpsbjan07
* August 2005 - December 2006
if  tm(2005m8) <= `datenum' & `datenum' <= tm(2006m12) local nberprogname cpsbaug05
* May 2004 - July 2005
if  tm(2004m5) <= `datenum' & `datenum' <= tm(2005m7) local nberprogname cpsbmay04
* January 2003 - April 2004
if  tm(2003m1) <= `datenum' & `datenum' <= tm(2004m4) local nberprogname cpsbjan03
* January 1998 - December 2002
if  tm(1998m1) <= `datenum' & `datenum' <= tm(2002m12) local nberprogname cpsbjan98
* September 1995 - December 1997
if  tm(1995m9) <= `datenum' & `datenum' <= tm(1997m12) local nberprogname cpsbsep95
* June 1995 - August 1995
if  tm(1995m6) <= `datenum' & `datenum' <= tm(1995m8) local nberprogname cpsbjun95
* April 1994 - May 1995
if  tm(1994m4) <= `datenum' & `datenum' <= tm(1995m5) local nberprogname cpsbapr94
* January 1994 - March 1994
if  tm(1994m1) <= `datenum' & `datenum' <= tm(1994m3) local nberprogname cpsbjan94


tempfile rawdat
!unzip -p ${censusbasicraw}`monthname'`shortyear'pub.zip > `rawdat'

* use appropriate NBER .do/.dct
* arguments refer to dat_name (`1') and dct_name (`2') in NBER do files
* before running, make necessary changes NBER do files to accept arguments
clear
do ${dictionaries}`nberprogname'.do `rawdat' ${dictionaries}`nberprogname'.dct

* include code here for certain months to add reweights
if `year' >= 2000 & `year' <= 2002 {
	merge 1:1 qstnum hryear4 hrmonth occurnum using `rwdta', assert(2 3)
	keep if _merge == 3
	drop _merge
} 

* merge telework-covid supplement
*note: June 2024 telework-covid added to CPS basic
if tm(2022m10) <= `datenum' & `datenum' <= tm(2024m5) {
	if `datenum' == tm(2024m1) {
		merge m:1 qstnum hryear4 hrmonth occurnum using `twdta'
	}

	else {
		merge 1:1 qstnum hryear4 hrmonth occurnum using `twdta'
	}

	drop if _merge == 2
	drop _merge
}

* save, compress, clean up
compress
save cps_`year'_`month'.dta, replace
zipfile cps_`year'_`month'.dta, saving(cps_`year'_`month'.dta.zip, replace)
copy cps_`year'_`month'.dta.zip ${censusbasicstata}cps_`year'_`month'.dta.zip, replace
erase cps_`year'_`month'.dta
erase cps_`year'_`month'.dta.zip

end
