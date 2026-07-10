# Raw columns needed across the whole recode scope. dplyr::any_of() means a
# file missing a column (e.g. no nwcmpwgt after 2002) simply omits it instead
# of erroring, since column names/positions shift across dictionary vintages.
raw_cols_needed <- c(
  # identifiers / core demographics / basic weight (Phase 1)
  "hrhhid", "hryear4", "hrmonth", "qstnum", "occurnum",
  "pesex", "pemlr", "peage", "prtage", "pwcmpwgt", "nwcmpwgt",
  # ORG membership + weight
  "hrmis", "pworwgt", "nworwgt",
  # wage_noadj / weekpay_noadj dependency chain
  "peernhry", "pehrusl1", "prhrusl", "peernhro",
  "prernhly", "pternhly", "prernwa", "pternwa",
  # tc_fix.do topcode flag (2023m4+)
  "ptwk",
  # 8 internal-only regressors feeding hoursu1i's imputation
  "peeduca", "perace", "ptdtrace", "prdtrace", "prorigin", "prdthsp",
  "prcitshp", "prmarsta", "gestfips", "peernlab", "peerncov", "peio1cow", "peio1icd"
)

#' Read one year's 12 monthly .dta.zip files and stack them into one table.
#'
#' peage/prtage never co-occur within a single month's file (the raw variable
#' was renamed circa May 2012), but do co-occur across a year that spans the
#' boundary -- bind_rows() naturally fills the absent column with NA for the
#' months where it wasn't present, so no special-casing is needed here.
read_raw_year <- function(year, raw_source_dir) {
  month_paths <- file.path(raw_source_dir, sprintf("cps_%d_%d.dta.zip", year, 1:12))

  raw <- purrr::map_dfr(month_paths, function(path) {
    d <- haven::read_dta(path, col_select = dplyr::any_of(raw_cols_needed))
    # sanity check: file's own year should match the requested batch
    stopifnot(all(d$hryear4 == year))
    d
  })

  # backfill columns that are entirely absent for this year (e.g. nwcmpwgt
  # outside 2000-2002, or an era-split column whose sibling covers the whole
  # year) so recode_year()/downstream code never has to check column existence
  backfill_cols <- c(
    "peage", "prtage", "nwcmpwgt", "nworwgt",
    "prernhly", "pternhly", "prernwa", "pternwa", "ptwk",
    "perace", "ptdtrace", "prdtrace", "prorigin", "prdthsp"
  )
  for (col in backfill_cols) {
    if (!col %in% names(raw)) raw[[col]] <- NA_real_
  }

  raw
}
