.. _changelog:

==============================================================================
Changelog
==============================================================================
If you use the EPI extracts for your research, please cite them as

.. note::
	Economic Policy Institute. |year|. Current Population Survey Extracts, |release|.


Version 0.4.3 -- 2018-09-13
===============================================================================

Added
-------------------------------------------------------------------------------
* Trimming of extreme wage values
	wage and wageotc set to missing if under 50 cents/hour or over $100/hour in 1989$.

* veteran: veteran status


Version 0.4.2 -- 2018-09-12
===============================================================================

Added
-------------------------------------------------------------------------------
* Hours imputation for wage and wageotc for non-hourly workers whose hours vary.
	For non-hourly workers whose hours vary during 1994-present, wage and wageotc
	use demographic/industry-predicted hours when calculating weekly earnings divided
	by hours worked. Depending on the year, this is roughly 2-3% of positive wage earners.

* hoursu1i: imputed hours worked for ORG sample, used in wage and wageotc
* hoursuint: intervalled usual weekly hours worked
* manuf: manufacturing indicator
* citizen: US citizenship indicator
* cititsat: detailed citizenship/foreign born status
* married: marital status
* gradeatn: detailed 1992+ educational attainment (replaces grade92)

Changed
-------------------------------------------------------------------------------
* grade92: renamed to gradeatn


Version 0.4.1 -- 2018-09-11
===============================================================================

Added
-------------------------------------------------------------------------------
* July 2018 extracts
* June 2018 extracts
* earnhour, a_earnhour: hourly earnings per hour for hourly workers

Changed
-------------------------------------------------------------------------------
* minsamp: extended back to 1973


Version 0.4.0 -- 2018-09-02
===============================================================================

Added
-------------------------------------------------------------------------------
* Top-code adjustments for weekpay (and wage, wageotc).
	All top-coded values of weekpay replaced with gender-specific imputed mean above the top-code, assuming Pareto distribution of weekpay above 80th percentile. wage and wageotc incorporate top-code adjusted weekpay.

* wage_noadj, wageotc_noadj, weekpay_noadj: non-adjusted wage values


Changed
-------------------------------------------------------------------------------
* hrhhid, pulineno: extended back to 1973
* wage, wageotc, weekpay now include imputed means of weekpay above top-code

Fixed
-------------------------------------------------------------------------------
* weekly earnings top-code in 1986-1988 corrected, now $999



Version 0.3.5 -- 2018-08-21
===============================================================================

Added
-------------------------------------------------------------------------------
* multjobs, numjobs: multiple job indicators
* occcode: original Census occupation code
* hoursumay: usual hours worked per week in May supplement
* hoursuorg: usual hours worked per week in ORG
* hoursu1, hoursu2, hoursut: usual hours on primary, other, all jobs
* hourslw1, hourslw2, hourslwt: last week hours on primary, other, all jobs
* hoursvary: hours vary indicator
* unicon_recnum: link to Unicon source data for 1973-1993

Changed
-------------------------------------------------------------------------------
* restricted ORG sample to ages 16 and over
* hourly earnings in May CPS for non-hourly workers now uses usual hours worked

Fixed
-------------------------------------------------------------------------------
* change weekly earnings top-code from $2884 to $2884.61 in 1998+ data


Version 0.3.4 -- 2018-08-01
===============================================================================

Added
-------------------------------------------------------------------------------
* ind70, ind80, ind90, ind00, ind10: original industry codes
* cow1, cow2: class of worker
* mind16: harmonized major industry
* selfemp extended to 1973

Fixed
-------------------------------------------------------------------------------
* removed inconsistent selfany variable


Version 0.3.3 -- 2018-07-27
===============================================================================

Added
-------------------------------------------------------------------------------
* renamed wage3 to wage
* renamed wage4 to wageotc

Fixed
-------------------------------------------------------------------------------
* educ missing values in 1992


Version 0.3.2 -- 2018-07-26
===============================================================================

Added
-------------------------------------------------------------------------------
* wage3, lfstat extended to 1973
* a_weekpay: BLS allocation for weekpay
* cmpwgt: composite final monthly weight
* discwork: discouraged worker
* finalwgt: final monthly weight
* lookdur: unemployment & looking duration
* ptecon: part-time for economic reasons
* public sector variables: pubsec, publoc, pubst, pubfed
* samejob: same job as last month
* schenrl: enrolled in college/high school
* unempdur: unemployment duration
* weekpay_tc: top-code indicator

Fixed
-------------------------------------------------------------------------------
* lfstat errors in 1988-1989

Modified
-------------------------------------------------------------------------------
* basicwgt is now final weight through 1997, composite weight 1998-present


Version 0.3.1 -- 2018-07-09
===============================================================================

Added
-------------------------------------------------------------------------------
* educ: Education level, available through 1973-present
* gradehi: highest grade attended, 1973-1991
* gradecom: completed highest grade, 1973-1991


Version 0.3.0 -- 2018-07-04
===============================================================================

Added
-------------------------------------------------------------------------------
* Data through 2018-05
* Initial version of 1973-1981 May extracts
* So many other things
* This changelog!

Fixed
-------------------------------------------------------------------------------
* Too many things
