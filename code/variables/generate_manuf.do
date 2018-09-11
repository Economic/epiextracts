********************************************************************************
* manuf: Consistent manufacturing indicator
********************************************************************************
gen byte manuf = .
replace manuf = 0 if mind16 ~= .
replace manuf = 1 if mind16 == 3 | mind16 == 4
label var manuf "Manufacturing industry"
lab def manuf 0 "Not in manufacturing" 1 "Manufacturing"
lab val manuf manuf
notes manuf: Manufacturing industry classification, consistent for 1973-present
notes manuf: derived from mind16 == 3 | mind16 == 4
