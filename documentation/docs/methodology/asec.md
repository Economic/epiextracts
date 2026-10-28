# March (ASEC) extracts

The EPI CPS March extracts cover the Annual Social and Economic Supplement (ASEC) to the Current Population Survey from 1962 to {{ latestmarch }}. Files are named `epi_cpsmarch_{year}`.

Years       | Source
:-----------|:-----------------------
1962 - 1997 | Unicon CPS March
1998 - {{ latestmarch }} | Census CPS ASEC public use files

Version 2026.10.13 rebuilds the March (ASEC) extracts for all years and adds 2019–2026. Results from earlier versions of the March extracts will not always match the current version. This page describes what changed, the breaks in the underlying survey, where the extracts differ from IPUMS, and which variables are limited to certain years.

## What changed from previous versions {: #changes}

### Renamed and removed variables

Previous name | Current name | Notes
:-------------|:-------------|:------
`faminc` (Basic Monthly/ORG) | [`i_faminc`](../variables/income/i_faminc.md) | Intervalled family income; `faminc` is now continuous family income in the March extracts
`faminc_det` | [`i_faminc_det`](../variables/income/i_faminc_det.md) | Intervalled family income, detailed

### New variables {: #new-variables}

* **Official poverty:** [`offpov`](../variables/income/offpov.md), [`offpovcut`](../variables/income/offpovcut.md), [`offpovuniverse`](../variables/income/offpovuniverse.md), [`offfaminc`](../variables/income/offfaminc.md), [`povlev`](../variables/income/povlev.md), [`povrate`](../variables/income/povrate.md)
* **Supplemental Poverty Measure (2010–present):** [`spmpov`](../variables/income/spmpov.md), [`spmpovcut`](../variables/income/spmpovcut.md), [`spmresources`](../variables/income/spmresources.md), [`spmwgt`](../variables/income/spmwgt.md), and SPM resource components (`spmeitc`, `spmfedtax`, `spmstatetax`, `spmsnap`, `spmschlunch`, `spmwic`, `spmmortgage`)
* **Income:** [`faminc`](../variables/income/faminc.md), [`hhinc`](../variables/income/hhinc.md), [`hhpct`](../variables/income/hhpct.md), [`earn`](../variables/income/earn.md), [`wagesal`](../variables/income/wagesal.md), [`famern`](../variables/income/famern.md), [`famiws`](../variables/income/famiws.md)
* **Health insurance:** current coverage ([`hicov`](../variables/income/hicov.md)), coverage last year ([`hicovly1`](../variables/income/hicovly1.md)–[`hicovly5`](../variables/income/hicovly5.md)), and coverage by type and employer plan (`hiprivly`, `himcaidly`, `himcarely`, `hiihsly`, `higotherly`, `hiownemp`, `hiownemply`, `hiownpaid`, `hiownpaidly`)
* **Benefits:** [`foodstamps`](../variables/income/foodstamps.md), [`pubhouse`](../variables/income/pubhouse.md), [`rentsub`](../variables/income/rentsub.md), [`penincl`](../variables/income/penincl.md), [`penplan`](../variables/income/penplan.md)
* **Work last year:** [`wrkly`](../variables/employment/wrkly.md), [`weeksly`](../variables/employment/weeksly.md), [`i_weeksly`](../variables/employment/i_weeksly.md), [`hoursly`](../variables/hours/hoursly.md), [`cowly`](../variables/employment/cowly.md), [`lookdurly`](../variables/employment/lookdurly.md)
* **Family and household structure:** [`hserial`](../variables/id/hserial.md), [`famkind`](../variables/id/famkind.md), [`dhhtype`](../variables/id/dhhtype.md), [`hhtenure`](../variables/id/hhtenure.md), [`parent`](../variables/demographics/parent.md), [`redesign`](../variables/id/redesign.md)

### Weights {: #weights}

* [`asecwgt`](../variables/weights/asecwgt.md), [`hhwgt`](../variables/weights/hhwgt.md), and [`famwgt`](../variables/weights/famwgt.md) use the same population controls as Census's published historical income tables:
    * 1980 and 1993: Unicon alternate weights, based on the 1980 and 1990 Censuses
    * 2011: weights re-estimated by Census using 2010 Census-based controls
    * 2021: weights re-estimated by Census using 2020 Census-based controls
    * 2025: Vintage 2025 revised weights
