# One-off helper: collect the Stata notes (`notes var: text`) that the
# Stata pipeline attaches to each variable into variable_notes.csv, which
# the .dta writer stores as characteristics. Run from r_pilot/:
#   Rscript scripts/seed_notes.R [path/to/code]
# where code/ holds generate_variables.do, adjust_wages.do and variables/.
# The published 2026.10.13 extracts came from the marchcps branch, so point
# this at a copy of its code/ (git archive marchcps code). After seeding, the
# CSV is the spec: edit it by hand.
#
# Reproduces how Stata runs the scripts, so the notes come out as Stata
# attaches them:
# - scripts run in generate_variables.do order, then adjust_wages.do's
# - any script can add notes to any variable (generate_pubst.do adds two to
#   publoc), and `notes difficult:` abbreviates difficulty
# - a last line without a trailing newline is never run by Stata
# - /* ... */ comments can split a note across lines
# - notes inside sample-specific blocks (`if $marchcps == 1`, ...) apply only
#   when Stata runs that sample: notes are collected per sample, "basic" (used
#   for Basic, ORG and May, which add the same notes) and "march"
library(dplyr)

args <- commandArgs(trailingOnly = TRUE)
code_dir <- if (length(args) > 0) args[1] else "../code"
registry <- readr::read_csv("variables.csv", col_types = readr::cols(.default = "c"), na = "")
exported <- registry$variable[registry$export == "TRUE"]
# Stata's sample globals for each set of notes
sample_globals <- list(
  basic = c(monthlycps = 1, maycps = 0, marchcps = 0),
  march = c(monthlycps = 0, maycps = 0, marchcps = 1)
)
in_sample <- function(variable, sample) {
  samples <- strsplit(registry$samples[match(variable, registry$variable)], ";")
  purrr::map_lgl(samples, ~ if (sample == "basic") any(c("basic", "org", "may") %in% .x) else sample %in% .x)
}

#' Whether an if-block's sample condition holds for a sample: the
#' `$global == value` terms joined by | (any) or & (all); blocks without
#' sample terms (dates, $earnerinfo) count as holding.
block_runs <- function(line, globals) {
  terms <- regmatches(line, gregexpr("\\$(monthlycps|maycps|marchcps) == [01]", line))[[1]]
  if (length(terms) == 0) return(TRUE)
  truth <- purrr::map_lgl(terms, ~ {
    parts <- strsplit(sub("^\\$", "", .x), " == ")[[1]]
    globals[[parts[1]]] == as.numeric(parts[2])
  })
  if (grepl("\\|", line)) any(truth) else all(truth)
}

# script order: the foreach list in generate_variables.do, then adjust_wages.do
foreach_list <- paste(readLines(file.path(code_dir, "generate_variables.do")), collapse = " ") |>
  sub(pattern = ".*foreach var in(.*?)\\{.*", replacement = "\\1")
script_order <- c(strsplit(trimws(foreach_list), "\\s+")[[1]],
                  sub(".*generate_(.*)\\.do", "\\1", grep("generate_", readLines(file.path(code_dir, "adjust_wages.do")), value = TRUE)))

# a script's lines as Stata runs them
script_lines <- function(path) {
  raw <- readChar(path, file.size(path), useBytes = TRUE)
  lines <- strsplit(raw, "\r?\n")[[1]]
  # Stata skips a final line that doesn't end in a newline
  if (!grepl("\n$", raw)) lines <- head(lines, -1)
  # drop /* ... */ comments, including ones spanning lines
  text <- gsub("(?s)/\\*.*?\\*/", "", paste(lines, collapse = "\n"), perl = TRUE)
  strsplit(text, "\n")[[1]]
}

# the variable a (possibly abbreviated) name refers to, among every variable
# the scripts create (`notes earn:` is March's earn, not earnhour)
resolve_variable <- function(name) {
  if (name %in% script_order) return(name)
  hits <- script_order[startsWith(script_order, name)]
  if (length(hits) == 1) hits else NA_character_
}

script_notes <- function(var, globals) {
  path <- file.path(code_dir, "variables", paste0("generate_", var, ".do"))
  if (!file.exists(path)) return(NULL)
  # track open if-blocks, so notes under blocks that don't run for the sample are skipped
  blocks <- character(0)
  found <- list()
  for (line in script_lines(path)) {
    note <- regmatches(line, regexec("^\\s*notes\\s+([A-Za-z0-9_]+)\\s*:\\s*(.*?)\\s*$", line))[[1]]
    runs <- all(purrr::map_lgl(blocks[grepl("^\\s*if ", blocks)], block_runs, globals = globals))
    if (length(note) > 0 && runs) {
      found[[length(found) + 1]] <- tibble(variable = resolve_variable(note[2]), text = note[3])
    }
    if (grepl("\\{\\s*$", line)) blocks <- c(blocks, line)
    if (grepl("^\\s*\\}", line) && length(blocks) > 0) blocks <- head(blocks, -1)
  }
  bind_rows(found)
}

notes <- names(sample_globals) |>
  purrr::map(function(sample) {
    script_order |>
      purrr::map(script_notes, globals = sample_globals[[sample]]) |>
      bind_rows() |>
      filter(variable %in% exported, in_sample(variable, sample)) |>
      # Stata numbers each variable's notes in the order they're added
      mutate(sample = sample, note = row_number(), .by = variable)
  }) |>
  bind_rows() |>
  select(sample, variable, note, text)

readr::write_csv(notes, "variable_notes.csv")
print(count(notes, sample, name = "notes"))
