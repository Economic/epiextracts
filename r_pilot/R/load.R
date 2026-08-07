# Raw columns needed across the whole recode scope. dplyr::any_of() means a
# file missing a column (e.g. no nwcmpwgt after 2002) simply omits it instead
# of erroring, since column names/positions shift across dictionary vintages.
raw_cols_needed <- c(
  # identifiers / core demographics / basic weight (Phase 1)
  "hrhhid", "hryear4", "hrmonth", "qstnum", "occurnum",
  "pesex", "pemlr", "peage", "prtage", "pwcmpwgt", "nwcmpwgt",
  # ORG membership + weight
  "hrmis", "pworwgt", "nworwgt",
  # wage_noadj / weekpay_noadj dependency chain
  "peernhry", "pehrusl1", "prhrusl", "peernhro",
  "prernhly", "pternhly", "prernwa", "pternwa",
  # tc_fix.do topcode flag (2023m4+)
  "ptwk",
  # 8 internal-only regressors feeding hoursu1i's imputation
  "peeduca", "perace", "ptdtrace", "prdtrace", "prorigin", "prdthsp",
  "prcitshp", "prmarsta", "gestfips", "peernlab", "peerncov", "peio1cow", "peio1icd",
  # geography (countyfips/cbsafips/cbsasize/metstat) -- gestfips already listed above
  "geco", "gtco", "gtcbsa", "gtcbsasz", "gemetsta", "gtmetsta"
)

# Columns that are structurally absent for an entire year (era-split columns
# whose sibling covers that year instead, e.g. nwcmpwgt outside 2000-2002).
# Used by read_raw_ascii_year() in raw_ascii.R so downstream code never has
# to check column existence itself.
backfill_cols <- c(
  "peage", "prtage", "nwcmpwgt", "nworwgt",
  "prernhly", "pternhly", "prernwa", "pternwa", "ptwk",
  "perace", "ptdtrace", "prdtrace", "prorigin", "prdthsp",
  "geco", "gtco", "gtcbsa", "gtcbsasz", "gemetsta", "gtmetsta"
)
