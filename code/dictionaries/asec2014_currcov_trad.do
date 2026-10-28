/*------------------------------------------------
  by Jean Roth Wed Sep 30 17:36:30 EDT 2015
  Please report errors to jroth@nber.org
  NOTE:  This program is distributed under the GNU GPL.
  See end of this file and http://www.gnu.org/licenses/ for details.
  Run with do cpsmar2015
----------------------------------------------- */

local dat_name "`1'"
local dct_name "`2'"

quietly infile using "`dct_name'", using("`dat_name'") clear

/*------------------------------------------------

  All items, except those with one character, also can have values
  of -1, -2, or -3 even if the values are not in the documentation
  The meaning is
       -1 .Blank or not in universe
       -2 .Don't know
       -3 .Refused

  The following changes in variable names have been made, if necessary:
      '$' to 'd';            '-' to '_';              '%' to 'p';
      ($ = unedited data;     - = edited data;         % = allocated data)

  Decimal places have been made explict in the dictionary file.
  Stata resolves a missing value of -1 / # of decimal places as a missing value.

  Variable names in Stata are case-sensitive

 -----------------------------------------------*/

note ppposold: U All

#delimit ;

;
label values now_anycov   now_anycov;
label define now_anycov
	1           "Covered/insured"
	2           "Not covered/insured"
;

#delimit cr

