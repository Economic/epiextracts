===============================================================================
Methodology: wage variables
===============================================================================
Three key wage variables in the EPI CPS extracts contain additional imputations and restrictions to improve their usefulness: :doc:`wage <variables/income/wage>`, :doc:`wageotc <variables/income/wageotc>`, :doc:`weekpay <variables/income/weekpay>`. This section discusses these modifications.

If you'd like to use variables that don't include these adjustments, consider using :doc:`wage_noadj <variables/income/wage_noadj>`, :doc:`wageotc_noadj <variables/income/wageotc_noadj>`, :doc:`weekpay_noadj <variables/income/weekpay_noadj>`. For a shorter overview of the wage variables, see :ref:`this discussion <which-wage-variable>`.

Top-code adjustments
===============================================================================
Weekly earnings in the underlying source data are top-coded or right-censored. For the top-coded weekly earnings, the EPI extracts variable :doc:`weekpay <variables/income/weekpay>` contains the gender- and year-specfic imputed mean above the top-code assuming the earnings distribution is Pareto above the 80th percentile. For non-hourly workers, these imputed values are also incorporated in the hourly wage variables :doc:`wage <variables/income/wage>` and :doc:`wageotc <variables/income/wageotc>`.

To use a weekly earnings variable without this adjustment, consider :doc:`weekpay_noadj <variables/income/weekpay_noadj>` and the associated hourly wage variables :doc:`wage_noadj <variables/income/wage_noadj>`, :doc:`wageotc_noadj <variables/income/wageotc_noadj>`.

.. toggle-header::
	:header: Function used to impute the mean above the topcode (**show/hide code**)

	.. literalinclude:: misc/topcode_impute.ado

.. toggle-header::
	:header: Specific top-code adjustment used for weekly earnings (**show/hide code**)

	.. literalinclude:: misc/generate_weekpay.do


Hours imputations
===============================================================================
For data from 1994 to the present, respondents can report that their usual weekly "hours vary" at work. The EPI extracts contain an imputed usual weekly hours variable :doc:`hoursu1i <variables/hours/hoursu1i>` that is equal to usual hours worked at the primary job (:doc:`hoursu1 <variables/hours/hoursu1>`), except when "hours vary", in which case it is based on the following regression-based predictions.

.. toggle-header::
	:header: Demographic & industry-based usual hours prediction (**show/hide code**)

	.. literalinclude:: misc/generate_hoursu1i.do

The imputed usual weekly hours is used when calculating hourly wages for nonhourly workers in :doc:`wage <variables/income/wage>` and :doc:`wageotc <variables/income/wageotc>`. If you do not want to include these hours imputations in your wage analysis, you can simply set wage values to missing for nonhourly workers whose hours vary:

.. code::

	gen wage_nohv = wage
	replace wage_nohv = . if paidhre == 1 & hoursvary == 1


Trimming outliers
===============================================================================
The hourly wage variables :doc:`wage <variables/income/wage>` and :doc:`wageotc <variables/income/wageotc>` are trimmed of outliers.
Specifically, these hourly wage values are set to missing if they are above 50 cents per hour or $100 per hour in 1989 dollars.

For hourly wage variables that do not have this modification, see :doc:`wage_noadj <variables/income/wage_noadj>` and :doc:`wageotc_noadj <variables/income/wageotc_noadj>`.

.. toggle-header:: rubric
	:header: Hourly wage limits for wage and wageotc (**show/hide table**)

	.. csv-table::
		:header: "Year","CPI-U-RS, extended","Lower limit ($)","Upper limit ($)"
		:file: misc/extremewages.csv

	Download this :download:`table <misc/extremewages.csv>`.


BLS wage allocations
================================================================================
In recent years, a large number of observations have weekly earnings or hourly wages imputed by the BLS. If you want to use a wage variable without any weekly or hourly earnings imputations by EPI or BLS, you can incorporate the allocation flags :doc:`a_weekpay <variables/income/a_weekpay>` and :doc:`a_earnhour <variables/income/a_earnhour>`:

::

	* Stata code to restrict hourly wages to data not allocated by BLS
	* Be aware that the allocation indicators are not consistent over time.
	* In particular, there is no allocation information at all during Jan 1994 - August 1995.

	gen wage_noimpute = wage_noadj
	replace wage_noimpute = . if paidhre == 1 & a_earnhour == 1
	replace wage_noimpute = . if paidhre == 0 & a_weekpay == 1
