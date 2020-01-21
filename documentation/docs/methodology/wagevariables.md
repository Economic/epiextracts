# Methodology: wage variables

Three key wage variables in the EPI CPS extracts contain additional imputations and restrictions to improve their usefulness: [`wage`](../variables/income/wage.md), [`wageotc`](../variables/income/wageotc.md), and [`weekpay`](../variables/income/weekpay.md). This section discusses these modifications.

If you'd like to use variables that don't include these adjustments, consider using [`wage_noadj`](../variables/income/wage_noadj.md), [`wageotc_noadj`](../variables/income/wageotc_noadj.md), and [`weekpay_noadj`](../variables/income/weekpay_noadj.md). 

For a shorter overview of the wage variables, see [this discussion](faq.md#which-wage-variable).

## Top-code adjustments

Weekly earnings in the underlying source data are top-coded or right-censored. For the top-coded weekly earnings, the EPI extracts variable [`weekpay`](../variables/income/weekpay.md) contains the gender- and year-specfic imputed mean above the top-code assuming the earnings distribution is Pareto above the 80th percentile. For non-hourly workers, these imputed values are also incorporated in the hourly wage variables [`wage`](../variables/income/wage.md) and [`wageotc`](../variables/income/wageotc.md).

To use a weekly earnings variable without this adjustment, consider [`weekpay_noadj`](../variables/income/weekpay_noadj.md) and the associated hourly wage variables [`wage_noadj`](../variables/income/wage_noadj.md), [`wageotc_noadj`](../variables/income/wageotc_noadj.md).

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


