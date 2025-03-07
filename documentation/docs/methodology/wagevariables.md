# Methodology: wage variables

Three key wage variables in the EPI CPS extracts contain additional imputations and restrictions to improve their usefulness: [`wage`](../variables/income/wage.md), [`wageotc`](../variables/income/wageotc.md), and [`weekpay`](../variables/income/weekpay.md). This section discusses these modifications.

If you'd like to use variables that don't include these adjustments, consider using [`wage_noadj`](../variables/income/wage_noadj.md), [`wageotc_noadj`](../variables/income/wageotc_noadj.md), and [`weekpay_noadj`](../variables/income/weekpay_noadj.md). 

For a shorter overview of the wage variables, see [this discussion](faq.md#which-wage-variable).

## Top-code adjustments

In order to preserve the confidentiality of respondents, the income variables in the public-use files of the CPS are top-coded or right-censored. Prior to April 2023, the top-code was a fixed value for weekly earnings. For the survey years 1973–1985, the weekly wage is top-coded at $999.00, $1,923 from 1986–1997,and $2,884.61 in 1998.
This truncation of the wage distribution creates a downward bias in estimates of the mean wage, particularly as the share of respondants with top-coded weekly pay increases over time due to inflation. To account for this, the EPI extracts variable [`weekpay`](../variables/income/weekpay.md) contains the gender- and year-specific imputed mean above the top-code assuming the earnings distribution is Pareto above the 80th percentile. For non-hourly workers, these imputed values are also incorporated in the hourly wage variables [`wage`](../variables/income/wage.md) and [`wageotc`](../variables/income/wageotc.md). However, the [increasing share of respondants](../variables/income/tc_weekpay.md) with top-coded earnings also causes [other problems](https://www.epi.org/blog/stagnant-topcode-thresholds-threaten-data-reliability-for-the-highest-earners-and-make-inequality-difficult-to-accurately-measure/).

Beginning in April 2023, the top-coding procedure changed from being a single value for weekly earnings (2,884.61), to a [dynamically adjusted](https://www2.census.gov/programs-surveys/cps/methodology/improving-disclosure-avoidance-puf-v2.pdf) value each month. This value is calculated by Census, and is the weighted average of the reported earnings of the top 3% of weekly earners. The same process is applied to hourly earners. Between April 2023 and March 2024, this new top-coding procedure is phased in so that only respondants who entered the survey in 2023 or later are top coded "dynamically." During this time period, only respondants coded as 4 in [`minsamp`](../variables/id/minsamp.md) will have the new top-coding procedure. Respondents coded as 8 in [`minsamp`](../variables/id/minsamp.md) are assigned the mean above the top-coded value for respondents that with the new top-coding procedure (respondents coded as 4 in [`minsamp`](../variables/id/minsamp.md), or half of the ORG sample) until all respondent groups are phased-in.

During this time, the respondents coded as 8 in [`minsamp`](../variables/id/minsamp.md) are still under the old top-code regime. To create a more consistant top-code value across these two regimes, we take the the average of the values of [`weekpay`](../variables/income/weekpay.md) that are greater than 2884.61 from respondants coded as 4 in [`minsamp`](../variables/id/minsamp.md) in a given month. That value then becomes the new top-code for respondents coded as 8 in [`minsamp`](../variables/id/minsamp.md). 

Starting in April 2024, we do not make any adjustments to the earnings of top-coded respondants.

To use a weekly earnings variable without any topcode adjustments across any years in the data, consider [`weekpay_noadj`](../variables/income/weekpay_noadj.md) and the associated hourly wage variables [`wage_noadj`](../variables/income/wage_noadj.md), [`wageotc_noadj`](../variables/income/wageotc_noadj.md).

??? note "Function used to impute the mean above the topcode"
    ```stata
    --8<-- "misc/topcode_impute.ado"
    ```

??? note "Specific top-code adjustment used for weekly earnings"
    ```stata
    --8<-- "misc/generate_weekpay.do"
    ```

## Hours imputations

For data from 1994 to the present, respondents can report that their usual weekly "hours vary" at work. The EPI extracts contain an imputed usual weekly hours variable [`hoursu1i`](../variables/hours/hoursu1i.md) that is equal to usual hours worked at the primary job [`hoursu1`](../variables/hours/hoursu1.md), except when "hours vary", in which case it is based on the following regression-based predictions:

??? note "Demographic & industry-based usual hours prediction"
    ```stata
    --8<-- "misc/generate_hoursu1i.do"
    ```

The imputed usual weekly hours is used when calculating hourly wages for nonhourly workers in [`wage`](../variables/income/wage.md) and [`wageotc`](../variables/income/wageotc.md). If you do not want to include these hours imputations in your wage analysis, you can simply set wage values to missing for nonhourly (`paidhre == 0`) workers whose hours vary (`hoursvary == 1`).

## Trimming outliers

The hourly wage variables [`wage`](../variables/income/wage.md) and [`wageotc`](../variables/income/wageotc.md) are trimmed of outliers. Specifically, these hourly wage values are set to missing if they are above 50 cents per hour or $100 per hour in 1989 dollars.

For hourly wage variables that do not have this modification, see [`wage_noadj`](../variables/income/wage_noadj.md) and [`wageotc_noadj`](../variables/income/wageotc_noadj.md)

??? note "Hourly wage limits for [`wage`](../variables/income/wage.md) and [`wageotc`](../variables/income/wageotc.md)"
    --8<-- "misc/extremewages.md"
    
    Download this [table](/misc/extremewages.csv).

## BLS wage allocations

In recent years, a large number of observations have weekly earnings or hourly wages imputed by the BLS. If you want to use a wage variable without any weekly or hourly earnings imputations by EPI or BLS, you can incorporate the allocation flags [`a_weekpay`](../variables/income/a_weekpay.md) and [`a_earnhour`](../variables/income/a_earnhour.md).

??? note "Generate wage variable that excludes all imputations"
    ```stata
    * Stata code to restrict hourly wages to data not allocated by BLS
    * Be aware that the allocation indicators are not consistent over time.
    * In particular, there is no allocation information at all during Jan 1994 - August 1995.

    gen wage_noimpute = wage_noadj
    replace wage_noimpute = . if paidhre == 1 & a_earnhour == 1
    replace wage_noimpute = . if paidhre == 0 & a_weekpay == 1
    ```


