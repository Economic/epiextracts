********************************************************************************
* Official poverty threshold
********************************************************************************
gen byte offpov = .

if $marchcps == 1 {
    if tm(1968m1) <= $date {
        * require both values; Stata treats missing as larger than any number
        replace offpov = 0 if offfaminc >= offpovcut & offpovuniverse == 1 & !missing(offfaminc, offpovcut)
        replace offpov = 1 if offfaminc < offpovcut & offpovuniverse == 1 & !missing(offfaminc, offpovcut)
    }
}

lab var offpov "Offical poverty threshold"
label def offpov 0 "Above poverty threshold" 1 "Below poverty threshold"
label value offpov offpov
notes offpov: Universe definition from 1980-present: all persons except for unrelated individuals under age 15
notes offpov: 1968-1997: faminc & povcut
notes offpov: 1998-present: ftotval & fpovcut
notes offpov: 2000-2001: differs from IPUMS OFFPOV, which uses related subfamilies' own thresholds (2000) and codes a zero-income unrelated subfamily without a threshold as above poverty (2001); EPI agrees with Census famlis and IPUMS POVERTY
