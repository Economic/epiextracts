sum year
keep if year == r(max)
gegen tag = tag(statefips)
keep if tag == 1
keep statefips tag

decode statefips, gen(stateabb)
tostring statefips, gen(statefipsstring)
gen labelvar = stateabb + " - " + statefipsstring

maptile tag, geo(statehex) geoid(statefips) labelhex(labelvar) ///
  twopt(graphregion(color(white)) ///
    plotregion(color(white)) ///
    legend(off))

graph export ${variableimages}statefips_titleimage.svg, replace
