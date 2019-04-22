*************************************************************************
* NAME: process_rawmarch
* DESC: Processes raw March data from Unicon or Census and converts to Stata
* format.
* Called by master.do
*************************************************************************
capture program drop process_rawmarch
program define process_rawmarch
syntax, begin(integer) end(integer)

* numeric codes beginning and end dates
local begindate = `begin'
local enddate = `end'

* No data prior to 1973: otherwise exit with error
if `begindate' < 1962 {
  di "No data prior to 1962"
  exit
}

* Begin date must be lte end date: otherwise exit with error
if `begindate' > `enddate' {
  di "Begin date must be prior to end date"
  exit
}

* Process unicon extracts for all years before 1994
if `begindate' <= 2014 {
  if `enddate' <= 2014 local tempenddate = `endate'
  else local tempenddate = 2014
  foreach year of numlist `begindate'/`tempenddate' {
    di "Unicon " `year' " ... already converted to Stata"
  }
}

* Process Census data all years 1994-present
if `begindate' >= 2014 | `enddate' >= 2014 {
  if `begindate' >= 2014 local tempbegindate = `begindate'
  else local tempbegindate = 2014
  foreach year of numlist `tempbegindate'/`enddate' {
    di "Census CPS " `year' " ... converting to Stata"
		* Use process_censusbasic function to convert the data to Stata
    process_censusmarch, year(`year')
  }
}

end



*************************************************************************
* NAME: process_censusmarch
* DESC: Processes raw March data from Census and converts to Stata
* format. Relies on dictionaries and do-files from NBER:
* https://www.nber.org/data/cps_progs.html
* Called by process_rawmarch
*************************************************************************
capture program drop process_censusmarch
program define process_censusmarch
syntax, year(integer)

* determine dictionary/NBER do-file to use
* January 2017 - present date
if  tm(2017m1) <= `datenum' & `datenum' <= tm(2019m3) local nberprogname cpsbjan2017
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

* save, compress, clean up
compress
save cps_`year'_`month'.dta, replace
zipfile cps_`year'_`month'.dta, saving(cps_`year'_`month'.dta.zip, replace)
copy cps_`year'_`month'.dta.zip ${censusbasicstata}cps_`year'_`month'.dta.zip, replace
erase cps_`year'_`month'.dta
erase cps_`year'_`month'.dta.zip

end
