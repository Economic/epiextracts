=======
Sources
=======
If you use the EPI extracts for your research, you can cite them as

	Economic Policy Institute. 2018. Current Population Survey Extracts, |release|.

The EPI code is available on
`github <https://github.com/Economic/epiextracts_basicorg>`_
(currently a private repository). It draws heavily from other sources of code
and raw data.

Other code incorporated into the EPI extracts
=============================================
* `EPI <https://www.epi.org/data/>`_:
  data library code	that processes raw CPS data, creates uniform extracts, and analyzes data
* `CEPR <http://ceprdata.org/cps-uniform-data-extracts/cps-basic-programs/cps-basic-monthly-programs/>`_:
  scripts for processing raw data and uniform coding of several variables
* `NBER <http://www.nber.org/data/cps_basic_progs.html>`_:
  scripts for transforming BLS/Census flat files into Stata data

Raw data underlying the EPI extracts
====================================

CPS Basic Monthly, 1976 - Present
---------------------------------

+----------------+--------------------+
| Years          | Data source        |
+================+====================+
| 1976 - 1993    | Unicon CPS Basic   |
+----------------+--------------------+
| 1994 - Present | Census/BLS monthly |
+----------------+--------------------+


CPS ORG/May 1973-Present
---------------------------------

+----------------+--------------------+
| Years          | Data source        |
+================+====================+
| 1973 - 1978    | Unicon CPS May     |
+----------------+--------------------+
| 1979 - 1983    | Unicon CPS ORG     |
+----------------+--------------------+
| 1984 - 1993    | Unicon CPS Basic   |
+----------------+--------------------+
| 1994 - Present | Census/BLS monthly |
+----------------+--------------------+

Documentation for source data
====================================
On maynard you can find documentation for the underlying source data as well
as the original EPI extracts:

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
