# ### VAR LISTS ####
# ## Categories based on Microsoft Planner

# # corresponds to vars tagged "green"
# #note: mostly agnostic variables
# round_green_list <- list(
#   ipums_tab = c(#"vetstat", "classwkr", "paidhour",
#                 #"rotate", "marst", "labforce",
#                 #"hispan","wkstat", "sex", "empstat",
#                 #"citizen"
#               ),
#   ipums_count = c(#"hrhhid", "hrhhid2"
#                   ),
#   epimd_tab = c(#"veteran", "unemp", "pubst", "pubsec",
#                 #"publoc", "pubfed", "paidhre", "minsamp",
#                 #"married", "lfstat", "hispanic", "ftptstat",
#                 #"female", "emp", "cow1", "citizen"
#                 ),
#   epimd_count = c(#"hrhhid", "hrhhid2"
#                   )
# )

# round_light_green_list <- list(
#   ipums_sum = c(#"spmmort"
#                 ),
#   ipums_mean = c(#"spmthresh", 
#                   #"spmmort", 
#                   #"offcutoff"
#                   ),
#   epimd_sum = c(#"rentsub"
#                 ),
#   epimd_mean = c(#"spmpovcut", 
#                  #"offpovcut", 
#                  #"rentsub"
#                  )
# )

# round_light_green2_list <- list(
#   ipums_tab = c(
#     #"spmpov",
#     #"rentsub", 
#     #"poverty", 
#     #"pension",
#     #"offpov", 
#     #"caidly", "himcaidly",
#     #"spmnewfam"
#     ),
#   epimd_tab = c(
#     #"spmpov",
#     #"rentsub", 
#     #"povrate", "povlev",
#     #"penplan", "penincl", 
#     #"offpov", 
#     #"medicaid"
#   )
# )

# round_dark_green_list <- list(
#   ipums_tab = c(#"durunemp", 
#                 #"race", 
#                 #"nchild", 
#                 #"higrade", 
#                 #"ftype", "famrel", 
#                 #"migrate1", 
#                 #"nwlookwk"),
#   ipums_sum = c(#"spmwt", "spmsttax", "spmfedtaxac",
#                 #"spmsnap", 
#                 #"asecwt"
#               ),
#   ipums_mean = c(#"spmsttax", "spmfedtaxac",
#                  #"spmsnap", 
#                  #"uhrsworkly", 
#                  #"age"),
#   epimd_tab = c(#"unempdur", 
#                 #"raceorig", 
#                 #"ownchild",
#                 #"gradehi", 
#                 #"famtype", "famrel",
#                 #"migarea", 
#                 #"lookdurly"),
#   epimd_sum = c(#"spmwgt", "spmstatetax", "spmfedtax", 
#                 #"foodstamps", 
#                 #"asecwgt"
#               ),
#   epimd_mean = c(#"spmstatetax", "spmfedtax", 
#                  #"foodstamps", 
#                  #"hoursly", 
#                  #"age"
#                 )
# )

# round_dark_green_list <- list(
#   ipums_tab = #"citizen",
#   epimd_tab = #"citistat"
# )

# round_light_gray_list <- list(
#   ipums_tab = c(#"statefip", 
#                 #"region",
#                 #"i_educ"
#               ),
#   ipums_mean = c(#"i_uhrsworkly"
#                 ),
#   epimd_tab = c(#"statefips", 
#                 #"region",
#                 #"educ"
#               )
#   epimd_mean = c(#"hoursly"
#                 )
# )


# round_dark_gray_list <- list(
#   ipums_sum = c(#"schllunch", 
#                 #"spmlunch",
#                 #"eitcred", 
#                 #"spmeitc", 
#                 #"spmfedtaxac", "spmwt",
#                 #"spmwic"
#               ),
#   ipums_mean = c(#"schllunch", 
#                  #"spmlunch",
#                  #"eitcred", "ctccrd"
#                 ),
#   ipums_tab = c(#"foodstmp", 
#                 #"i_educ", 
#                 #"race", "sex", "famrel",
#                 #"nwlookwk", 
#                 #"himcaidly", "caidly",
#                 #"spmpov"
#               ),
#   epimd_sum = c(#"schlunch", 
#                 #"spm_schlunch", 
#                 #"eitc", 
#                 #"spmeitc", 
#                 #"spmfedtax", "spmwgt",
#                 #"spmwic"
#                 ),
#   epimd_mean = c(#"schlunch", 
#                  #"spm_schlunch",
#                 #"eitc", "childtaxcredit"
#                 ),
#   epimd_tab = c(#"foodstamps", 
#                 #"educ", 
#                 #"raceorig", "female", "famrel",
#                 #"lookdurly", 
#                 #"medicaid",
#                 #"spmpov"
#               )
# )

