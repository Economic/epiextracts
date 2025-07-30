*001011 1
*001132 2
tempfile anycovdat

do code/dictionaries/asec2018_currcov.do "/data/cps/march/census/raw/asec18_currcov_extract.dat" code/dictionaries/asec2018_currcov.dct

save `anycovdat', replace

tempfile rawdat
!unzip -p "/data/cps/march/census/raw/asec2018_pubuse.zip" > "`rawdat'"

do code/dictionaries/cpsmar2018.do `rawdat' code/dictionaries/cpsmar2018.dct

merge 1:1 h_seq ppposold using `anycovdat'

