*************************************************************************
* NAME: keepifexist
* DESC: a "keep" function that still executes when some variables
* specified don't actually exist
*************************************************************************
* program to keep variables if they exist
capture program drop keepifexist
program define keepifexist, rclass
syntax anything
local keeplist ""
foreach x in `anything' {
        capture unab y: `x'
        if _rc == 0 {
                foreach z of varlist `y' {
                        local keeplist `keeplist' `z'
                }
        }
        else local keeplist `keeplist'
}

if "`keeplist'" == "" {
	noi di "Warning: none of those variables existed. All variables dropped."
	error 1
}
else {
        di "Keeping `keeplist'"
        keep `keeplist'
}
return local keeplist "`keeplist'"
end
