# March (ASEC) recodes: the unicon_march (1962-1997, u_ columns) and
# census_march (1998+, m_ columns) sources in variable_functions.csv. Stata
# runs each March file as March of its year with $earnerinfo = $basicfile = 0.
# Rows arrive in file order (Unicon record order), which some rules use.

# --- identifiers (generate_minsamp/hrhhid/hrhhid2/pulineno/hserial.do) ------

# month in sample: code 9 is missing in 1962 and 1967
recode_minsamp_unicon_march <- function(u_mis, year) {
  dplyr::if_else(year %in% c(1962, 1967) & u_mis == 9, NA_real_, as.numeric(u_mis))
}
recode_minsamp_census_march <- function(m_h_mis) as.numeric(m_h_mis)

#' 1969-1971 (checked over 1968-1975): a few related-subfamily heads sit
#' between two records of another household in record order but carry the
#' previous household's _hhid. Stata flags a record between two records of
#' one other household, coded as a related subfamily (famdesc 4), whose own
#' _hhid has no primary family with subfamilies (famdesc 2), and moves it to
#' the surrounding household. Returns the flag, in the rows' own order.
march_misidentified <- function(u__hhid, u_famdesc, u_recnum, year) {
  flag <- rep(FALSE, length(year))
  if (!any(year >= 1968 & year <= 1975)) return(flag)
  # households with a primary family with subfamilies
  own_sub <- stats::ave(as.numeric(u_famdesc %in% 2), u__hhid, FUN = max) == 1
  # in record order: between two records of another household
  o <- order(u_recnum)
  id <- u__hhid[o]
  n <- length(id)
  prev <- c(NA, id[-n])
  nxt <- c(id[-1], NA)
  between <- !is.na(prev) & !is.na(nxt) & id != prev & prev == nxt
  flag[o] <- between & u_famdesc[o] %in% 4 & !own_sub[o]
  flag & year >= 1968 & year <= 1975
}

# the household id of the previous record (record order) for flagged rows
move_to_previous <- function(x, flag, u_recnum) {
  o <- order(u_recnum)
  x_sorted <- x[o]
  prev <- c(NA, x_sorted[-length(x_sorted)])
  x_sorted[flag[o]] <- prev[flag[o]]
  x[o] <- x_sorted
  x
}

recode_hrhhid_unicon_march <- function(u_hhid, u__hhid, u_famdesc, u_recnum, year) {
  hrhhid <- dplyr::coalesce(as.character(u_hhid), "")
  move_to_previous(hrhhid, march_misidentified(u__hhid, u_famdesc, u_recnum, year), u_recnum)
}
# household id: h_idnum, split into h_idnum1/h_idnum2 in 2005-2018
recode_hrhhid_census_march <- function(m_h_idnum, m_h_idnum1, year) {
  dplyr::coalesce(as.character(dplyr::if_else(year >= 2005 & year <= 2018, as.character(m_h_idnum1), as.character(m_h_idnum))), "")
}
recode_hrhhid2_census_march <- function(m_h_idnum2, year) {
  dplyr::if_else(year >= 2005 & year <= 2018, dplyr::coalesce(as.character(m_h_idnum2), ""), "")
}

# person line number (missing in the 1976-1978 files)
recode_pulineno_unicon_march <- function(u_lineno, year) {
  dplyr::if_else(year >= 1976 & year <= 1978, NA_real_, as.numeric(u_lineno))
}
recode_pulineno_census_march <- function(m_a_lineno) as.numeric(m_a_lineno)

#' Household serial number within the file: 1962 groups _hhid; 1963-1967
#' numbers households in record order (_hhid is reused for unrelated
#' households); 1968-1975 groups _hhid after moving misidentified records;
#' from 1976 the file's own sequence number.
recode_hserial_unicon_march <- function(u__hhid, u_famdesc, u_recnum, u_hhseq, year) {
  yr <- unique(year)
  if (yr >= 1976) return(as.numeric(u_hhseq))
  if (yr >= 1963 && yr <= 1967) {
    # a new household each time _hhid changes, in record order
    o <- order(u_recnum)
    id <- u__hhid[o]
    serial <- numeric(length(id))
    serial[o] <- cumsum(c(TRUE, id[-1] != id[-length(id)]))
    return(serial)
  }
  key <- u__hhid
  if (yr >= 1968) key <- move_to_previous(key, march_misidentified(u__hhid, u_famdesc, u_recnum, year), u_recnum)
  # Stata's gegen group(): households numbered in sorted order of the key
  as.numeric(vctrs::vec_rank(key, ties = "dense", incomplete = "na"))
}
recode_hserial_census_march <- function(m_h_seq) as.numeric(m_h_seq)

# --- household and family structure (generate_famid/personid/hhtype/famtype.do)
recode_famid_unicon_march <- function(u_famnum, year) dplyr::if_else(year >= 1963, as.numeric(u_famnum), NA_real_)
recode_famid_census_march <- function(m_a_famnum) as.numeric(m_a_famnum)

# person id from 2005: peridnum, a long digit string (Stata's destring; doubles both)
recode_personid_census_march <- function(m_peridnum, year) {
  dplyr::if_else(year >= 2005, suppressWarnings(as.numeric(m_peridnum)), NA_real_)
}

recode_hhtype_unicon_march <- function(u_hhtype, year) dplyr::if_else(year >= 1988, as.numeric(u_hhtype), NA_real_)
recode_hhtype_census_march <- function(m_hrhtype) as.numeric(m_hrhtype)

#' Family type (1 primary family, 2 primary individual, 3 related subfamily,
#' 4 unrelated secondary family, 5 unrelated secondary individual): each
#' Unicon era codes it differently.
recode_famtype_unicon_march <- function(u_famtyp, u_famdesc, year) {
  yr <- unique(year)
  map_codes <- function(x, from) unname(c(1, 2, 3, 4, 5)[match(x, from)])
  if (yr == 1962) return(map_codes(u_famtyp, c(0, 3, 1, 2, 4)))
  if (yr <= 1967) return(map_codes(u_famtyp, c(1, 4, 2, 3, 5)))
  if (yr <= 1975) {
    return(dplyr::case_when(u_famdesc %in% c(1, 2) ~ 1, u_famdesc == 5 ~ 2, u_famdesc == 4 ~ 3,
                            u_famdesc == 3 ~ 4, u_famdesc >= 6 ~ 5, TRUE ~ NA_real_))
  }
  if (yr <= 1987) return(map_codes(u_famtyp, c(0, 4, 3, 2, 1)))
  as.numeric(u_famtyp)
}
recode_famtype_census_march <- function(m_a_famtyp) as.numeric(m_a_famtyp)

