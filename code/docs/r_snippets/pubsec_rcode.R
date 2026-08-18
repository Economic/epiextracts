# --- pubsec (generate_pubsec.do), 1994+ ------------------------------------
recode_pubsec <- function(peio1cow) {
  pubsec <- dplyr::case_when(peio1cow >= 1 & !is.na(peio1cow) ~ 0, TRUE ~ NA_real_)
  dplyr::if_else(peio1cow >= 1 & peio1cow <= 3, 1, pubsec, missing = pubsec)
}
