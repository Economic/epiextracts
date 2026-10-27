# Parity gate: compare the R extracts against the published Stata extracts.
# Values are checked per variable with registry tolerances; labels, column
# order and the dataset label are checked against the published metadata.
# parity_gate() stops the build if anything doesn't match.

# unique in every year; personid is missing before 1998, pulineno is not
join_keys <- c("year", "month", "hrhhid", "hhid", "pulineno")

#' Published Stata extract(s) for one year and sample: the annual file, or
#' the monthly files for a partial year.
reference_dta_path <- function(year, sample, config) {
  dir <- file.path(config$paths$reference, sample, "epi")
  if (is_partial_year(year, config)) {
    return(file.path(dir, sprintf("epi_cps%s_%d_%d.dta", sample, year, year_months(year, config))))
  }
  file.path(dir, sprintf("epi_cps%s_%d.dta", sample, year))
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

#' Compare one year's values: rows matched on the join keys, then every
#' exported column with its registry tolerance. Columns with tolerance 0
#' must also be whole numbers in R (they are byte/int/long in Stata).
compare_values_year <- function(r_year, reference_parquet, registry, sample) {
  columns <- export_columns(registry, sample)
  reference <- arrow::read_parquet(reference_parquet, col_select = dplyr::any_of(columns))
  r_year <- r_year[, columns]

  matched <- dplyr::inner_join(r_year, reference, by = join_keys, suffix = c("_r", "_stata"))
  n_only_r <- nrow(dplyr::anti_join(r_year, reference, by = join_keys))
  n_only_stata <- nrow(dplyr::anti_join(reference, r_year, by = join_keys))

  # keys match by construction; compare everything else
  purrr::map(setdiff(columns, join_keys), function(v) {
    tol <- registry$tolerance[registry$variable == v]
    if (!v %in% names(reference)) {
      return(tibble::tibble(variable = v, in_reference = FALSE))
    }
    r_col <- matched[[paste0(v, "_r")]]
    s_col <- matched[[paste0(v, "_stata")]]
    missingness <- is.na(r_col) != is.na(s_col)
    both <- !is.na(r_col) & !is.na(s_col)
    tibble::tibble(
      variable = v,
      in_reference = TRUE,
      n_compared = nrow(matched),
      n_missingness_mismatch = sum(missingness),
      n_value_mismatch = sum(abs(r_col[both] - s_col[both]) > tol),
      n_not_whole = if (tol == 0) sum(r_col[both] != round(r_col[both])) else 0L
    )
  }) |>
    dplyr::bind_rows() |>
    dplyr::mutate(sample = sample, year = unique(r_year$year), n_r_rows = nrow(r_year),
                  n_stata_rows = nrow(reference), n_only_r = n_only_r, n_only_stata = n_only_stata, .before = 1)
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
                   .by = c(sample, variable))
}