# --- weights (generate_asecwgt/hhwgt/famwgt.do) ---------------------------------

#' ASEC person weight: Unicon wgt in hundredths (1963 and 1966 carry IPUMS
#' scaling factors); marsupwt from 1998 (in hundredths from 2019); 2014's
#' samples scaled 3/8 (redesigned) and 5/8 (traditional). Population-control
#' years use the alternate weights Census's published series use: wgtalt in
#' 1980 and 1993, the revised marsupwt_rev in 2011, 2021 and 2025.
recode_asecwgt_unicon_march <- function(u_wgt, u_wgtalt, year) {
  factor <- dplyr::case_when(year == 1963 ~ 1.3675, year == 1966 ~ 0.5043, TRUE ~ 1)
  asecwgt <- dplyr::if_else(year %in% c(1980, 1993), u_wgtalt / 100, u_wgt / 100 * factor)
  dplyr::if_else(asecwgt <= 0, NA_real_, asecwgt)
}
recode_asecwgt_census_march <- function(m_marsupwt, m_marsupwt_rev, m_redesign, year) {
  asecwgt <- dplyr::case_when(
    year == 2011 ~ as.numeric(m_marsupwt_rev),
    year %in% c(2021, 2025) ~ m_marsupwt_rev / 100,
    year == 2014 & m_redesign == 1 ~ m_marsupwt * (3 / 8),
    year == 2014 & m_redesign == 0 ~ m_marsupwt * (5 / 8),
    year >= 2019 ~ m_marsupwt / 100,
    TRUE ~ as.numeric(m_marsupwt)
  )
  dplyr::if_else(asecwgt <= 0, NA_real_, asecwgt)
}

# the largest value of x among a group's rows where `where` holds (missing if
# none), for every row: Stata's bysort g: egen max(cond(where, x, .))
group_max_where <- function(x, where, group) {
  value <- dplyr::if_else(where %in% TRUE, x, NA_real_)
  out <- stats::ave(value, group, FUN = function(v) if (all(is.na(v))) NA_real_ else max(v, na.rm = TRUE))
  as.numeric(out)
}

#' Household weight. 1962-1976 (and 1980): the household head's asecwgt
#' (_relhd 1), falling back to the hhrel head in 1968-1975; 1977-1997 Unicon
#' hhwgt; from 1998 hsup_wgt (scaled as asecwgt); 1993 hhwgtalt; 2011, 2021,
#' 2025 the reference person's asecwgt. Group-quarters households are
#' missing: lvqtyp (1962: 1, 1963-1975: 2, any member), htype2 2 (1976-1987),
#' hhtype 9-10 (1988+).
recode_hhwgt_unicon_march <- function(asecwgt, hserial, u__relhd, u_hhrel, u_hhwgt, u_hhwgtalt, u_lvqtyp, u_htype2, hhtype, year) {
  yr <- unique(year)
  head_weight <- group_max_where(asecwgt, u__relhd == 1, hserial)
  hhwgt <- if (yr <= 1976 || yr == 1980) head_weight else u_hhwgt / 100
  if (yr >= 1968 && yr <= 1975) hhwgt <- dplyr::coalesce(hhwgt, group_max_where(asecwgt, u_hhrel == 1, hserial))
  if (yr == 1993) hhwgt <- u_hhwgtalt / 100
  # group quarters
  gq <- if (yr == 1962) {
    stats::ave(as.numeric(u_lvqtyp %in% 1), hserial, FUN = max) == 1
  } else if (yr <= 1975) {
    stats::ave(as.numeric(u_lvqtyp %in% 2), hserial, FUN = max) == 1
  } else if (yr <= 1987) {
    u_htype2 %in% 2
  } else {
    hhtype %in% c(9, 10)
  }
  dplyr::if_else(gq, NA_real_, hhwgt)
}
recode_hhwgt_census_march <- function(asecwgt, hserial, m_hsup_wgt, m_redesign, m_a_exprrp, hhtype, year) {
  yr <- unique(year)
  hhwgt <- if (yr <= 2013) {
    dplyr::if_else(m_hsup_wgt > 0, as.numeric(m_hsup_wgt), NA_real_)
  } else if (yr == 2014) {
    dplyr::case_when(m_redesign == 1 ~ m_hsup_wgt * (3 / 8), m_redesign == 0 ~ m_hsup_wgt * (5 / 8), TRUE ~ NA_real_)
  } else if (yr <= 2018) {
    as.numeric(m_hsup_wgt)
  } else {
    m_hsup_wgt / 100
  }
  if (yr %in% c(2011, 2021, 2025)) hhwgt <- group_max_where(asecwgt, m_a_exprrp %in% c(1, 2), hserial)
  dplyr::if_else(hhtype %in% c(9, 10), NA_real_, hhwgt)
}

#' Family weight. Unicon famwgt in hundredths from 1963; 1976 the asecwgt of
#' the family's first person (lowest perid); 1993 fmwgtalt; 1980 the
#' alternate weight of the member whose wgt equals Unicon famwgt (own asecwgt
#' for primary and secondary individuals, _famtyp 4 and 1); from 1998
#' fsup_wgt (scaled as asecwgt). 1963, 1964, 1966, 2011, 2021 and 2025: the
#' family reference person's asecwgt, or the first person's where a family
#' has none (file order; Stata's order after its sort can differ for ties),
#' and unrelated individuals' own.
recode_famwgt_unicon_march <- function(asecwgt, hserial, famid, u_famwgt, u_fmwgtalt, u_wgt, u__famtyp, u_perid, u_famrel, year) {
  yr <- unique(year)
  family <- paste(hserial, famid)
  famwgt <- if (yr == 1962) {
    rep(NA_real_, length(year))
  } else if (yr == 1976) {
    first_person <- stats::ave(u_perid, family, FUN = min)
    group_max_where(asecwgt, u_perid == first_person, family)
  } else if (yr == 1993) {
    u_fmwgtalt / 100
  } else {
    u_famwgt / 100
  }
  if (yr == 1980) {
    individual <- u__famtyp %in% c(1, 4)
    matched <- !is.na(u_wgt) & !is.na(u_famwgt) & abs(u_wgt - u_famwgt) <= 1 & !individual
    alternate <- group_max_where(asecwgt, matched, paste(family, individual))
    famwgt <- dplyr::coalesce(alternate, famwgt)
    famwgt <- dplyr::if_else(individual, asecwgt, famwgt)
  }
  if (yr %in% c(1963, 1964, 1966)) famwgt <- reference_person_weight(asecwgt, family, u_famrel == 0, u_famrel == 4)
  dplyr::if_else(famwgt <= 0, NA_real_, famwgt)
}
recode_famwgt_census_march <- function(asecwgt, hserial, famid, m_fsup_wgt, m_redesign, m_a_famrel, year) {
  yr <- unique(year)
  famwgt <- if (yr == 2014) {
    dplyr::case_when(m_redesign == 1 ~ m_fsup_wgt * (3 / 8), m_redesign == 0 ~ m_fsup_wgt * (5 / 8), TRUE ~ NA_real_)
  } else if (yr >= 2019) {
    m_fsup_wgt / 100
  } else {
    as.numeric(m_fsup_wgt)
  }
  if (yr %in% c(2011, 2021, 2025)) {
    famwgt <- reference_person_weight(asecwgt, paste(hserial, famid), m_a_famrel == 1, m_a_famrel == 0)
  }
  dplyr::if_else(famwgt <= 0, NA_real_, famwgt)
}

