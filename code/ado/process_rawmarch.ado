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

* Process unicon extracts for all years before 2005
if `begindate' <= 1997 {
  if `enddate' <= 1997 local tempenddate = `endate'
  else local tempenddate = 1997
  foreach year of numlist `begindate'/`tempenddate' {
    di "Unicon " `year' " ... already converted to Stata"
  }
}

* Process Census data all years 2005-present
if `begindate' >= 1998 | `enddate' >= 1998 {
  if `begindate' >= 1998 local tempbegindate = `begindate'
  else local tempbegindate = 1998
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

if `year' < 2019 {
 local shortyear = substr("`year'",3,2)

  * determine dictionary/NBER do-file to use
  if 1998 <= `year' & `year' <= 2012 local nberprogname cpsmar`shortyear'
  if 2013 <= `year' & `year' <= 2018 local nberprogname cpsmar`year'

  * determine archive name
  if 1998 <= `year' & `year' <= 2002 local archivename mar`shortyear'supp.zip
  if `year' == 2003 local archivename asec2003.zip
  if `year' == 2004 local archivename asec2004.zip
  if `year' == 2005 local archivename asec2005_pubuse.zip
  if `year' == 2006 local archivename asec2006_pubuse.zip
  if `year' == 2007 local archivename asec2007_pubuse_tax2.zip
  if 2008 <= `year' & `year' <= 2013 local archivename asec`year'_pubuse.zip
  if `year' == 2014 local archivename asec2014_pubuse_3x8_rerun_v2.zip
  if `year' == 2015 local archivename asec2015_pubuse.zip
  if `year' == 2016 local archivename asec2016_pubuse_v3.zip
  if `year' == 2017 local archivename asec2017_pubuse.zip
  if `year' == 2018 local archivename asec2018_pubuse.zip

  if 2014 <= `year' & `year' <= 2018 {
    local inputpath ${censusmarchraw}
    local anycovfile asec`shortyear'_currcov_extract.dat

    local anycovprogname asec`year'_currcov

    clear 
    tempfile anycovdat_`year'
    do ${dictionaries}`anycovprogname'.do ${censusmarchraw}`anycovfile' ${dictionaries}`anycovprogname'.dct
    save `anycovdat_`year'', replace
  }
  
  tempfile rawdat
  !unzip -p ${censusmarchraw}`archivename' > `rawdat'

  * use appropriate NBER .do/.dct
  * arguments refer to dat_name (`1') and dct_name (`2') in NBER do files
  * before running, make necessary changes NBER do files to accept arguments
  clear
  do ${dictionaries}`nberprogname'.do `rawdat' ${dictionaries}`nberprogname'.dct

  * supplemental datasets
  *note: SPM and Current Coverage
  if 2010 <= `year' & `year' <= 2018 {
      * spm files based on reference year
			local spmyear = `year'-1
			local inputpath ${censusmarchraw}
      * spmresearch2013 == spmresearch_redes_old
			local spmfile spmresearch`spmyear'.dta

			merge 1:1 h_seq pppos using "`inputpath'`spmfile'", assert(3) nogenerate

      * post-2014 redesign
      if 2014 <= `year' {
        merge 1:1 h_seq ppposold using `anycovdat_`year'', assert(3) nogenerate
      }


	}
 
  * save, compress, clean up
  compress
  saveold cpsmarch_`year'.dta, replace version(13)
  zipfile cpsmarch_`year'.dta, saving(cpsmarch_`year'.dta.zip, replace)
  copy cpsmarch_`year'.dta.zip ${censusmarchstata}cpsmarch_`year'.dta.zip, replace
  erase cpsmarch_`year'.dta
  erase cpsmarch_`year'.dta.zip

  * run traditional file as well
  if `year' == 2014 {
    local nberprogname cpsmar2014t
    local archivename asec2014_pubuse_tax_fix_5x8_2017.zip

    * Current Coverage dataset
    local inputpath ${censusmarchraw}
    *note: file renamed after download
    local anycovfile asec14_currcov_extract_trad.dat

    local anycovprogname asec`year'_currcov_trad

    tempfile anycovdattrad_`year'
    * drop label defined for redesign
    capture label drop now_anycov
    do ${dictionaries}`anycovprogname'.do ${censusmarchraw}`anycovfile' ${dictionaries}`anycovprogname'.dct
    save `anycovdattrad_`year'', replace

    * read in raw CPS
    tempfile rawdat2014trad
    !unzip -p ${censusmarchraw}`archivename' > `rawdat2014trad'

    clear
    do ${dictionaries}`nberprogname'.do `rawdat2014trad' ${dictionaries}`nberprogname'.dct

    * SPM dataset
    *note: file renamed after download
		local spmfiletrad spmresearch2013_trad.dta

    * merge supplemental datasets
		merge 1:1 h_seq pppos using "`inputpath'`spmfiletrad'", assert(3) nogenerate /* SPM */
    merge 1:1 h_seq ppposold using `anycovdattrad_`year'', assert(3) nogenerate /* Current Coverage */

    * save, compress, clean up
    compress
    saveold cpsmarch_`year'_traditional.dta, replace version(13)
    zipfile cpsmarch_`year'_traditional.dta, saving(cpsmarch_`year'_traditional.dta.zip, replace)
    copy cpsmarch_`year'_traditional.dta.zip ${censusmarchstata}cpsmarch_`year'_traditional.dta.zip, replace
    erase cpsmarch_`year'_traditional.dta
    erase cpsmarch_`year'_traditional.dta.zip
  }  
} 
* 2019 redesign does not have dictionary, use labelled CSV data
*note: create dictionary files in the future 
if `year' >= 2019 {
    local shortyear = substr("`year'",3,2)

    local archivename asecpub`shortyear'csv.zip

    !unzip -j ${censusmarchraw}`archivename' -d ${censusmarchraw}tempfolder
    clear

    tempfile pppub
    import delimited "${censusmarchraw}tempfolder/pppub`shortyear'.csv", stringcols(1)
    gen id = ph_seq
    gen id2 = pf_seq
    save `pppub'

    clear 

    tempfile hhpub
    import delimited "${censusmarchraw}tempfolder/hhpub`shortyear'.csv", stringcols(1)
    gen id = h_seq
    save `hhpub'
    
    clear

    tempfile ffpub
    import delimited "${censusmarchraw}tempfolder/ffpub`shortyear'.csv"
    gen id = fh_seq
    gen id2 = ffpos
    save `ffpub'

    clear

    use `pppub', clear
    joinby id id2 using `ffpub'
    merge m:1 id using `hhpub'

    * keep only matched merge
    keep if _merge == 3
    drop _merge

    * save, compress, clean up
    compress
    saveold cpsmarch_`year'.dta, replace version(13)
    zipfile cpsmarch_`year'.dta, saving(cpsmarch_`year'.dta.zip, replace)
    copy cpsmarch_`year'.dta.zip ${censusmarchstata}cpsmarch_`year'.dta.zip, replace
    erase cpsmarch_`year'.dta
    erase cpsmarch_`year'.dta.zip

    clear
}




end
