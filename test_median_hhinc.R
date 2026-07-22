library(tidyverse)
library(realtalk)

# set CPI base
cpi_base = c_cpi_u_extended_annual$c_cpi_u_extended[c_cpi_u_extended_annual$year == 2024]

### EPI Household income ####
epi_march <-
  epiextractr::load_cps(
    "march", 
    1984:2025, 
    year, hrhhid, hrhhid2, hhinc, hhwgt, pulineno,
    .extracts_dir = "extracts/"
  ) |>
  mutate(
    # create hhrecord, pulineno == 1 drops out in some households
    hhrecord =
      as.integer(
        pulineno == min(pulineno, na.rm = TRUE)),
    .by = c(hrhhid, hrhhid2, year),
)

# check the consistency of household income across household
hhinc_consistency <- epi_march |>
  summarize(
    n_distinct_hhinc = n_distinct(hhinc, na.rm = TRUE), 
    n_members = n(), 
    .by = c(year, hrhhid, hrhhid2)
)

# calculate median income
epi_median_hh_income <- epi_march |> 
  filter(
    hhrecord == 1, 
    hhinc < 99999999
  ) |> 
  mutate(year = year - 1) |> 
  left_join(c_cpi_u_extended_annual) |> 
  mutate(hhinc = hhinc * (cpi_base/c_cpi_u_extended)) |> 
  summarize(
    epi_hhinc = 
      MetricsWeighted::weighted_quantile(
        hhinc, 
        w = hhwgt, 
        probs = 0.5, 
        na.rm = TRUE), 
    .by = year
  )

### IPUMS Household income ####
ipums_march <- haven::read_dta("./cps_00078.dta") 

# calculate median household income
ipums_median_hh_income <- ipums_march |>
  filter(
    pernum == 1,
    hhincome < 99999999
  ) |>
  mutate(year = year - 1) |> 
  left_join(c_cpi_u_extended_annual) |>
  mutate(hhincome = hhincome * (cpi_base/c_cpi_u_extended)) |>
  summarize(
    ipums_hhinc = 
      MetricsWeighted::weighted_quantile(
        hhincome, 
        w = asecwth,
        probs = 0.5,
        na.rm = TRUE
      ), 
    .by = year
  )

### Census benchmark ####
census_benchmark <- read.csv("./census_benchmark.csv")

### Final benchmark table ####
benchmark <- inner_join(epi_median_hh_income, ipums_median_hh_income) |> 
  inner_join(census_benchmark) 

# plot benchmark
ggplot(
  pivot_longer(benchmark, cols = -year, names_to = "source", values_to = "hhinc"), 
  aes(x = year, y = hhinc, color = source)
) +
  geom_line() +
  geom_point() +
  labs(x = "Income year", y = "Real median household income", title = "EPI vs. Census median household income")