# family weight from the reference person (first person if none), unrelated
# individuals keeping their own
reference_person_weight <- function(asecwgt, family, is_reference, is_unrelated) {
  reference <- group_max_where(asecwgt, is_reference, family)
  first <- stats::ave(asecwgt, family, FUN = function(v) v[1])
  weight <- dplyr::coalesce(reference, first)
  dplyr::if_else(is_unrelated %in% TRUE, asecwgt, weight)
}

# --- shared variables: March branches -----------------------------------------
# Each March year is one era, so these functions branch on the file's year.
# Comparisons with no `~= .` guard in the scripts use as_stata() (missing is
# larger than any number in Stata).

# Stata's recode: listed codes replaced at once, others kept
recode_codes <- function(x, from, to) {
  x <- as.numeric(x)
  hit <- match(x, from)
  x[!is.na(hit)] <- to[hit[!is.na(hit)]]
  x
}

# --- geography (generate_statefips/countyfips/metstat.do) ---------------------

# Unicon state codes to FIPS, 1963-1967; 1968-1976 code groups of small
# states (101-119 in state_geocodes.csv)
march_state_codes_1963 <- list(
  from = c(0, 1, 2, 3, 4, 5, 6, 10, 11, 13, 22, 23, 24, 25, 26, 31, 32, 33, 34, 35, 36, 37,
           41, 42, 43, 44, 45, 46, 47, 48, 49, 51, 52, 53, 54, 65, 66, 67, 68,
           71, 72, 73, 74, 75, 76, 77, 78, 85, 86, 87, 88, 89),
  to = c(NA, 23, 25, 33, 50, 44, 9, 36, 34, 42, 55, 18, 39, 17, 26, 27, 19, 29, 38, 46, 31, 20,
         10, 24, 11, 51, 54, 45, 37, 13, 12, 21, 47, 1, 28, 5, 22, 40, 48,
         30, 16, 56, 8, 35, 4, 49, 32, 2, 15, 53, 41, 6)
)
march_state_codes_1968 <- list(
  from = c(0, 11, 21, 22, 23, 31, 32, 33, 43, 51, 52, 53, 54, 55, 61, 62, 71, 72, 91, 92,
           19, 39, 41, 49, 57, 59, 69, 79, 81, 89, 99),
  to = c(NA, 9, 36, 34, 42, 39, 18, 17, 29, 11, 24, 54, 13, 12, 21, 47, 22, 48, 41, 6,
         101:111)
)
march_state_codes_1973 <- list(
  from = c(0, 14, 16, 21, 22, 23, 31, 32, 33, 53, 56, 59, 72, 92,
           19, 39, 49, 57, 58, 67, 69, 79, 89, 99),
  to = c(NA, 25, 9, 36, 34, 42, 39, 18, 17, 11, 37, 12, 48, 6,
         112, 102, 113, 114, 115, 116, 107, 117, 118, 119)
)

#' statefips (statecensus, division and region are looked up from it, as for
#' Basic). 1962: none (Stata's merge keeps only unmatched rows). 1963-1976:
#' Unicon codes recoded to FIPS, small states in groups. 1977-1997: the Census
#' state code. statefips is the geocodes' own, so codes outside it are missing.
recode_statefips_unicon_march <- function(u_state, year, state_geocodes) {
  yr <- unique(year)
  if (yr == 1962) return(rep(NA_real_, length(year)))
  if (yr >= 1977) return(as.numeric(state_geocodes$statefips[match(u_state, state_geocodes$statecensus)]))
  codes <- if (yr <= 1967) march_state_codes_1963 else if (yr <= 1972) march_state_codes_1968 else march_state_codes_1973
  statefips <- recode_codes(u_state, codes$from, codes$to)
  as.numeric(state_geocodes$statefips[match(statefips, state_geocodes$statefips)])
}
# 1998-2000 the Census state code (hg_st60, which keeps its own value labels:
# see value_label_overrides), then gestfips
recode_statefips_census_march <- function(m_hg_st60, m_gestfips, year, state_geocodes) {
  statefips <- if (unique(year) <= 2000) {
    state_geocodes$statefips[match(m_hg_st60, state_geocodes$statecensus)]
  } else {
    state_geocodes$statefips[match(m_gestfips, state_geocodes$statefips)]
  }
  as.numeric(statefips)
}

recode_countyfips_unicon_march <- function(u_cntyfp, year) dplyr::if_else(year >= 1996, as.numeric(u_cntyfp), NA_real_)
recode_countyfips_census_march <- function(m_geco, m_gtco, year) {
  dplyr::if_else(year <= 2004, as.numeric(m_geco), as.numeric(m_gtco))
}
# cbsafips/cbsasize from 2004m5, so March 2005 on
recode_cbsafips_census_march <- function(m_gtcbsa, year) dplyr::if_else(year >= 2005, as.numeric(m_gtcbsa), NA_real_)
recode_cbsasize_census_march <- function(m_gtcbsasz, year) dplyr::if_else(year >= 2005, as.numeric(m_gtcbsasz), NA_real_)

#' metstat: citystat through 1976 (1962-1967 codes 0-1 metro, 2 not;
#' 1968-1976 codes 1-2 metro, 3 not), then metstat (1 metro, 2 not)
recode_metstat_unicon_march <- function(u_citystat, u_metstat, year) {
  yr <- unique(year)
  if (yr <= 1967) return(dplyr::case_when(u_citystat == 2 ~ 0, u_citystat %in% c(0, 1) ~ 1, TRUE ~ NA_real_))
  if (yr <= 1976) return(dplyr::case_when(u_citystat == 3 ~ 0, u_citystat %in% c(1, 2) ~ 1, TRUE ~ NA_real_))
  yes_no(u_metstat)
}
recode_metstat_census_march <- function(m_hmsa_r, m_gtmetsta, year) {
  yes_no(if (unique(year) <= 2004) m_hmsa_r else m_gtmetsta)
}

