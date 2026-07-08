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
