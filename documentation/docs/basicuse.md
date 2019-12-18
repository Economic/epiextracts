# How to use the EPI extracts

## 1. Download the data
Version {{ version }} of the EPI CPS extracts is available to download [here](index.md).

## 2. Unzip and move the files
The zip file you downloaded is a collection of Stata data files, one file for each year (or monthly files when annual data is not available). You should decompress those files and move them into an appropriate directory on your computer.

## 3. Use the data with your favorite statistical package

??? info "Stata examples"
    Feel free to just use the datasets just as you would any Stata dataset:
    ```stata
    use "/data/cps/epi_cpsorg_2018.dta", clear
    ```
    where you have replaced `/data/cps/` with the directory containing the decompressed files.

    Alternatively, the Stata command `load_epiextracts` is an easy way to load a selection of years and variables of the EPI CPS extracts into memory. First, install the Stata package with
    ```stata
    net install load_epiextracts, from("https://microdata.epi.org/stata")
    ```
    and then use it like

    ```stata
    * Load all of the 2016-2017 EPI CPS Basic monthly extracts
    load_epiextracts, begin(2016m1) end(2017m12) sample(basic) sourcedir("/data/cps")

    * Load certain variables from the 1990m7-2018m6 EPI CPS ORG
    load_epiextracts, begin(1990m7) end(2018m6) keep(age lfstat union) sample(org) sourcedir("/data/cps")
    ```
    After installing the command see `help load_epiextracts` for more details.

??? info "R examples"
    The haven package will load Stata datasets:
    ```r
    mydata <- haven::read_dta("/data/cps/epi_cpsorg_2018.dta.zip")
    ```

## 4. Cite the data
If you use the EPI extracts for your research, please cite the data in your references:

!!! note "Suggested citation for EPI microdata extracts"
    Economic Policy Institute. {{ year }}. Current Population Survey Extracts, Version {{ version }}, https://microdata.epi.org.


