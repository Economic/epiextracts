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

  * determine archive name for raw files
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

  * determine archive names for current health insurance coverage supplement 
  if 2014 <= `year' & `year' <= 2018 {
    local inputpath ${censusmarchraw}
    local anycovfile asec`shortyear'_currcov_extract.dat

    local anycovprogname asec`year'_currcov

    clear 
    tempfile anycovdat_`year'
    do ${dictionaries}`anycovprogname'.do ${censusmarchraw}`anycovfile' ${dictionaries}`anycovprogname'.dct
    save `anycovdat_`year'', replace
  }
  
  * unzip archived files
  tempfile rawdat
  !unzip -p ${censusmarchraw}`archivename' > `rawdat'

  * use appropriate NBER .do/.dct
  * arguments refer to dat_name (`1') and dct_name (`2') in NBER do files
  * before running, make necessary changes NBER do files to accept arguments
  clear
  do ${dictionaries}`nberprogname'.do `rawdat' ${dictionaries}`nberprogname'.dct

  * combine datasets for additional detail 
  *note: files already in .dta format

  * combine with revised health insurance datasets (in .dta)
  *note: 1997-2004, June 2007 revision flags; 2000-2010, September 2011 revision
  *note: 2001 revisions match the expanded SCHIP file, so they are merged in the CHIP block below
  if 1997 <= `year' & `year' <= 2010 & `year' != 2001 {
    merge_revhi, year(`year')
  }

  * combine with 2014 redesign supplemental datasets
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

  * revised person weights based on updated population controls (marsupwt_rev)
  if inlist(`year', 2010, 2011) {
    merge_revwgt, year(`year')
  }

  * 2018 bridge file: the same people run through the updated processing system;
  * keep only its coverage recode for the processing-change series (hicovly5)
  if `year' == 2018 {
    preserve
      tempfile bridgecsv bridgecov
      !unzip -p ${censusmarchraw}asec2018_bridge_csv.zip pppub18.csv > `bridgecsv'
      import delimited using `bridgecsv', stringcols(1) clear
      keep peridnum cov
      rename cov cov_bridge
      save `bridgecov'
    restore

    * 14 production records have no bridge counterpart; 25 bridge-only records are dropped
    merge 1:1 peridnum using `bridgecov', keep(master match) nogenerate
  }

  * save, compress, clean up
  compress
  saveold cpsmarch_`year'.dta, replace version(13)
  zipfile cpsmarch_`year'.dta, saving(cpsmarch_`year'.dta.zip, replace)
  copy cpsmarch_`year'.dta.zip ${censusmarchstata}cpsmarch_`year'.dta.zip, replace
  erase cpsmarch_`year'.dta
  erase cpsmarch_`year'.dta.zip

  * run CHIP file
  if `year' == 2001 {
    local archivename chip2001pub.zip

    tempfile rawdat
    !unzip -p ${censusmarchraw}`archivename' > `rawdat'

    * drop data and value labels from the regular 2001 file;
    * cpsmar01.do redefines its labels without replace
    clear
    do ${dictionaries}cpsmar01.do `rawdat' ${dictionaries}cpsmar01.dct

    * September 2011 health insurance revision (person counts match SCHIP file)
    merge_revhi, year(`year')

    * save, compress, clean up
    compress
    saveold cpsmarch_`year'_schip.dta, replace version(13)
    zipfile cpsmarch_`year'_schip.dta, saving(cpsmarch_`year'_schip.dta.zip, replace)
    copy cpsmarch_`year'_schip.dta.zip ${censusmarchstata}cpsmarch_`year'_schip.dta.zip, replace
    erase cpsmarch_`year'_schip.dta
    erase cpsmarch_`year'_schip.dta.zip

  }

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
    gen id2 = phf_seq
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

    * revised person weights based on updated population controls (marsupwt_rev)
    if inlist(`year', 2020, 2021, 2025) {
      merge_revwgt, year(`year')
    }

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



*************************************************************************
* NAME: merge_revhi
* DESC: Merges Census revised health insurance files onto the March data
* in memory. 1997-2004: household flags approximating the June 2007
* correction (see revhlth_readme.txt). 2000-2010: September 2011 revised
* recodes overwrite the originals, which are kept as *_orig.
* Called by process_censusmarch
*************************************************************************
capture program drop merge_revhi
program define merge_revhi
syntax, year(integer)

local shortyear = substr("`year'",3,2)

* June 2007 revision: whole-household employer (allempl) and
* direct-purchase (allpriv) flags, one record per household
if 1997 <= `year' & `year' <= 2004 {
  preserve
    use "${censusmarchraw}hi_pu_xtrct`shortyear'.dta", clear

    * Census names are uppercase but NBER dictionaries are lowercase
    rename *, lower

    * flags are stored as strings
    destring _all, replace

    tempfile revflags
    save `revflags'
  restore

  merge m:1 h_seq using `revflags', assert(3) nogenerate
}

* September 2011 revision: full set of revised person-level recodes
if 2000 <= `year' & `year' <= 2010 {
  * keep the as-published recodes for the original and HIA series (hicovly1, hicovly2)
  foreach v in cov_hi mcaid mcare champ {
    clonevar `v'_orig = `v'
  }

  preserve
    use "${censusmarchraw}hlthins_sy`year'_rev.dta", clear

    * without lowercasing, the revised values sit alongside the originals unused
    rename *, lower

    * revised values are stored as strings
    destring _all, replace

    tempfile revhi
    save `revhi'
  restore

  * overwrite original recodes with revised values for every person
  merge 1:1 ph_seq pppos using `revhi', update replace assert(3 4 5) nogenerate
}

end



*************************************************************************
* NAME: merge_revwgt
* DESC: Merges person weights re-estimated with updated population
* controls onto the March data in memory as marsupwt_rev, in the same
* units as marsupwt. 2010-2011: 2010 Census-based (from IPUMS ASECWT,
* matched on household ids and line number); 2020-2021: 2020
* Census-based; 2025: Vintage 2025 (Census replicate weight files).
* Called by process_censusmarch
*************************************************************************
capture program drop merge_revwgt
program define merge_revwgt
syntax, year(integer)

preserve
  * 2010 Census-based weights, already keyed on h_seq and pppos
  if inlist(`year', 2010, 2011) {
    import delimited using "${censusmarchraw}asec_2010base_weights_2010_2011.csv", clear
    keep if year == `year'
    keep h_seq pppos marsupwt_rev
  }

  * Census replicate weight files: main weight pwwgt0 has 4 implied decimals
  if inlist(`year', 2020, 2021, 2025) {
    if inlist(`year', 2020, 2021) local revfile CPS_ASEC_ASCII_REPWGT_`year'_2020BASE.zip
    if `year' == 2025 local revfile CPS_ASEC_ASCII_REPWGT_2025_V2025.ZIP

    tempfile revdat
    !unzip -p ${censusmarchraw}`revfile' > `revdat'
    infix double pwwgt0 1-9 long h_seq 1450-1454 int pppos 1455-1456 using `revdat', clear

    * public use weights from 2019 on carry 2 implied decimals
    gen double marsupwt_rev = pwwgt0 / 100
    keep h_seq pppos marsupwt_rev
  }

  tempfile revwgt
  save `revwgt'
restore

* every person has a revised weight; keep the original record order
gen long revwgt_order = _n
merge 1:1 h_seq pppos using `revwgt', assert(3) nogenerate
sort revwgt_order
drop revwgt_order
label var marsupwt_rev "Person supplement weight, revised population controls"

end
