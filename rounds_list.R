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

# health insurance
health_insurance_list <- list(
  ipums_tab = c("anycovnw", "anycovly"),
  epimd_tab = c("hicov", "hicovly")
)

round_pink_list <- list(
  ipums_tab = c("offpov", "poverty", "spmpov"),
  #ipums_sum = c("incwage", "ftotval", "ctccrd"),
  #ipums_mean = c("incwage", "ftotval", "offcutoff"),
  ipums_rate = c("offpov"),
  epimd_tab = c("offpov", "povlev", "spmpov"),
  #epimd_sum = c("income", "faminc_c", "childtaxcredit"),
  #epimd_mean = c("income", "faminc_c", "offpovcut")
  epimd_rate = c("offpov")
)

offpov_list <- list(
  ipums_tab = c("offpov"),
  #ipums_sum = c("incwage", "ftotval", "ctccrd"),
  #ipums_mean = c("incwage", "ftotval", "offcutoff"),
  ipums_rate = c("offpov"),
  epimd_tab = c("offpov"),
  #epimd_sum = c("income", "faminc_c", "childtaxcredit"),
  #epimd_mean = c("income", "faminc_c", "offpovcut")
  epimd_rate = c("offpov")
)
