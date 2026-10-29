# Industry and occupation recodes (Census era, Basic/ORG). Each function's
# arguments are the columns it reads; see R/registry.R. Code labels for the
# era classifications (ind90, occ18, ...) live in value_labels.csv.

# --- indcode (generate_indcode.do), 1994+ ----------------------------------
recode_indcode <- function(peio1icd) {
  indcode <- as.numeric(peio1icd)
  dplyr::if_else(indcode < 0, NA_real_, indcode)
}

# --- mind16 (generate_mind16.do) -------------------------------------------
# Major-industry bucket boundaries differ between the pre-2003 (3-digit,
# "ind90"-era) and 2003+ (4-digit) industry code systems; a 2020+ hospital
# code carve-out (8191/8192) is nested inside the 2003+ branch.
recode_mind16 <- function(indcode, year) {
  yr <- unique(year)
  if (yr <= 1982) {
    # 1970 Census codes (no -1 or military codes in these years)
    return(dplyr::case_when(
      indcode %in% c(17, 18, 29) | (indcode >= 27 & indcode <= 28) | (indcode >= 47 & indcode <= 58) ~ 1,
      indcode >= 67 & indcode <= 78 ~ 2,
      indcode >= 107 & indcode <= 267 ~ 3,
      indcode >= 268 & indcode <= 399 ~ 4,
      indcode >= 407 & indcode <= 429 ~ 5,
      (indcode >= 447 & indcode <= 449) | (indcode >= 467 & indcode <= 499) ~ 6,
      indcode >= 507 & indcode <= 599 ~ 7,
      (indcode >= 607 & indcode <= 668) | (indcode >= 677 & indcode <= 699) ~ 8,
      (indcode >= 707 & indcode <= 719) | (indcode >= 727 & indcode <= 767) | indcode %in% c(19, 849, 877, 887) |
        (indcode >= 888 & indcode <= 899) ~ 9,
      indcode == 769 | (indcode >= 779 & indcode <= 799) ~ 10,
      indcode %in% c(669, 869) | (indcode >= 777 & indcode <= 778) | (indcode >= 807 & indcode <= 817) ~ 11,
      indcode == 838 ~ 12,
      (indcode >= 828 & indcode <= 837) | (indcode >= 839 & indcode <= 848) ~ 13,
      indcode >= 857 & indcode <= 868 ~ 14,
      indcode >= 878 & indcode <= 879 ~ 15,
      indcode >= 907 & indcode <= 947 ~ 16,
      TRUE ~ NA_real_
    ))
  }
  if (yr <= 1991) {
    # 1980 Census codes; -1 (not in universe) and 991 (armed forces) missing
    return(dplyr::case_when(
      indcode %in% c(-1, 991) ~ NA_real_,
      (indcode >= 10 & indcode <= 20) | (indcode >= 30 & indcode <= 31) | (indcode >= 40 & indcode <= 50) ~ 1,
      indcode == 60 ~ 2,
      indcode >= 230 & indcode <= 392 ~ 3,
      indcode >= 100 & indcode <= 222 ~ 4,
      indcode >= 400 & indcode <= 432 ~ 5,
      (indcode >= 440 & indcode <= 442) | (indcode >= 460 & indcode <= 472) ~ 6,
      indcode >= 500 & indcode <= 571 ~ 7,
      (indcode >= 580 & indcode <= 640) | (indcode >= 642 & indcode <= 691) ~ 8,
      indcode %in% c(841, 21) | (indcode >= 700 & indcode <= 712) | (indcode >= 721 & indcode <= 760) |
        (indcode >= 873 & indcode <= 892) ~ 9,
      indcode == 761 | (indcode >= 771 & indcode <= 791) ~ 10,
      indcode %in% c(872, 641, 762, 770) | (indcode >= 800 & indcode <= 802) ~ 11,
      indcode == 831 ~ 12,
      (indcode >= 812 & indcode <= 830) | (indcode >= 832 & indcode <= 840) ~ 13,
      indcode >= 842 & indcode <= 860 ~ 14,
      indcode >= 861 & indcode <= 871 ~ 15,
      indcode >= 900 & indcode <= 932 ~ 16,
      TRUE ~ NA_real_
    ))
  }
  if (yr <= 2002) {
    dplyr::case_when(
      indcode == 991 ~ NA_real_,
      (indcode >= 10 & indcode <= 19) | (indcode >= 21 & indcode <= 30) |
        (indcode >= 31 & indcode <= 32) | (indcode >= 40 & indcode <= 50) ~ 1,
      indcode == 60 ~ 2,
      (indcode >= 230 & indcode <= 392) ~ 3,
      (indcode >= 100 & indcode <= 222) ~ 4,
      (indcode >= 400 & indcode <= 432) ~ 5,
      (indcode >= 440 & indcode <= 442) | (indcode >= 450 & indcode <= 472) ~ 6,
      (indcode >= 500 & indcode <= 571) ~ 7,
      (indcode >= 580 & indcode <= 640) | (indcode >= 642 & indcode <= 691) ~ 8,
      indcode == 841 | (indcode >= 700 & indcode <= 712) | (indcode >= 721 & indcode <= 760) |
        indcode == 20 | (indcode >= 873 & indcode <= 893) ~ 9,
      indcode == 761 | (indcode >= 771 & indcode <= 791) ~ 10,
      indcode == 872 | indcode == 641 | indcode == 762 | indcode == 770 |
        (indcode >= 800 & indcode <= 810) ~ 11,
      indcode == 831 ~ 12,
      (indcode >= 812 & indcode <= 830) | (indcode >= 832 & indcode <= 840) ~ 13,
      (indcode >= 842 & indcode <= 860) ~ 14,
      (indcode >= 861 & indcode <= 871) ~ 15,
      (indcode >= 900 & indcode <= 932) ~ 16,
      TRUE ~ NA_real_
    )
  } else {
    dplyr::case_when(
      indcode == 9890 ~ NA_real_,
      (indcode >= 170 & indcode <= 180) | indcode == 290 | indcode == 7480 |
        (indcode >= 190 & indcode <= 280) | (indcode >= 370 & indcode <= 490) ~ 1,
      indcode == 770 ~ 2,
      (indcode >= 2470 & indcode <= 3990) ~ 3,
      (indcode >= 1070 & indcode <= 2390) | (indcode >= 6470 & indcode <= 6481) ~ 4,
      (indcode >= 6070 & indcode <= 6390) ~ 5,
      (indcode >= 570 & indcode <= 690) | (indcode >= 6490 & indcode <= 6695) |
        (indcode >= 6780 & indcode <= 6790) ~ 6,
      (indcode >= 4070 & indcode <= 4590) ~ 7,
      (indcode >= 4670 & indcode <= 5791) ~ 8,
      (indcode >= 6870 & indcode <= 7190) | (indcode >= 7270 & indcode <= 7470) |
        (indcode >= 7490 & indcode <= 7790) | (indcode >= 8770 & indcode <= 8891) |
        (indcode >= 9160 & indcode <= 9190) ~ 9,
      indcode == 9290 | (indcode >= 8970 & indcode <= 9090) ~ 10,
      (indcode >= 8560 & indcode <= 8690) ~ 11,
      indcode == 8190 | (indcode == 8191 & yr >= 2020) | (indcode == 8192 & yr >= 2020) ~ 12,
      (indcode >= 7970 & indcode <= 8180) | (indcode >= 8270 & indcode <= 8290) ~ 13,
      indcode == 6770 | (indcode >= 7860 & indcode <= 7890) ~ 14,
      (indcode >= 8370 & indcode <= 8470) ~ 15,
      (indcode >= 9370 & indcode <= 9590) ~ 16,
      TRUE ~ NA_real_
    )
  }
}

