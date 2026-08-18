recode_uncov <- function(peerncov) {
  dplyr::case_when(peerncov == 2 ~ 0, peerncov == 1 ~ 1, TRUE ~ NA_real_)
}
