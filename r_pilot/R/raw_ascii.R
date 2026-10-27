# Raw Census ASCII ingestion (replaces code/ado/process_rawbasic.ado).
# Each month is parsed once with EVERY dictionary column and cached as
# parquet, so adding a variable never re-parses raw files: recoding reads
# only the columns it needs from the cache.
#
# Not yet ported: the telework supplement merge (2022m10-2024m5, see
# process_rawbasic.ado). No ported variable uses it; see DEVIATIONS.md.

monthname_lut <- tolower(month.abb)

#' Scale a raw fixed-width numeric column by its dictionary-implied decimals.
#'
#' Census stores missing-data codes (-1 not in universe, -2 don't know,
#' -3 refused) as literal negative integers, even in fields whose format
#' implies decimals. Stata's infile turns those into missing in decimal
#' fields (it does not scale -1 to -0.01) and keeps them as-is in integer
#' fields. This reproduces that.
scale_numeric <- function(raw_chr, decimals) {
  x <- suppressWarnings(as.numeric(raw_chr))
  if (decimals == 0) return(x)
  is_sentinel <- !is.na(x) & x < 0
  out <- x / 10^decimals
  out[is_sentinel] <- NA_real_
  out
}

#' Copy of a raw file (unzipped if needed) with NUL bytes replaced by spaces.
#'
#' Some 1994-1997 files have NUL bytes inside records (e.g. 4,286 in
#' jan94pub, in the gecmsa field). readr splits a line at a NUL, creating
#' extra blank rows and losing the rest of the record; Stata's infile reads
#' the record whole and the field as missing. A space gives the same: a
#' blank field, read as missing.
without_nul_bytes <- function(file) {
  con <- if (grepl("\\.zip$", file)) unz(file, utils::unzip(file, list = TRUE)$Name[1], "rb") else file(file, "rb")
  on.exit(close(con))
  bytes <- readBin(con, "raw", n = 2e9)
  if (!any(bytes == as.raw(0))) return(file)
  bytes[bytes == as.raw(0)] <- charToRaw(" ")
  cleaned <- tempfile(fileext = ".dat")
  writeBin(bytes, cleaned)
  cleaned
}

#' Read fixed-width columns from a file using a parsed dictionary, converting
#' strings (trimmed) and numerics (scaled) per the dictionary.
read_fwf_dictionary <- function(file, dict) {
  positions <- readr::fwf_positions(dict$start, dict$end, col_names = dict$varname)
  # read everything as character first so decimal scaling stays explicit
  data <- readr::read_fwf(without_nul_bytes(file), positions, col_types = readr::cols(.default = readr::col_character()))
  for (i in seq_len(nrow(dict))) {
    v <- dict$varname[i]
    data[[v]] <- if (dict$type[i] == "string") trimws(data[[v]]) else scale_numeric(data[[v]], dict$decimals[i])
  }
  data
}

#' Raw input files for one year: the monthly pub.zips, plus the yearly
#' reweight archive in reweight years. Tracked as file targets.
raw_zip_paths <- function(year, config) {
  shortyear <- sprintf("%02d", year %% 100)
  months <- year_months(year, config)
  zips <- file.path(config$paths$raw_ascii, sprintf("%s%spub.zip", monthname_lut[months], shortyear))
  if (year %in% config$reweight_years) {
    zips <- c(zips, file.path(config$paths$raw_ascii, sprintf("rw%s.zip", shortyear)))
  }
  zips
}

