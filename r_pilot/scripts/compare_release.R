# Compare two folders of released extracts file by file (Phase 4.4). Run
# from r_pilot/:
#   Rscript scripts/compare_release.R <r_dir> <stata_dir> <report.csv> [value years]
# e.g. Rscript scripts/compare_release.R output /data/cps/basic/epi report.csv 2005 2026
# Metadata (rows, columns, storage types, labels, notes, data label) is
# checked for every file; values only for the listed years, since reading
# whole .dta files takes about a minute per Basic year.
suppressMessages({
  source("packages.R")
  invisible(lapply(list.files("R", full.names = TRUE), source))
})

args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) >= 3)
registry <- read_registry("variables.csv")
exceptions <- read_parity_exceptions("parity_exceptions.csv")

report <- compare_release_dirs(args[1], args[2], registry, exceptions, value_years = as.integer(args[-(1:3)]))
create_csv(report, args[3])

# summary: failing checks by check and variable, with the files they fail in
failing <- dplyr::filter(report, !ok)
cat(nrow(report), "checks on", dplyr::n_distinct(report$file), "files;", nrow(failing), "failing\n")
if (nrow(failing) > 0) {
  failing |>
    dplyr::summarise(files = dplyr::n(), example = dplyr::first(file), .by = c(check, variable)) |>
    as.data.frame() |>
    print()
}
