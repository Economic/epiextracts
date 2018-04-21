* utility programs

capture program drop processrawdata
program define processrawdata
syntax, begin(string) end(string)

di "`begin' begin date"
di "`end' end date"

end
