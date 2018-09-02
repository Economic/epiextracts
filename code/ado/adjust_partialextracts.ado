*************************************************************************
* NAME: adjust_partialextracts
* DESC: Make adjustments to partial year extracts
* that should use full year of data (top-code, hours imputation)
*************************************************************************
capture program drop adjust_partialextracts
program define adjust_partialextracts
syntax, begin(string) end(string)

* deal with dates
local begindate = tm(`begin')
local enddate = tm(`end')


end
