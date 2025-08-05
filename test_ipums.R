library(tidyverse)
library(haven)
library(epiextractr)
library(epidatatools)
library(openxlsx)

### DATA SOURCE ####
epi_march <- read_dta("epi_march.dta")
ipums_march <- read_dta("cps_00054.dta") 

test <- ipums_march %>% 
  mutate(i_educ = case_when(
           educ %in% c(73,72) ~ "High school",
           educ %in% c(0, 1, 999) ~ NA,
           educ %in% c(2:71) ~ "Less than high school",
           educ %in% c(80:92) ~  "Some college",
           educ %in% c(100:111) ~ "College",
           educ %in% c(120:125) ~ "Advanced"),
         i_uhrsworkly = case_when(
           uhrsworkly == 999 ~ NA,
           TRUE ~ uhrsworkly))

epi_basic <- load_basic(1979:2024, year, basicwgt, mind16, mocc10)

### MIND/MOCC ####
march_mind16 <- crosstab(epi_march, year, mind16, percent = "row", w = asecwgt) |> filter(year >= 1979) |> 
  sheets_fun(wb, s = "march_mind16")
basic_mind16 <- crosstab(epi_basic, year, mind16, percent = "row", w = basicwgt) |> 
  sheets_fun(wb, s = "basic_mind16")
comp_mind16 <- march_mind16 - basic_mind16 )

march_mocc10 <- crosstab(epi_march, year, mocc10, percent = "row", w = asecwgt) |> filter(year >= 1979) |> 
  sheets_fun(wb, s = "march_mocc10")
basic_mocc10 <- crosstab(epi_basic, year, mocc10, percent = "row", w = basicwgt) |> 
  sheets_fun(wb, s = "basic_mocc10")
comp_mocc10 <- march_mocc10 - basic_mocc10 

saveWorkbook(wb, file = "./mind16_mocc10.xlsx", overwrite = TRUE)

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
  ipums_sum = c("spmmort"),
  ipums_count = c("famid"),
  ipums_mean = c("spmthresh", "spmmort", "offcutoff"),
  epimd_sum = c("mortgage"),
  epimd_count = c("famid"),
  epimd_mean = c("spmpovcut", "offpovcut", "mortgage")
)

# corresponds to vars tagged "light green"
round_light_green2_list <- list(
  ipums_tab = c(#"whyunemp", "whyabsnt", "union", 
    #"classwkr","schlcoll", 
    #"labforce", "metro", 
    #"spmpov"), 
    #"rentsub", "poverty", "pension",
    #"offpov", "caidly", "himcaidly",
    "classwly", "spmfamunit"),
  epimd_tab = c(#"whyunemp", "whyabsent", "unmem", "union",
    #"uncov", "selfinc", "selfemp", "schenrl",
    #"nilf", "metstat",
    #"spmpov",
    #"rentsub", "povrate", "povlev",
    #"penplan", "penincl", "offpov", "medicaid",
    "cowly")
)



# corresponds to vars tagged "dark green"
round_dark_green_list <- list(
  ipums_tab = c("durunemp", "race", "nchild", "higrade", "ftype",
                "famrel", "migrate1", "nwlookwk"),
  ipums_sum = c("spmwt", "spmsttax", "spmfedtaxac",
                "spmsnap", "asecwt"),
  ipums_mean = c("spmsttax", "spmfedtaxac",
                 "spmsnap", "uhrsworkly", "age"),
  epimd_tab = c("unempdur", "raceorig", "ownchild",
                "gradehi", "famtype", "famrel",
                "migarea", "lookdurly"),
  epimd_sum = c("spmwgt", "spm_statetax", "spm_fedtax", 
                "snap", "asecwgt"),
  epimd_mean = c("spm_statetax", "spm_fedtax", 
                 "snap", "hoursly", "age")
)

round_dark_green_list <- list(
  ipums_tab = "citizen",
  epimd_tab = "citistat"
)

round_dark_gray_list <- list(
  #ipums_sum = c(#"schllunch", "spmlunch",
                #"eitcred", 
                #"spmeitc", 
                #"spmfedtaxac", "spmwt",
                #"spmwic"),
  #ipums_mean = c("schllunch", "spmlunch",
  #               "eitcred", "ctccrd"),
  #ipums_tab = c(#"i_foodstamp", "i_educ", 
                #"race", "sex", "famrel",
                #"nwlookwk", "himcaidly", "caidly",
                #"spmpov"),
  #epimd_sum = c(#"schlunch", "spm_schlunch", 
                #"eitc", 
                #"spmeitc", 
                #"spm_fedtax", "spmwgt",
                #"spm_wic"),
  #epimd_mean = c("schlunch", "spm_schlunch",
  #               "eitc", "childtaxcredit"),
  #epimd_tab = c(#"foodstamps", "educ", 
                #"raceorig", "female", "famrel",
                #"lookdurly", "medicaid",
                #"spmpov")
)

round_light_gray_list <- list(
  ipums_tab = c(#"statefip", 
                "region",
                "i_educ"),
  #ipums_mean = c("i_uhrsworkly"),
  epimd_tab = c(#"statefips", 
                "region",
                "educ")
 # epimd_mean = c("hoursly")
)

health_insurance_list <- list(
  ipums_tab = c("anycovnw", "anycovly"),
  epimd_tab = c("hicov", "hicovly")
)

# list of variable lists for mapping
all_lists <- list(#round_green_list,
                  #round_light_green2_list,
                  #round_dark_green_list,
                  #round_dark_gray_list,
                  #round_light_gray_list
                  health_insurance_list)

# list of files to map to
all_files <- c(#"round_green_wb.xlsx",
              #"round_light_green2_wb.xlsx",
              #"round_dark_green_wb.xlsx",
              #"round_dark_gray_wb.xlsx",
              "health_insurance_coverage.xlsx")

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
  ipums_tab = c("spmpov", "poverty", "offpov", "offpovcut",
                "spmfamunit"),
  ipums_sum = c("incwage", "ftotval", "faminc", "ctccrd"),
  ipums_count = c(),
  ipums_mean = c("incwage", "ftotval"),
  epimd_tab = c("spmpov", "povrate", "povlev", "offpov", "offpovcut",
                "spmfamunit"),
  epimd_sum = c("income", "faminc_c", "faminc", "childtaxcredit"),
  epimd_count = c(),
  epimd_mean = c("income", "faminc_c", "faminc")
)