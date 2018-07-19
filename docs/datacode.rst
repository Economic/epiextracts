===============================================================================
Latest data & code
===============================================================================
|release| of the EPI CPS extracts is on maynard:

+-------------------------+---------------------------------------------------+
| Dataset                 | Location                                          |
+=========================+===================================================+
| CPS-Basic, 1976-present | :file:`/data/cps/basic/epiextracts/`              |
+-------------------------+---------------------------------------------------+
| CPS-ORG, 1979-present   | :file:`/data/cps/org/epiextracts/`                |
+-------------------------+---------------------------------------------------+
| CPS-May, 1973-1981      | :file:`/data/cps/may/epiextracts/`                |
+-------------------------+---------------------------------------------------+

The code that produces these extracts is available at `Github <https://github.com/Economic/epiextracts_basicorg/>`_.

See the :ref:`changelog` for the latest updates to the data.

Which version of the data am I using?
===============================================================================
To determine which version of the data you have, use Stata to load any of the datasets into memory and then use the :code:`describe` or :code:`notes` commands:

::

	describe, short
	notes _dta
