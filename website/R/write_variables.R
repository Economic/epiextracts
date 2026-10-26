# Quarto pre-render step: write _variables.yml from ../config/release.yml,
# the single source of release metadata, so {{< var ... >}} stays current.
release <- yaml::read_yaml("../config/release.yml")

list(
  version = release$version,
  latestdata = release$latestdata,
  # citation year comes from the version (YYYY.M.DD)
  year = substr(release$version, 1, 4),
  # last data year, used in the download zip names
  dataendyear = substr(release$latestdata, 1, 4)
) |>
  yaml::write_yaml("_variables.yml")
