# Quarto pre-render step: write _variables.yml from ../config/release.yml,
# the single source of release metadata, so {{< var ... >}} stays current.
release <- yaml::read_yaml("../config/release.yml")

variables <- list(
  version = release$version,
  latestdata = release$latestdata,
  # citation year comes from the version (YYYY.M.DD)
  year = substr(release$version, 1, 4),
  # last data year, used in the download zip names
  dataendyear = substr(release$latestdata, 1, 4)
) |>
  yaml::as.yaml()

# only rewrite when the values change: quarto preview treats a rewritten
# _variables.yml as a site-wide change and re-renders every page you open
if (!file.exists("_variables.yml") || !identical(readr::read_file("_variables.yml"), variables)) {
  writeLines(variables, "_variables.yml", sep = "")
}
