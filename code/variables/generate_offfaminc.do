********************************************************************************
* Official family income: continuous
********************************************************************************
gen byte offfaminc = .

if $marchcps == 1 {
    
    if tm(1968m1) <= $date & $date <= tm(1987m12) {
        * related subfamily indicator
        gen related = famsub >= 1
        * presence of related subfamily by household
        bysort hrhhid hserial: egen rsubfam = max(related)

        * income of primary householder with related subfamily
        bysort hrhhid hserial: egen ftotval_rsubfam = max(cond(famdesc == 2, _faminc, .))

        replace offfaminc = ftotval_rsubfam if offpovuniverse == 1 & rsubfam == 1 & inlist(famdesc, 2, 4)
        replace offfaminc = _faminc if offpovuniverse == 1 & offfaminc == .
    }

    if tm(1988m1) <= $date & $date <= tm(1997m12) {
        * related subfamily indicator
        gen related = famtype == 3
        * presence of related subfamily by household
        bysort hrhhid hserial: egen rsubfam = max(related)

        * income of primary householder with related subfamily
        bysort hrhhid hserial: egen ftotval_rsubfam = max(cond(famtype == 1 & rsubfam == 1, _faminc, .))

        replace offfaminc = ftotval_rsubfam if offpovuniverse == 1 & rsubfam == 1 & inlist(famtype, 1, 3)
        replace offfaminc = _faminc if offpovuniverse == 1 & offfaminc == .
    }

    if tm(1998m1) <= $date {
        * related subfamily indicator
        gen related = famtype == 3
        * presence of related subfamily by household
        bysort hrhhid hserial: egen rsubfam = max(related) 

        * primary householder with related subfamily income
        bysort hrhhid hserial: egen ftotval_rsubfam = max(cond(famtype == 1 & rsubfam == 1, ftotval, .))

        * official family income
        replace offfaminc = ftotval_rsubfam if offpovuniverse == 1 & rsubfam == 1 & inlist(famtype, 1, 3)
        replace offfaminc = ftotval if offpovuniverse == 1 & offfaminc == .
    }
}

lab val offfaminc offfaminc
lab var offfaminc "Family income: continuous"
notes offfaminc: faminc_c treats primary and related subfamilies as one household in accordance with the official poverty rate measure
notes offfaminc: 1968-1997: Unicon faminc
notes offfaminc: 1998-present: CPS ftotval