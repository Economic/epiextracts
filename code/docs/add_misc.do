copy ${code}sample_cpsbasic.do ${docs}misc/sample_cpsbasic.do, replace
copy ${code}sample_cpsorg.do ${docs}misc/sample_cpsorg.do, replace
copy ${codevars}generate_weekpay.do ${docs}misc/generate_weekpay.do, replace
copy ${codevars}generate_hoursu1i.do ${docs}misc/generate_hoursu1i.do, replace
copy ${code}ado/topcode_impute.ado ${docs}misc/topcode_impute.ado, replace
* convert to markdown for doc purposes using 'tabulate': https://pypi.org/project/tabulate/
! tabulate -s , --header -f github ${docs}misc/extremewages.csv > ${docs}misc/extremewages.md
