*************************************************************************
* NAME: valuelabel2md
* DESC: converts value label definitions to md file
* used in documentation making programs
*************************************************************************
capture program drop valuelabel2md
program define valuelabel2md
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
!sed -i.bak 's/ "/|"/' `outputfile'
!sed -i.bak 's/"//g' `outputfile'
!sed -i.bak '1 i\-----|-----' `outputfile'
!sed -i.bak '1 i\Value|Label' `outputfile'
erase `outputfile'.bak
type `outputfile'

end
