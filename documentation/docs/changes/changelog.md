# Changelog

If you use the EPI extracts for your research, please cite them as

!!! note "Suggested citation for EPI microdata extracts"
    Economic Policy Institute. {{ year }}. Current Population Survey Extracts, Version {{ version }}, https://microdata.epi.org.

## Recent changes
### Version 1.0.59 -- 2024-12-
#### Added
* November 2024 extracts
### Version 1.0.58 -- 2024-11-25
#### Added
* October 2024 extracts
* Included two variables,`telework` and `hourslwtw`, from the [Telework/Covid-19](https://www.census.gov/data/datasets/time-series/demo/cps/cps-supp_cps-repwgt/telework-cps-covid.html) supplement. From October 2022 to May 2024, variables related to telework were only available in this supplement file. Starting in [June 2024](https://www.census.gov/programs-surveys/cps/data/datasets/cps-basic-footnotes.html), the telework variables were incorporated in the basic monthly CPS.
#### Modified
* Fixed title error for occupational code 4610 in `occ10`. See [commit](https://github.com/Economic/epiextracts/commit/81ad48d3eec676ed94e9fe49ec52501e656d08ed) for details. Thanks to Emma Cohn for spotting this error!
### Version 1.0.57 -- 2024-10-11
#### Added
* September 2024 extracts
### Version 1.0.56 -- 2024-09-13
#### Added
* August 2024 extracts
#### Modified
* Fixed error in defining `mocc10` to account for changing occupation codes in 2020, modified `mocc10` to include occupation codes that were previously erroneously excluded. See [commit](https://github.com/Economic/epiextracts/commit/f646c37cd9c2b329035c77b51e82c262432dd270#diff-eb3c834281425bb265a1ffc0fd741e846b529d9e164840a527aa84cd1353b932) for details. Thanks to Stevie Marvin for spotting this error!
### Version 1.0.55 -- 2024-08-09
#### Added
* July 2024 extracts
### Version 1.0.54 -- 2024-07-12
#### Added
* June 2024 extracts
### Version 1.0.53 -- 2024-06-12
#### Added
* May 2024 extracts
### Version 1.0.52 -- 2024-05-10
#### Added
* April 2024 extracts
### Version 1.0.51 -- 2024-04-23
#### Added 
* documentation for `occcode` - original census occupation code, not harmonized over time
#### Modified
* v1.0.50 introduced an error where occupation codes for `occ70` through `occ18` were missing. This update rectified an issue where the occupation variables relied on code erroneously included in the generation of `occ70` instead of `occcode` to create those variables. Thanks to Hilary Wething for spotting this error!
### Version 1.0.50 -- 2024-04-11
#### Added
* March 2024 extracts
#### Modified
* Fixed documentation error in `earnhour` to be consistent with the underlying variable name change. Change occurred in [March 2021](https://www.census.gov/programs-surveys/cps/data/datasets/cps-basic-footnotes.html).  
### Version 1.0.49 -- 2024-03-18
#### Added
* February 2024 extracts
#### Modified
* Fixed labeling errors in `occ90` to be consistent with the relevant [census codebook](https://www2.census.gov/programs-surveys/cps/techdocs/cpsmar96.pdf), appendix B. This impacts value labels for `occ90` from 1992 to 2002 in the basic monthly and ORG data. Thank you to John Schmitt for discovering and notifying EPI of this error!
    * label for occupation code 021 was "Business and promotion managers", now "Managers, service organizations, n.e.c"
    * label for occupation code 034 was "Supervisors and proprietors, sales occupation", now "Business and promotion agents"
    * label for occupation code 243 was "Supervisors--forestry", now  "Supervisors and proprietors, sales occupation"
### Version 1.0.48 -- 2024-02-14
#### Added
* January 2024 extracts
### Version 1.0.47 -- 2024-01-10
#### Added
* December 2023 extracts
### Version 1.0.46 -- 2023-12-15
#### Added
* November 2023 extracts
### Version 1.0.45 -- 2023-11-16
#### Added
* October 2023 extracts
### Version 1.0.44 -- 2023-10-12
#### Added
* September 2023 extracts
### Version 1.0.43 -- 2023-09-18
#### Added
* August 2023 extracts
### Version 1.0.42 -- 2023-08-16
#### Added
* July 2023 extracts
#### Modified
* `hoursvary` was only 1 and missing in prior versions. Now has value of 0 when hours do not vary.
### Version 1.0.41 -- 2023-08-02
#### Added
* April, May, June 2023 extracts
#### Modified
* `weekpay` has been adjusted to reflect the [new topcoding](https://www2.census.gov/programs-surveys/cps/methodology/improving-disclosure-avoidance-puf-v2.pdf) procedures from Census. See more about how we deal with this in the [wage variables methodology](../methodology/wagevariables.md)
### Version 1.0.40 -- 2023-04-24
#### Added
* March 2023 extracts
### Version 1.0.39 -- 2023-03-17
#### Added
* February 2023 extracts
### Version 1.0.38 -- 2023-02-27
#### Added
* January 2023 extracts
### Version 1.0.37 -- 2023-01-12
#### Added
* December 2022 extracts
### Version 1.0.36 -- 2022-12-08
#### Added
* November 2022 extracts
### Version 1.0.35 -- 2022-11-10
#### Added
* October 2022 extracts
### Version 1.0.34 -- 2022-10-13
#### Added
* September 2022 extracts
#### Modified 
* Fixed typo in `minsamp` documentation
### Version 1.0.33 -- 2022-09-09
#### Added
* August 2022 extracts
### Version 1.0.32 -- 2022-08-10
#### Added
* July 2022 extracts
### Version 1.0.31 -- 2022-07-18
#### Added
* June 2022 extracts
### Version 1.0.30 -- 2022-06-08
#### Added
* May 2022 extracts
### Version 1.0.29 -- 2022-05-11
#### Added
* April 2022 extracts
### Version 1.0.28 -- 2022-04-06
#### Added
* March 2022 extracts
### Version 1.0.27 -- 2022-03-10
#### Added
* February 2022 extracts
### Version 1.0.26 -- 2022-02-17
#### Added
* January 2022 extracts
### Version 1.0.25 -- 2022-01-14
#### Added
* December 2021 extracts
### Version 1.0.24 -- 2021-12-08
#### Added
* November 2021 extracts
### Version 1.0.23 -- 2021-11-15
#### Added
* October 2021 extracts
### Version 1.0.22 -- 2021-10-14
#### Added
* September 2021 extracts
### Version 1.0.21 -- 2021-09-09
#### Added
* August 2021 extracts
### Version 1.0.20 -- 2021-08-11
#### Added
* July 2021 extracts

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
