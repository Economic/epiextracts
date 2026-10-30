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