# --- occcode (generate_occcode.do): peio1ocd, renamed ptio1ocd from 2021m3 --
recode_occcode <- function(year, month, peio1ocd, ptio1ocd) {
  occcode <- dplyr::if_else(ym(year, month) <= ym(2021, 2), as.numeric(peio1ocd), as.numeric(ptio1ocd))
  dplyr::if_else(occcode < 1, NA_real_, occcode)
}

# --- era classifications (generate_ind90..ind22.do, generate_occ90..occ18.do)
# the original code, kept only in the years its Census classification was used
recode_ind70 <- function(indcode, year, month) in_window(indcode, year, month, c(1973, 1), c(1982, 12))
recode_ind80 <- function(indcode, year, month) in_window(indcode, year, month, c(1983, 1), c(1991, 12))
recode_ind90 <- function(indcode, year, month) in_window(indcode, year, month, c(1992, 1), c(2002, 12))
recode_ind02 <- function(indcode, year, month) in_window(indcode, year, month, c(2003, 1), c(2008, 12))
recode_ind07 <- function(indcode, year, month) in_window(indcode, year, month, c(2009, 1), c(2013, 12))
recode_ind12 <- function(indcode, year, month) in_window(indcode, year, month, c(2014, 1), c(2019, 12))
recode_ind17 <- function(indcode, year, month) in_window(indcode, year, month, c(2020, 1), c(2024, 12))
recode_ind22 <- function(indcode, year, month) in_window(indcode, year, month, from = c(2025, 1))
recode_occ70 <- function(occcode, year, month) in_window(occcode, year, month, c(1973, 1), c(1982, 12))
recode_occ80 <- function(occcode, year, month) in_window(occcode, year, month, c(1983, 1), c(1991, 12))
recode_occ90 <- function(occcode, year, month) in_window(occcode, year, month, c(1992, 1), c(2002, 12))
recode_occ00 <- function(occcode, year, month) in_window(occcode, year, month, c(2003, 1), c(2010, 12))
recode_occ10 <- function(occcode, year, month) in_window(occcode, year, month, c(2011, 1), c(2019, 12))
recode_occ18 <- function(occcode, year, month) in_window(occcode, year, month, from = c(2020, 1))

