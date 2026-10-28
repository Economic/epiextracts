# One-off helper: turn generate_mocc10.do's code ranges into
# crosswalks/mocc10.csv, which recode_mocc10() applies. Run from r_pilot/:
#   Rscript scripts/convert_mocc10.R [path/to/generate_mocc10.do]
# After converting, the CSV is the spec: edit it by hand, and the parity gate
# checks the result against the published extracts.
library(dplyr)

args <- commandArgs(trailingOnly = TRUE)
do_file <- if (length(args) > 0) args[1] else "../code/variables/generate_mocc10.do"
lines <- readLines(do_file)

# era headers look like: if tm(1992m1) <= $date & $date <= tm(2002m12){;
# the last era has no end date
to_month <- function(x) if (is.na(x)) NA_character_ else x
rows <- list()
era_from <- era_to <- NA_character_
value <- NA
order <- 0
for (line in lines) {
  era <- regmatches(line, regexec("if tm\\((\\d{4}m\\d+)\\) <= \\$date( & \\$date <= tm\\((\\d{4}m\\d+)\\))?", line))[[1]]
  if (length(era) > 0) {
    era_from <- era[2]
    era_to <- if (era[4] == "") NA_character_ else era[4]
    next
  }
  # each statement: replace mocc10 = <value or .> if (
  start <- regmatches(line, regexec("replace mocc10 = (\\.|\\d+) if", line))[[1]]
  if (length(start) > 0) {
    value <- if (start[2] == ".") NA_real_ else as.numeric(start[2])
    order <- order + 1
  }
  # codes and ranges, e.g. (occcode == 5) or (occcode >= 7 & occcode <= 37);
  # spacing varies (tabs, spaces), so match any whitespace
  conditions <- regmatches(line, gregexpr("occcode\\s*(==|>=)\\s*-?\\d+(\\s*&\\s*occcode\\s*<=\\s*-?\\d+)?", line))[[1]]
  for (condition in conditions) {
    bounds <- as.numeric(regmatches(condition, gregexpr("-?\\d+", condition))[[1]])
    rows[[length(rows) + 1]] <- tibble(from = era_from, to = to_month(era_to), step = order, mocc10 = value,
                                       low = bounds[1], high = bounds[length(bounds)])
  }
}

crosswalk <- bind_rows(rows)
fs::dir_create("crosswalks")
readr::write_csv(crosswalk, "crosswalks/mocc10.csv", na = "")
cat(nrow(crosswalk), "ranges in", n_distinct(crosswalk$from), "eras\n")
