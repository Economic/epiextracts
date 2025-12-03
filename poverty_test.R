library(tidyverse)
library(haven)
library(epiextractr)
library(epidatatools)


### DATA SOURCE ####
ipums_march <- arrow::read_feather("cps_00063.feather") %>% 
  mutate(i_educ = case_when(
           educ %in% c(73,72) ~ "High school",
           educ %in% c(0, 1, 999) ~ NA,
           educ %in% c(2:71) ~ "Less than high school",
           educ %in% c(80:92) ~  "Some college",
           educ %in% c(100:111) ~ "College",
           educ %in% c(120:125) ~ "Advanced"),
         i_uhrsworkly = case_when(
           uhrsworkly == 999 ~ NA,
           TRUE ~ uhrsworkly),
          offtotval = case_when(offtotval == 9999999999 ~ NA, TRUE ~ offtotval),
          offcutoff = case_when(offcutoff == 999999 ~ NA, TRUE ~ offcutoff),
          ftotval = case_when(ftotval == 9999999999 ~ NA, TRUE ~ ftotval),
          incwage = case_when(incwage == 9999999999 ~ NA,
                              incwage == 9999999998 ~ NA, 
                              TRUE ~ incwage),
          ctccrd = case_when(ctccrd == 999999 ~ NA, TRUE ~ ctccrd))

# check how offtotval is being assigned
#note: documentation says it should be ftotval (prim) + ftotval (rsub), 
#      but it's actually just the max(ftotval(prim))
filter(ipums_march, year == 2018) |> 
  # identify presence of related subfamilies within household
  mutate(hh_has_rel = any(ftype == 3), .by = hrhhid) |>
  # list households with related subfamilies incomes + compare
  filter(hh_has_rel == TRUE) |> select(ftype, hrhhid, offtotval, ftotval, year)

# create summary table to benchmark EPI microdata
summarize(ipums_march |> filter(between(year, 2000, 2018)), 
                    obs = sum(!is.na(offtotval)), 
                    mean = mean(offtotval, na.rm = TRUE), 
                    std_dev = sd(offtotval, na.rm = TRUE), 
                    min = min(offtotval, na.rm = TRUE), 
                    max = max(offtotval, na.rm = TRUE), 
                    .by = year)


# figure out how to assign offtotval to epi microdata
#note: some ftotval == offtotval DO have related subfamily, so ftotval already adjusted
ftotval_adj <- filter(ipums_march, year == 2018) |> mutate(dummy = case_when(offpovuniv == 0 ~ NA,
                                                               ftotval == offtotval ~ "Not related subfamily",
                                                               ftotval != offtotval ~ "Related subfamily")) |> 
  # any related subfamily that has dummy value already has income adjusted in ftotval
   filter(dummy == "Not related subfamily", ftype == 3) |> select(ftype, hrhhid, offtotval, ftotval, everything())


# figure out the rest of the misaligned related subfamily observations
filter(ipums_march, year == 2018) |> mutate(dummy = case_when(offpovuniv == 0 ~ NA,
                                                               # related subfamily with ftotval already adjusted
                                                               ftype == 3 & ftotval == max(offtotval) ~ "Adjusted already",
                                                               TRUE ~ "Not adjusted"), .by = hrhhid) |> 
   crosstab(dummy, ftype)

filter(ipums_march, year == 2018) |> mutate(dummy = case_when(offpovuniv == 0 ~ NA,
                                                               # related subfamily with ftotval already adjusted
                                                               ftotval == max(offtotval) ~ "Adjusted already",
                                                               TRUE ~ "Not adjusted"), .by = hrhhid) |> 
   crosstab(dummy, ftype)

filter(ipums_march, year == 2018) |> mutate(dummy = case_when(offpovuniv == 0 ~ NA,
                                                              # some subfamilies aren't being assigned properly in IPUMS
                                                              max(ftype) == 3 & offtotval != max(offtotval) ~ "Related subfamily, but not getting picked up",
                                                              TRUE ~ "Everyone else"), .by = hrhhid) |> 
    crosstab(dummy, ftype)

