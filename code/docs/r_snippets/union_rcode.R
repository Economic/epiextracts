recode_union <- function(unmem, uncov) {
  union <- dplyr::case_when(!is.na(unmem) | !is.na(uncov) ~ 0, TRUE ~ NA_real_)
  union <- dplyr::if_else(unmem == 1, 1, union, missing = union)
  union <- dplyr::if_else(uncov == 1, 1, union, missing = union)
  union
}
