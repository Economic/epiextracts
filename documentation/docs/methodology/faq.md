# Frequently asked questions

## Which version of the data am I using?

Access the dataset label to determine the version of the extracts you are using:

```stata tab="Stata"
use epi_cpsorg_2019.dta, clear

* describe the data to view the version
describe, short

* save the version information in a local macro
local dataversion: data label
display "`dataversion'"
```

```r tab="R"
mydata <- haven::read_dta("epi_cpsorg_2019.dta")
dataversion <- attr(mydata,"label")
```

## What sample restrictions are used in the EPI extracts?

The EPI CPS Basic monthly and May extracts are restricted to those with non-missing, positive ages. The EPI CPS ORG extracts are restricted to those ages 16 and above with a positive earner sample weight ([`orgwgt`](../variables/weights/orgwgt.md)) and in the outgoing rotation months ([`minsamp`](../variables/id/minsamp.md)).

As a result the sample of individuals in the EPI extracts is sometimes smaller than what is in the raw, underlying CPS data, which can include nonresponding households and, in the case of the underlying ORG data, individuals below the age of 16.

??? note "Basic/May sample restriction"
    ```stata
    --8<-- "misc/sample_cpsbasic.do"
    ```

??? note "ORG sample restriction"
    ```stata
    --8<-- "misc/sample_cpsorg.do"
    ```

## Which sample weight variable should I use?

There are four sample weights available in the CPS extracts:

 Characteristic | [`basicwgt`](../variables/weights/basicwgt.md) | [`cmpwgt`](../variables/weights/cmpwgt.md) | [`finalwgt`](../variables/weights/finalwgt.md) | [`orgwgt`](../variables/weights/orgwgt.md)
--------------------|-----------|---------------|-----------|---------------
Years available     | All years | 1998 - present| All years | 1979 - present
Samples available   | All       | Basic/ORG     | All       | ORG
Sample restrictions | Ages 16+  | Ages 16+      | None      | Earner study

While there is not always a single correct answer regarding which weight you should use, here are some helpful guidelines:

* For many outcomes in the CPS Basic or May data, use [`basicwgt`](../variables/weights/basicwgt.md) to analyze the population ages 16 and over.

* If your analysis involves the ORG data, such as earnings information, use [`orgwgt`](../variables/weights/orgwgt.md).

* [`finalwgt`](../variables/weights/finalwgt.md) is the only weight defined for individuals under the age of 16.

* If you want to match monthly labor force statistics published by the BLS like unemployment rates, this is possible from 1998 through the present day using [`basicwgt`](../variables/weights/basicwgt.md)or [`cmpwgt`](../variables/weights/basicwgt.md), which have the same values during that time period.

In a given month, the above weights sum to the total monthly population estimate of the relevant sample.

## Which wage variable should I use? {: #which-wage-variable}

There are several hourly wage variables in the EPI CPS extracts, but for many purposes we recommend using [`wage`](../variables/income/wage.md) or [`wageotc`](../variables/income/wageotc.md).

[`wageotc`](../variables/income/wageotc.md) includes overtime, tips, and commissions (OTC) for hourly workers, but is only available for 1994-present. [`wage`](../variables/income/wage.md) is available for all years, but does not include OTC payments for hourly workers.

Both [`wage`](../variables/income/wage.md) and [`wageotc`](../variables/income/wageotc.md) include several adjustments by EPI to improve the quality of the data: top-code imputations, hours imputations, and the trimming of outliers (see the [wage methodology](wagevariables.md) for more details). However, for convenience there are variables that exclude these adjustments, as described in the table below:

&nbsp; | [`wage`](../variables/income/wage.md) | [`wageotc`](../variables/income/wageotc.md) | [`wage_noadj`](../variables/income/wage_noadj.md) | [`wageotc_noadj`](../variables/income/wageotc_noadj.md)
-----------------------|--------------------|--------------------|--------------------|--------------------
Availability           | All years          | 1994 - present     | All years          | 1994 - present
OTC for hourly workers | No                 | Yes                | No                 | Yes
Top-code imputations   | Yes                | Yes                | No                 | No
Hours vary imputations | Yes                | Yes                | No                 | No
Trimming               | Yes                | Yes                | No                 | No
BLS imputations        | Yes                | Yes                | Yes                | Yes

Additionally, if you want to use a wage variable without any weekly or hourly earnings imputations by EPI or BLS, you can incorporate the allocation flags [`a_weekpay`](../variables/income/a_weekpay.md) and [`a_earnhour`](../variables/income/a_earnhour.md). 

??? note "Example Stata code to exclude EPI and BLS imputations"
    ````stata
    * Be aware that the allocation indicators are not consistent over time.
    * In particular, there is no allocation information at all during Jan 1994 - August 1995.
    gen wage_noimpute = wage_noadj
    replace wage_noimpute = . if paidhre == 1 & a_earnhour == 1
    replace wage_noimpute = . if paidhre == 0 & a_weekpay == 1
    ````

## How do I merge the EPI CPS extracts to other sources of CPS extracts? {: #merging}

For years 1984-present, the following variables uniquely identify observations
in the EPI CPS extracts:

```
year month statefips hrhhid hrhhid2 hrsersuf hrsample huhhnum pulineno
```

These variables are present in the raw data available from
[Census](https://thedataweb.rm.census.gov/ftp/cps_ftp.html),
[NBER](http://www.nber.org/data/cps_basic.html), or
[IPUMS](https://cps.ipums.org/cps/).

For years prior to 1994, EPI CPS extracts are based on Unicon source data.
For these years the EPI variable
[`unicon_recnum`](../variables/id/unicon_recnum.md)
uniquely identifies observations and will match to Unicon's recnum variable.