id_list <- list(
  ipums_tab = c("rotate",
                "ftype", "famrel"),
  ipums_sum = c("asecwt", "asecwth"),
  ipums_count = c("hrhhid", "hrhhid2", "famid"),
  epimd_tab = c("minsamp",
                "famtype", "famrel"),
  epimd_sum = c("asecwgt", "hhwgt"),
  epimd_count = c("hrhhid", "hrhhid2", "famid")
)

geo_list <- list(
  ipums_tab = c("migrate1", "region", "statefip"),
  epimd_tab = c("migarea", "region", "statefips")
)

demo_list <- list(
  ipums_tab = c("vetstat", "marst",
                "sex",  
                "hispan", "race",
                "citizen", 
                "nchild"
              ),
  ipums_mean = c("age"),
  epimd_tab = c("veteran", "married", 
                "female",
                "hispanic", "raceorig",
                "citizen", "citistat", 
                "ownchild"),
  epimd_mean = c("age")
)

educ_list <- list(
  ipums_tab = c("schlcoll",
                "higrade",
                "i_educ"
              ),
  epimd_tab = c("schenrl",
                "gradehi",
                "educ" 
               )
)

lf_list <- list(
  ipums_tab = c("classwkr", 
                "paidhour",
                "labforce",
                "metro",
                "wkstat", "empstat",
                "whyunemp", "whyabsnt", "union",
                "classwly",
                "durunemp", "nwlookwk"
              ),
  ipums_mean = c("i_uhrsworkly"
                ),
  epimd_tab = c("cow1", "pubst", "pubsec", "publoc", "pubfed", "selfinc", "selfemp", 
                "paidhre",
                "lfstat", "unemp", "emp", "nilf", 
                "metstat",
                "ftptstat", 
                "whyunemp", "whyabsent", "unmem", "uncov", "union",
                "cowly",
                "unempdur", "lookdurly"
                ),
  epimd_mean = c("hoursly"
              )
)

spm_list <- list(
  ipums_tab = c("spmpov", "spmnewfam"),
  ipums_sum = c("spmwt", "spmsttax", "spmfedtaxac",
                "spmsnap",
                "spmmort",
                "spmlunch",
                "spmeitc", 
                "spmwic"
              ),
  ipums_mean = c("spmsttax", "spmfedtaxac",
                 "spmsnap",
                 "spmmort",
                 "spmthresh", 
                 "spmlunch"
                ),
  epimd_tab = c("spmpov", "spmfamtype"
               ),
  epimd_sum = c("spmwgt", "spmstatetax", "spmfedtax", 
                "spmsnap",
                "spmmortgage",
                "spmschlunch",
                "spmeitc",
                "spmwic"
               ),
  epimd_mean = c("spmstatetax", "spmfedtax",
                 "spmmortgage",
                 "spmpovcut",
                 "spmschlunch"
                )
)

public_benefits_list <- list(
  ipums_tab = c("rentsub",
                "foodstmp"
               ),
  ipums_sum = c("schllunch",
                "eitcred"
               ),
  ipums_mean = c("schllunch",
                 "eitcred", "ctccrd"
                ),
  epimd_tab = c("rentsub",
                "foodstamps"
              ),
  epimd_sum = c("schlunch",
                "eitc"
                ),
  epimd_mean = c("schlunch",
                 "eitc", "childtaxcredit"
                )
)

hi_pension_list <- list(
  ipums_tab = c("anycovnw", "anycovly",
                "inclugh",
                "paidgh",
                "himcaidly", "caidly", "caidnw",
                "pension"
                ),
  epimd_tab = c("hicov", "hicovly", 
                "hiownemply",
                "hiownpaidly",
                "medicaid",
                "penplan", "penincl"
              )
)

offpov_list <- list(
  ipums_tab = c("poverty", 
                "offpov", "offpovuniv"),
  ipums_sum = c("incwage", "ftotval"),
  ipums_mean = c("incwage", "ftotval", "offcutoff"),
  epimd_tab = c("povrate", "povlev",
                "offpov", "offpovuniverse"),
  epimd_sum = c("income", "faminc"),
  epimd_mean = c("income", "faminc", "offpovcut")
)

