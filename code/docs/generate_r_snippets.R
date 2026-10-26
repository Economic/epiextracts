# Generates per-variable R code snippets for the documentation site, mirroring
# how docwrite.do already embeds each variable's generate_<var>.do verbatim in
# a "## Code" admonition. Run this once per release (from the project root,
# before `do code/docs/createdocs.do` or the Quarto build).
#
# Reads the `snippet` column of the variable registry (r_pilot/variables.csv):
# "fn1;fn2" extracts those functions (wherever they're defined in
# r_pilot/R/), "file:<name>.R" takes a whole file, blank means no snippet.
# Writes code/docs/r_snippets/<variable>_rcode.R.

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
registry_csv <- "r_pilot/variables.csv"
r_pilot_dir  <- "r_pilot/R"
out_dir      <- "code/docs/r_snippets"

registry <- readr::read_csv(registry_csv, col_types = readr::cols(.default = "c"), na = "")
registry <- registry[!is.na(registry$snippet), ]
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

# which file defines each top-level function
r_files <- list.files(r_pilot_dir, pattern = "\\.R$", full.names = TRUE)
defined_in <- unlist(lapply(r_files, function(f) {
  exprs <- parse(f, keep.source = FALSE)
  is_fn <- vapply(exprs, function(e) is.call(e) && as.character(e[[1]]) %in% c("<-", "=") &&
                    is.call(e[[3]]) && identical(e[[3]][[1]], as.name("function")), logical(1))
  names <- vapply(exprs[is_fn], function(e) as.character(e[[2]]), character(1))
  setNames(rep(f, length(names)), names)
}))

for (i in seq_len(nrow(registry))) {
  var <- registry$variable[i]
  spec <- registry$snippet[i]

  snippet <- if (startsWith(spec, "file:")) {
    paste(readLines(file.path(r_pilot_dir, sub("^file:", "", spec))), collapse = "\n")
  } else {
    fn_names <- strsplit(spec, ";")[[1]]
    if (any(!fn_names %in% names(defined_in))) {
      stop("generate_r_snippets.R: no definition found for ", paste(setdiff(fn_names, names(defined_in)), collapse = ", "))
    }
    # functions can live in different files; extract each from its own
    pieces <- vapply(fn_names, function(fn) extract_functions(defined_in[[fn]], fn)[[fn]], character(1))
    paste(pieces, collapse = "\n\n")
  }

  out_file <- file.path(out_dir, sprintf("%s_rcode.R", var))
  writeLines(snippet, out_file)
  cat("wrote", out_file, "\n")
}
