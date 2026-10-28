# Parity gate: compare the R extracts against the published Stata extracts.
# Values are checked per variable with registry tolerances, against the
# released .feather files; labels, column
# order and the dataset label are checked against the published metadata.
# parity_gate() stops the build if anything doesn't match, except documented
# exceptions (parity_exceptions.csv), which are reported but allowed.

# unique in every year; personid is missing before 1998, pulineno is not
join_keys <- c("year", "month", "hrhhid", "hhid", "pulineno")

#' Published Stata extract(s) for one year and sample: the annual file, or
#' the monthly files for a partial year (spec: see build_year_spec()).
reference_dta_path <- function(spec, sample, config) {
  dir <- file.path(config$paths$reference, sample, "epi")
  if (spec$partial) {
    return(file.path(dir, sprintf("epi_cps%s_%d_%d.dta", sample, spec$year, spec$months)))
  }
  file.path(dir, sprintf("epi_cps%s_%d.dta", sample, spec$year))
}

#' Cache one year's published values as parquet (labels dropped), so the
#' large .dta files are read once rather than on every recode change.
cache_reference_year <- function(dta_paths, cache_dir) {
  out_dir <- file.path(cache_dir, "reference")
  fs::dir_create(out_dir)
  # monthly files of a partial year go into one parquet named for the year
  out_file <- file.path(out_dir, sub("^(epi_cps[a-z]+_[0-9]{4}).*$", "\\1.parquet", basename(dta_paths[1])))
  dta_paths |>
    purrr::map(~ haven::read_dta(.x) |> haven::zap_labels() |> haven::zap_formats()) |>
    dplyr::bind_rows() |>
    arrow::write_parquet(out_file)
  out_file
}

#' Published metadata: column order, variable labels, value labels, data label.
reference_metadata <- function(dta_paths) {
  # monthly files of a partial year share one layout; the first stands for all
  header <- haven::read_dta(dta_paths[1], n_max = 0)
  value_labels <- names(header) |>
    purrr::map(~ {
      labels <- attr(header[[.x]], "labels")
      if (is.null(labels)) return(NULL)
      tibble::tibble(variable = .x, value = unname(as.numeric(labels)), label = names(labels))
    }) |>
    dplyr::bind_rows()
  list(
    columns = names(header),
    var_labels = purrr::map_chr(header, ~ attr(.x, "label") %||% ""),
    value_labels = value_labels,
    data_label = attr(header, "label") %||% ""
  )
}

#' Known differences from the published extracts (parity_exceptions.csv):
#' variable, sample, months (from/to, e.g. 2022m10) and why. Rows in those
#' months are reported separately and don't fail the gate.
read_parity_exceptions <- function(exceptions_file) {
  to_ym <- function(x) purrr::map_dbl(x, ~ { d <- as.numeric(strsplit(.x, "m")[[1]]); ym(d[1], d[2]) })
  readr::read_csv(exceptions_file, col_types = "ccccc") |>
    dplyr::mutate(from = to_ym(from), to = to_ym(to))
}

#' Compare one year's values: rows matched on the join keys, then every
#' exported column with its registry tolerance. Columns with tolerance 0
#' must also be whole numbers in R (they are byte/int/long in Stata); string
#' columns must be equal.
#'
#' Reads the released .feather files (r_files: one per year, or one per month
#' of a partial year) and the cached published year a batch of columns at a
#' time, so memory stays at the keys plus one batch from each side (about
#' 1 GB) rather than two whole years.
compare_values_year <- function(r_files, reference_parquet, registry, sample, exceptions, batch_size = 20) {
  columns <- export_columns(registry, sample)
  reference_columns <- names(arrow::open_dataset(reference_parquet)$schema)
  # one or more columns from each side, as plain vectors (labels dropped)
  read_r <- function(cols) {
    purrr::map(r_files, ~ arrow::read_feather(.x, col_select = dplyr::all_of(cols))) |>
      dplyr::bind_rows() |>
      haven::zap_labels()
  }
  read_reference <- function(cols) arrow::read_parquet(reference_parquet, col_select = dplyr::all_of(cols))

  # match rows once on the keys; row positions then line up every column
  r_keys <- dplyr::mutate(read_r(join_keys), .r = dplyr::row_number())
  s_keys <- dplyr::mutate(read_reference(join_keys), .s = dplyr::row_number())
  matched <- dplyr::inner_join(r_keys, s_keys, by = join_keys)
  n_only_r <- sum(!r_keys$.r %in% matched$.r)
  n_only_stata <- sum(!s_keys$.s %in% matched$.s)
  n_r_rows <- nrow(r_keys)
  n_stata_rows <- nrow(s_keys)
  date <- ym(matched$year, matched$month)
  rm(r_keys, s_keys)

  # keys match by construction; compare everything else, a batch of columns at a time
  compare_column <- function(v, r_col, s_col) {
    tol <- registry$tolerance[registry$variable == v]
    # rows in a documented exception window are counted apart
    windows <- exceptions[exceptions$variable == v & exceptions$sample == sample, ]
    excepted <- purrr::reduce(purrr::map2(windows$from, windows$to, ~ date >= .x & date <= .y),
                              `|`, .init = rep(FALSE, length(date)))
    missingness <- is.na(r_col) != is.na(s_col)
    both <- !is.na(r_col) & !is.na(s_col)
    differs <- if (is.character(r_col)) both & r_col != s_col else both & abs(r_col - s_col) > tol
    not_whole <- if (tol == 0 && is.numeric(r_col)) both & r_col != round(r_col) else rep(FALSE, length(both))
    tibble::tibble(
      variable = v,
      in_reference = TRUE,
      n_compared = sum(!excepted),
      n_missingness_mismatch = sum(missingness & !excepted),
      n_value_mismatch = sum(differs & !excepted),
      n_not_whole = sum(not_whole & !excepted),
      n_excepted = sum(excepted),
      n_excepted_mismatch = sum((missingness | differs) & excepted)
    )
  }
  to_compare <- setdiff(columns, join_keys)
  missing_from_reference <- setdiff(to_compare, reference_columns)
  in_both <- intersect(to_compare, reference_columns)
  report <- split(in_both, ceiling(seq_along(in_both) / batch_size)) |>
    purrr::map(function(batch) {
      r_batch <- read_r(batch)
      s_batch <- read_reference(batch)
      purrr::map(batch, ~ compare_column(.x, r_batch[[.x]][matched$.r], s_batch[[.x]][matched$.s]))
    }) |>
    purrr::list_flatten() |>
    c(purrr::map(missing_from_reference, ~ tibble::tibble(variable = .x, in_reference = FALSE))) |>
    dplyr::bind_rows()

  dplyr::mutate(report, sample = sample, year = unique(matched$year), n_r_rows = n_r_rows,
                n_stata_rows = n_stata_rows, n_only_r = n_only_r, n_only_stata = n_only_stata, .before = 1)
}

