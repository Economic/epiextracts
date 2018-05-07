

/* Note 1:
In order to succesfully run this file, the NBER do files must be modified.
For example, in ${code}cpsbjan2015.do, local macros should reference arguments
stated after do file execution in this file (see Note 2). In addition, the -log-
and -set mem- commands at the beginning, and -saveold- or -save- command at the
end of the NBER files should be deleted.
*/

foreach year of numlist 2017/2017 {
	local shortyear: di substr("`year'",3,.)
	foreach month of numlist 1/12 {

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

		unzipfile ${rawdata}`monthname'`shortyear'pub.zip, replace

		* get file name from zipped file with shell command
		* install ashell stata command using "ssc install ashell"
		ashell zipinfo -1 "${rawdata}`monthname'`shortyear'pub.zip"
		local inputfilename: di r(o1)


		/* Define NBER program according to dates
		found here: http://www.nber.org/data/cps_basic_progs.html*/

		local monthdate: di ym(`year',`month')

		* January 2015 - most recent date
		if  tm(2015m1) <= `monthdate' & `monthdate' <= tm(2017m12) local nberprogname cpsbjan2015
		* April 2014 - December 2014
		if  tm(2014m4) <= `monthdate' & `monthdate' <= tm(2014m12) local nberprogname cpsbapr2014
		* January 2014 - March 2014
		if  tm(2014m1) <= `monthdate' & `monthdate' <= tm(2014m3) local nberprogname cpsbjan2014
		* January 2013 - December 2013
		if  tm(2013m1) <= `monthdate' & `monthdate' <= tm(2013m12) local nberprogname cpsbjan13
		* May 2012 - December 2012
		if  tm(2012m5) <= `monthdate' & `monthdate' <= tm(2012m12) local nberprogname cpsbmay12
		* January 2010 - April 2012
		if  tm(2010m1) <= `monthdate' & `monthdate' <= tm(2012m4) local nberprogname cpsbjan10
		* January 2009 - December 2009
		if  tm(2009m1) <= `monthdate' & `monthdate' <= tm(2009m12) local nberprogname cpsbjan09

		***** revised weights dec 2007? *****

		* January 2007 - December 2008
		if  tm(2007m1) <= `monthdate' & `monthdate' <= tm(2008m12) local nberprogname cpsbjan07
		* August 2005 - December 2006
		if  tm(2005m8) <= `monthdate' & `monthdate' <= tm(2006m12) local nberprogname cpsbaug05
		* May 2004 - July 2005
		if  tm(2004m5) <= `monthdate' & `monthdate' <= tm(2006m7) local nberprogname cpsbmay04
		* January 2003 - April 2004
		if  tm(2003m1) <= `monthdate' & `monthdate' <= tm(2004m4) local nberprogname cpsbjan03
		* January 1998 - December 2002
		if  tm(1998m1) <= `monthdate' & `monthdate' <= tm(2002m12) local nberprogname cpsbjan98
		* September 1995 - December 1997
		if  tm(1995m9) <= `monthdate' & `monthdate' <= tm(1997m12) local nberprogname cpsbsep95
		* June 1995 - August 1995
		if  tm(1995m6) <= `monthdate' & `monthdate' <= tm(1995m8) local nberprogname cpsbjun95
		* April 1994 - May 1995 (start in january 1995)
		if  tm(1995m1) <= `monthdate' & `monthdate' <= tm(1995m5) local nberprogname cpsbapr94


		/*
		Note 2:
		arguments refer to dat_name (`1') and dct_name (`2') in NBER do files
		make necessary changes NBER do files to accept arguments
		*/
		clear
		* Run NBER program to read cps data files to Stata format
		do ${code}`nberprogname'.do `inputfilename' ${code}`nberprogname'.dct

/*
		* add revised weights, industry codes, etc. for 2000-2002 data
		if `year' >= 2000 & `year' <= 2002 {
			unzipfile ${cleandata}rw_`year'_`month'.dta.zip, replace
			merge 1:1 qstnum hryear4 hrmonth occurnum using rw_`year'_`month'.dta, assert(2 3)
			keep if _merge == 3
			drop _merge
			erase rw_`year'_`month'.dta
		}
*/

		* save in Stata format and clean up
		save cps_`year'_`month'.dta, replace
		zipfile cps_`year'_`month'.dta, saving(cps_`year'_`month'.dta.zip, replace)
		copy cps_`year'_`month'.dta.zip ${cleandata}cps_`year'_`month'.dta.zip, replace
		erase cps_`year'_`month'.dta
		erase cps_`year'_`month'.dta.zip
		erase `inputfilename'

	}
}