# --- manuf (generate_manuf.do): mind16 durable (3) or nondurable (4) goods --
recode_manuf <- function(mind16) {
  dplyr::case_when(mind16 %in% c(3, 4) ~ 1, !is.na(mind16) ~ 0, TRUE ~ NA_real_)
}

# --- Census industry/occupation recodes, 2003+ (generate_dind03/mind03/docc03/mocc03.do)
recode_dind03 <- function(prdtind1, year) nonnegative(dplyr::if_else(year >= 2003, as.numeric(prdtind1), NA_real_))
recode_mind03 <- function(prmjind1, year) nonnegative(dplyr::if_else(year >= 2003, as.numeric(prmjind1), NA_real_))
recode_docc03 <- function(prdtocc1, year) nonnegative(dplyr::if_else(year >= 2003, as.numeric(prdtocc1), NA_real_))
recode_mocc03 <- function(prmjocc1, year) nonnegative(dplyr::if_else(year >= 2003, as.numeric(prmjocc1), NA_real_))

# --- mocc10 (generate_mocc10.do): consistent major occupation ---------------
# crosswalks/mocc10.csv lists each era's code ranges in the script's order
# (scripts/convert_mocc10.R); later steps overwrite earlier ones, as Stata's
# sequence of replace statements does.
read_mocc10_crosswalk <- function(crosswalk_file) {
  readr::read_csv(crosswalk_file, col_types = "cciddd") |>
    dplyr::mutate(
      from = purrr::map_dbl(from, ~ { d <- as.numeric(strsplit(.x, "m")[[1]]); ym(d[1], d[2]) }),
      to = purrr::map_dbl(to, ~ if (is.na(.x)) Inf else { d <- as.numeric(strsplit(.x, "m")[[1]]); ym(d[1], d[2]) })
    )
}

recode_mocc10 <- function(occcode, year, month, mocc10_crosswalk) {
  date <- ym(year, month)
  mocc10 <- rep(NA_real_, length(occcode))
  # only the eras these months fall in
  ranges <- mocc10_crosswalk[mocc10_crosswalk$to >= min(date) & mocc10_crosswalk$from <= max(date), ]
  # apply the ranges in order; a row takes the value of the last range it falls in
  for (i in seq_len(nrow(ranges))) {
    r <- ranges[i, ]
    hit <- date >= r$from & date <= r$to & occcode >= r$low & occcode <= r$high
    mocc10 <- stata_replace(mocc10, hit, r$mocc10)
  }
  mocc10
}
