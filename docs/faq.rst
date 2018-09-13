===============================================================================
Frequently asked questions
===============================================================================

Which version of the data am I using?
===============================================================================
To determine which version of the data you have,
use Stata to load any of the datasets into memory
and then use the :code:`describe` or :code:`notes` commands:

::

	describe, short
	notes _dta

If you want to refer to the version information in a log file or other
output you can use Stata's data note local macro :code:`_dta[note1]`.


What sample restrictions are used in the EPI extracts?
===============================================================================
The EPI CPS Basic monthly and May extracts are restricted to those with non-missing, positive ages. The EPI CPS ORG extracts are restricted to those ages 16 and above with a positive earner sample weight (:doc:`orgwgt <variables/weights/orgwgt>`) and in the outgoing rotation months (:doc:`minsamp <variables/id/minsamp>`).

.. toggle-header::
	:header: Basic/May sample restriction (**show/hide code**)

	.. literalinclude:: misc/sample_cpsbasic.do


.. toggle-header::
	:header: ORG sample restriction (**show/hide code**)

	.. literalinclude:: misc/sample_cpsorg.do

As a result the sample of individuals in the EPI extracts is sometimes smaller than what is in the raw, underlying CPS data, which can include nonresponding households and, in the case of the underlying ORG data, individuals below the age of 16.

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


Which sample weight variable should I use?
==============================================================================
Coming soon!


Which wage variable should I use?
==============================================================================
Coming soon!


How do you adjust the wage variables for top-coding?
==============================================================================
Coming soon!

.. toggle-header::
	:header: function to impute mean above the topcode (**show/hide code**)

	.. literalinclude:: misc/topcode_impute.ado

.. toggle-header::
	:header: specific adjustment for weekly earnings (**show/hide code**)

	.. literalinclude:: misc/generate_weekpay.do

How do you trim the hourly wage variables?
==============================================================================
The hourly wage variables :doc:`wage <variables/income/wage>` and :doc:`wageotc <variables/income/wageotc>` are trimmed of outliers.
Specifically, these hourly wage values are set to missing if they are above 50 cents per hour or $100 per hour in 1989 dollars.

For hourly wage variables that do not have this modification, see :doc:`wage_noadj <variables/income/wage_noadj>` and :doc:`wageotc_noadj <variables/income/wageotc_noadj>`

.. toggle-header::
	:header: Hourly wage limits (**show/hide table**)

	.. csv-table::
		:header: "Year","CPI-U-RS, extended","Lower limit ($)","Upper limit ($)"
		:file: misc/extremewages.csv
