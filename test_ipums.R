library(tidyverse)
library(haven)
library(epiextractr)
library(epidatatools)
library(openxlsx2)


### DATA SOURCE ####
vars <- c(
  "YEAR", "SERIAL", "MONTH", "ASECWT", "ASECWTH", 
  "HSEQ", "PERNUM", "HRHHID", "HRHHID2", "LINENO", "FAMID",
  "REGION", "STATEFIP", "STATECENSUS", "COUNTY", 
  #"PUBHOUS", "CPSIDP", "CPSIDV", "WKSUNEM1", "FAMKIND", 
  #"METRO", 
  "FAMINC", "MIGRATE1",
  # "AGE", "SEX",  "RENTSUB", "NCHILD", 
  #"MARST", "VETSTAT", "RACE",
  #"FTYPE", "FAMREL", "CITIZEN", "HISPAN", "EMPSTAT", 
  #"LABFORCE", #"DURUNEMP", 
  "CLASSWKR", 
  #"WHYUNEMP", "WHYABSNT", 
  "FTOTVAL",
  "WKSTAT", "EDUC", #"HIGRADE", #"SCHLCOLL", "ROTATE",  
  "ASECFWT", "CLASSWLY", #"UHRSWORKLY", 
  #"NWLOOKWK", "PENSION",  #"INCTOT", "INCWAGE", "CTCCRD", 
  #"ACTCCRD", "EITCRED", "FOODSTMP", "SCHLLUNCH", "INCLUGH", 
  "OFFPOV", "OFFPOVUNIV", "OFFTOTVAL", "OFFCUTOFF", 
  "POVERTY", "CUTOFF",  
  #"SPMLUNCH", "SPMNEWFAM", 
  #"SPMPOV", "SPMMORT", "SPMWT", "SPMSTTAX", "SPMFEDTAXAC", "SPMEITC", 
  #"SPMWIC", "SPMSNAP", "SPMTHRESH", 
  #"CAIDLY", "CAIDNW", "ANYCOVLY", "ANYCOVNW", "PAIDGH",  
  #"PAIDHOUR", 
  # "UNION", 
  "HIMCAIDLY", 
  #"EARNWEEK", "UH_NOWANYCOV_A1",
  "OCC", "IND", "OCCLY", "INDLY",
  "COVERPI", "PRVTCOVLY", "HIMCARELY", "HICHAMP",
  "TRCCOVLY", "CHAMPVALY", "INHCOVLY"
)

ipums_raw <- dl_ipums_asec(
    years = 1962:2025, 
    variables = vars) |> 
  janitor::clean_names()

