# Generate the variable pages and variable index as .qmd files
# (replaces code/docs/docwrite.do and code/docs/variableindex.do).
# Run from website/: Rscript R/build_variable_pages.R
library(dplyr)
library(purrr)

repo_root  <- ".."
codedocs   <- file.path(repo_root, "code/docs")
pages_dir  <- "variables"

# every variable ported to R (has a code/docs/r_snippets/<var>_rcode.R file),
# plus two not-yet-ported examples (Stata code fallback, long value-label list)
ported_variables <- list.files(file.path(codedocs, "r_snippets"), pattern = "_rcode\\.R$") |>
  sub(pattern = "_rcode\\.R$", replacement = "")
poc_variables <- union(ported_variables, c("lfstat", "occ18"))

# variable -> group and sample availability
variables_groups <- read.csv(file.path(codedocs, "variables_groups.csv"), colClasses = "character")

# one row of the 2024 ORG and Basic extracts carries every variable and value label
label_data <- list(
  haven::read_dta("/data/cps/org/epi/epi_cpsorg_2024.dta", n_max = 1),
  haven::read_dta("/data/cps/basic/epi/epi_cpsbasic_2024.dta", n_max = 1)
)

# first non-empty attribute for a variable across the label datasets
label_attr_fun <- function(var, which) {
  label_data |>
    map(~ attr(.x[[var]], which)) |>
    compact() |>
    pluck(1)
}

# MkDocs admonitions -> Quarto callouts:
#   !!! warning "Title"        ::: {.callout-warning title="Title"}
#       indented body     ->   body
#                              :::
admonitions_to_callouts_fun <- function(lines) {
  out <- character(0)
  in_box <- FALSE
  for (line in lines) {
    # an indented (or blank) line continues the open box
    if (in_box && (grepl("^(    |\t)", line) || line == "")) {
      out <- c(out, sub("^(    |\t)", "", line))
      next
    }
    if (in_box) {
      out <- c(out, ":::", "")
      in_box <- FALSE
    }
    # an admonition header opens a new box
    header <- regmatches(line, regexec('^!!!\\s+(\\w+)\\s*(?:"([^"]*)")?\\s*$', line, perl = TRUE))[[1]]
    if (length(header) > 0) {
      title <- if (header[3] != "") paste0(' title="', header[3], '"') else ""
      out <- c(out, paste0("::: {.callout-", header[2], title, "}"))
      in_box <- TRUE
    } else {
      out <- c(out, line)
    }
  }
  if (in_box) out <- c(out, ":::")
  out
}

# read a markdown description file if it exists, else NULL
read_desc_fun <- function(var, type) {
  path <- file.path(codedocs, "descriptions", type, paste0(var, "_", type, ".md"))
  if (!file.exists(path)) return(NULL)
  readLines(path, warn = FALSE) |>
    admonitions_to_callouts_fun() |>
    paste(collapse = "\n") |>
    # MkDocs links point at .md pages; Quarto pages are .qmd (sources stay MkDocs-compatible)
    gsub(pattern = "(\\]\\([^)#]*?)\\.md(#[^)]*)?\\)", replacement = "\\1.qmd\\2)", perl = TRUE)
}

# wrap HTML so pandoc passes it through untouched
raw_html_fun <- function(html) paste0("```{=html}\n", paste(html, collapse = "\n"), "\n```")

# value labels (replaces valuelabel2md.ado): a compact list when short,
# a searchable table (filtered by search.js) when long
value_list_max <- 12
value_labels_html_fun <- function(var) {
  labels <- label_attr_fun(var, "labels")
  if (is.null(labels)) return(NULL)
  values <- htmltools::htmlEscape(as.character(unname(labels)))
  text <- htmltools::htmlEscape(names(labels))

  if (length(labels) <= value_list_max) {
    html <- c('<dl class="value-list">', paste0("<dt>", values, "</dt><dd>", text, "</dd>"), "</dl>")
  } else {
    html <- c(
      '<div class="value-search">',
      paste0('<input type="search" class="form-control form-control-sm" placeholder="Search ', length(labels),
             ' values" aria-label="Search values">'),
      paste0('<p class="value-count">Showing ', length(labels), " of ", length(labels), "</p>"),
      '<div class="value-scroll"><table class="table table-sm value-table">',
      "<thead><tr><th>Value</th><th>Label</th></tr></thead><tbody>",
      paste0("<tr><td>", values, "</td><td>", text, "</td></tr>"),
      "</tbody></table></div></div>"
    )
  }
  raw_html_fun(html)
}

# timeline scale shared by every page: first May year to the latest data month
latest_data <- yaml::read_yaml(file.path(repo_root, "config/release.yml"))$latestdata
timeline_start <- 1973
sample_full_range <- c(Basic = "1976 - present", May = "1973 - 1981", ORG = "1979 - present")

# "1995m9" / "1994" / "present" -> decimal year; an end date covers its whole month or year
date_to_decimal_fun <- function(x, side) {
  if (x == "present") x <- latest_data
  parts <- as.numeric(strsplit(x, "m")[[1]])
  year <- parts[1]
  month <- if (length(parts) == 2) parts[2] else if (side == "start") 1 else 12
  if (is.na(year) || year < timeline_start || year > 2100) {
    warning("unparseable availability date: ", x)
    return(NA_real_)
  }
  year + (month - if (side == "start") 1 else 0) / 12
}