# more robust test for subfamily indicator tests
hh_has_rel <- filter(ipums_march, year == 2018) |> 
  # household maximum offtotval
  mutate(hh_max_offtotval = max(offtotval, na.rm = TRUE), .by = hrhhid) |>
  mutate(
    # presence of related subfamily
    hh_has_rel = any(ftype == 3),
    # indicate whether household w/ rsub has offtotval different than the maximum value
    dummy = case_when(
      offpovuniv == 0 ~ NA_real_,
      hh_has_rel & (offtotval != hh_max_offtotval) ~ 1,
      TRUE ~ 0),
    .by = hrhhid)

# look at specific households that fit criteria
# i.e related subfamily that has different offtotval than the max(offtotval(prim))
filter(ipums_march, hrhhid == 21650059271105, year == 2018)  |> 
  # sploc, momloc, poploc are used by IPUMS to establish subfamily
  select(famrel, ftype, offtotval, ftotval, sploc, momloc, poploc, famkind)

# look at that household by newly created subfamily indicator tests
filter(hh_has_rel, hrhhid == 21650059271105)  |> 
  # what are the different income values
  select(ftype, dummy, offtotval, hh_max_offtotval, ftotval, year)

# do households have more than one primary family reference person?
rprifam <- ipums_march |> 
  # sum the number of primary householders within a houshold
  filter(year == 2018, famrel == 1, ftype == 1)  |> mutate(sum = sum(famrel), .by = hrhhid)  |> 
  # show households with multiple householders
  filter(sum > 1) |> select(hrhhid, sum)

# details of multi-householder households
filter(ipums_march, year == 2018)  |> left_join(rprifam, by = "hrhhid")  |> filter(sum == 2)

# count of households
hh_has_rel  |> filter(dummy == 1, famrel == 0)  |> count(hrhhid)  |> filter(!is.na(n), n > 0)

## run ipums_march in test_ipums.R
epi_march_2020_2024 <- read_dta("epi_march_2020_2024.dta")



test8 <- filter(epi_march, year %in% c(2004))  |> 
  summarize(n = n_distinct(offpovcut), .by = c(hrhhid, hserial, year, month, statefips)) |> 
  select(year, hrhhid, hserial, n) |> 
  filter(n > 1) 

test9 <- filter(ipums_march, year %in% c(2002))  |> 
  summarize(n = n_distinct(offcutoff), .by = c(hrhhid, hserial, year, month, statefips)) |> 
  select(year, hrhhid, hserial, n) |> 
  filter(n > 1) 

test10 <- filter(test7, year %in% c(2002))  |> 
  mutate(offpovcut = case_when(is.na(offfaminc) ~ NA, TRUE ~ offpovcut)) |> 
  summarize(n_epi = n_distinct(offpovcut, na.rm = TRUE),
            n_ipums = n_distinct(offcutoff, na.rm = TRUE), 
            .by = c(hrhhid, hserial, year, month, statefips)) |> 
  select(hrhhid, hserial, year, month, statefips, starts_with("n")) |> 
  mutate(n = n_epi == n_ipums)

filter(test7, year == 2002, hrhhid == "133020820680205")  |> 
  select(offfaminc, faminc_c, ftotval.x, offpovcut, offcutoff, rsubfam, offpov.x, offpov.y, everything())

test11 <- inner_join(test7, test10, 
                      by = c("hrhhid", "hserial", "year", "month", "statefips")) |> 
  filter(n == FALSE) |> 
  select(hrhhid, offfaminc, faminc_c, ftotval.x, offpovcut, offcutoff, rsubfam, offpov.x, offpov.y)

# merges ipums and EPI extracts and tests if the official poverty cut offs differ across organizations
# note: IPUMS replaces official poverty cutoffs with NA for those with official family income == NA
merge_epi_ipums <- function(x) {
  epi_ipums <- merge_status(select(filter(ipums_march, year %in% c(x)) |> 
                                            mutate(statefips = as.numeric(as_factor(statefips)),
                                                   hrhhid = str_pad(hrhhid, width = 15, side = "left", pad = 0),
                                                  famtype = as.numeric(ftype)),  
                                           hrhhid, hserial, pulineno, year, month, statefips, 
                                           offpov, offtotval, ftype, famrel, offcutoff, famtype, sex, race, asecwth), 
                                    select(filter(epi_march, year %in% c(x)) |> mutate(famtype = as.numeric(famtype)), 
                                           hrhhid, hserial, pulineno, year, month, 
                                           statefips, offpov, offfaminc, faminc_c, famtype, famrel, 
                                           offpovcut, rsubfam, offpovuniverse, female, wbho, asecwgt), 
                     by = c("hrhhid", "year", "month", "pulineno", "famtype")) #, "hserial", "statefips"))
}