ipums_march <- ipums_raw %>% 
  mutate(i_educ = case_when(
           # NIU/blank/missing
           educ %in% c(0, 1, 999) ~ NA,
           # grades 1-11, plus 12th grade attended w/o diploma (matches EPI's grdcom==2 rule)
           educ %in% c(2:71) ~ "Less than high school",
           # 12th grade w/ diploma (72 = diploma status unclear, dominant code pre-1992; 73 = explicit diploma)
           educ %in% c(72:73) ~ "High school",
           # 1-3 yrs of college, plus associate's degrees/some college no degree (81/91/92, post-1992 only)
           educ %in% c(80:100) ~  "Some college",
           # 4 yrs of college / bachelor's degree; pre-1992 also absorbs "attended a 5th/6th yr but didn't
           # complete it" since IPUMS rounds those down to the highest *completed* year, same as EPI's own
           # grdhi>=17 & grdcom==2 rule
           educ %in% c(110:111) ~ "College",
           # 5+ yrs of college (120), 5 yrs (121, pre-1992's completed-5th-year code), 6+ yrs (122), and
           # post-1992 specific advanced degrees (123-125) - matches EPI's grdhi 17-18 & grdcom==1 -> Advanced
           educ %in% c(120:125) ~ "Advanced"),
          # i_uhrsworkly = case_when(
          #  uhrsworkly == 999 ~ NA,
          #  TRUE ~ uhrsworkly),
          offtotval = case_when(offtotval == 9999999999 ~ NA, TRUE ~ offtotval),
          offcutoff = case_when(offcutoff == 999999 ~ NA, TRUE ~ offcutoff),
          ftotval = case_when(ftotval == 9999999999 ~ NA, TRUE ~ ftotval),
          # incwage = case_when(incwage == 9999999999 ~ NA,
          #                     incwage == 9999999998 ~ NA, 
          #                     TRUE ~ incwage),
          # ctccrd = case_when(ctccrd == 999999 ~ NA, TRUE ~ ctccrd),
          offpov = case_when(offpov == 1 ~ 1,
                             offpov == 2 ~ 0,
                             TRUE ~ NA),
          asecwgt = asecwt, 
          hrhhid = as.character(hrhhid), hrhhid2 = as.character(hrhhid2),
          # epi extracts hrhhid is consistent, IPUMS is not, pad with zeros to see if this is a fix
          hrhhid = str_pad(hrhhid, width = 15, pad = "0", side = "left"),
          hserial = hseq,
          # statefips = statefip,
          # statefips = case_when(
          #   year %in% c(1973:1976) & statefip == 25 ~ 14,
          #   year %in% c(1973:1976) & statefip == 9 ~ 16,
          #   year %in% c(1968:1972) & statefip == 9 ~ 11,
          #   year %in% c(1973:1976) & statefip == 81 ~ 19,
          #   year %in% c(1968:1972) & statefip == 70 ~ 19,
          #   year <= 1975 & statefip == 36 ~ 21,
          #   year <= 1975 & statefip == 34 ~ 22,
          #   year <= 1975 & statefip == 42 ~ 23,
          #   year <= 1975 & statefip == 39 ~ 31,
          #   year <= 1975 & statefip == 18 ~ 32,
          #   year <= 1975 & statefip == 17 ~ 33,
          #   year <= 1975 & statefip == 71 ~ 39,
          #   year %in% c(1973:1976) & statefip == 87 ~ 49,
          #   year %in% c(1968:1972) & statefip == 11 ~ 51,
          #   year %in% c(1973:1976) & statefip == 11 ~ 53,
          #   year %in% c(1968:1972) & statefip == 11 ~ 51,
          #   year %in% c(1973:1976) & statefip == 37 ~ 56,
          #   year %in% c(1973:1976) & statefip == 90 ~ 57,
          #   year %in% c(1973:1976) & statefip == 83 ~ 58,
          #   year %in% c(1973:1976) & statefip == 12 ~ 59,
          #   year %in% c(1968:1972) & statefip == 12 ~ 55,
          #   year %in% c(1973:1976) & statefip == 84 ~ 67,
          #   year <= 1975 & statefip == 76 ~ 69,
          #   year <= 1975 & statefip == 48 ~ 72,
          #   year %in% c(1973:1976) & statefip == 85 ~ 79,
          #   year %in% c(1973:1976) & statefip == 89 ~ 89,
          #   year <= 1975 & statefip == 6 ~ 92,
          #   year %in% c(1973:1976) & statefip == 88 ~ 99,
          #   year %in% c(1968:1972) & statefip == 24 ~ 52,
          #   year %in% c(1968:1972) & statefip == 54 ~ 53,
          #   year %in% c(1968:1972) & statefip == 13 ~ 54,
          #   year %in% c(1968:1972) & statefip == 75 ~ 57,
          #   year %in% c(1968:1972) & statefip == 74 ~ 59,
          #   year %in% c(1968:1972) & statefip == 21 ~ 61,
          #   year %in% c(1968:1972) & statefip == 47 ~ 62,
          #   year %in% c(1968:1972) & statefip ==  22 ~ 71,
          #   year %in% c(1968:1972) & statefip == 77 ~ 79,
          #   year %in% c(1968:1972) & statefip == 78 ~ 81,
          #   year %in% c(1968:1972) & statefip == 79 ~ 89,
          #   year %in% c(1968:1972) & statefip == 41 ~ 91,
          #   year %in% c(1968:1972) & statefip == 6 ~ 92,
          #   year %in% c(1968:1972) & statefip == 80 ~ 99),
          hiother = 
            case_when(
              hichamp == 2 ~ 1,
              inhcovly == 2 ~ 1,
              TRUE ~ 0
            )
          ) |> 
  rename(pulineno = lineno)

epi_march <- load_cps("march", 1962:2025, .extracts_dir = "extracts/")

