==============================================================================
Citations & sources
==============================================================================
If you use the EPI extracts for your research, please cite the data in your references:

.. note::
	Economic Policy Institute. |year|. Current Population Survey Extracts, |release|.

Underlying code
==============================================================================
The code that creates the EPI extracts and documentation is available on
`Github <https://github.com/Economic/epiextracts_basicorg>`_. The current code draws heavily from other sources:

* `EPI <https://www.epi.org/data/>`_:
  data library code	that processes raw CPS data, creates uniform extracts, and analyzes data
* `CEPR <http://ceprdata.org/cps-uniform-data-extracts/cps-basic-programs/cps-basic-monthly-programs/>`_:
  scripts for processing raw data and uniform coding of several variables
* `NBER <http://www.nber.org/data/cps_basic_progs.html>`_:
  scripts for transforming BLS/Census flat files into Stata data

Raw data underlying the EPI extracts
====================================

+-------------------------+----------------+--------------------+
| Dataset                 | Years          | Source             |
+=========================+================+====================+
| EPI CPS Basic Monthly   | 1976 - 1993    | Unicon CPS Basic   |
+-------------------------+----------------+--------------------+
| EPI CPS Basic Monthly   | 1994 - Present | Census/BLS monthly |
+-------------------------+----------------+--------------------+
| EPI CPS ORG             | 1979 - 1983    | Unicon CPS ORG     |
+-------------------------+----------------+--------------------+
| EPI CPS ORG             | 1984 - 1993    | Unicon CPS Basic   |
+-------------------------+----------------+--------------------+
| EPI CPS ORG             | 1994 - Present | Census/BLS monthly |
+-------------------------+----------------+--------------------+
| EPI CPS May             | 1973 - 1981    | Unicon CPS May     |
+-------------------------+----------------+--------------------+


Documentation for source data
===============================================================================
On maynard you can find documentation for the underlying source data and the original EPI extracts:

+-------------------------+---------------------------------------------------------+
| Source data             | Documentation                                           |
+=========================+=========================================================+
| Original EPI CPS Basic  | :file:`/data/cps/basic/epi/raw/codebooks/`              |
+-------------------------+---------------------------------------------------------+
| Original EPI CPS ORG    | :file:`/data/cps/org/epi/raw/codebooks/`                |
+-------------------------+---------------------------------------------------------+
| Unicon CPS Basic        | :file:`/data/cps/basic/unicon/codebooks/`               |
+-------------------------+---------------------------------------------------------+
| Unicon CPS ORG          | :file:`/data/cps/org/unicon/codebooks/`                 |
+-------------------------+---------------------------------------------------------+
| Unicon CPS May          | :file:`/data/cps/may/unicon/codebooks/`                 |
+-------------------------+---------------------------------------------------------+
