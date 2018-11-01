===============================================================================
How to use the EPI extracts
===============================================================================
.. tip::

	**EPI users:** the extracts are already on maynard and epi06. See :doc:`here <epiuse>` for instructions. You don't need to download the data.

1. Download the data
===============================================================================
|release| of the EPI CPS extracts is available to download :doc:`here <index>`.

2. Unzip and move the files
===============================================================================
The zip file you downloaded is actually a collection of zipped Stata data files, one file for each year. You should move those annual zip files into an appropriate directory on your computer.

3. Use the data with your favorite statistical package
===============================================================================

Stata
-------------------------------------------------------------------------------
Feel free to just use the datasets just as you would any Stata dataset!

.. code::

	unzipfile "/data/cps/epi_cpsbasic_2017.dta.zip", replace
	use epi_cpsbasic_2017.dta, clear

Alternatively, the Stata command :code:`append_extracts` is an easy way to load a selection of years and variables of the EPI CPS extracts into memory. First, install the Stata package with

.. code::

	net install append_extracts, from("https://microdata.epi.org/stata")

and then use it like

.. code::

		* Load all of the 2016-2017 EPI CPS Basic monthly extracts
		append_extracts, begin(2016m1) end(2017m12) sample(basic) sourcedir("/data/cps")

		* Load certain variables from the 1990m7-2018m6 EPI CPS ORG
		append_extracts, begin(1990m7) end(2018m6) keep(age lfstat union) sample(org) sourcedir("/data/cps")

After installing the command see :code:`help append_extracts` for more details.

R
-------------------------------------------------------------------------------
Use the :code:`read_dta()` function from R's haven package:

.. code-block:: R

	mydata = haven::read_dta(unzip("/data/cps/epi_cpsbasic_2017.dta.zip"))


4. Cite the data
===============================================================================
If you use the EPI extracts for your research, please cite the data in your references:

.. note::
	Economic Policy Institute. |year|. Current Population Survey Extracts, |release|.
