webdoc init ${variablelongdesc}statefips_longdesc, replace
* some webdoc options to deal with formatting
webdoc set stlog
webdoc set _stlog

sum year
keep if year == r(max)
gegen tag = tag(statefips)
keep if tag == 1
keep statefips tag

decode statefips, gen(stateabb)
tostring statefips, gen(statefipsstring)
gen labelvar = stateabb + " - " + statefipsstring

maptile tag, geo(statehex) geoid(statefips) labelhex(labelvar) ///
  twopt(graphregion(color("252 252 252")) ///
    plotregion(color("252 252 252")) ///
    legend(off))

graph export ${variableimages}statefips_titleimage.svg, replace