# "1979 - 1993, 1995m9 - present" -> one row per contiguous period
availability_periods_fun <- function(text, sample) {
  if (text == "All years") text <- sample_full_range[[sample]]
  strsplit(text, ",")[[1]] |>
    trimws() |>
    map(~ {
      ends <- trimws(strsplit(.x, "-")[[1]])
      tibble(
        label = .x,
        start = date_to_decimal_fun(ends[1], "start"),
        end = date_to_decimal_fun(ends[2], "end")
      )
    }) |>
    list_rbind()
}

# availability as timeline bars, one row per sample (basic, may and org, as docwrite.do shows)
availability_html_fun <- function(var) {
  row <- filter(variables_groups, varname == var)
  samples <- c(Basic = row$basic, May = row$may, ORG = row$org)
  timeline_end <- date_to_decimal_fun("present", "end")
  pct_fun <- function(x) sprintf("%.2f%%", 100 * (x - timeline_start) / (timeline_end - timeline_start))

  # decade tick labels along the top
  ticks <- seq(1980, floor(timeline_end), by = 10)
  axis <- c(
    '<div class="timeline-row timeline-axis"><div></div><div class="timeline-track">',
    paste0('<span style="left:', pct_fun(ticks), '">', ticks, "</span>"),
    "</div><div></div></div>"
  )

  # one bar per period; samples without the variable get an empty track
  rows <- imap(samples, ~ {
    if (.x == "") {
      bars <- character(0)
      text <- '<span class="text-muted">Not available</span>'
    } else {
      periods <- availability_periods_fun(.x, .y) |> filter(!is.na(start), !is.na(end))
      bars <- paste0('<span class="timeline-bar" style="left:', pct_fun(periods$start),
                     ";width:", pct_fun(periods$end - periods$start + timeline_start),
                     '" title="', .y, ": ", periods$label, '"></span>')
      # spell out "All years" as the sample's actual range
      text <- htmltools::htmlEscape(if (.x == "All years") sample_full_range[[.y]] else .x)
    }
    c('<div class="timeline-row">',
      paste0('<div class="timeline-sample">', .y, "</div>"),
      '<div class="timeline-track">', bars, "</div>",
      paste0('<div class="timeline-text">', text, "</div>"),
      "</div>")
  }) |>
    unlist()

  raw_html_fun(c('<div class="timeline">', axis, rows, "</div>"))
}

# R snippet if the variable has been ported to r_pilot/, else the Stata script
variable_code_fun <- function(var) {
  r_path <- file.path(codedocs, "r_snippets", paste0(var, "_rcode.R"))
  if (file.exists(r_path)) {
    list(lang = "r", code = readLines(r_path, warn = FALSE))
  } else {
    list(lang = "stata", code = readLines(file.path(repo_root, "code/variables", paste0("generate_", var, ".do")), warn = FALSE))
  }
}

# collapsed callout holding a code block
code_callout_fun <- function(title, lang, code) {
  c(
    paste0('::: {.callout-note collapse="true" title="', title, '"}'),
    paste0("````", lang), code, "````",
    ":::"
  ) |>
    paste(collapse = "\n")
}

# assemble one variable page; sections without content are dropped
variable_page_fun <- function(var) {
  group <- filter(variables_groups, varname == var)$group
  label <- label_attr_fun(var, "label")
  code <- variable_code_fun(var)
  figure_script <- file.path("R/figures", paste0(var, "_figure.R"))
  figure_note <- file.path("R/figures", paste0(var, "_figure.md"))

  # detailed comments = long description plus any note about the figure
  # (the Stata analysis scripts wrote these notes into the longdesc files)
  comments <- c(
    read_desc_fun(var, "longdesc"),
    if (file.exists(figure_note)) paste(readLines(figure_note, warn = FALSE), collapse = "\n")
  )

  # figure chunk runs the plotting script; readers can unfold its code
  figure <- if (file.exists(figure_script)) {
    paste0("```{r}\n#| code-fold: true\n#| code-summary: \"Figure creation\"\n#| file: ", figure_script, "\n```")
  }

  sections <- list(
    paste0("---\ntitle: \"`", var, "`: ", label, "\"\n",
           "# generated by R/build_variable_pages.R -- do not edit by hand\n---"),
    figure,
    paste0("## Description\n\n", read_desc_fun(var, "shortdesc")),
    paste0("## Availability\n\n", availability_html_fun(var), "\n\n", read_desc_fun(var, "availability") %||% ""),
    if (!is.null(value_labels_html_fun(var))) paste0("## Values\n\n", value_labels_html_fun(var)),
    if (length(comments) > 0) paste0("## Detailed comments\n\n", paste(comments, collapse = "\n\n")),
    paste0("## Code\n\n", code_callout_fun("Variable creation", code$lang, code$code))
  )

  # write to variables/<group>/<var>.qmd
  dir.create(file.path(pages_dir, group), recursive = TRUE, showWarnings = FALSE)
  sections |>
    compact() |>
    paste(collapse = "\n\n") |>
    writeLines(file.path(pages_dir, group, paste0(var, ".qmd")))
}

# index of every variable; only variables with a page are linked
index_page_fun <- function(page_vars) {
  rows <- variables_groups |>
    arrange(varname) |>
    mutate(
      label = map_chr(varname, ~ label_attr_fun(.x, "label") %||% ""),
      link = if_else(
        varname %in% page_vars,
        paste0("[`", varname, "`](", group, "/", varname, ".qmd)"),
        paste0("`", varname, "`")
      )
    )

  c(
    "---\ntitle: Available variables\n# generated by R/build_variable_pages.R -- do not edit by hand\n---\n",
    "Variable | Description",
    "---------|------------",
    paste(rows$link, "|", rows$label)
  ) |>
    writeLines(file.path(pages_dir, "index.qmd"))
}

walk(poc_variables, variable_page_fun)
index_page_fun(poc_variables)
