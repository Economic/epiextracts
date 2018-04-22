* utility programs

* Identify which basic monthly files to convert to Stata
capture program drop processrawbasic
program define processrawbasic
syntax, begin(string) end(string)

local begindate = tm(`begin')
local enddate = tm(`end')

if `begindate' < tm(1976m1) {
  di "No data prior to 1976"
  exit
}

if `begindate' > `enddate' {
  di "Begin date must be prior to end date"
  exit
}

* use Unicon extracts for 1976-1988
if `begindate' >= tm(1976m1) & `begindate' <= tm(1988m12) {
  if `enddate' <= tm(1988m12) local tempenddate = `endate'
  else local tempenddate = tm(1988m12)
  foreach date of numlist `begindate'/`tempenddate' {
    di "Unicon " %tm `date' " ... already converted to Stata"
  }
}

* use Census data and NBER dictionaries for 1989+
if `begindate' >= tm(1989m1) | `enddate' >= tm(1989m1) {
  if `begindate' >= tm(1989m1) local tempbegindate = `begindate'
  else local tempbegindate = tm(1989m1)
  foreach date of numlist `tempbegindate'/`enddate' {
    di "Census CPS " %tm `date' " ... converting to Stata"
    * processcensusbasic(`date')
  }
}

end



* use raw Census data and NBER dictionaries for 1989+
capture program drop processcensusbasic
program define processcensusbasic

end