#' Census-2000-based reweights for one month (reweight years only).
#'
#' Reweight zips are yearly archives with one .dat per month, so the member
#' is extracted first. The main dictionaries type qstnum/occurnum as strings
#' and the reweight dictionaries as numeric; both are made strings before
#' joining, as process_rawbasic.ado does with tostring.
read_reweight_month <- function(year, month, config) {
  shortyear <- sprintf("%02d", year %% 100)
  month2d <- sprintf("%02d", month)
  rw_dict <- parse_dictionary(file.path(config$paths$dictionaries, "reweights", sprintf("rw%s%s.dct", shortyear, month2d)))

  exdir <- tempfile()
  dir.create(exdir)
  on.exit(unlink(exdir, recursive = TRUE), add = TRUE)
  rw_dat <- utils::unzip(file.path(config$paths$raw_ascii, sprintf("rw%s.zip", shortyear)),
                         files = sprintf("rw%s%s.dat", shortyear, month2d), exdir = exdir)

  rw_data <- read_fwf_dictionary(rw_dat, rw_dict)
  # numeric ids -> the same string form the main file uses
  rw_data |>
    dplyr::mutate(dplyr::across(c(qstnum, occurnum), ~ as.character(as.integer(round(.x)))))
}

#' Parse one month (all dictionary columns) and merge reweights where they apply.
#'
#' The reweight merge replicates Stata's `merge 1:1 ... assert(2 3); keep if
#' _merge == 3`: every main row must find a reweight row (hard stop if not);
#' reweight-only rows are dropped.
parse_raw_month <- function(year, month, config) {
  shortyear <- sprintf("%02d", year %% 100)
  month_zip <- file.path(config$paths$raw_ascii, sprintf("%s%spub.zip", monthname_lut[month], shortyear))
  dict <- parse_dictionary(file.path(config$paths$dictionaries, paste0(select_dictionary(year, month), ".dct")))
  month_data <- read_fwf_dictionary(month_zip, dict)
  # sanity check from 1998: in 1994-1997 hrmonth has stray values and blank
  # records, which is why year/month come from the file date (as in Stata)
  if (year >= 1998) stopifnot(all(month_data$hrmonth == month))

  if (year %in% config$reweight_years) {
    rw_keys <- c("qstnum", "hryear4", "hrmonth", "occurnum")
    rw_data <- read_reweight_month(year, month, config)
    # keep only reweight columns the main file doesn't already have
    rw_data <- rw_data[, c(rw_keys, setdiff(names(rw_data), names(month_data)))]
    n_before <- nrow(month_data)
    month_data <- dplyr::inner_join(month_data, rw_data, by = rw_keys)
    if (nrow(month_data) < n_before) {
      stop(sprintf("reweight merge: %d of %d rows found no reweight match (%d-%02d)",
                   n_before - nrow(month_data), n_before, year, month))
    }
  }
  month_data
}

#' Parse every month of one year into the parquet cache; returns the paths.
parse_raw_year <- function(year, raw_zips, config) {
  out_dir <- file.path(config$paths$cache, "raw")
  fs::dir_create(out_dir)
  purrr::map_chr(year_months(year, config), ~ {
    out_file <- file.path(out_dir, sprintf("%d_%02d.parquet", year, .x))
    arrow::write_parquet(parse_raw_month(year, .x, config), out_file)
    out_file
  })
}

# columns read_raw_year() adds from the cached file name (YYYY_MM.parquet):
# year and month come from the file, as in Stata (year(dofm($date)))
file_date_columns <- c("file_year", "file_month")

#' Read selected raw columns for one or more months from the parquet cache.
#' Columns a month's dictionary doesn't have (era-specific names like
#' peage/prtage) come back as NA, so recode functions never check column
#' existence.
read_raw_year <- function(raw_files, columns) {
  # months missing a column get NA for it when stacked
  data <- raw_files |>
    purrr::map(~ {
      date <- as.integer(strsplit(sub("\\.parquet$", "", basename(.x)), "_")[[1]])
      arrow::read_parquet(.x, col_select = dplyr::any_of(columns)) |>
        dplyr::mutate(file_year = date[1], file_month = date[2])
    }) |>
    dplyr::bind_rows()
  # columns no month of this year has
  for (col in setdiff(columns, names(data))) data[[col]] <- NA_real_
  data
}
