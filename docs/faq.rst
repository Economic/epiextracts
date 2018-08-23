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
