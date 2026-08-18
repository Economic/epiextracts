# Generates per-variable R code snippets for the documentation site, mirroring
# how docwrite.do already embeds each variable's generate_<var>.do verbatim in
# a "## Code" admonition. Run this once per release (from the project root,
# before `do code/docs/createdocs.do`) so docwrite.do finds a fresh snippet
# file for every variable listed in code/docs/r_snippets_map.csv.
#
# Reads code/docs/r_snippets_map.csv (varname, r_file, functions) and, for
# each row, extracts the named function(s) from r_pilot/R/<r_file> -- or the
# whole file, if functions == "WHOLE_FILE" -- writing the result to
# code/docs/r_snippets/<varname>_rcode.R.

library(readr)

#' Extract one top-level `name <- function(...) {...}` definition's exact
#' source text, INCLUDING the explanatory comment block directly above it.
#'
#' parse(..., keep.source = TRUE)'s srcref only spans the function's own
#' lines, not comments above it -- confirmed empirically, since this
#' project's functions are always preceded by a contiguous "# ..." header
#' with no blank line in between. This walks backward from the function's
#' start line, absorbing that comment block, so the extracted snippet reads
#' the same way it does in the actual source file.
extract_function_source <- function(lines, exprs, srefs, function_name) {
  idx <- NULL
  for (i in seq_along(exprs)) {
    e <- exprs[[i]]
    if (is.call(e) && as.character(e[[1]]) %in% c("<-", "=") &&
          is.symbol(e[[2]]) && as.character(e[[2]]) == function_name) {
      idx <- i
      break
    }
  }
  if (is.null(idx)) return(NULL)

  start_line <- srefs[[idx]][1]
  end_line <- srefs[[idx]][3]

  comment_start <- start_line
  prev <- start_line - 1
  while (prev >= 1 && grepl("^\\s*#", lines[prev])) {
    comment_start <- prev
    prev <- prev - 1
  }

  paste(lines[comment_start:end_line], collapse = "\n")
}

#' Extract several named functions from one R file, in the order requested.
#' Errors loudly if any requested function isn't found, rather than silently
#' writing an incomplete/empty snippet.
extract_functions <- function(r_file, function_names) {
  lines <- readLines(r_file)
  exprs <- parse(r_file, keep.source = TRUE)
  srefs <- attr(exprs, "srcref")

  pieces <- setNames(vector("list", length(function_names)), function_names)
  for (fn in function_names) {
    pieces[[fn]] <- extract_function_source(lines, exprs, srefs, fn)
  }

  missing <- function_names[vapply(pieces, is.null, logical(1))]
  if (length(missing) > 0) {
    stop(sprintf("generate_r_snippets.R: function(s) not found in %s: %s", r_file, paste(missing, collapse = ", ")))
  }
  pieces
}

## CONFIGURATION -- run from the project root
map_csv    <- "code/docs/r_snippets_map.csv"
r_pilot_dir <- "r_pilot/R"
out_dir    <- "code/docs/r_snippets"

map <- readr::read_csv(map_csv, show_col_types = FALSE)
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

for (i in seq_len(nrow(map))) {
  var <- map$varname[i]
  r_file <- file.path(r_pilot_dir, map$r_file[i])
  spec <- map$functions[i]

  snippet <- if (identical(spec, "WHOLE_FILE")) {
    paste(readLines(r_file), collapse = "\n")
  } else {
    fn_names <- strsplit(spec, ";")[[1]]
    pieces <- extract_functions(r_file, fn_names)
    paste(unlist(pieces[fn_names]), collapse = "\n\n")
  }

  out_file <- file.path(out_dir, sprintf("%s_rcode.R", var))
  writeLines(snippet, out_file)
  cat("wrote", out_file, "\n")
}
