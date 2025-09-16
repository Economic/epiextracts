library(tidyverse)
library(epiextractr)
library(epidatatools)

epi_basic <- load_basic(1979:2024, year, basicwgt, mind16, mocc10)

### MIND/MOCC ####
march_mind16 <- crosstab(epi_march, year, mind16, percent = "row", w = asecwgt) |> filter(year >= 1979) |> 
  sheets_fun(wb, s = "march_mind16")
basic_mind16 <- crosstab(epi_basic, year, mind16, percent = "row", w = basicwgt) |> 
  sheets_fun(wb, s = "basic_mind16")
comp_mind16 <- march_mind16 - basic_mind16 

march_mocc10 <- crosstab(epi_march, year, mocc10, percent = "row", w = asecwgt) |> filter(year >= 1979) |> 
  sheets_fun(wb, s = "march_mocc10")
basic_mocc10 <- crosstab(epi_basic, year, mocc10, percent = "row", w = basicwgt) |> 
  sheets_fun(wb, s = "basic_mocc10")
comp_mocc10 <- march_mocc10 - basic_mocc10 

saveWorkbook(wb, file = "./mind16_mocc10.xlsx", overwrite = TRUE)