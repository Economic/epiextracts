# Changelog

If you use the EPI extracts for your research, please cite them as

!!! note "Suggested citation for EPI microdata extracts"
    Economic Policy Institute. {{ year }}. Current Population Survey Extracts, Version {{ version }}, https://microdata.epi.org.

## Recent changes
### Version 1.0.19 -- 2021-07-12
#### Added
* June 2021 extracts
#### Modified
* March 2021 CPS Basic data had missing wage values. A modified file was uploaded by Census (https://www2.census.gov/programs-surveys/cps/datasets/2021/basic/may21pub.zip). v1.0.19 incorporates this new file for March. 
### Version 1.0.18 -- 2021-06-09
#### Added
* May 2021 extracts

## Recent changes
### Version 1.0.17 -- 2021-05-13
#### Added
* April 2021 extracts

#### Modified 
* Minor coding changes to `mind16` suggested by Brain Dew (see here: https://github.com/Economic/epiextracts/pull/163)
### Version 1.0.16 -- 2021-04-08
#### Added

* March 2021 extracts

#### Modified

* Minor coding error that caused `occ10` to exist beyond 2019. This has been fixed 
### Version 1.0.15 -- 2021-03-09
#### Added

* February 2021 extracts

### Version 1.0.14 -- 2021-02-11
#### Added

* January 2021 extracts
### Version 1.0.13 -- 2021-01-13

#### Added

* December 2020 extracts

### Version 1.0.12 -- 2020-12-10

#### Added

* November 2020 extracts

### Modified

* January-July 2020 basic monthly CPS were re-released by Census to fix a small occupation coding error. These changes to the data have been incorporated in v1.0.12 (https://www.census.gov/programs-surveys/cps/technical-documentation/user-notes/cpsbasic_2020_01.html)

### Version 1.0.11 -- 2020-11-12

#### Added

* October 2020 extracts

#### Modified
* `cmpwgt` and `finalwgt` - changed instances where weights had a value of zero to be missing instead 

### Version 1.0.10 -- 2020-10-08

#### Added

* September 2020 extracts

### Version 1.0.9 -- 2020-09-09

#### Added

* August 2020 extracts

### Version 1.0.8 -- 2020-08-13

#### Added

* July 2020 extracts

### Version 1.0.7 -- 2020-07-10

#### Added

* June 2020 extracts

### Version 1.0.6 -- 2020-06-26

#### Added
* `dlfstat` : detailed labor force status
* `emphrs` : reason not at work/hours last week
* `ftptstat` : full/part time work status
* `whyabsent` : reason absent from work
* `whyunemp` : reason for unemployment

### Version 1.0.5 -- 2020-06-12

#### Added

* May 2020 extracts

#### Fixed
* `ind12` - corrected availability; previously was available up to the most recent month of data, when it should have been available through 2019m12 


### Version 1.0.4 -- 2020-05-19

#### Fixed

* `otcamt` corrected (values were too low as they were incorrectly divided by 100); this correction also changes values of `wageotc`

### Version 1.0.3 -- 2020-05-13

#### Added

* April 2020 extracts

### Version 1.0.2 -- 2020-03-15

#### Added

* March 2020 extracts

#### Modified

* `mocc10` - modified to accomodate 2018 occupation recodes (applies to data starting in 2020)

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