# --- demographics (generate_age/female/hispanic/wb*.do, citistat, citizen,
# married, veteran) --------------------------------------------------------
recode_raw_age_census_march <- function(m_a_age) as.numeric(m_a_age)
recode_female_census_march <- function(m_a_sex) recode_female_unicon(m_a_sex)

# Hispanic from 1971 (0 before): _spneth / a_reorgn 1-7, missing for 9-10
# (through 2002); then prdthsp, as for Basic
recode_hispanic_unicon_march <- function(u__spneth, year) {
  hispanic <- rep(0, length(year))
  if (unique(year) < 1971) return(hispanic)
  hispanic <- stata_replace(hispanic, u__spneth >= 1 & u__spneth <= 7, 1)
  stata_replace(hispanic, u__spneth >= 9 & u__spneth <= 10, NA_real_)
}
recode_hispanic_census_march <- function(m_a_reorgn, m_prdthsp, year) {
  if (unique(year) >= 2003) return(recode_hispanic(year, NA_real_, m_prdthsp))
  recode_hispanic_unicon_march(m_a_reorgn, year)
}

#' wbho and wbho_only (the same in March): race 1 white, 2 black, 3 (from
#' 1989 any higher code) other; Hispanic overrides. 1962's codes run 0-2, so
#' its white (0) is missing and black and other read as white and black
#' (reproduced).
recode_wbho_unicon_march <- function(u_race, year, hispanic) {
  other <- if (unique(year) <= 1988) u_race == 3 else as_stata(u_race) >= 3
  wbho <- dplyr::case_when(u_race == 1 ~ 1, u_race == 2 ~ 2, other ~ 4, TRUE ~ NA_real_)
  stata_replace(wbho, hispanic == 1, 3)
}
# from 1988: Asian (4) apart from other (3 and, through 1995, 5)
recode_wbhao_unicon_march <- function(u_race, year, hispanic) {
  yr <- unique(year)
  if (yr < 1988) return(rep(NA_real_, length(year)))
  other <- if (yr <= 1995) u_race %in% c(3, 5) else u_race %in% 3
  wbhao <- dplyr::case_when(u_race == 1 ~ 1, u_race == 2 ~ 2, u_race == 4 ~ 4, other ~ 5, TRUE ~ NA_real_)
  stata_replace(wbhao, hispanic == 1, 3)
}
# race as coded: 1962 (0 white, 1 black, 2 other), 1963-1987 (3 other),
# 1988-1995 (3 American Indian, 4 Asian, 5 other), 1996-1997 (no other)
recode_raceorig_unicon_march <- function(u_race, year) {
  yr <- unique(year)
  # each era's codes and what they become; anything else is missing
  codes <- if (yr == 1962) {
    list(0:2, c(1, 2, 0))
  } else if (yr <= 1987) {
    list(1:3, c(1, 2, 0))
  } else if (yr <= 1995) {
    list(1:5, c(1:4, 0))
  } else {
    list(1:4, 1:4)
  }
  codes[[2]][match(u_race, codes[[1]])]
}
# single race: white, black, other (1988-1995: codes 4-5, so 3 is missing)
recode_wbo_only_unicon_march <- function(u_race, year) {
  yr <- unique(year)
  if (yr == 1962) return(dplyr::case_when(u_race == 0 ~ 1, u_race == 1 ~ 2, u_race == 2 ~ 3, TRUE ~ NA_real_))
  other <- if (yr <= 1987) u_race == 3 else if (yr <= 1995) u_race %in% 4:5 else as_stata(u_race) >= 3
  dplyr::case_when(u_race == 1 ~ 1, u_race == 2 ~ 2, other ~ 3, TRUE ~ NA_real_)
}

# 1998-2002 a_race (1 white, 2 black, 3 American Indian, 4 Asian), coded as
# Basic's perace; from 2003 prdtrace, as Basic's ptdtrace (the detailed
# codes change in 2013 for March)
recode_wbho_census_march <- function(m_a_race, m_prdtrace, year, month, hispanic) {
  if (unique(year) >= 2003) return(recode_wbho(year, month, NA_real_, m_prdtrace, hispanic))
  recode_wbho_unicon_march(m_a_race, year, hispanic)
}
recode_wbhao_census_march <- function(m_a_race, m_prdtrace, year, month, hispanic) {
  recode_wbhao(year, month, m_a_race, m_prdtrace, hispanic)
}
# multiple races from 2003, except 2012 (its window ends at 2012m1)
recode_wbhom_census_march <- function(m_prdtrace, year, month, hispanic) {
  dplyr::if_else(year == 2012, NA_real_, recode_wbhom(year, month, m_prdtrace, hispanic))
}
recode_wbhaom_census_march <- function(m_prdtrace, year, month, hispanic) {
  dplyr::if_else(year == 2012, NA_real_, recode_wbhaom(year, month, m_prdtrace, hispanic))
}
recode_raceorig_census_march <- function(m_a_race, m_prdtrace, year, month) {
  recode_raceorig(year, month, m_a_race, m_prdtrace)
}
recode_wbo_only_census_march <- function(m_a_race, m_prdtrace, year) {
  race <- if (unique(year) <= 2002) m_a_race else m_prdtrace
  dplyr::case_when(race == 1 ~ 1, race == 2 ~ 2, as_stata(race) >= 3 ~ 3, TRUE ~ NA_real_)
}
recode_wbho_only_census_march <- function(m_a_race, m_prdtrace, year, hispanic) {
  wbho <- c(1, 2, 4)[recode_wbo_only_census_march(m_a_race, m_prdtrace, year)]
  stata_replace(wbho, hispanic == 1, 3)
}

# citizenship from 1994: 1-4 citizens, 5 not
recode_citistat_unicon_march <- function(u_citstat, year) dplyr::if_else(year >= 1994, as.numeric(u_citstat), NA_real_)
recode_citistat_census_march <- function(m_prcitshp) as.numeric(m_prcitshp)
recode_citizen_march <- function(citistat) {
  dplyr::case_when(citistat == 5 ~ 0, citistat >= 1 & citistat <= 4 ~ 1, TRUE ~ NA_real_)
}

recode_married_unicon_march <- function(u__marstat) {
  dplyr::case_when(u__marstat >= 3 & u__marstat <= 6 ~ 0, u__marstat >= 1 & u__marstat <= 2 ~ 1, TRUE ~ NA_real_)
}
recode_married_census_march <- function(m_a_maritl) {
  dplyr::case_when(m_a_maritl >= 4 & m_a_maritl <= 7 ~ 0, m_a_maritl >= 1 & m_a_maritl <= 3 ~ 1, TRUE ~ NA_real_)
}

