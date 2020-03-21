# Changelog

If you use the EPI extracts for your research, please cite them as

!!! note "Suggested citation for EPI microdata extracts"
    Economic Policy Institute. {{ year }}. Current Population Survey Extracts, Version {{ version }}, https://microdata.epi.org.

## Recent changes

### Version 1.0.1 -- 2020-03-13

#### Added

* January 2020 extracts
* February 2020 extracts
* `ind17` - 2017 census industry recodes (changes apply to data starting in 2020)
* `occ18` - 2018 Cencus occupational classification (changes apply to data starting in 2020)

#### Modified

* Hourly wage limits for 2020 updated based on CBO inflation projections.
* `mind16` - modified to accomodate 2017 industry recodes (applies to data starting in 2020)

#### Fixed

* union, unioncov and unionmem no longer missing for January 1984 in the basic monthly/January 1983 in the ORG 
* `occ10` - fixed to start in January 2011 instead of April 2012.

### Version 1.0 -- 2020-01-15

#### Added

* December 2019 extracts

### Version 0.6.15 -- 2019-12-16

#### Added

* November 2019 extracts

### Version 0.6.14 -- 2019-11-18

#### Added

* October 2019 extracts

### Version 0.6.13 -- 2019-10-10

#### Added

* September 2019 extracts

### Version 0.6.12 -- 2019-09-13

#### Added

* August 2019 extracts

### Version 0.6.11 -- 2019-08-08

#### Added

* July 2019 extracts

### Version 0.6.10 -- 2019-07-12

#### Added

* June 2019 extracts

### Version 0.6.9 -- 2019-06-12

#### Added

* May 2019 extracts

### Version 0.6.8 -- 2019-05-14

#### Added

* April 2019 extracts

### Version 0.6.7 -- 2019-04-22

#### Fixed

* hhtype no longer missing for 1984-1993.

### Version 0.6.6 -- 2019-04-15

#### Added

* March 2019 extracts

### Version 0.6.5 -- 2019-03-19

#### Added

* February 2019 extracts

### Version 0.6.4 -- 2019-02-22

#### Added

* `agechild` - presence of own children, by age group

#### Modified

* Hourly wage limits for 2019 updated based on CBO inflation projections.

### Version 0.6.3 -- 2019-02-07

#### Added

* January 2019 extracts

### Version 0.6.2 -- 2019-01-31

#### Added

* December 2018 extracts: all data from 2018 updated.

### Version 0.6.1 -- 2019-01-21

#### Added

* `faminc`: family income category
* `famtype`: family type
* `famwgt`: family weight
* `famid`: family id
* `hhtype`: household type
* `hhid`: household id
* `personid`: person id

### Version 0.6.0 -- 2019-01-08

#### Added

* `famrel`: relationship to primary family
* `ownchild`: Number of own children in primary family
* `wbho_only`: White only, Black only, Hispanic, Other
* `wbo_only`: White only, Black only, Hispanic

#### Changed

* `renamed` wbonly to wbo_only
* `educ`: now categorizes "12th grade, no diploma" as LTHS

#### Fixed

* `gradeatn`: missing values corrected