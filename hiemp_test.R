library(tidyverse)
library(epidatatools)

ipums <- haven::read_dta("cps_00069.dta")

ipums |> 
  filter(year == 2024) |> 
  mutate(
    anycovnw = as.numeric(haven::as_factor(anycovnw)),
    dummy = 
      case_when(
        anycovnw == 1 ~ "Covered", 
        anycovnw == 2 ~ "Not covered")) |> 
  crosstab(dummy)

ipums |> 
  filter(year == 2017) |> 
  mutate(
    test = as.character(haven::as_factor(covergh))) |> 
  crosstab(test)

ipums |> 
  filter(year == 2024) |> 
  mutate(
    phinsur = as.numeric(haven::as_factor(phinsur)),
    dummy = 
      case_when(
        phinsur == 1 ~ NA, 
        phinsur == 2 ~ "Not covered",
        phinsur == 3 ~ "Covered")) |> 
  crosstab(dummy, w = asecwt)

ipums |> 
  filter(year == 2024) |> 
  mutate(
    grpcovly = as.numeric(haven::as_factor(grpcovly)),
    dummy = 
      case_when(
        grpcovly == 1 ~ NA, 
        grpcovly == 2 ~ "No",
        grpcovly == 3 ~ "Yes")) |> 
  crosstab(dummy, w = asecwt)

ipums |> 
  filter(year == 2017) |> 
  mutate(
    covergh = as.numeric(haven::as_factor(covergh)),
    dummy = 
      case_when(
        covergh == 2 ~ "Yes", 
        covergh == 1 ~ "No")) |> 
  crosstab(dummy, w = asecwt)