#' Compare the extract's metadata spec (registry labels, value_labels.csv,
#' column order, data label) with one year's published metadata.
compare_metadata_year <- function(reference_meta, registry, value_labels, sample, year, label) {
  columns <- export_columns(registry, sample)
  in_reference <- columns[columns %in% reference_meta$columns]

  # value labels as "value=label" strings, so sets can be compared
  label_set <- function(d, v) {
    rows <- d[d$variable == v, ]
    paste(sort(paste0(rows$value, "=", rows$label)), collapse = "; ")
  }

  checks <- dplyr::bind_rows(
    tibble::tibble(
      check = "variable label",
      variable = in_reference,
      published = unname(reference_meta$var_labels[in_reference]),
      r = registry$label[match(in_reference, registry$variable)]
    ),
    tibble::tibble(
      check = "value labels",
      variable = in_reference,
      published = purrr::map_chr(in_reference, ~ label_set(reference_meta$value_labels, .x)),
      r = purrr::map_chr(in_reference, ~ label_set(value_labels, .x))
    ),
    tibble::tibble(
      check = "column order",
      variable = "(all)",
      # R's columns must appear in the same relative order as published
      published = paste(intersect(reference_meta$columns, in_reference), collapse = " "),
      r = paste(in_reference, collapse = " ")
    ),
    tibble::tibble(
      check = "data label",
      variable = "(dataset)",
      # versions differ between builds; compare the rest of the label
      published = sub("Version .*$", "Version", reference_meta$data_label),
      r = sub("Version .*$", "Version", label)
    )
  )
  dplyr::mutate(checks, sample = sample, year = year, ok = published == r, .before = 1)
}

#' Stop the build if any value or metadata check failed; otherwise return a
#' one-row-per-variable summary.
parity_gate <- function(value_report, metadata_report) {
  value_failures <- value_report |>
    dplyr::filter(!in_reference | n_only_r > 0 | n_only_stata > 0 |
                    n_missingness_mismatch > 0 | n_value_mismatch > 0 | n_not_whole > 0)
  metadata_failures <- dplyr::filter(metadata_report, !ok)

  if (nrow(value_failures) > 0 || nrow(metadata_failures) > 0) {
    # one line per failing variable, with the years it fails in
    year_span <- function(year) paste(min(year), max(year), sep = "-")
    print_rows <- function(d) paste(utils::capture.output(print(as.data.frame(d))), collapse = "\n")
    value_summary <- if (nrow(value_failures) > 0) {
      dplyr::summarise(value_failures, years = year_span(year),
                       mismatches = sum(n_missingness_mismatch + n_value_mismatch + n_not_whole, na.rm = TRUE),
                       .by = c(sample, variable))
    }
    metadata_summary <- if (nrow(metadata_failures) > 0) {
      dplyr::summarise(metadata_failures, years = year_span(year), .by = c(sample, check, variable))
    }
    stop(
      "parity gate failed (details in reports/parity_*.csv)\n",
      if (!is.null(value_summary)) paste0("values:\n", print_rows(value_summary), "\n"),
      if (!is.null(metadata_summary)) paste0("metadata:\n", print_rows(metadata_summary)),
      call. = FALSE
    )
  }
  dplyr::summarise(value_report, years = dplyr::n_distinct(year), rows_compared = sum(n_compared),
                   excepted_mismatches = sum(n_excepted_mismatch), .by = c(sample, variable))
}
