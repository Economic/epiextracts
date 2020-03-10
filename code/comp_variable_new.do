set more off

load_epiextracts, begin(1979m1) end(2018m12) sample(basic) keep(year wbho basicwgt)

tab year wbho [aw=basicwgt], row nofreq