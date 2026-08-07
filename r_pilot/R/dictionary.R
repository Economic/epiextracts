# NBER Stata-dictionary (.dct) parsing for the raw Census ASCII ingestion
# port (replaces code/ado/process_rawbasic.ado / process_censusbasic).

#' Parse a Stata-style fixed-width dictionary into a tibble of column specs.
#'
#' Generic -- extracts every `_column(...)` line in the file; callers filter
#' down to the columns they need. Every dictionary vintage confirmed to use
#' exactly this one line format (no multi-line entries, no conditionals), so
#' a single regex covers all of them. Width/decimals are derived from the
#' %FORMAT spec (e.g. %15s = 15-char string; %10.4f = 10-char numeric field
#' with 4 implied decimal places), not stated separately.
parse_dictionary <- function(dct_path) {
  lines <- readLines(dct_path, warn = FALSE)
  pat <- "^\\s*_column\\(\\s*(\\d+)\\s*\\)\\s+(str\\d+|byte|int|long|double)\\s+(\\S+)\\s+%(\\d+)(?:\\.(\\d+))?([a-zA-Z])\\s+\"(.*)\"\\s*$"
  m <- stringr::str_match(lines, pat)
  m <- m[!is.na(m[, 1]), , drop = FALSE]

  start    <- as.integer(m[, 2])
  width    <- as.integer(m[, 5])
  decimals <- ifelse(is.na(m[, 6]), 0L, as.integer(m[, 6]))
  fmt      <- m[, 7]

  tibble::tibble(
    varname    = tolower(m[, 4]),
    start      = start,
    end        = start + width - 1L,
    type       = ifelse(fmt %in% c("s", "S"), "string", "numeric"),
    decimals   = decimals,
    stata_type = m[, 3]
  )
}

#' Select the NBER dictionary vintage for a given year/month, replicating
#' process_rawbasic.ado's date-range table exactly (Basic Monthly, 2000-2024).
#'
#' Uses an integer month-index (year*12 + month), not Date arithmetic --
#' as.Date() range boundaries are a real footgun here (e.g. "2021-02-29"
#' silently returns NA since 2021 isn't a leap year, breaking whatever
#' comparison used it). The month-index approach mirrors Stata's own tm()
#' and sidesteps this whole class of calendar bugs.
#'
#' cpsbjun2024's upper bound is left open-ended rather than replicating
#' Stata's hardcoded tm(2026m5) cap -- that cap reads as "as far as tested
#' when written," not a real format boundary confirmed by data. A new
#' vintage row gets added here when Census next changes the raw layout,
#' same as every prior transition.
select_dictionary <- function(year, month) {
  mi <- function(y, m) y * 12L + (m - 1L)
  target <- mi(year, month)

  dictionary_table <- tibble::tribble(
    ~start_mi,    ~end_mi,       ~dict,
    mi(2024, 6),  Inf,            "cpsbjun2024",
    mi(2021, 3),  mi(2024, 5),    "cpsbmar2021",
    mi(2020, 1),  mi(2021, 2),    "cpsbjan2020",
    mi(2017, 1),  mi(2019, 12),   "cpsbjan2017",
    mi(2015, 1),  mi(2016, 12),   "cpsbjan2015",
    mi(2014, 4),  mi(2014, 12),   "cpsbapr2014",
    mi(2014, 1),  mi(2014, 3),    "cpsbjan2014",
    mi(2013, 1),  mi(2013, 12),   "cpsbjan13",
    mi(2012, 5),  mi(2012, 12),   "cpsbmay12",
    mi(2010, 1),  mi(2012, 4),    "cpsbjan10",
    mi(2009, 1),  mi(2009, 12),   "cpsbjan09",
    mi(2007, 1),  mi(2008, 12),   "cpsbjan07",
    mi(2005, 8),  mi(2006, 12),   "cpsbaug05",
    mi(2004, 5),  mi(2005, 7),    "cpsbmay04",
    mi(2003, 1),  mi(2004, 4),    "cpsbjan03",
    mi(1998, 1),  mi(2002, 12),   "cpsbjan98"
  )

  hit <- dictionary_table[dictionary_table$start_mi <= target & target <= dictionary_table$end_mi, ]
  if (nrow(hit) != 1) {
    stop(sprintf("No unique dictionary vintage for %d-%02d (matched %d rows)", year, month, nrow(hit)))
  }
  hit$dict[[1]]
}
