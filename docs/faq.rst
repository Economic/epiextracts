===============================================================================
Frequently asked questions
===============================================================================

Which version of the data am I using?
===============================================================================
To determine which version of the data you have,
use Stata to load any of the datasets into memory
and then use the :code:`describe` or :code:`notes` commands. Or you save this information in a local macro using Stata's :code:`_dta[note1]` characteristic.

Alternatively, R's haven package allows you to read the data and access the data notes.

.. toggle-header::
	:header: Access the data version in Stata (**show/hide code**)

	::

		use epi_cpsorg_2017.dta, clear

		* describe the data
		describe, short

		* list the data notes
		notes _dta

		* save the data notes in a local macro
		local dataversion: char _dta[note1]
		di "`dataversion'"


.. toggle-header::
	:header: Access the data version in R (**show/hide code**)

	.. code-block:: R

		library(haven)
		mydata <- read_dta("epi_cpsorg_2017.dta")
		dataversion <- attr(mydata,"label")


What sample restrictions are used in the EPI extracts?
===============================================================================
The EPI CPS Basic monthly and May extracts are restricted to those with non-missing, positive ages. The EPI CPS ORG extracts are restricted to those ages 16 and above with a positive earner sample weight (:doc:`orgwgt <variables/weights/orgwgt>`) and in the outgoing rotation months (:doc:`minsamp <variables/id/minsamp>`).

As a result the sample of individuals in the EPI extracts is sometimes smaller than what is in the raw, underlying CPS data, which can include nonresponding households and, in the case of the underlying ORG data, individuals below the age of 16.

.. toggle-header::
	:header: Basic/May sample restriction (**show/hide code**)

	.. literalinclude:: misc/sample_cpsbasic.do


.. toggle-header::
	:header: ORG sample restriction (**show/hide code**)

	.. literalinclude:: misc/sample_cpsorg.do


Which sample weight variable should I use?
==============================================================================
There are four sample weights available in the CPS extracts:

.. csv-table::
	:header: " ", "basicwgt", "cmpwgt", "finalwgt", "orgwgt"
	:widths: 20, 10, 10, 10, 10

	"Years available", "All years", "1998 - present", "All years", "1979 - present"
	"Samples available", "All", "Basic/ORG", "All", "ORG"
	"Sample restrictions", "Ages 16+", "Ages 16+", "None", "Earner study"

While there is not always a single correct answer regarding which weight you should use, here are some helpful guidelines:

	* For many outcomes in the CPS Basic or May data, use :doc:`basicwgt <variables/weights/basicwgt>` to analyze the population ages 16 and over.
	* If your analysis involves the ORG data, such as earnings information, use :doc:`orgwgt <variables/weights/orgwgt>`.
	* :doc:`finalwgt <variables/weights/finalwgt>` is the only weight defined for individuals under the age of 16.


Which wage variable should I use?
==============================================================================
There are several hourly wage variables in the EPI CPS extracts, but for many purposes we recommend using :doc:`wage <variables/income/wage>` or :doc:`wageotc <variables/income/wageotc>`.

:doc:`wageotc <variables/income/wageotc>` includes overtime, tips, and commissions (OTC) for hourly workers, but is only available for 1994-present. :doc:`wage <variables/income/wage>` is available for all years, but does not include OTC payments for hourly workers.

Both :doc:`wage <variables/income/wage>` and :doc:`wageotc <variables/income/wageotc>` include several adjustments by EPI to improve the quality of the data: top-code imputations, hours imputations, and the trimming of outliers (see the :doc:`wage methodology <wagemethodology>` for more details). However, for convenience there are variables that exclude these adjustments, as described in the table below:

.. csv-table::
	:header: " ", "wage", "wageotc", "wage_noadj", "wageotc_noadj"
	:widths: 20, 10, 10, 10, 10

	"Availability", "All years", "1994 - present", "All years", "1994 - present"
	"OTC for hourly workers", "No", "Yes", "No", "Yes"
	"Top-code imputations", "Yes", "Yes", "No", "No"
	"Hours vary imputations", "Yes", "Yes", "No", "No"
	"Trimming", "Yes", "Yes", "No", "No"
	"BLS imputations", "Yes", "Yes", "Yes", "Yes"

Additionally, if you want to use a wage variable without any weekly or hourly earnings imputations by EPI or BLS, you can incorporate the allocation flags :doc:`a_weekpay <variables/income/a_weekpay>` and :doc:`a_earnhour <variables/income/a_earnhour>`. For example, here is Stata code to exclude EPI and BLS imputations:

::

	* Stata code to restrict hourly wages to data not allocated by BLS
	* Be aware that the allocation indicators are not consistent over time.
	* In particular, there is no allocation information at all during Jan 1994 - August 1995.

	gen wage_noimpute = wage_noadj
	replace wage_noimpute = . if paidhre == 1 & a_earnhour == 1
	replace wage_noimpute = . if paidhre == 0 & a_weekpay == 1


.. _merging-to-other-data:

How do I merge the EPI CPS extracts to other sources of CPS extracts?
==============================================================================
For years 1984-present, the following variables uniquely identify observations
in the EPI CPS extracts:

::

	year month statefips hrhhid hrhhid2 hrsersuf hrsample huhhnum pulineno

These variables are present in the raw data available from
`Census <https://thedataweb.rm.census.gov/ftp/cps_ftp.html>`_,
`NBER <http://www.nber.org/data/cps_basic.html>`_, or
`IPUMS <https://cps.ipums.org/cps/>`_.

For years prior to 1994, EPI CPS extracts are based on Unicon source data.
For these years the EPI variable
:doc:`unicon_recnum <variables/id/unicon_recnum>`
uniquely identifies observations and will match to Unicon's recnum variable.
