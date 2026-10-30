# Release comparison (Phase 4.4): compare two folders of released .dta files
# (e.g. the R pipeline's output and the Stata pipeline's) file by file, as
# users receive them. Unlike the parity gate, which checks the pipeline's
# values against cached published data, this reads both sides' files from
# disk: which files exist, rows, column order, Stata storage types, labels,
# notes and the data label, plus values where requested.
# Run it with scripts/compare_release.R.

#' Value labels of every variable as "value=label; ..." strings (header only).
value_label_sets <- function(path) {
  header <- haven::read_dta(path, n_max = 0)
  purrr::map_chr(header, function(x) {
    labels <- attr(x, "labels")
    if (is.null(labels)) "" else paste(sort(paste0(unname(labels), "=", names(labels))), collapse = "; ")
  })
}

#' Compare one released .dta file with its counterpart. Returns one row per
#' check: check, variable, ok, and what each side has.
compare_release_file <- function(r_file, stata_file, registry, exceptions, values = FALSE) {
  sample <- sub("^epi_cps([a-z]+)_.*$", "\\1", basename(r_file))
  r <- read_dta_metadata(r_file)
  s <- read_dta_metadata(stata_file)
  row <- function(check, variable, ok, r_value, stata_value) {
    tibble::tibble(check = check, variable = variable, ok = ok, r = as.character(r_value), stata = as.character(stata_value))
  }

  # file-level checks; versions differ between builds, so the data label is
  # compared without its version number
  without_version <- function(label) sub("Version .*$", "Version", label)
  checks <- list(
    row("rows", "(file)", r$n == s$n, r$n, s$n),
    row("data label", "(file)", without_version(r$data_label) == without_version(s$data_label), r$data_label, s$data_label),
    row("column order", "(file)", identical(r$variables$variable, s$variables$variable),
        paste(r$variables$variable, collapse = " "), paste(s$variables$variable, collapse = " "))
  )

  # per-variable metadata, for variables both files have
  both <- dplyr::inner_join(r$variables, s$variables, by = "variable", suffix = c("_r", "_s"))
  label_sets_r <- value_label_sets(r_file)
  label_sets_s <- value_label_sets(stata_file)
  notes_text <- function(notes, v) paste(notes$text[notes$variable == v][order(notes$note[notes$variable == v])], collapse = " | ")
  checks <- c(checks, list(
    row("storage type", both$variable, both$type_r == both$type_s, both$type_r, both$type_s),
    row("variable label", both$variable, both$label_r == both$label_s, both$label_r, both$label_s),
    row("value label name", both$variable, both$value_label_r == both$value_label_s, both$value_label_r, both$value_label_s),
    row("value labels", both$variable, label_sets_r[both$variable] == label_sets_s[both$variable],
        label_sets_r[both$variable], label_sets_s[both$variable]),
    row("notes", both$variable,
        purrr::map_lgl(both$variable, ~ notes_text(r$notes, .x) == notes_text(s$notes, .x)),
        purrr::map_chr(both$variable, ~ notes_text(r$notes, .x)), purrr::map_chr(both$variable, ~ notes_text(s$notes, .x)))
  ))

  # values: read a batch of columns at a time from each .dta, as parity does
  if (values) {
    read_dta_columns <- function(path) function(cols) haven::zap_labels(haven::read_dta(path, col_select = dplyr::all_of(cols)))
    report <- compare_values(read_dta_columns(r_file), read_dta_columns(stata_file), s$variables$variable,
                             registry, sample, exceptions)
    mismatches <- report$n_missingness_mismatch + report$n_value_mismatch + report$n_not_whole
    checks <- c(checks, list(
      row("matched rows", "(file)", report$n_only_r[1] == 0 & report$n_only_stata[1] == 0,
          paste(report$n_only_r[1], "only in R"), paste(report$n_only_stata[1], "only in Stata")),
      row("values", report$variable, report$in_reference & dplyr::coalesce(mismatches, 0) == 0,
          sprintf("%s mismatches; %s excepted", dplyr::coalesce(mismatches, NA), dplyr::coalesce(report$n_excepted_mismatch, NA)),
          sprintf("%s compared", report$n_compared))
    ))
  }
  dplyr::bind_rows(checks) |>
    dplyr::mutate(file = basename(r_file), .before = 1)
}

#' Compare every released .dta file in two folders. Files only one side has
#' are reported; values are compared for the years in value_years (all
#' metadata checks run for every file).
compare_release_dirs <- function(r_dir, stata_dir, registry, exceptions, value_years = integer(0)) {
  pattern <- "^epi_cps(basic|org|may)_[0-9]{4}(_[0-9]+)?\\.dta$"
  r_files <- list.files(r_dir, pattern = pattern)
  stata_files <- list.files(stata_dir, pattern = pattern)
  inventory <- tibble::tibble(file = union(r_files, stata_files), check = "file present", variable = "(file)") |>
    dplyr::mutate(ok = file %in% r_files & file %in% stata_files,
                  r = ifelse(file %in% r_files, "yes", "no"), stata = ifelse(file %in% stata_files, "yes", "no"))
  # each R .dta should have its .feather alongside
  feathers <- tibble::tibble(file = r_files, check = "feather present", variable = "(file)",
                             ok = file.exists(file.path(r_dir, sub("\\.dta$", ".feather", r_files))), r = "", stata = "")
  common <- intersect(r_files, stata_files)
  file_checks <- purrr::map(common, ~ {
    year <- as.integer(sub("^epi_cps[a-z]+_([0-9]{4}).*$", "\\1", .x))
    compare_release_file(file.path(r_dir, .x), file.path(stata_dir, .x), registry, exceptions,
                         values = year %in% value_years)
  })
  dplyr::bind_rows(inventory, feathers, file_checks)
}
