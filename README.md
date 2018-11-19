# EPI uniform extracts of the Current Population Survey
This repository creates cleaned uniform extracts of the CPS basic monthly, outgoing rotation group, and May supplement files.

## Get the data and documentation
You probably just want the data and documentation available [here](https://microdata.epi.org/).

## Deployment
1. Stata processes the raw data, generates the cleaned datasets, and creates most of the .rst files used in the documentation. Run `master.do` from the project root to load into memory global macros for the directory structure as well as the Stata programs used to generate the data and documentation.

2. Sphinx processes the .rst files to create the documentation website.

3. A Makefile deploys the data, code, and documentation to public and internal EPI servers.

### Convert raw source data into Stata datasets
For 1994-present, use the `process_rawbasic` program to convert the BLS/Census raw data into Stata files. For example,

```stata
process_rawbasic, begin(1994m1) end(2018m10)
```

For 1973-1993, the CPS extracts rely on data from Unicon already saved as Stata .dta files.

### Create EPI CPS extracts from Stata source files
Use the `create_extracts` program to create the May/ORG/Basic extracts. For example,

```stata
create_extracts, begin(1973m1) end(2018m10)
```

### Create the documentation
Use sphinx.
