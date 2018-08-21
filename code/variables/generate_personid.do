********************************************************************************
* Consistent person id
********************************************************************************
* use pulineno & recnum?
* use already existing hrhhid hrsersuf huhhnum pulineno to uniquely id persons
* for 1994m1-2004m4:
*		duplicates report gestcen hrhhid hrsample hrsersuf huhhnum pulineno
*		assert r(unique_value) == r(N)
* for 1994m1-2004m4:
* 	duplicates report hrhhid hrhhid2 pulineno
*		assert r(unique_value) == r(N)
