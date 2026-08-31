library(tidyverse)
library(epiextractr)
library(epidatatools)

epi_raw <- load_cps("march", 2002:2025, .extracts_dir = "extracts/")

walk(
  .x = 1992:1994,
  .f = 
    ~ {
    haven::read_dta(paste0("extracts/epi_cpsmarch_", .x, ".dta")) |> 
    arrow::write_feather(paste0("extracts/epi_cpsmarch_", .x, ".feather"))
  }
)

hicovly <- load_cps("march", 1988:1994, year, hicovlyi, hicovly, asecwgt, age, .extracts_dir = "extracts/") |> 
   mutate(year = year - 1) |>
   crosstab(year, hicovly, w = asecwgt)

epi_raw <- load_cps("march", 2017, .extracts_dir = "extracts/")

crosstab(epi_raw, hiemp, w = asecwgt)
crosstab(epi_raw, hi, w = asecwgt)

crosstab(epi_raw, cov_hi, w = asecwgt)

epi_raw  |> 
  mutate(dummy = 
    case_when(
      priv == 1 ~ 1, 
      depriv == 1 ~ 1,
      othstyp1 %in% c(12:13) ~ 1,
      othstyp2 %in% c(12:13) ~ 1,
      othstyp3 %in% c(12:13) ~ 1,
      othstyp4 %in% c(12:13) ~ 1,
      othstyp5 %in% c(12:13) ~ 1,
      othstyp6 %in% c(12:13) ~ 1,
      cov_hi == 1 ~ 1 
    )
)  |> 
  crosstab(dummy, hi_yn, w = asecwgt)

epi_raw  |> 
  mutate(dummy = case_when(mcare == 1 ~ 1, mcaid == 1 ~ 1, oth == 1 ~ 1))  |> 
  crosstab(dummy, w = asecwgt)

crosstab(epi_raw, mcaid, w = asecwgt)
crosstab(epi_raw, mcare, w = asecwgt)
crosstab(epi_raw, oth, w = asecwgt)

crosstab(epi_raw, mcaid, hi_yn, w = asecwgt)
crosstab(epi_raw, mcare, hi_yn, w = asecwgt)
crosstab(epi_raw, mcaid, mcare, w = asecwgt)

epi_raw  |> 
  mutate(dummy = case_when(mcaid == 1 ~ 1, othstper == 1 ~ 1))  |> 
  crosstab(dummy, w = asecwgt)

crosstab(epi_raw, othstper, w = asecwgt)

epi_raw <- load_cps("march", 2017, .extracts_dir = "extracts/")

hicovly <- epi_raw |> 
  mutate(year = year - 1) |> 
  crosstab(year, hicovly, w = asecwgt, percent = "row")

hicovly <- 
  map( 
    .x = 1995:1996,
    ~ {
      load_cps("march", .x, .extracts_dir = "extracts/") |> 
      mutate(year = year - 1) |> 
      crosstab(year, hicovly, w = asecwgt)
    }
  ) |> bind_rows() |> mutate(total = Covered + `Not covered`)

# 2017 (data year == 2018)
# > 292320000-261409152
# [1] 30910848
# > 58962845-30910848
# [1] 28051997

epi <- epi_raw |> 
  filter(
    age %in% c(18:64), !is.na(age),
    earn > 0, !is.na(earn)
  ) |> 
  mutate(year = year - 1)

hiownemply_wa <- 
  crosstab(
    filter(
      epi
    ), 
    year, 
    hiownpaidly, 
    w = asecwgt, 
    percent = "row"
)

hiownemply_saw <- 
  crosstab(
    filter(
      epi,
      cowly == 1,
      hoursly >= 20,
      wksly_binned >= 3 
    ),
    year,
    hiownpaidly,
    w = asecwgt,
    percent = "row" 
  )


walk(
  2000:2010,
  ~ {
    haven::read_sas(paste0("/data/cps/march/census/raw/hlthins_sy", .x, "_rev.sas7bdat")) |> 
    haven::write_dta(paste0("/data/cps/march/census/raw/hlthins_sy", .x, "_rev.dta"))
  }
)


