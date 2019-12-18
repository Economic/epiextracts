# Methodology: race/ethnicity variables

Definitions for race and ethnicity in the CPS change significantly over time.
This page discusses the coding decisions made in the EPI CPS extracts to harmonize
these variables.

## Changes over time to race/ethnicity categories in the CPS

Through 2002, the number of race categories ranged from three (white, black, and other) to five (white, black, American Indian/Eskimo/Aleut, Asian or Pacific Islander, and other). Beginning in 2003, respondents could report a single or multiple races from a list of 21 race categories. Five more categories were added in May of 2012.

Hispanic ethnicity in the CPS is categorized by separate questions. Prior to 2003, this information was collected through a question regarding origin or descent of each person in the household, and respondents could choose from a list of several options. However, the primary purpose was to identify whether or not respondents were of Hispanic or Latino descent, and all other answers were grouped into a non-Hispanic category. In 2003, this question was changed to "Are you Spanish, Hispanic, or Latino?" and detailed information on Hispanic ethnicity is collected only if respondents answered yes. There are currently 8 categories to choose from in the detailed Hispanic question.

To see exactly how race and ethnicity in the CPS changed over time, the official data dictionaries are available from the [Census](https://thedataweb.rm.census.gov/ftp/cps_ftp.html#cpsbasic).

## Race/Ethnicity variables in the EPI CPS extracts

The EPI CPS extracts contain several harmonized variables that combine and categorize race and Hispanic ethnicity. For all variables except [`wbo_only`](../variables/demographics/wbo_only.md), race categories are mutually exclusive with [`hispanic`](../variables/demographics/hispanic.md) ethnicity. The table below summarizes the existing race/etchnicity variables in the EPI CPS extracts:

Variable name | Categories | Availability
--------------|------------|-------------
[`hispanic`](../variables/demographics/hispanic.md) | Hispanic, Not Hispanic | All years
[`wbhao`](../variables/demographics/wbhao.md) | White, Black, Hispanic, Asian, Other | 1989 - Present
[`wbhaom`](../variables/demographics/wbhaom.md) | White, Black, Hispanic, Asian, Native American, Multiple races | 2003 - Present
[`wbho`](../variables/demographics/wbho.md) | White, Black, Hispanic, Other | All years
[`wbho_only`](../variables/demographics/wbho_only.md) | White only, Black only, Hispanic, Other | All years
[`wbhom`](../variables/demographics/wbhom.md) | White, Black, Hispanic, Other, Multiple races | 2003 - Present
[`wbo_only`](../variables/demographics/wbo_only.md) | White only / Hispanic, Black only / Hispanic, Other | All years

A minimally recoded variable named [`raceorig`](../variables/demographics/raceorig.md) is also included in the extracts. This variable preserves the all of the detailed race information available in the full CPS, but is not consistent over time.
