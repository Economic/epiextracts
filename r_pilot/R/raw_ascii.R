# Raw Census ASCII ingestion (replaces code/ado/process_rawbasic.ado /
# process_censusbasic). Parses the fixed-width monthly files directly via
# the NBER dictionaries -- no Stata step in between. Reads only the 36
# columns in raw_cols_needed (R/load.R); the parser itself (dictionary.R)
# is generic and would support reading more columns later without new
# architecture. This is now recode_year()'s sole raw-data source -- it was
# validated (925 checks, 0 mismatches, full 2000-2024) against the
# Stata-converted intermediate before that intermediate was retired from
# the pipeline.
#
# Known, documented exclusion: the telework-COVID supplement merge
# (Oct 2022-May 2024, code/ado/process_rawbasic.ado's twoct2022/twdec2023
# branch) is NOT ported here -- the raw supplement files don't exist
# anywhere on disk, and none of the currently-ported variables depend on
# telework-derived columns.

monthname_lut <- tolower(month.abb)

#' Scale a raw fixed-width numeric column by its dictionary-implied decimals.
#'
#' Census/NBER convention (confirmed empirically against real Stata `infile
#' using <dct>`): missing-data sentinel codes (-1 not-in-universe, -2 don't
#' know, -3 refused) are stored as literal small negative integers in the
#' raw ASCII, even in fields whose format implies decimal places for genuine
#' values (e.g. %4.2f: raw "800" -> 8.00). For those decimal fields, Stata's
#' infile converts a raw negative value to MISSING -- it does NOT scale it
#' (-1 does not become -0.01). Integer-format fields (decimals == 0) are
#' unaffected; Stata keeps -1/-2/-3 there as literal integers. This only
#' matters for the 8 of 36 columns with decimals > 0 (the weight/earnings
#' columns) -- the other 28 already match without this rule.
scale_numeric <- function(raw_chr, decimals) {
  x <- suppressWarnings(as.numeric(raw_chr))
  if (decimals == 0) return(x)
  is_sentinel <- !is.na(x) & x < 0
  out <- x / 10^decimals
  out[is_sentinel] <- NA_real_
  out
}

#' Read one month's raw Census ASCII fixed-width file, filtered to
#' raw_cols_needed, plus the 2000-2002 reweight merge where applicable.
read_raw_ascii_month <- function(year, month, raw_ascii_dir, dictionaries_dir) {
  shortyear <- sprintf("%02d", year %% 100)
  month_zip <- file.path(raw_ascii_dir, sprintf("%s%spub.zip", monthname_lut[month], shortyear))

  dict_name <- select_dictionary(year, month)
  dict <- parse_dictionary(file.path(dictionaries_dir, paste0(dict_name, ".dct")))
  wanted <- dict[dict$varname %in% raw_cols_needed, ]

  # readr::read_fwf() reads directly from a single-file .zip with no unzip
  # step needed, matching haven::read_dta()'s existing .dta.zip behavior.
  # Read everything as character first so decimal scaling stays explicit.
  positions <- readr::fwf_positions(wanted$start, wanted$end, col_names = wanted$varname)
  month_data <- readr::read_fwf(month_zip, positions, col_types = readr::cols(.default = readr::col_character()))

  for (i in seq_len(nrow(wanted))) {
    v <- wanted$varname[i]
    month_data[[v]] <- if (wanted$type[i] == "string") {
      trimws(month_data[[v]])
    } else {
      scale_numeric(month_data[[v]], wanted$decimals[i])
    }
  }

  if (year >= 2000 && year <= 2002) {
    month_data <- merge_reweight(month_data, year, month, raw_ascii_dir, dictionaries_dir)
  }

  month_data
}

#' 2000-2002 only: merge the Census-2000-based reweight file's nwcmpwgt/
#' nworwgt onto the main month's data.
#'
#' Reweight zips (rw<yy>.zip) are yearly archives containing one .dat member
#' per month -- unlike the single-file monthly pub.zips, so read_fwf() can't
#' target a member directly; extract via utils::unzip() first. The main
#' dictionaries type qstnum/occurnum as strings, the reweight dictionaries as
#' numeric -- coerced to matching string form before joining, mirroring
#' Stata's own explicit tostring() calls in process_censusbasic.
#'
#' Replicates Stata's `merge 1:1 ... assert(2 3); keep if _merge==3`: every
#' main-file row must find a reweight match (a hard stop() if not, matching
#' Stata's assert strictness); reweight-only rows are silently dropped.
merge_reweight <- function(month_data, year, month, raw_ascii_dir, dictionaries_dir) {
  shortyear <- sprintf("%02d", year %% 100)
  month2d <- sprintf("%02d", month)
  rw_zip <- file.path(raw_ascii_dir, sprintf("rw%s.zip", shortyear))
  rw_dat_name <- sprintf("rw%s%s.dat", shortyear, month2d)
  rw_dict <- parse_dictionary(file.path(dictionaries_dir, "reweights", sprintf("rw%s%s.dct", shortyear, month2d)))

  rw_keys <- c("qstnum", "hryear4", "hrmonth", "occurnum")
  rw_wanted <- rw_dict[rw_dict$varname %in% c(rw_keys, "nwcmpwgt", "nworwgt"), ]
  positions <- readr::fwf_positions(rw_wanted$start, rw_wanted$end, col_names = rw_wanted$varname)

  exdir <- tempfile()
  dir.create(exdir)
  on.exit(unlink(exdir, recursive = TRUE), add = TRUE)
  rw_dat <- utils::unzip(rw_zip, files = rw_dat_name, exdir = exdir)
  rw_data <- readr::read_fwf(rw_dat, positions, col_types = readr::cols(.default = readr::col_character()))

  for (i in seq_len(nrow(rw_wanted))) {
    v <- rw_wanted$varname[i]
    rw_data[[v]] <- if (v %in% c("qstnum", "occurnum")) {
      as.character(as.integer(round(as.numeric(rw_data[[v]]))))
    } else {
      scale_numeric(rw_data[[v]], rw_wanted$decimals[i])
    }
  }

  n_before <- nrow(month_data)
  merged <- dplyr::inner_join(month_data, rw_data, by = rw_keys)
  if (nrow(merged) < n_before) {
    stop(sprintf(
      "reweight merge: %d of %d main rows found no reweight match (year=%d month=%d)",
      n_before - nrow(merged), n_before, year, month
    ))
  }
  merged
}

#' Read one year's 12 monthly raw Census ASCII files and stack them, backfilling
#' structurally-absent columns exactly like the retired Stata-intermediate
#' reader did, so recode_year() never has to check column existence itself.
read_raw_ascii_year <- function(year, raw_ascii_dir, dictionaries_dir) {
  raw <- purrr::map_dfr(1:12, function(m) {
    d <- read_raw_ascii_month(year, m, raw_ascii_dir, dictionaries_dir)
    stopifnot(all(d$hryear4 == year))
    d
  })

  for (col in backfill_cols) {
    if (!col %in% names(raw)) raw[[col]] <- NA_real_
  }

  raw
}
