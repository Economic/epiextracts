---
title: Home
---

# EPI Microdata Extracts

## Download the data
The latest EPI CPS extracts are available in Stata format:

!!! note
     Due to the 2025 U.S federal government shutdown, October data was not collected and is not available in the EPI CPS extracts.

Extract     | Years   | File | Version
------------|---------|------|---------------------------------
CPS Basic monthly | 1976 - {{ release.latestdata }} | [epi_cpsbasic_2000_{{ release.latestdata[:4] }}.zip](epi_cpsbasic_2000_{{ release.latestdata[:4] }}.zip) <br/> [epi_cpsbasic_1976_1999.zip](epi_cpsbasic_1976_1999.zip) | {{ release.version }}
CPS May           | 1973 - 1981            | [epi_cpsmay_1973_1981.zip](epi_cpsmay_1973_1981.zip) | {{ release.version }}
CPS ORG           | 1979 - {{ release.latestdata }} | [epi_cpsorg_1979_{{ release.latestdata[:4] }}.zip](epi_cpsorg_1979_{{ release.latestdata[:4] }}.zip) | {{ release.version }}


## View the documentation
* [Variables](variables/) available in the EPI extracts
* How to [use](basicuse.md) the data after downloading it
* Frequently asked [questions](methodology/faq.md)
* Methodology for specific variables like [wages](methodology/wagevariables.md) and [race/ethnicity](methodology/racevariables.md)
* How to [cite](sources.md) the EPI extracts
* Recent [changes](changes/changelog.md) to the data

## Citations
If you use the EPI extracts for your research, please cite the data in your references:

!!! note "Suggested citation for EPI microdata extracts"
    Economic Policy Institute. {{ release.version[:4] }}. Current Population Survey Extracts, Version {{ release.version }}, https://microdata.epi.org.

The code that creates the EPI extracts and documentation is available on
[Github](https://github.com/Economic/epiextracts).
