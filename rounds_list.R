# ### VAR LISTS ####
id_list <- list(
  # ipums_tab = 
  #   c(
  #     #"rotate",
  #     #"famrel",
  #     #"ftype"
  #   ),
  ipums_sum = 
    c(
      "asecwt", 
      "asecwth"
    ),
  #ipums_count = c("hrhhid", "hrhhid2", "famid"),
  # epimd_tab = 
  #   c(
  #     #"minsamp", 
  #     # "famrel",
  #     #"famtype"
  #   ),
  epimd_sum = 
    c(
      "asecwgt", 
      "hhwgt" 
    )
  #, epimd_count = c("hrhhid", "hrhhid2", "famid")
)

geo_list <- list(
  ipums_tab = 
    c(
      #"statefip", 
      #"region", 
      "migrate1"
    ),
  epimd_tab = 
    c(
      #"statefips", 
      #"region", 
      "migarea" # added collapsed categories in earlier years
    )
)

# demo_list <- list(
#   ipums_tab = c(
#                 #"sex",  
#                 #"hispan", 
#                 #"citizen",
#                 #"nchild",
#                 "vetstat", "marst", "race"
#               ),
#   ipums_mean = c("age"),
#   epimd_tab = c(
#                 #"female",
#                 #"hispanic", 
#                 #"citizen", "citistat",
#                 #"ownchild", # nothing comparable
#                 "veteran", # change in unvierse definition 1968-1987, overlaps with overestimation
#                 "married", "raceorig" # samples don't match (EPI 54282 vs IPUMS 55882)
#                 ),
#   epimd_mean = c("age")
# )

educ_list <- list(
  ipums_tab = c(#"schlcoll",
                #"higrade",
                "i_educ"
              ),
  epimd_tab = c(#"schenrl",
                #"gradehi",
                "educ" 
               )
)

lf_list <- list(
  ipums_tab = 
    c(
      "classwkr", # added collapse categories in earlier years
      #"paidhour",
      #"labforce", "empstat",
      #"metro",
      "wkstat"
      #, "whyunemp", 
      #"whyabsnt", 
      #"union",
      #"classwly", 
      #"durunemp", "nwlookwk"
    ),
  # ipums_mean = 
  #   c(
  #     "i_uhrsworkly"
  #   ),
  epimd_tab = 
    c(
      "cow1", #"pubst", "pubsec", "publoc", "pubfed", "selfinc", 
      #"selfemp", 
      #"paidhre",
      #"lfstat", "unemp", "emp", "nilf", 
      #"metstat",
      "ftptstat" 
      #, "whyunemp", 
      #"whyabsent", # 1962 for own illness differs
      #"unmem", "union", "uncov",
      #"cowly", # different sample of government workers 1988 (EPI 13240 vs IPUMS 12566) and 1989 (EPI 12311 vs IPUMS 11722)
      #"unempdur", "lookdurly"
    )
  #, epimd_mean = 
  #   c(
  #     "hoursly"
  #   )
)

# spm_list <- list(
#   ipums_tab = 
#     c(
#       "spmpov", "spmnewfam"
#     ),
#   ipums_sum = 
#     c(
#       "spmwt", "spmsttax", "spmfedtaxac",
#       "spmsnap",
#       "spmmort",
#       "spmlunch",
#       "spmeitc", 
#       "spmwic"
#     ),
#   ipums_mean = 
#     c(
#       "spmsttax", "spmfedtaxac",
#       "spmsnap",
#       "spmmort",
#       "spmthresh", 
#       "spmlunch"
#     ),
#   epimd_tab = 
#     c(
#       "spmpov", 
#       "spmfamtype"
#     ),
#   epimd_sum = 
#     c(
#       "spmwgt", "spmstatetax", "spmfedtax", 
#       "spmsnap",
#       "spmmortgage",
#       "spmschlunch",
#       "spmeitc",
#       "spmwic"
#     ),
#   epimd_mean = 
#     c(
#       "spmstatetax", "spmfedtax",
#       "spmmortgage",
#       "spmpovcut",
#       "spmschlunch"
#     )
# )

# public_benefits_list <- list(
#   # ipums_tab = 
#   #   c(
#   #     "rentsub",
#   #     "foodstmp"
#   #   ),
#   # ipums_sum = 
#   #   c(
#   #     "schllunch",
#   #     "eitcred"
#   #   ),
#   # ipums_mean = 
#   #   c(
#   #     "schllunch",
#   #     "eitcred", "ctccrd"
#   #   ),
#   # epimd_tab = 
#   #   c(
#   #     "rentsub",
#   #     "foodstamps"
#   #   ),
#   # epimd_sum = 
#   #   c(
#   #     "schlunch", # remove from release, indicator better? HFLUNCH, person or family?
#   #     "eitc" # remove from release, what is the point?
#   #   ),
#   # epimd_mean = 
#   #   c(
#   #     "schlunch",
#   #     "eitc", "childtaxcredit" # remove from release, ""
#   #   )
# )

hi_pension_list <- list(
  ipums_tab = c(#"anycovnw", "anycovly",
                #"inclugh",
                #"paidgh",
                #"himcaidly", "caidly", "caidnw",
                #"pension",
                "coverpi", "prvtcovly",
                "himcarely", 
                "hiother" 
                ),
  epimd_tab = c(#"hicov", "hicovly", 
                #"hiownemply",
                #"hiownpaidly",
                #"himcaidly",
                #"penplan", "penincl",
                "hiprivly",
                "himcarely",
                "higotherly"
              )
)

offpov_list <- list(
  ipums_tab = 
    c(
      "poverty", 
      "offpov"
      #, "offpovuniv"
    ),
  ipums_sum = 
    c(
      #"incwage", 
      "ftotval",
      "offtotval"
    ),
  ipums_mean = 
    c(
      #"incwage", 
      "ftotval", 
      "offcutoff", "offtotval"),
  epimd_tab = 
    c(
      "povrate", "povlev",
      "offpov"
      #, "offpovuniverse"
    ),
  epimd_sum = 
    c(
      #"income", # remove from list
      "faminc",
      "offfaminc"
    ),
  epimd_mean = 
    c(
      #"income", 
      "faminc", 
      "offpovcut", "offfaminc"
    )
)