#' veteran from 1963: _vet 1-8 veterans; 1963-1967 vet 5-6 not, missing for
#' vet 9; from 1968 _vet 6 not; missing in the armed forces (_popstat 2)
recode_veteran_unicon_march <- function(u__vet, u_vet, u__popstat, year) {
  yr <- unique(year)
  veteran <- rep(NA_real_, length(year))
  if (yr == 1962) return(veteran)
  veteran <- stata_replace(veteran, u__vet >= 1 & u__vet <= 8, 1)
  if (yr <= 1967) {
    veteran <- stata_replace(veteran, u_vet %in% c(5, 6), 0)
    return(stata_replace(veteran, u__popstat == 2 | u_vet == 9, NA_real_))
  }
  veteran <- stata_replace(veteran, u__vet == 6, 0)
  stata_replace(veteran, u__popstat == 2, NA_real_)
}
# a_vet through 2005, then peafever/peafwhn1
recode_veteran_census_march <- function(m_a_vet, m_peafever, m_peafwhn1, year) {
  veteran <- rep(NA_real_, length(year))
  if (unique(year) <= 2005) {
    veteran <- stata_replace(veteran, m_a_vet == 6, 0)
    return(stata_replace(veteran, m_a_vet >= 1 & m_a_vet <= 5, 1))
  }
  veteran <- stata_replace(veteran, m_peafever == 2, 0)
  stata_replace(veteran, m_peafwhn1 >= 1 & m_peafwhn1 <= 9, 1)
}

# --- education (generate_gradehi/gradeatn/educ.do) -----------------------------
# highest grade attended: grdhi less one (1968-1987) or as is (1988-1991)
recode_gradehi_unicon_march <- function(u_grdhi, year) {
  yr <- unique(year)
  if (yr < 1968 || yr > 1991) return(rep(NA_real_, length(year)))
  dplyr::if_else(u_grdhi > 0, u_grdhi - if (yr <= 1987) 1 else 0, NA_real_)
}
# grade attained from 1992 (grdatn, then a_hga), 31-46 shifted to 1-16
recode_gradeatn_unicon_march <- function(u_grdatn, year) {
  gradeatn <- dplyr::if_else(year >= 1992, u_grdatn - 30, NA_real_)
  dplyr::if_else(gradeatn <= 0, NA_real_, gradeatn)
}
recode_gradeatn_census_march <- function(m_a_hga) {
  gradeatn <- m_a_hga - 30
  dplyr::if_else(gradeatn <= 0, NA_real_, gradeatn)
}

#' educ through 1991: highest grade attended (_grdhi) and whether it was
#' completed (grdcom: 1962 6 yes, 7 no; then 1 yes, 2 no). 1968-1987 first
#' set grdhi 1-12 to less than high school, then the 1968-1991 rules apply
#' (adding _grdhi 0 with grdcom other than 0). From 1992 grdatn, coded as
#' Basic's peeduca.
recode_educ_unicon_march <- function(u__grdhi, u_grdhi, u_grdcom, u_grdatn, year) {
  yr <- unique(year)
  if (yr >= 1992) return(recode_educ(u_grdatn))
  done <- if (yr == 1962) 6 else 1
  not_done <- if (yr == 1962) 7 else 2
  educ <- rep(NA_real_, length(year))
  if (yr <= 1967) educ <- stata_replace(educ, u__grdhi >= 0 & u__grdhi <= 11, 1)
  if (yr >= 1968 && yr <= 1987) educ <- stata_replace(educ, u_grdhi >= 1 & u_grdhi <= 12, 1)
  if (yr >= 1968) {
    educ <- stata_replace(educ, u__grdhi == 0 & u_grdcom != 0, 1)
    educ <- stata_replace(educ, u__grdhi >= 1 & u__grdhi <= 11, 1)
  }
  educ <- stata_replace(educ, u__grdhi == 12 & u_grdcom == not_done, 1)
  educ <- stata_replace(educ, u__grdhi == 12 & u_grdcom == done, 2)
  educ <- stata_replace(educ, u__grdhi == 13 & u_grdcom == not_done, 2)
  educ <- stata_replace(educ, u__grdhi == 13 & u_grdcom == done, 3)
  educ <- stata_replace(educ, u__grdhi >= 14 & u__grdhi <= 15, 3)
  educ <- stata_replace(educ, u__grdhi == 16 & u_grdcom == not_done, 3)
  educ <- stata_replace(educ, u__grdhi == 16 & u_grdcom == done, 4)
  educ <- stata_replace(educ, u__grdhi == 17 & u_grdcom == not_done, 4)
  educ <- stata_replace(educ, u__grdhi == 17 & u_grdcom == done, 5)
  stata_replace(educ, u__grdhi == 18, 5)
}
recode_educ_census_march <- function(m_a_hga) recode_educ(m_a_hga)

# school enrollment from 1986 (1 yes, 2 no)
recode_schenrl_unicon_march <- function(u_schenr, year) dplyr::if_else(year >= 1986, yes_no(u_schenr), NA_real_)
recode_schenrl_census_march <- function(m_a_enrlw) yes_no(m_a_enrlw)

# --- labor force (generate_lfstat/dlfstat/whyabsent/whyunemp.do, ...) ---------
# employment status recode: _esr through 1993 (1-2 employed, 3 unemployed,
# 7 not in the labor force; 4-6 missing), then mlr
recode_lfstat_unicon_march <- function(u__esr, u_mlr, year) {
  if (unique(year) >= 1994) return(recode_lfstat(u_mlr))
  dplyr::case_when(u__esr %in% c(1, 2) ~ 1, u__esr == 3 ~ 2, u__esr == 7 ~ 3, TRUE ~ NA_real_)
}
recode_lfstat_census_march <- function(m_pemlr) recode_lfstat(m_pemlr)
recode_dlfstat_unicon_march <- function(u_mlr, year) {
  dplyr::if_else(year >= 1994 & u_mlr != -1, as.numeric(u_mlr), NA_real_)
}
recode_dlfstat_census_march <- function(m_pemlr) dplyr::if_else(m_pemlr == -1, NA_real_, as.numeric(m_pemlr))

