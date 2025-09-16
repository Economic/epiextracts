library(tidyverse)
library(haven)
library(epiextractr)
library(epidatatools)
library(openxlsx)


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

#epi_march <- read_dta("epi_march.dta") |> arrow::write_feather("epi_march.feather")
epi_march <- arrow::write_feather("epi_march.feather")

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
# read in variable lists
source("rounds_list.R", echo = TRUE)

# list of variable lists for mapping
all_lists <- list(#round_green_list,
                  #round_light_green2_list,
                  #round_dark_green_list,
                  #round_dark_gray_list,
                  #round_light_gray_list
                  #health_insurance_list,
                  round_pink_list)

# list of files to map to
all_files <- c(#"round_green_wb.xlsx",
              #"round_light_green2_wb.xlsx",
              #"round_dark_green_wb.xlsx",
              #"round_dark_gray_wb.xlsx",
              #"health_insurance_coverage.xlsx",
              "round_pink_wb.xlsx")

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
