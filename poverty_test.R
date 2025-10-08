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

# epi extracts hrhhid is consistent, IPUMS is not, pad with zeros to see if this is a fix
ipums_march_test <- filter(ipums_march, year %in% c(2020:2024))  |>  
  mutate(hrhhid = str_pad(hrhhid, width = 7, pad = "0", side = "left"))

epi_march_test <- epi_march_2020_2024 |> 
  mutate(hrhhid_ = str_sub(peridnum, start = 1, end = -8))

test7 <- merge_status(select(filter(ipums_march, year %in% c(2020:2024)), hrhhid, hserial, year, month, statefips, offpov, offtotval, ftotval, ftype, famrel), 
                     select(epi_march_test, hrhhid_, hserial, year, month, statefips, offpov, offfaminc, ftotval, faminc_c, famtype, famrel, related), 
                     by = c("hrhhid" = "hrhhid_", "hserial", "year", "month", "statefips", "famrel")) |> 
  mutate(test = (offpov.x == offpov.y)) |> filter(test == FALSE) |> 
  select(hrhhid, related, famrel, ftype, famtype, offtotval, ftotval.x, offfaminc, ftotval.y, faminc_c, offpov.x, offpov.y) |> 
  mutate(test = (offtotval == ftotval.x))

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