#' reason absent from work: whyabs through 1993, coded onto the 1994 codes
#' (1962 and 1963-1967 number them differently); absrsn after
recode_whyabsent_unicon_march <- function(u_whyabs, u_absrsn, year) {
  yr <- unique(year)
  if (yr >= 1994) return(dplyr::if_else(u_absrsn %in% c(-1, 0), NA_real_, as.numeric(u_absrsn)))
  codes <- if (yr == 1962) {
    list(c(1, 0, 3, 2, 4), c(4, 5, 9, 10, 14))
  } else if (yr <= 1967) {
    list(c(2, 1, 4, 3, 5), c(4, 5, 9, 10, 14))
  } else {
    list(c(6, 7, 5, 2, 1, 4, 3, 8), c(1, 1, 3, 4, 5, 9, 10, 14))
  }
  codes[[2]][match(u_whyabs, codes[[1]])]
}
recode_whyabsent_census_march <- function(m_peabsrsn) dplyr::if_else(m_peabsrsn %in% c(-1, 0), NA_real_, as.numeric(m_peabsrsn))

# reason unemployed from 1988: runemp (codes 1-5 onto 1, 2, 4, 5, 6), then
# runtype; pruntype from 1998 (only 0 is missing)
recode_whyunemp_unicon_march <- function(u_runemp, u_runtype, year) {
  yr <- unique(year)
  if (yr < 1988) return(rep(NA_real_, length(year)))
  if (yr >= 1994) return(dplyr::if_else(u_runtype %in% c(-1, 0), NA_real_, as.numeric(u_runtype)))
  c(1, 2, 4, 5, 6)[match(u_runemp, 1:5)]
}
recode_whyunemp_census_march <- function(m_pruntype) dplyr::if_else(m_pruntype %in% 0, NA_real_, as.numeric(m_pruntype))

# --- class of worker (generate_selfemp/selfinc/cow1/pub*.do) -------------------
# Unicon class codes: 1962 (0 private, 1 government, 2 self-employed),
# 1963-1987 (1 private, 2 government, 3 self-employed, 4-5 other), 1988-1997
# (1 private, 2-4 federal/state/local, 5 self-employed incorporated, 6
# unincorporated, 7-8 without pay/never worked)
recode_selfemp_unicon_march <- function(u_class, year) {
  yr <- unique(year)
  # 1962's private class is 0, so any class counts
  if (yr == 1962) return(dplyr::case_when(u_class == 2 ~ 1, u_class >= 0 ~ 0, TRUE ~ NA_real_))
  class_indicator_unicon(u_class, u_class == if (yr <= 1987) 3 else 6)
}
# 1988-1997 class indicators: 0 for any class, 1 for the given code
class_1988_unicon_march <- function(u_class, year, code) {
  dplyr::if_else(year >= 1988, class_indicator_unicon(u_class, u_class == code), NA_real_)
}
recode_selfinc_unicon_march <- function(u_class, year) class_1988_unicon_march(u_class, year, 5)
recode_pubfed_unicon_march <- function(u_class, year) class_1988_unicon_march(u_class, year, 2)
recode_pubst_unicon_march <- function(u_class, year) class_1988_unicon_march(u_class, year, 3)
recode_publoc_unicon_march <- function(u_class, year) class_1988_unicon_march(u_class, year, 4)
recode_pubsec_unicon_march <- function(u_class, year) {
  yr <- unique(year)
  if (yr == 1962) return(dplyr::case_when(u_class == 1 ~ 1, u_class %in% 2:3 ~ 0, TRUE ~ NA_real_))
  private <- if (yr <= 1967) c(1, 3, 4) else if (yr <= 1987) c(1, 3:5) else c(1, 5:8)
  government <- if (yr <= 1987) 2 else 2:4
  dplyr::case_when(u_class %in% government ~ 1, u_class %in% private ~ 0, TRUE ~ NA_real_)
}
# 1988-1993 class onto the Census codes; then cowjob1
recode_cow1_unicon_march <- function(u_class, u_cowjob1, year) {
  yr <- unique(year)
  if (yr < 1988) return(rep(NA_real_, length(year)))
  if (yr >= 1994) return(dplyr::if_else(u_cowjob1 <= 0, NA_real_, as.numeric(u_cowjob1)))
  c(9, 1, 2, 3, 6, 7, 8)[match(u_class, 1:7)]
}
# Census class codes (peio1cow): the Basic recodes
recode_selfemp_census_march <- function(m_peio1cow) recode_selfemp(m_peio1cow)
recode_selfinc_census_march <- function(m_peio1cow) recode_selfinc(m_peio1cow)
recode_pubfed_census_march <- function(m_peio1cow) recode_pubfed(m_peio1cow)
recode_pubst_census_march <- function(m_peio1cow) recode_pubst(m_peio1cow)
recode_publoc_census_march <- function(m_peio1cow) recode_publoc(m_peio1cow)
recode_pubsec_census_march <- function(m_peio1cow) recode_pubsec(m_peio1cow)
recode_cow1_census_march <- function(m_peio1cow) recode_cow1(m_peio1cow)

# union membership and coverage from 1983 (1 yes, 2 no)
recode_unmem_unicon_march <- function(u_unmem, year) dplyr::if_else(year >= 1983, yes_no(u_unmem), NA_real_)
recode_uncov_unicon_march <- function(u_uncov, year) dplyr::if_else(year >= 1983, yes_no(u_uncov), NA_real_)
recode_unmem_census_march <- function(m_a_unmem) yes_no(m_a_unmem)
recode_uncov_census_march <- function(m_a_uncov) yes_no(m_a_uncov)

# --- unemployment and work status (generate_unempdur/discwork/ftptstat.do) ------
# weeks looking for work from 1968 (positive values)
recode_unempdur_unicon_march <- function(u_wksun, year) {
  dplyr::if_else(year >= 1968 & u_wksun > 0, as.numeric(u_wksun), NA_real_)
}
recode_unempdur_census_march <- function(m_a_wkslk) dplyr::if_else(m_a_wkslk > 0, as.numeric(m_a_wkslk), NA_real_)

# discouraged workers from 1994: 0 for everyone else, missing values included
recode_discwork_unicon_march <- function(u_dscwk, year) {
  dplyr::if_else(year >= 1994, dplyr::if_else(u_dscwk %in% c(1, 2), 1, 0), NA_real_)
}
recode_discwork_census_march <- function(m_prdisc) recode_discwork(m_prdisc)

#' full/part-time status from 1976: 1976-1987 _wkstat (3 and 5 onto 11 and
#' 12), 1988-1993 wkstat and wksch; not in the labor force is 1. From 1994
#' rwkstat (positive values).
recode_ftptstat_unicon_march <- function(u__wkstat, u_wkstat, u_wksch, u_rwkstat, lfstat, year) {
  yr <- unique(year)
  ftptstat <- rep(NA_real_, length(year))
  if (yr < 1976) return(ftptstat)
  if (yr >= 1994) return(dplyr::if_else(u_rwkstat > 0, as.numeric(u_rwkstat), NA_real_))
  if (yr <= 1987) {
    ftptstat <- stata_replace(ftptstat, u__wkstat == 3, 11)
    ftptstat <- stata_replace(ftptstat, u__wkstat == 5, 12)
  } else {
    ftptstat <- stata_replace(ftptstat, u_wkstat == 3, 3)
    ftptstat <- stata_replace(ftptstat, u_wkstat == 5, 6)
    ftptstat <- stata_replace(ftptstat, u_wksch == 3, 11)
    ftptstat <- stata_replace(ftptstat, u_wksch == 4, 12)
  }
  stata_replace(ftptstat, lfstat == 3, 1)
}
recode_ftptstat_census_march <- function(m_prwkstat) recode_ftptstat(m_prwkstat)

