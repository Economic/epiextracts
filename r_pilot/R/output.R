# Writing extracts: exported columns in registry order, with variable labels,
# value labels and the dataset label, so .feather (and later .dta) files carry
# the same metadata as the Stata-made extracts.

#' Select and label one sample's exported columns.
label_extract <- function(data, registry, value_labels, sample, label) {
  columns <- export_columns(registry, sample)
  data <- data[, columns]
  for (v in columns) {
    labels <- value_labels[value_labels$variable == v, ]
    # value labels where defined, then the variable label
    if (nrow(labels) > 0) {
      data[[v]] <- haven::labelled(data[[v]], labels = stats::setNames(labels$value, labels$label))
    }
    attr(data[[v]], "label") <- registry$label[registry$variable == v]
  }
  attr(data, "label") <- label
  data
}

#' Write one year's labelled extract: one annual file, or one file per month
#' for a partial year (epi_cps<sample>_<year>_<month>.feather, as Stata does).
write_extract <- function(data, sample, output_dir, config) {
  yr <- unique(data$year)
  if (!is_partial_year(yr, config)) {
    return(create_feather(data, file.path(output_dir, sprintf("epi_cps%s_%d.feather", sample, yr))))
  }
  purrr::map_chr(sort(unique(data$month)), ~ {
    # filtering keeps the column labels and the data label
    month_data <- data[data$month == .x, ]
    attr(month_data, "label") <- attr(data, "label")
    create_feather(month_data, file.path(output_dir, sprintf("epi_cps%s_%d_%d.feather", sample, yr, .x)))
  })
}

create_feather <- function(data, file) {
  fs::dir_create(fs::path_dir(file))
  arrow::write_feather(data, file)
  file
}

create_csv <- function(data, file) {
  fs::dir_create(fs::path_dir(file))
  readr::write_csv(data, file)
  file
}
