# --- unmem/uncov/union (generate_unmem.do, generate_uncov.do,
# generate_union.do), 1994+, ORG-supplement questions (earnerinfo==1) -------
# IMPORTANT: dplyr::if_else()'s default NA-propagation does NOT match Stata's
# `replace x = y if cond` (which leaves x unchanged when cond is missing/false)
# -- every sequential replace-if here MUST pass missing = <current value>,
# or NA condition values silently corrupt rows instead of leaving them as-is.
recode_unmem <- function(peernlab) {
  dplyr::case_when(peernlab == 2 ~ 0, peernlab == 1 ~ 1, TRUE ~ NA_real_)
}
