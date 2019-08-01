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
Five more were added in May of 2012 for a total of 26. In 2014, additional categories 
were added to the detailed Hispanic group variable.

To see exactly how race and ethnicity in the CPS changed over time, the official 
data dictionaries are available `here <https://thedataweb.rm.census.gov/ftp/cps_ftp.html#cpsbasic>`_.


Race/Ethnicity variables in the EPI CPS extracts
===============================================================================
There are several harmoinzed variables that categorize race/ethnicity in the EPI CPS extracts. 
In general, race categories are mutually exlusive with :doc:`Hispanic <variables/weights/hispanic>` ethnicity.

.. csv-table::
    :header: "Variable name", "Categories", "Availability" 
    :widths: 10, 20, 10

    :doc:`wbho <variables/weights/wbho>`, "white, black, Hispanic, other", "All years"
    :doc:`wbhao <variables/weights/wbhao>`, "white, black, Hispanic, asian, other", "1989 - present"
    :doc:`wbhom <variables/weights/wbhom>`, "white, black, Hispanic, other, multiple", "2003 - present"
    :doc:`wbhaom <variables/weights/wbhaom>`, "white, black, Hispanic, asian, native american, multiple", "2003 - present"
    :doc:`wbho_only <variables/weights/wbho_only>`, "white only, black only, Hispanic, other", "All years"
    :doc:`wbo_only <variables/weights/wbo_only>`, "white/Hispanic, black/Hispanic, other", "All years"



A mininimally recoded variable named :doc:`raceorig <variables/weights/raceorig>` is also
included in the extracts. This variable preserves the detailed race information available 
in the full CPS, but is not consistant over time.
