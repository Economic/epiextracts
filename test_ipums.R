library(tidyverse)
library(haven)
library(epiextractr)
library(epidatatools)
library(openxlsx)

epi_march <- read_dta("epi_march.dta")
ipums_march <- read_dta("cps_00044.dta")


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


# function to perform different measurement types for different groups 
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
  
  #df %>% sheets_fun(wb = wb, s = paste0(deparse(substitute(x))))
  
}





ipums_wb <- createWorkbook()

ipums_count_vars <- c("hrhhid", "hrhhid2", "hseq", "lineno", "famid", "spmfamunit")

ipums_sum_vars <- c("asecwth", "asecwt", "asecfwt", "ftotval", "inctot", "incwage", 
                    "ctccrd", "actccrd", "eitcred", "schllunch", "spmthresh", "cutoff",
                    "spmlunch", "spmsttax", "spmfedtaxac", "spmeitc", "spmwic", "spmsnap",
                    "foodstamp")

ipums_mean_vars <- c("ftotval", "inctot", "incwage", "foodstamp", "offcutoff", "cutoff", "spmthresh")

ipums_tab_vars <- c("ftype", "classwkr", "educ", "schlcoll", "pension", 
                    "offpov", "poverty", "spmpov", 
                    "spmmort", "migsta1", "himcaidly", "caidly", "grpcovly", "grpownly", "dpownly")

ipums_mean <- map(ipums_mean_vars, ~ mfun(ipums_march, x = .x, m = "mean")) %>% 
  reduce(full_join, by = "year") %>% 
  sheets_fun(wb = ipums_wb, s = "ipums_mean")

ipums_count <- map(ipums_count_vars, ~ mfun(ipums_march, x = .x, m = "count")) %>% 
  reduce(full_join, by = "year") %>% 
  sheets_fun(wb = ipums_wb, s = "ipums_count")

ipums_sum <- map(ipums_sum_vars, ~ mfun(ipums_march, x = .x, m = "sum")) %>% 
  reduce(full_join, by = "year") %>% 
  sheets_fun(wb = ipums_wb, s = "ipums_sum")

ipums_tab <- map(ipums_tab_vars, ~ mfun(ipums_march, x = .x, m = "tab")) %>% 
  reduce(full_join, by = "year") %>% 
  sheets_fun(wb = ipums_wb, s = "ipums_tab")

saveWorkbook(wb = ipums_wb, file = "ipums_wb.xlsx")


epi_wb <- createWorkbook()

epi_count_vars <- c("hrhhid", "hrhhid2", "pulineno", "famid")

epi_sum_vars <- c("asecwgt", "hhwgt", "famwgt", "spmwgt", "earn", "income", 
                  "faminc_c", "famern", "famiws", "hhinc_c", "eitc", "childtaxcredit",
                  "spm_fedtax", "spm_statetax", "snap", "wic", "schlunch")

epi_mean_vars <- c("earn", "income", "offpovcut", "spmpovcut",
                   "faminc_c", "famern", "famiws", "hhinc_c", "eitc", "childtaxcredit")

epi_tab_vars1 <- c("nilf", "emp", "female", "wbho", "wbhao", "married", "citizen", 
                  "famtype", "cow1", "educ", "schenrl", "penplan", "penincl")

epi_tab_vars2 <- c("offpov", "povrate", "povlev", "hipaid", "hiemp", "hicov", #spmpov,
                  "foodstamps", "medicaid", "medicaidcov")


epi_tab_vars3 <- c("pubhouse", "hhtenure", "rentsub", "mortgage", "cowly", "dhhtype",
                  "famkind", "disability", "parent", "migarea", "migstatus", "migmetro", 
                  "lookdurly", "wrkly", "ownchild")

epi_mean <- map(epi_mean_vars, ~ mfun(epi_march, x = .x, m = "mean")) %>% 
  reduce(full_join, by = "year") %>% 
  sheets_fun(wb = epi_wb, s = "epi_mean")

epi_count <- map(epi_count_vars, ~ mfun(epi_march, x = .x, m = "count")) %>% 
  reduce(full_join, by = "year") %>% 
  sheets_fun(wb = epi_wb, s = "epi_count")

epi_sum <- map(epi_sum_vars, ~ mfun(epi_march, x = .x, m = "sum")) %>% 
  reduce(full_join, by = "year") %>% 
  sheets_fun(wb = epi_wb, s = "epi_sum")

epi_tab1 <- map(epi_tab_vars1, ~ mfun(epi_march, x = .x, m = "tab")) %>% 
  reduce(full_join, by = "year")

epi_tab2 <- map(epi_tab_vars2, ~ mfun(epi_march, x = .x, m = "tab")) %>% 
  reduce(full_join, by = "year")

epi_tab3 <- map(epi_tab_vars3, ~ mfun(epi_march, x = .x, m = "tab")) %>% 
  reduce(full_join, by = "year")

epi_tab <- full_join(epi_tab1, epi_tab2, by = "year") %>% 
  full_join(epi_tab3, by = "year") %>% 
  sheets_fun(wb = epi_wb, s = "epi_tab")

saveWorkbook(epi_wb, file = "epi_wb.xlsx")
