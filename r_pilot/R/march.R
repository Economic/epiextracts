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