# --- hours and earnings (generate_paidhre/hours*/earnhour/a_earnhour.do) ---------
# earnings questions from 1979
recode_paidhre_unicon_march <- function(u_ernpdh, year) dplyr::if_else(year >= 1979, yes_no(u_ernpdh), NA_real_)
recode_paidhre_census_march <- function(m_a_hrlywk) yes_no(m_a_hrlywk)

# usual weekly hours from 1979 (0 is missing for Unicon)
recode_hoursut_unicon_march <- function(u_ernush, year) {
  hours <- dplyr::if_else(year >= 1979 & u_ernush != 0, as.numeric(u_ernush), NA_real_)
  nonnegative(hours)
}
recode_hoursut_census_march <- function(m_a_uslhrs) nonnegative(m_a_uslhrs)

# hours worked last week (1962-1967: 99 is none)
recode_hourslwt_unicon_march <- function(u_hours, year) {
  if (unique(year) <= 1967) return(dplyr::case_when(u_hours == 99 ~ 0, u_hours < 99 ~ nonnegative(u_hours), TRUE ~ NA_real_))
  nonnegative(u_hours)
}
recode_hourslwt_census_march <- function(m_a_hrs1) nonnegative(m_a_hrs1)

#' usual hours at the earnings job: ernush from 1979, a_uslhrs from 1998.
#' From 1995 Stata's `if ernel == 1 {` (prerelg from 1998) reads only the
#' first record, after generate_statefips.do's merge has sorted by state with
#' ties in no fixed order: every row gets the hours when that record is in
#' the earnings sample, none otherwise. Reproduced with the years it happened
#' (march_hoursuorg_years, from the published files); a later year is missing.
march_hoursuorg_years <- c(1996, 2000, 2006, 2011, 2014)
recode_hoursuorg_unicon_march <- function(u_ernush, year) {
  yr <- unique(year)
  if (yr < 1979 || (yr >= 1995 && !yr %in% march_hoursuorg_years)) return(rep(NA_real_, length(year)))
  nonnegative(u_ernush)
}
recode_hoursuorg_census_march <- function(m_a_uslhrs, year) {
  dplyr::if_else(year %in% march_hoursuorg_years, nonnegative(m_a_uslhrs), NA_real_)
}

# hours vary (-4) from 1994; any other value, missing included, is 0
recode_hoursvary_unicon_march <- function(u_ernush, year) {
  dplyr::if_else(year >= 1994, march_hours_vary(u_ernush), NA_real_)
}
recode_hoursvary_census_march <- function(m_a_uslhrs) march_hours_vary(m_a_uslhrs)
march_hours_vary <- function(hours) {
  vary <- dplyr::if_else(as_stata(hours) >= 0, 0, NA_real_)
  stata_replace(vary, hours == -4, 1)
}

# hourly rate from 1979
recode_earnhour_unicon_march <- function(u_ernhr, year) nonnegative(dplyr::if_else(year >= 1979, as.numeric(u_ernhr), NA_real_))
recode_earnhour_census_march <- function(m_a_hrspay) nonnegative(m_a_hrspay)

# hourly rate allocated, for positive rates: ahours (from 1976), then aphrs
# (1998-2006), a1hrs (2007-2010), axhrs (2011 on)
march_allocated <- function(amount, flag) {
  positive <- !is.na(amount) & amount > 0
  dplyr::if_else(positive, dplyr::if_else(flag %in% 1, 1, 0), NA_real_)
}
recode_a_earnhour_unicon_march <- function(earnhour, u_ahours, year) {
  dplyr::if_else(year >= 1976, march_allocated(earnhour, u_ahours), NA_real_)
}
recode_a_earnhour_census_march <- function(earnhour, m_aphrs, m_a1hrs, m_axhrs, year) {
  yr <- unique(year)
  flag <- if (yr <= 2006) m_aphrs else if (yr <= 2010) m_a1hrs else m_axhrs
  march_allocated(earnhour, flag)
}

# --- family (generate_i_faminc/ownchild/famrel.do) -----------------------------
#' family income in 14 categories: hfminc in 1988 and 1990-1997 (none in
#' 1989), h_faminc 1998-2004 (codes 0-10 up one, 11-12 into 12); hufaminc
#' 2005-2009 and hefaminc 2010-2018 (12-13 into 12, above down one); from 2019
#' family income (ftot_r) grouped into the same categories.
march_faminc_old <- function(x) {
  dplyr::case_when(x <= 10 ~ x + 1, x >= 11 & x <= 12 ~ 12, x >= 13 & x < 19 ~ as.numeric(x), TRUE ~ NA_real_)
}
recode_i_faminc_unicon_march <- function(u_hfminc, year) {
  dplyr::if_else(year == 1988 | year >= 1990, march_faminc_old(u_hfminc), NA_real_)
}
recode_i_faminc_census_march <- function(m_h_faminc, m_hufaminc, m_hefaminc, m_ftot_r, year) {
  yr <- unique(year)
  if (yr <= 2004) return(march_faminc_old(m_h_faminc))
  if (yr <= 2018) {
    x <- if (yr <= 2009) m_hufaminc else m_hefaminc
    return(dplyr::case_when(x <= 11 ~ as.numeric(x), x >= 12 & x <= 13 ~ 12, x >= 14 ~ x - 1, TRUE ~ NA_real_))
  }
  # ftot_r's $5,000 brackets (2,500 at the bottom) grouped
  dplyr::case_when(
    m_ftot_r <= 2 ~ 1,
    m_ftot_r <= 6 ~ m_ftot_r - 1,
    m_ftot_r <= 8 ~ 6,
    m_ftot_r <= 10 ~ 7,
    m_ftot_r <= 12 ~ 8,
    m_ftot_r <= 14 ~ 9,
    m_ftot_r <= 16 ~ 10,
    m_ftot_r <= 20 ~ 11,
    m_ftot_r <= 30 ~ 12,
    m_ftot_r <= 40 ~ 13,
    m_ftot_r == 41 ~ 14,
    TRUE ~ NA_real_
  )
}

