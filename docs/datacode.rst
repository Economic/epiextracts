===============================================================================
Latest data & code
===============================================================================

Where are the data & code?
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


How do I use the EPI extracts?
===============================================================================
Feel free to just use the datasets in the above directories just as you would
any data! Alternatively, if you're on maynard using Stata, we have written some
helpful functions to access the EPI extracts.

If you simply want to load certain years or variables of the EPI CPS extracts into memory, try the Stata command :code:`append_extracts`:

.. code::

		* Load all of the 2016-2017 EPI CPS Basic monthly extracts
		append_extracts, begin(2016m1) end(2017m12) sample(basic)

		* Load certain variables from the 1990m7-2018m6 EPI CPS ORG
		append_extracts, begin(1990m7) end(2018m6) sample(org) keeponly(age lfstat union)


If you'd like to investigate certain variables in the raw CPS data and merge them to
the EPI extracts, try the command :code:`merge_rawextracts`:

.. code::

	merge_rawextracts, begin(1994m1) end(1995m12) sample(org) keepvarraw(peernlab) keepvarextracts(age selfemp lfstat orgwgt)


See :code:`help append_extracts` or :code:`help merge_rawextracts` for more details.
