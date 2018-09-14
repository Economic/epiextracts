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

.. toggle-header::
	:header: Hourly wage limits (**show/hide table**)

	.. csv-table::
		:header: "Year","CPI-U-RS, extended","Lower limit ($)","Upper limit ($)"
		:file: misc/extremewages.csv


BLS allocations
===============================================================================
