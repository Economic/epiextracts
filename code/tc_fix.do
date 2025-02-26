* get old TC procedure value
load_epiextracts, begin(2023m1) end(2023m12) sample(org) version(local)
drop if minsamp == 4 & month >= 4
local topcodeval 2884.60
local weightvar orgwgt
* males: generate top-code adjusted weekly earnings
topcode_impute weekpay_noadj if weekpay_noadj ~= . & female == 0 & age >= 16 & age ~= . [pw=`weightvar'], generate(weekpay_male) method(Pareto) threshold(80) topcodeval(`topcodeval')

* females: generate top-code adjusted weekly earnings
topcode_impute weekpay_noadj if weekpay_noadj ~= . & female == 1 & age >= 16 & age ~= . [pw=`weightvar'], generate(weekpay_female) method(pareto) threshold(80) topcodeval(`topcodeval')

* store imputed value for men
sum weekpay_male 
local male_tc = r(max)

* store imputed value for women
sum weekpay_female
local female_tc = r(max)

* apply old TC procedure
foreach sample in "org" "basic" {
    * load 2023 file and fix topcode
    use ${extracts}epi_cps`sample'_2023.dta, clear

    * remove weekpay and wage variables and reassign with corrected methodology
    drop weekpay 
    gen weekpay = . 
    replace weekpay = weekpay_noadj
    * 2023m1-2023m3 follow old TC procedure, use imputed value
    replace weekpay = `male_tc' if female == 0 & tc_weekpay == 1 & month <= 3
    replace weekpay = `female_tc' if female == 1 & tc_weekpay == 1 & month <= 3

    * 2023m4-2024m3 follow new TC procedure, replace all TC with new procedure
    foreach month of numlist 4 / 12 {
        * minsamp == 4
        sum weekpay_noadj if month == `month' 
        replace weekpay = r(max) if tc_weekpay == 1 & minsamp == 4 & month == `month'

        * minsamp == 8 ~ mean above old TC value
        sum weekpay_noadj [w=`sample'wgt] if weekpay_noadj >= 2884.6 & minsamp == 4 & month == `month'
        replace weekpay = r(mean) if tc_weekpay == 1 & minsamp == 8 & month == `month'

    }
    
    * replace wage variable in all months based on new weekpay var (using standared calculation from generate_weekpay.do)
    drop wage
    gen wage = .
    replace wage = wage_noadj if paidhre == 1
    replace wage = weekpay/hoursu1 if paidhre == 0
    
    * use imputed hours for hours vary respondents
	replace wage = weekpay/hoursu1i if paidhre == 0 & hoursvary == 1

    * apply changes to wageotc
    drop wageotc
    gen wageotc = .
	* for hourly workers
	replace wageotc = wageotc_noadj if paidhre == 1
	* for nonhourly
	replace wageotc = wage if paidhre == 0

   	* trim wage values according to extreme values
	merge m:1 year using $extremewages, assert(2 3) keepusing(wage_lower wage_upper)
	keep if _merge == 3
	replace wage = . if wage < wage_lower
	replace wage = . if wage > wage_upper
    replace wageotc = . if wageotc < wage_lower
	replace wageotc = . if wageotc > wage_upper
	drop _merge wage_lower wage_upper
    *overwrite old 2023 data files
    saveold ${extracts}epi_cps`sample'_2023.dta, replace version(13)


    *******************************************************************************
    *start same process for 2024
    *******************************************************************************
    use ${extracts}epi_cps`sample'_2024.dta, clear

    * remove weekpay and wage variables and reassign with corrected methodology
    drop weekpay 
    gen weekpay = . 
    replace weekpay = weekpay_noadj
    * replace all TC with new procedure in 2024
    foreach month of numlist 1 / 3 {
        sum weekpay_noadj if month == `month'
        replace weekpay = r(max) if tc_weekpay == 1 & minsamp == 4 & month == `month'

        sum weekpay_noadj [w=`sample'wgt] if weekpay_noadj >= 2884.6 & minsamp == 4 & month == `month'
        replace weekpay = r(mean) if tc_weekpay == 1 & minsamp == 8 & month == `month'
    }

    foreach month of numlist 4 / 12 {
        sum weekpay_noadj if month == `month'
        replace weekpay = r(max) if tc_weekpay == 1 & month == `month'
    }

    * replace wage variable in all months based on new weekpay var
    drop wage
    gen wage = .
    replace wage = wage_noadj if paidhre == 1
    replace wage = weekpay/hoursu1 if paidhre == 0
    
    * use imputed hours for hours vary respondents
	replace wage = weekpay/hoursu1i if paidhre == 0 & hoursvary == 1
    
    * apply changes to wageotc
    drop wageotc
    gen wageotc = .
	* for hourly workers
	replace wageotc = wageotc_noadj if paidhre == 1
	* for nonhourly
	replace wageotc = wage if paidhre == 0

   	* trim wage values according to extreme values
	merge m:1 year using $extremewages, assert(2 3) keepusing(wage_lower wage_upper)
	keep if _merge == 3
	replace wage = . if wage < wage_lower
	replace wage = . if wage > wage_upper
    replace wageotc = . if wageotc < wage_lower
	replace wageotc = . if wageotc > wage_upper
	drop _merge wage_lower wage_upper

    *overwrite old 2024 files
    saveold ${extracts}epi_cps`sample'_2024.dta, replace version(13) 
}


