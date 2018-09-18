===============================================================================
Methodology: wage variables
===============================================================================


Top-code adjustments
===============================================================================
Coming soon!

.. toggle-header::
	:header: function to impute mean above the topcode (**show/hide code**)

	.. literalinclude:: misc/topcode_impute.ado

.. toggle-header::
	:header: specific adjustment for weekly earnings (**show/hide code**)

	.. literalinclude:: misc/generate_weekpay.do


Hours imputations
===============================================================================
Coming soon!

.. toggle-header::
	:header: demographic & industry-based usual hours prediction (**show/hide code**)

	.. literalinclude:: misc/generate_hoursu1i.do

If you do not want to include these imputations,
you can simply set wage values to missing for nonhourly workers whose hours vary:

.. code::

	gen wage_nohv = wage
	replace wage_nohv = . if paidhre == 1 & hoursvary == 1


Trimming outliers
===============================================================================
The hourly wage variables :doc:`wage <variables/income/wage>` and :doc:`wageotc <variables/income/wageotc>` are trimmed of outliers.
Specifically, these hourly wage values are set to missing if they are above 50 cents per hour or $100 per hour in 1989 dollars.

For hourly wage variables that do not have this modification, see :doc:`wage_noadj <variables/income/wage_noadj>` and :doc:`wageotc_noadj <variables/income/wageotc_noadj>`

.. toggle-header:: rubric
	:header: Hourly wage limits for wage and wageotc (**show/hide table**)

	.. csv-table::
		:header: "Year","CPI-U-RS, extended","Lower limit ($)","Upper limit ($)"
		:file: misc/extremewages.csv

	Download this :download:`table <misc/extremewages.csv>`.


BLS allocations
================================================================================
Coming soon!

If you want to use a wage variable without any weekly or hourly earnings imputations by EPI or BLS,
you can incorporate the allocation flags :doc:`a_weekpay <variables/income/a_weekpay>` and :doc:`a_earnhour <variables/income/a_earnhour>`:

::

	* Stata code to restrict hourly wages to data not allocated by BLS
	* Be aware that the allocation indicators are not consistent over time.
	* In particular, there is no allocation information at all during Jan 1994 - August 1995.

	gen wage_noimpute = wage_noadj
	replace wage_noimpute = . if paidhre == 1 & a_earnhour == 1
	replace wage_noimpute = . if paidhre == 0 & a_weekpay == 1
