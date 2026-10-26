# Shared helpers for the Quarto site. Paths are relative to website/ (execute-dir: project).

repo_root <- ".."

# Print a source file as a fenced code block (replaces mkdocs --8<-- snippets).
# Four backticks so files that contain ``` don't close the fence early.
code_block_fun <- function(path, lang) {
  code <- readLines(file.path(repo_root, path), warn = FALSE)
  cat("````", lang, "\n", paste(code, collapse = "\n"), "\n````\n", sep = "")
}

# Hourly wage trimming limits by year (replaces the extremewages.csv that
# create_extracts.ado writes), from the same CPI function the pipeline uses:
# actual CPI-U-RS plus the CBO projection in config/cpi_projection.yml.
wage_limits_fun <- function() {
  source(file.path(repo_root, "r_pilot/R/helpers.R"))
  source(file.path(repo_root, "r_pilot/R/cpi.R"))
  cpi <- cpi_annual_fun(file.path(repo_root, "suppdata/cpiurs_extended.csv"),
                        file.path(repo_root, "config/cpi_projection.yml"))

  # limits are $0.50 and $100 in 1989 dollars
  dplyr::inner_join(cpi, build_wage_bounds(cpi), by = "year") |>
    dplyr::filter(year >= 1962) |>
    dplyr::rename(cpiurs_extended = cpi_u_rs)
}