# read_dta("extracts/epi_cpsmarch_1988.dta") |> mutate(hrhhid = str_pad(hrhhid, width = 15, side = "left", pad = 0)) #|> arrow::write_feather("epi_march.feather")
#epi_march <- read_dta("epi_march_2000_2002.dta") |> mutate(hrhhid = str_pad(hrhhid, width = 15, side = "left", pad = 0)) #|> arrow::write_feather("epi_march.feather")
#epi_march <- arrow::read_feather("epi_march.feather")

### FUNCTIONS ####
# function to write worksheet to excel 
sheets_fun <- function(data, wb, s) {
  
  wb$add_worksheet(sheet = s)$
     add_data(x = data)$
     set_col_widths(cols = 2:ncol(data), widths = 15)$
     add_cell_style(dims = wb_dims(rows = 1, cols = 2:ncol(data)),
                    wrap_text = TRUE, horizontal = "center", vertical = "center")
  
}

# function to perform different methods for different groups 
mfun <- function(data, x, m = NULL) {
  
  # cross-tabulation for indicator variables
  if (m == "tab") {
    df <- data %>% 
      crosstab(year, !!rlang::parse_expr(x)) %>% 
      rename_with(.cols = -year, ~ paste0(x, "_", .x, recycle0 = TRUE))
  } 
  
  # count for id variables
  else if (m == "count") {
    df <- data %>% 
      filter(!is.na(!!rlang::parse_expr(x))) %>% 
      summarise(!!paste0(x, "_n") := n(), .by = year)
  } 
  
  # sum for income variables and weights
  else if (m == "sum") {
    df <- data %>% 
      summarise(!!paste0(x, "_sum") := sum(!!rlang::parse_expr(x), na.rm = TRUE), .by = year)
  } 
  
  # average for income variables
  else if (m == "mean") {
    df <- data %>% 
      summarise(!!paste0(x, "_mean") := mean(!!rlang::parse_expr(x), na.rm = TRUE), .by = year)
  }

  else if (m == "rate") {
    df <- data %>%
      summarise(!!paste0(x, "_rate") := weighted.mean(!!rlang::parse_expr(x), w = asecwgt, na.rm = TRUE), .by = year)
  }
  
  else {
    message("Invalid method: ", m)
    return(tibble())
  }
  
  return(df)
  
}

# testing function to handle list input
testing_fun <- function(x, wb) {
  
  # iterate across each list item
  imap(x, ~ {
    
    s <- .y  # full name of the list item/group, e.g., "ipums_tab"
    m <- str_sub(.y, start = 7)  # extract method (e.g., "tab")
    
    # dynamically assign data
    data_source <- if (str_detect(s, "ipums")) ipums_march else epi_march
    
    
    # iterate across vector of var names
    df <- map(.x, ~ mfun(data = data_source, x = .x, m = m)) %>%
      # df of variables across a list item
      reduce(full_join, by = "year")
    
    # map to workbook
    sheets_fun(wb = wb, s = s, data = df) 
    
    # return df
    return(df)
  })
  
}

### VAR LISTS ####
# read in variable lists
source("rounds_list.R", echo = TRUE)

# list of variable lists for mapping
all_lists <- list(
                  #id_list, # all difference explained
                  #geo_list,
                  #demo_list, # all differences explained
                  #educ_list,
                  #lf_list,
                  #spm_list, # spm can go back further in time?
                  #public_benefits_list, # removing some variables from list
                  hi_pension_list
                  #offpov_list
                  )

# list of files to map to
all_files <- c(
              #"id.xlsx",
              #"geo.xlsx",
              #"demo.xlsx"
              #"educ.xlsx",
              #"lf.xlsx",
              #"spm.xlsx",
              #"public_benefits.xlsx",
              "hi_pension.xlsx"
              #"off_pov.xlsx"
            )

# quietly iterate over the two parallel vectors
pwalk(
  .l = list(lst  = all_lists,
            file = all_files),
  .f = function(lst, file) {
    # create wb
    wb <- wb_workbook()
    
    # fill wb with the variables and methods specified
    #note: data source, variables, and methods defined by list item
    #      (e.g., "ipums_tab")
    testing_fun(x = lst, wb = wb) 
    
    # save wb
    wb_save(wb, file, overwrite = TRUE)
  }
)