test_fun <- function(x) {     
  merge_epi_ipums(x) |> 
    mutate(offpovcut = case_when(is.na(offfaminc) ~ NA, TRUE ~ offpovcut)) |> 
    summarize(n_epi = n_distinct(offpovcut, na.rm = TRUE),
              n_ipums = n_distinct(offcutoff, na.rm = TRUE), 
              .by = c(hrhhid, hserial, year, month, statefips)) |> 
    select(hrhhid, hserial, year, month, statefips, starts_with("n")) |> 
    mutate(n = n_epi == n_ipums)|> 
    inner_join(epi_ipums, by = c("hrhhid", "hserial", "year", "month", "statefips")) |> 
    filter(n == FALSE) |> 
    select(hrhhid, rsubfam, famtype, offpovcut, offcutoff, offfaminc, faminc_c, ftotval.x,  offpov.x, offpov.y, n, n_epi, n_ipums)
}

test <- map(2004:2024, ~ test_fun(.x) |> filter(n == FALSE))


test12 <- test_fun(2002) |> filter(n == FALSE)


test_n_epi_ipums <- map(2004:2010, ~ filter(test_fun(.x), n_ipums > 1) |> count() == filter(test_fun(.x), n_epi > 1) |> count())

test_fun(2004) |> filter(rsubfam == 1 & n_epi > 1) |> count()
test_fun(2004) |> filter(rsubfam == 1 & n_ipums > 1) |> count()


tester <- map(c(1968:1979), ~ merge_epi_ipums(.x)) # |> 
                            mutate(test = (offpov.x == offpov.y)) |> filter(test == FALSE) |> 
                            select(hrhhid, pulineno, offpovuniverse, offcutoff, offpovcut, 
                              offtotval, offfaminc, faminc_c, offpov.x, offpov.y, famtype, sex, female, race, wbho))
  
test <- merge_epi_ipums(1988) |> filter(`_merge` != "both", !is.na(famtype))
filter(epi_march, year == 1987) |> count()
filter(ipums_march, year == 1987) |> count()
test2 <- map(1968:1979, ~ filter(epi_march, year == .x))
test3 <- map(1968:1979, ~ filter(epi_march, year == .x))
test5 <- merge_epi_ipums(1988) 

# found something off about the way offfaminc is being assigned, 
#  assigned to non-related families

# list the files inside the zip
zipfile <- "/data/cps/march/census/raw/asecpub19csv.zip"
csv_name <- unzip(zipfile, list = TRUE)$Name[3]  # assuming first file is your CSV

# read only the header (names) without loading all data
col_names <- names(read.csv(unz(zipfile, csv_name), nrows = 1))

# print with position numbers
data.frame(
  position = seq_along(col_names),
  name = col_names
)

# pre-1980 missing and below threshold not matching ipums

epi_ipums <- merge_status(select(filter(ipums_march, year == 1979) |> 
                                 mutate(statefips = as.numeric(as_factor(statefips)), 
                                        hrhhid = str_pad(hrhhid, width = 15, side = "left", pad = 0),
                                        famtype = as.numeric(ftype)),
                                 age, hrhhid, pulineno, year, month, statefips, offpovuniv,
                                 offpov, offtotval, ftype, famtype, sex, race, asecwth), 
                          select(filter(epi_march, year == 1979) |> 
                                 mutate(famtype = as.numeric(famtype), 
                                        offpovuniverse = as.numeric(offpovuniverse)), 
                                 age, hrhhid, pulineno, year, month, statefips, offpov, famtype, famrel, 
                                 offpovcut, offpovuniverse, famdesc, female, wbho, asecwgt), 
                     by = c("hrhhid", "year", "month", "pulineno", "famtype"))  |> 
  select(famtype, offpovuniv,`age.x`, famdesc, offpovuniverse, `age.y`, everything())

test <- filter(epi_ipums, offpovuniv != offpovuniverse)

test2 <- filter(epi_march, year == 1979, !(famdesc > 5 & age < 14), offpovuniverse != 1) 
