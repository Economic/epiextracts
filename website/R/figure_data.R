# Build the small yearly summary tables behind the variable-page figures
# (replaces the data steps in code/docs/analysis/*_analysis.do and the
# sample windows in code/docs/detailed_analysis.do).
# Run from website/: Rscript R/figure_data.R
library(dplyr)
library(purrr)
library(arrow)

epi_dir  <- "/data/cps"
end_year <- 2024 # same window as code/docs/detailed_analysis.do
out_dir  <- "data"

# Weighted mean over rows where both value and weight are present
# (what Stata's gcollapse (mean) [pw=] does per variable)
wmean_fun <- function(x, w) {
  keep <- !is.na(x) & !is.na(w)
  sum(x[keep] * w[keep]) / sum(w[keep])
}

# Weighted median, matching Stata's (p50) [pw=] definition:
# first value whose cumulative weight passes half the total,
# averaged with the next value when it lands exactly on half
weighted_median_fun <- function(x, w) {
  keep <- !is.na(x) & !is.na(w)
  x <- x[keep]
  w <- w[keep]
  o <- order(x)
  x <- x[o]
  cum_w <- cumsum(w[o])
  half <- sum(w, na.rm = TRUE) / 2
  i <- which(cum_w >= half)[1]
  if (isTRUE(all.equal(cum_w[i], half))) (x[i] + x[i + 1]) / 2 else x[i]
}

# Deflate a dollar column to end_year dollars with CPI-U-RS
deflate_fun <- function(d, cols) {
  cpi <- read.csv("../suppdata/cpiurs_extended.csv")
  cpi_base <- cpi$cpiurs_extended[cpi$year == end_year]
  d |>
    left_join(cpi, by = "year") |>
    mutate(across({{ cols }}, ~ .x * cpi_base / cpiurs_extended)) |>
    select(-cpiurs_extended)
}

