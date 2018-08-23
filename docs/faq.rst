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

If you want to include the version information concisely in a log file or other
output you can refer to the data note local macro :code:`_dta[note1]`.
