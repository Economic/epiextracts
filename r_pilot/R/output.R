# Writing extracts: exported columns in registry order, with variable labels,
# value labels and the dataset label, as .feather and as Stata .dta (R/dta.R),
# so both carry the same values and metadata as the Stata-made extracts.

#' Store a numeric column as the published files do: whole numbers as
#' integers, other values at float precision (Stata's float, which the
#' published .dta and the .feather made from it hold). Keeps the .dta and
#' .feather values identical.
store_values <- function(x) {
  if (!is.numeric(x)) return(x)
  v <- x[!is.na(x)]
  if (all(v == round(v)) && all(abs(v) < .Machine$integer.max)) return(as.integer(x))
  float_round(x)
}

#' Select, store and label one sample's exported columns.
label_extract <- function(data, registry, value_labels, sample, label) {
  columns <- export_columns(registry, sample)
  data <- data[, columns]
  for (v in columns) {
    data[[v]] <- store_values(data[[v]])
    labels <- value_labels[value_labels$variable == v, ]
    # value labels where defined (same storage type as the column), then the variable label
    if (nrow(labels) > 0) {
      values <- if (is.integer(data[[v]])) as.integer(labels$value) else labels$value
      data[[v]] <- haven::labelled(data[[v]], labels = stats::setNames(values, labels$label))
    }
    attr(data[[v]], "label") <- registry$label[registry$variable == v]
  }
  attr(data, "label") <- label
  data
}

#' Write one year's labelled extract as .feather or .dta: one annual file, or
#' one file per month for a partial year (epi_cps<sample>_<year>_<month>.<ext>,
#' as Stata does). .dta files also carry the variables' notes; `uncompressed`
#' lists the wages-stage variables, which Stata's annual files store as float
#' (see write_stata_dta()). A partial year's monthly files are compressed
#' after the wage adjustments (create_extracts.ado), so there they shrink too.
write_extract <- function(data, sample, output_dir, spec, format = c("feather", "dta"), notes = NULL,
                          uncompressed = character(0)) {
  format <- match.arg(format)
  write_file <- function(d, file) {
    fs::dir_create(fs::path_dir(file))
    if (format == "feather") arrow::write_feather(d, file) else write_stata_dta(d, file, notes, uncompressed = uncompressed)
    file
  }
  yr <- spec$year
  if (spec$partial) uncompressed <- character(0)
  if (!spec$partial) {
    return(write_file(data, file.path(output_dir, sprintf("epi_cps%s_%d.%s", sample, yr, format))))
  }
  purrr::map_chr(sort(unique(data$month)), ~ {
    # filtering keeps the column labels; the data label is copied over
    month_data <- data[data$month == .x, ]
    attr(month_data, "label") <- attr(data, "label")
    write_file(month_data, file.path(output_dir, sprintf("epi_cps%s_%d_%d.%s", sample, yr, .x, format)))
  })
}

create_csv <- function(data, file) {
  fs::dir_create(fs::path_dir(file))
  readr::write_csv(data, file)
  file
}
