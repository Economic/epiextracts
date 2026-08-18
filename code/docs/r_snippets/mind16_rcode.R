# --- mind16 (generate_mind16.do) -------------------------------------------
# Major-industry bucket boundaries differ between the pre-2003 (3-digit,
# "ind90"-era) and 2003+ (4-digit) industry code systems; a 2020+ hospital
# code carve-out (8191/8192) is nested inside the 2003+ branch.
recode_mind16 <- function(indcode, year) {
  yr <- unique(year)
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