# ---- one spec per figure ----------------------------------------------------
# sources: which samples and years feed the figure, and the weight used for each
#          (copied into a `wgt` column before `summary` runs)
# cols:    columns `summary` needs besides year and the weight
# summary: collapses one sample-year to a few rows
# finish:  optional step on the combined table (e.g. inflation adjustment)
figure_specs <- list(
  # share of the civilian population by age group; ages 0+ consistent from 1982
  age = list(
    sources = list(basic = list(years = 1982:end_year, wgt = "finalwgt")),
    cols = "age",
    summary = function(d) {
      d |>
        mutate(age_group = cut(
          age,
          breaks = c(0, 15, 24, 39, 54, 64, 80),
          labels = c("Ages 0-15", "Ages 16-24", "Ages 25-39", "Ages 40-54", "Ages 55-64", "Ages 65+"),
          include.lowest = TRUE
        )) |>
        summarise(wgt = sum(wgt, na.rm = TRUE), .by = c(year, age_group)) |>
        mutate(share = 100 * wgt / sum(wgt, na.rm = TRUE), .keep = "unused")
    }
  ),

  # prime-age (25-54) labor force participation by gender; in labor force = employed or unemployed
  lfstat = list(
    sources = list(basic = list(years = 1976:end_year, wgt = "basicwgt")),
    cols = c("age", "female", "lfstat"),
    summary = function(d) {
      d |>
        filter(age >= 25, age <= 54, !is.na(lfstat)) |>
        summarise(lfpr = 100 * wmean_fun(lfstat %in% c(1, 2), wgt), .by = c(year, female))
    }
  ),

  # educational attainment shares, ages 25+
  educ = list(
    sources = list(
      may = list(years = 1973:1975, wgt = "basicwgt"),
      basic = list(years = 1976:end_year, wgt = "basicwgt")
    ),
    cols = c("age", "educ"),
    summary = function(d) {
      d |>
        filter(age >= 25, !is.na(educ)) |>
        summarise(
          across(educ, list(
            lths = ~ 100 * wmean_fun(.x == 1, wgt),
            hs = ~ 100 * wmean_fun(.x == 2, wgt),
            some = ~ 100 * wmean_fun(.x == 3, wgt),
            college = ~ 100 * wmean_fun(.x == 4, wgt),
            advanced = ~ 100 * wmean_fun(.x == 5, wgt)
          ), .names = "{.fn}"),
          .by = year
        )
    }
  ),

  # employment-to-population ratios, overall and prime-age (25-54); 1976+ annual data
  emp = list(
    sources = list(basic = list(years = 1976:end_year, wgt = "basicwgt")),
    cols = c("age", "emp"),
    summary = function(d) {
      d |>
        filter(!is.na(emp)) |>
        summarise(
          allepop = 100 * wmean_fun(emp == 1, wgt),
          primeepop = 100 * wmean_fun(if_else(age >= 25 & age <= 54, emp == 1, NA), wgt),
          .by = year
        )
    }
  ),

  # public sector share of employed workers ages 16-64, by gender
  pubsec = list(
    sources = list(
      may = list(years = 1973:1975, wgt = "basicwgt"),
      basic = list(years = 1976:end_year, wgt = "basicwgt")
    ),
    cols = c("age", "emp", "female", "pubsec"),
    summary = function(d) {
      d |>
        filter(!is.na(pubsec), age >= 16, age <= 64, emp == 1) |>
        summarise(pubsec = 100 * wmean_fun(pubsec, wgt), .by = c(year, female))
    }
  ),

  # median real hourly wage by gender (positive wages, ages 16+)
  wage = list(
    sources = list(
      may = list(years = 1973:1978, wgt = "basicwgt"),
      org = list(years = 1979:end_year, wgt = "orgwgt")
    ),
    cols = c("age", "female", "wage"),
    summary = function(d) {
      d |>
        filter(wage > 0, age >= 16) |>
        summarise(wage = weighted_median_fun(wage, wgt), .by = c(year, female))
    },
    finish = function(d) deflate_fun(d, wage)
  ),

  # mean real hourly wage, adjusted vs unadjusted (ages 16+; zero wages dropped from wage only, as in Stata)
  wage_noadj = list(
    sources = list(
      may = list(years = 1973:1978, wgt = "basicwgt"),
      org = list(years = 1979:end_year, wgt = "orgwgt")
    ),
    cols = c("age", "wage", "wage_noadj"),
    summary = function(d) {
      d |>
        filter(age >= 16) |>
        mutate(wage = na_if(wage, 0)) |>
        summarise(across(c(wage, wage_noadj), ~ wmean_fun(.x, wgt)), .by = year)
    },
    finish = function(d) deflate_fun(d, c(wage, wage_noadj))
  ),

  # union membership and representation among wage and salary workers ages 16+
  union = list(
    sources = list(
      may = list(years = 1973:1981, wgt = "basicwgt"),
      org = list(years = 1983:end_year, wgt = "orgwgt")
    ),
    cols = c("age", "selfemp", "unmem", "union"),
    summary = function(d) {
      d |>
        filter(age >= 16, selfemp == 0) |>
        summarise(across(c(unmem, union), ~ 100 * wmean_fun(.x, wgt)), .by = year)
    }
  ),

  # union membership by gender among wage and salary workers ages 16+
  unmem = list(
    sources = list(
      may = list(years = 1973:1981, wgt = "basicwgt"),
      org = list(years = 1983:end_year, wgt = "orgwgt")
    ),
    cols = c("age", "selfemp", "female", "unmem"),
    summary = function(d) {
      d |>
        filter(age >= 16, selfemp == 0) |>
        summarise(unmem = 100 * wmean_fun(unmem, wgt), .by = c(year, female))
    }
  )
)

# ---- read each sample-year once for every figure that uses it ---------------
# one row per (figure, sample, year, weight)
jobs <- figure_specs |>
  imap(~ imap(.x$sources, function(src, sample) {
    tibble(figure = .y, sample = sample, year = src$years, wgt = src$wgt)
  })) |>
  list_flatten() |>
  list_rbind()

# read only the columns the figures need, then summarise for each figure
summarise_sample_year_fun <- function(sample, year, jobs_here) {
  cols <- jobs_here$figure |>
    map(~ figure_specs[[.x]]$cols) |>
    unlist() |>
    c("year", jobs_here$wgt) |>
    unique()
  d <- file.path(epi_dir, sample, "epi", paste0("epi_cps", sample, "_", year, ".feather")) |>
    read_feather(col_select = any_of(cols)) |>
    haven::zap_labels()

  # each figure gets its own weight copied into `wgt`
  jobs_here |>
    mutate(result = map2(figure, wgt, function(fig, wgt_col) {
      d$wgt <- d[[wgt_col]]
      figure_specs[[fig]]$summary(d)
    }))
}

results <- jobs |>
  tidyr::nest(.by = c(sample, year), .key = "jobs_here") |>
  pmap(summarise_sample_year_fun) |>
  list_rbind()

# ---- combine years per figure and write one CSV each ------------------------
dir.create(out_dir, showWarnings = FALSE)
results |>
  summarise(data = list(list_rbind(result)), .by = figure) |>
  pwalk(function(figure, data) {
    finish <- figure_specs[[figure]]$finish %||% identity
    data |>
      arrange(year) |>
      finish() |>
      write.csv(file.path(out_dir, paste0(figure, "_figdata.csv")), row.names = FALSE)
  })
