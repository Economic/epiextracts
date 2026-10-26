# One-off helper: copy variable labels (into variables.csv) and value labels
# (into value_labels.csv) from a published Stata extract, for exported
# variables that don't have them yet. Run from r_pilot/ after adding
# variables to the registry:
#   Rscript scripts/seed_labels.R [/data/cps/org/epi/epi_cpsorg_2024.dta]
# After seeding, these files are the spec: edit them by hand, and the parity
# gate checks them against the published extracts.
library(dplyr)

args <- commandArgs(trailingOnly = TRUE)
reference_file <- if (length(args) > 0) args[1] else "/data/cps/org/epi/epi_cpsorg_2024.dta"

registry <- readr::read_csv("variables.csv", col_types = readr::cols(.default = "c"), na = "")
value_labels_file <- "value_labels.csv"
value_labels <- if (file.exists(value_labels_file)) {
  readr::read_csv(value_labels_file, col_types = "cdc")
} else {
  tibble(variable = character(), value = numeric(), label = character())
}

# header only: labels without loading any rows
reference <- haven::read_dta(reference_file, n_max = 0)

# variable labels for exported variables that have none
registry <- registry |>
  mutate(label = if_else(
    export == "TRUE" & is.na(label) & variable %in% names(reference),
    purrr::map_chr(variable, ~ attr(reference[[.x]], "label") %||% NA_character_),
    label
  ))

# value labels for exported variables not yet in value_labels.csv
new_value_labels <- registry$variable[registry$export == "TRUE"] |>
  setdiff(value_labels$variable) |>
  intersect(names(reference)) |>
  purrr::map(~ {
    labels <- attr(reference[[.x]], "labels")
    if (is.null(labels)) return(NULL)
    tibble(variable = .x, value = unname(as.numeric(labels)), label = names(labels))
  }) |>
  bind_rows()

readr::write_csv(registry, "variables.csv", na = "")
readr::write_csv(bind_rows(value_labels, new_value_labels), value_labels_file)
cat("labelled", sum(!is.na(registry$label)), "variables;",
    n_distinct(new_value_labels$variable), "new value-label sets\n")
