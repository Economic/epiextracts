sum year
keep if year == r(max)
gegen tag = tag(statefips)
keep if tag == 1
keep statefips tag statecensus

decode statecensus, gen(stateabb)
tostring statecensus, gen(statecensusstring)
gen labelvar = stateabb + " - " + statecensusstring

maptile tag, geo(statehex) geoid(statefips) labelhex(labelvar) ///
  twopt(graphregion(color(white)) ///
    plotregion(color(white)) ///
    legend(off))

graph export ${variableimages}statecensus_titleimage.svg, replace
