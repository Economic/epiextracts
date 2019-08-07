===============================================================================
Methodology: Race/ethnicity variables
===============================================================================
Definitions for race and ethnicity in the CPS change significantly over time.
This page discusses the coding decisions made in the EPI CPS extracts to harmonize
these variables.


Changes to race/ethnicity in the CPS over time
===============================================================================
Through 2002, the number of race categories ranged from 3 (white, black, and other) to 5 
(white, black, American Indian/Eskimo/Aleut, Asian or Pacific Islander, and other). 
Beginning in 2003, respondents could report more than one race from a list of 21 race categories.
Five more were added in May of 2012 for a total of 26. 

Hispanic ethnicity in the CPS is identified by a separate variable.
Prior to 2003, this information was collected through a question regarding origin or descent 
of each person in the household, and respondents could choose from a list of several options.
However, the primary purpose was to identify whether or not respondents were of Hispanic or 
Latino descent, and all other answers were grouped into a non-Hispanic category. 
In 2003, this question was changed to "Are you Spanish, Hispanic, or Latino?" and detailed
information on Hispanic ethnicity is collected only if respondents answered yes. 
There are currently 8 categories to choose from in the detailed Hispanic question. 

To see exactly how race and ethnicity in the CPS changed over time, the official 
data dictionaries are available `here <https://thedataweb.rm.census.gov/ftp/cps_ftp.html#cpsbasic>`_.


Race/Ethnicity variables in the EPI CPS extracts
===============================================================================
There are several harmonized variables that combine and categorize race and Hispanic ethnicity in the EPI CPS extracts. 
For all variables except for :doc:`wbo_only <variables/demographics/wbo_only>`, race categories are mutually exclusive with :doc:`Hispanic <variables/demographics/hispanic>` ethnicity.
Click on the linked variable names in the table below to view more specific information about each variable. 

.. csv-table::
    :header: "Variable name", "Categories", "Availability" 
    :widths: 10, 20, 10

    :doc:`wbho <variables/demographics/wbho>`, "white, black, Hispanic, other", "All years"
    :doc:`wbhao <variables/demographics/wbhao>`, "white, black, Hispanic, asian, other", "1989 - present"
    :doc:`wbhom <variables/demographics/wbhom>`, "white, black, Hispanic, other, multiple", "2003 - present"
    :doc:`wbhaom <variables/demographics/wbhaom>`, "white, black, Hispanic, asian, native american, multiple", "2003 - present"
    :doc:`wbho_only <variables/demographics/wbho_only>`, "white only, black only, Hispanic, other", "All years"
    :doc:`wbo_only <variables/demographics/wbo_only>`, "white/Hispanic, black/Hispanic, other", "All years"
    :doc:`hispanic <variables/demographics/hispanic>`, "Not Hispanic, Hispanic", "All years"



A minimally recoded variable named :doc:`raceorig <variables/demographics/raceorig>` is also
included in the extracts. This variable preserves the detailed race information available 
in the full CPS, but is not consistent over time.