# own children under 18 from 1963 (1963-1975 code 10 is missing)
recode_ownchild_unicon_march <- function(u_child18, year) {
  yr <- unique(year)
  if (yr == 1962) return(rep(NA_real_, length(year)))
  dplyr::if_else(yr <= 1975 & u_child18 %in% 10, NA_real_, as.numeric(u_child18))
}
recode_ownchild_census_march <- function(m_fownu18) as.numeric(m_fownu18)

# family relationship: 1962-1967 codes 0-3 up one (4 is 0); 1968-1987 none
recode_famrel_unicon_march <- function(u_famrel, year) {
  yr <- unique(year)
  if (yr <= 1967) return(dplyr::case_when(u_famrel == 4 ~ 0, u_famrel < 4 ~ u_famrel + 1, TRUE ~ NA_real_))
  if (yr <= 1987) return(rep(NA_real_, length(year)))
  as.numeric(u_famrel)
}
recode_famrel_census_march <- function(m_a_famrel) nonnegative(m_a_famrel)

# --- industry and occupation (generate_indcode/occcode/mind16/...03.do) --------
# Unicon ind: 1962 code 44 and 1963-1967 codes 45 and 99 are armed forces or
# not in universe; 0 is missing from 1968
recode_indcode_unicon_march <- function(u_ind, year) {
  yr <- unique(year)
  missing_codes <- if (yr == 1962) 44 else if (yr <= 1967) c(45, 99) else 0
  dplyr::if_else(u_ind %in% missing_codes, NA_real_, as.numeric(u_ind))
}
# a_ind through 2002, then peioind; 0 is missing
recode_indcode_census_march <- function(m_a_ind, m_peioind, year) {
  indcode <- if (unique(year) <= 2002) m_a_ind else m_peioind
  dplyr::if_else(indcode == 0, NA_real_, as.numeric(indcode))
}
recode_occcode_unicon_march <- function(u_occ) dplyr::if_else(u_occ < 1, NA_real_, as.numeric(u_occ))
recode_occcode_census_march <- function(m_a_occ, m_peioocc, year) {
  occcode <- if (unique(year) <= 2002) m_a_occ else m_peioocc
  dplyr::if_else(occcode < 1, NA_real_, as.numeric(occcode))
}

#' Major industry. 1962-1970 March files have their own industry codes:
#' 1962 and 1963-1967 one-or-two-digit groups, 1968-1970 1960 Census codes.
#' From 1971, Basic's rules (recode_mind16()).
recode_mind16_march <- function(indcode, year) {
  yr <- unique(year)
  if (yr >= 1971) return(recode_mind16(indcode, year))
  if (yr == 1962) {
    return(dplyr::case_when(
      indcode >= 0 & indcode <= 2 ~ 1,
      indcode == 3 ~ 2,
      indcode >= 4 & indcode <= 14 ~ 3,
      indcode >= 15 & indcode <= 20 ~ 4,
      indcode >= 21 & indcode <= 22 ~ 5,
      indcode >= 23 & indcode <= 24 ~ 6,
      indcode == 25 ~ 7,
      indcode == 27 ~ 8,
      (indcode >= 28 & indcode <= 31) | indcode == 39 ~ 9,
      indcode >= 32 & indcode <= 33 ~ 10,
      indcode %in% c(26, 34) ~ 11,
      indcode == 36 ~ 12,
      indcode == 35 ~ 13,
      indcode == 38 ~ 14,
      indcode == 37 ~ 15,
      indcode >= 40 & indcode <= 43 ~ 16,
      TRUE ~ NA_real_
    ))
  }
  if (yr <= 1967) {
    # mostly 1962's codes plus one, but durable goods run to 16
    return(dplyr::case_when(
      indcode >= 1 & indcode <= 3 ~ 1,
      indcode == 4 ~ 2,
      indcode >= 5 & indcode <= 16 ~ 3,
      indcode >= 17 & indcode <= 21 ~ 4,
      indcode >= 22 & indcode <= 23 ~ 5,
      indcode >= 24 & indcode <= 25 ~ 6,
      indcode == 26 ~ 7,
      indcode == 28 ~ 8,
      (indcode >= 29 & indcode <= 32) | indcode == 40 ~ 9,
      indcode >= 33 & indcode <= 34 ~ 10,
      indcode %in% c(27, 35) ~ 11,
      indcode == 37 ~ 12,
      indcode == 36 ~ 13,
      indcode == 39 ~ 14,
      indcode == 38 ~ 15,
      indcode >= 41 & indcode <= 44 ~ 16,
      TRUE ~ NA_real_
    ))
  }
  dplyr::case_when(
    indcode %in% 16:18 | (indcode >= 126 & indcode <= 156) ~ 1,
    indcode == 196 ~ 2,
    indcode >= 206 & indcode <= 296 ~ 3,
    indcode >= 306 & indcode <= 459 ~ 4,
    indcode >= 506 & indcode <= 526 ~ 5,
    (indcode >= 536 & indcode <= 539) | (indcode >= 567 & indcode <= 579) ~ 6,
    indcode >= 606 & indcode <= 629 ~ 7,
    (indcode >= 636 & indcode <= 658) | (indcode >= 666 & indcode <= 696) ~ 8,
    (indcode >= 706 & indcode <= 736) | (indcode >= 806 & indcode <= 809) | indcode == 869 |
      (indcode >= 888 & indcode <= 898) ~ 9,
    indcode == 816 | (indcode >= 826 & indcode <= 839) ~ 10,
    indcode == 659 | (indcode >= 846 & indcode <= 849) ~ 11,
    indcode == 868 ~ 12,
    indcode == 867 ~ 13,
    indcode == 876 ~ 14,
    indcode == 879 ~ 15,
    indcode >= 906 & indcode <= 936 ~ 16,
    TRUE ~ NA_real_
  )
}

# Census detailed/major industry and occupation recodes from 2003; each
# script sets a different floor to missing (dind03/docc03 0 or less,
# mind03 below 1, mocc03 below 0)
recode_dind03_census_march <- function(m_a_dtind, year) march_recode_2003(m_a_dtind, year, 1)
recode_mind03_census_march <- function(m_a_mjind, year) march_recode_2003(m_a_mjind, year, 1)
recode_docc03_census_march <- function(m_a_dtocc, year) march_recode_2003(m_a_dtocc, year, 1)
recode_mocc03_census_march <- function(m_a_mjocc, year) march_recode_2003(m_a_mjocc, year, 0)
march_recode_2003 <- function(x, year, lowest) {
  dplyr::if_else(year >= 2003 & x >= lowest, as.numeric(x), NA_real_)
}
