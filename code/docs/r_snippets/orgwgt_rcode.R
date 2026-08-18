# --- orgwgt (generate_orgwgt.do), Census era Basic Monthly 1994+ -----------
# Same reweight-era pattern as cmpwgt: nworwgt supersedes pworwgt for 2000-2002.
recode_orgwgt <- function(pworwgt, nworwgt, year, reweight_years) {
  orgwgt <- dplyr::if_else(
    year %in% reweight_years,
    as.numeric(nworwgt),
    as.numeric(pworwgt)
  )
  dplyr::if_else(orgwgt <= 0 | is.na(orgwgt), NA_real_, orgwgt)
}