* `hhwgt` is missing for group quarters units, which Census does not count as households. In 1962–1976, `hhwgt` is the `asecwgt` of the household head. In 1968–1975, households with no `_relhd` head take the weight of the head identified by `hhrel` instead of being missing.
* `famwgt` for 1963, 1964, and 1966 is the `asecwgt` of the family reference person, so it carries the same adjustment factors as `asecwgt`. Zero and negative `famwgt` values are missing.
* `asecwgt` for 1963 and 1966 is adjusted using the [IPUMS methodology](https://cps.ipums.org/cps/asec_sample_notes.shtml).

## Survey and series breaks

* **2014 split-sample redesign.** The 2014 ASEC was fielded with two questionnaires: 3/8 of the sample got the redesigned income and health insurance questions and 5/8 got the traditional questions. [`redesign`](../variables/id/redesign.md) identifies which group a record belongs to. Both groups are included, and their weights are scaled by 3/8 and 5/8 so the combined file sums to the population. When you analyze one group alone, divide its weights by 3/8 (redesigned) or 5/8 (traditional) to get population totals.
* **2019 processing-system change.** Starting with the 2019 ASEC, Census processes the redesigned questionnaire with an updated system. Several income, poverty, and health insurance variables come from different source variables before and after 2019. For health insurance, the 2018 bridge file (2018 respondents run through the updated system) provides an overlap year: see [`hicovly4`](../variables/income/hicovly4.md) (legacy processing) and [`hicovly5`](../variables/income/hicovly5.md) (updated processing).
* **Health insurance coverage series.** There is no single consistent series for coverage last year. Use `hicovly1` (1988–2000), `hicovly2` (2001–2010, Census's 2007 revision), `hicovly3` (2000–2014, traditional questions), `hicovly4` (2014–2018, redesigned questions, legacy processing), or `hicovly5` (2018–present, updated processing). The 2001 extract uses the expanded SCHIP sample file.
* **Population control revisions.** Years in which weights move to new population controls (1980, 1993, 2011, 2021, 2025) can produce level shifts in weighted counts. See [Weights](#weights).
* **Unicon to Census source files (1998).** Variables come from Unicon files through 1997 and from Census public use files starting in 1998. Source variables for each era are listed on each variable's page.

## Differences from IPUMS

Variable | EPI | IPUMS | Years
:--------|:----|:------|:-----
[`asecwgt`](../variables/weights/asecwgt.md) | Alternate weights in 1980 and 1993, revised weights in 2011, 2021, and 2025, matching Census's historical income tables | `ASECWT` uses original weights in 1980, 1993, and 2025, and revised weights in 2010 and 2020 | 1980, 1993, 2010–2011, 2020–2021, 2025
[`offpov`](../variables/income/offpov.md) | Agrees with Census `famlis` and IPUMS `POVERTY` | `OFFPOV` uses related subfamilies' own thresholds (2000) and codes a zero-income unrelated subfamily without a threshold as above poverty (2001) | 2000–2001
[`hiprivly`](../variables/income/hiprivly.md) | Adds children covered by private plans (`chhi`), consistent with `hicovly1` | `COVERPI` excludes them | 1988–1994
[`ftptstat`](../variables/employment/ftptstat.md) | Not in labor force is coded 1 | `WKSTAT` puts it in NIU | All years

## Coverage gaps by year

Many March variables start after 1962. Some notable gaps:

* **Geography:** [`statefips`](../variables/geography/statefips.md) begins in 1963 and [`countyfips`](../variables/geography/countyfips.md) in 1996. [`cbsafips`](../variables/geography/cbsafips.md) and [`cbsasize`](../variables/geography/cbsasize.md) begin in 2005.
* **Weights:** [`famwgt`](../variables/weights/famwgt.md) begins in 1963.
* **Race and ethnicity:** [`hispanic`](../variables/demographics/hispanic.md) begins in 1971, [`wbhao`](../variables/demographics/wbhao.md) in 1988, and [`wbhom`](../variables/demographics/wbhom.md) in 2003. In 1971–2002, "don't know" and "NA" responses to Hispanic origin are missing in `hispanic` but counted as not Hispanic in `wbho` and the other race variables.
* **Poverty:** official poverty variables begin in 1968 and SPM variables in 2010. Universe definitions change in 1980 (see [`offpov`](../variables/income/offpov.md)).
* **Income:** [`i_faminc`](../variables/income/i_faminc.md) is not available in 1989.
* **Health insurance:** coverage last year begins in 1988 (calendar year 1987), and current coverage ([`hicov`](../variables/income/hicov.md)) in 2014. Employer-plan variables `hiownemp` and `hiownpaid` begin in 2019.
* **Citizenship and labor force detail:** [`citizen`](../variables/demographics/citizen.md), [`discwork`](../variables/employment/discwork.md), and [`dlfstat`](../variables/employment/dlfstat.md) begin in 1994.

See each variable's page for full availability by year.
