library(tidyverse)
library(haven)
library(epiextractr)
library(epidatatools)
library(openxlsx)

### DATA SOURCE ####
epi_march <- read_dta("epi_march.dta")
ipums_march <- read_dta("cps_00047.dta")

# set workbooks
round_green_wb <- createWorkbook()
round_light_green_wb <- createWorkbook()
round_dark_green_wb <- createWorkbook()

### FUNCTIONS ####
# function to write worksheet to excel 
sheets_fun <- function(data, wb, s) {
  
  # add worksheet and map data
  addWorksheet(wb, sheetName = paste0(s))
  writeData(wb, sheet = paste0(s), x = data)
  
  # assign column widths and data formatting
  setColWidths(wb, sheet = paste0(s), cols = 2:ncol(data), widths = 15)
  addStyle(wb, sheet = paste0(s), 
           style = createStyle(wrapText = TRUE, halign = "center", valign = "center"), 
           rows = 1, 2:ncol(data))
  
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
## Categories based on Microsoft Planner

# corresponds to vars tagged "green"
#note: mostly agnostic variables
round_green_list <- list(
  ipums_tab = c("vetstat", "classwkr", "paidhour",
                "rotate", "marst", "labforce",
                "hispan","wkstat", "sex", "empstat",
                "citizen"),
  ipums_count = c("hrhhid", "hrhhid2"),
  epimd_tab = c("veteran", "unemp", "pubst", "pubsec",
              "publoc", "pubfed", "paidhre", "minsamp",
              "married", "lfstat", "hispanic", "ftptstat",
              "female", "emp", "cow1", "citizen"),
  epimd_count = c("hrhhid", "hrhhid2")
)


# corresponds to vars tagged "light green"
round_light_green_list <- list(
  ipums_tab = c("whyunemp", "whyabsnt", "union", 
                "classwkr","schlcoll", "labforce", 
                "metro", "educ", "spmpov", "spmfamunit",
                "rentsub", "poverty", "pension",
                "offpov", "caidly", "himcaidly",
                "grpownly", "dpownly", "phiown", 
                "gqtype", "classwly"),
  ipums_sum = c("spmeitc", "spmwic", "schllunch", "spmmort", "foodstamp",
                "eitcred", "crccrd", "actccrd"),
  ipums_count = c("famid"),
  ipums_mean = c("spmwic", "spmthresh", "schllunch", 
                 "spmmort", "offpovcut", "foodstamp", "eitcred", 
                 "crccrd", "actccrd"),
  epimd_tab = c("whyunemp", "whyabsent", "unmem", "union",
                "uncov", "selfinc", "selfemp", "schenrl",
                "nilf", "metstat", "educ", "spmpov",
                "spmfamtype", "rentsub", "povrate", "povlev",
                "penplan", "penincl", "offpov", "medicaid",
                "hiemp", "hicov", "dhhtype", "cowly"),
  epimd_sum = c("spmeitc", "spmwic", "schlunch",
                "spmfamtype", "mortgage", "foodstamps", "eitc",
                "childtaxcredit"),
  epimd_count = c("famid"),
  epimd_mean = c("spmeitc", "spmwic", "spmpovcut", "schlunch",
                 "offpovcut", "mortgage", "foodstamps", "eitc",
                 "childtaxcredit")
)

# corresponds to vars tagged "dark green"
round_dark_green_list <- list(
  ipums_tab = c("durunemp", "race", "nchild", "higrade", "ftype",
                "famrel", "migrate1", "nwlookwk"),
  ipums_sum = c("spmwt", "spmsttax", "spmfedtaxac",
                "spmsnap", "asecwt"),
  ipums_mean = c("spmsttax", "spmfedtaxac",
                 "spmsnap", "uhrsworkly"),
  epi_tab = c("unempdur", "raceorig", "ownchild",
              "gradehi", "famtype", "famrel",
              "migarea", "lookdurly"),
  epi_sum = c("spmwgt", "spm_statetax", "spm_fedtax", 
              "snap", "asecwgt"),
  epi_mean = c("spm_statetax", "spm_fedtax", 
               "snap", "hoursly")
)


# list of variable lists for mapping
all_lists <- list(round_green_list,
                  round_light_green_list,
                  round_dark_green_list)

# list of files to map to
all_files <- c("round_green_wb.xlsx",
               "round_light_green_wb.xlsx",
               "round_dark_green_wb.xlsx")

# quietly iterate over the two parallel vectors
pwalk(
  .l = list(lst  = all_lists,
            file = all_files),
  .f = function(lst, file) {
    # create wb
    wb <- createWorkbook()
    
    # fill wb with the variables and methods specified
    #note: data source, variables, and methods defined by list item
    #      (e.g., "ipums_tab")
    testing_fun(x = lst, wb = wb)
    
    # save wb
    saveWorkbook(wb, file, overwrite = TRUE)
  }
)

break

round_pink_list <- list(
  ipums_tab = c(),
  ipums_sum = c(),
  ipums_count = c(),
  ipums_mean = c(),
  epimd_tab = c(),
  epimd_sum = c(),
  epimd_count = c(),
  epimd_mean = c()
)