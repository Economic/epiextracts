*************************************************************************
* NAME: valuelabel2csv
* DESC: converts value label definitions to csv file
* used in documentation making programs
*************************************************************************
capture program drop valuelabel2csv
program define valuelabel2csv
syntax using, [VARiable(varname) label(string) replace]

if "`variable'" != "" & "`label'" != "" {
	di "specify either varname() or valname(), but not both"
	exit
}

if "`variable'" != "" {
	local labelname: value label `variable'
}
else {
	local labelname `label'
}

local outputfile = subinstr("`2'",",","",1)

label save `labelname' using `outputfile', `replace'
!sed -i.bak "s/label define `labelname' //g" `outputfile'
!sed -i.bak "s/', modify//g" `outputfile'
!sed -i.bak 's/\`//g' `outputfile'
!sed -i.bak 's/ "/,"/' `outputfile'
erase `outputfile'.bak
type `outputfile'

end
