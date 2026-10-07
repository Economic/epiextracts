library(tidyverse)
library(epidatatools)
library(epiextractr)
library(realtalk)
library(scales)

c_cpi_u_base <- c_cpi_u_annual$c_cpi_u[c_cpi_u_annual$year == 2025]

asec_raw <- load_cps("march", 1962:2026, .extracts_dir = "extracts/")

asec_final <- asec_raw |>
  # income refers to the prior calendar year; shift before joining CPI
  mutate(year = year - 1) |>
  left_join(c_cpi_u_extended_annual, by = "year") |>
  mutate(hhinc_real = hhinc * (c_cpi_u_base / c_cpi_u_extended))

med_hhinc_real <- asec_final |> 
  # valid household weight
  filter(hhwgt > 0, !is.na(hhinc)) |>
  # one record per household
  distinct(year, hserial, .keep_all = TRUE) |>
  summarize(
    med_hhinc_real = 
      averaged_median(
        x = hhinc_real, 
        w = hhwgt
      ),
    .by = year
  )

# Census method: linear interpolation within $2,500 income brackets
# (e.g., $85,000 to $87,499), assuming constant density within each bracket
binned_median_fun <- function(x, w, width = 2500) {
  # weighted household counts by bracket, in ascending order
  brackets <- tibble(bracket = floor(x / width), w = w) |>
    summarize(w = sum(w, na.rm = TRUE), .by = bracket) |>
    arrange(bracket) |>
    mutate(cum_w = cumsum(w))

  # bracket containing the median and the weight below it
  half <- sum(brackets$w, na.rm = TRUE) / 2
  med <- brackets |>
    filter(cum_w >= half) |>
    slice(1)
  below <- med$cum_w - med$w

  # lower bracket limit plus the share of the bracket needed to reach the median
  med$bracket * width + width * (half - below) / med$w
}

med_hhinc_census <- asec_final |>
  # valid household weight
  filter(hhwgt > 0, !is.na(hhinc)) |>
  # one record per household
  distinct(year, hserial, .keep_all = TRUE) |>
  summarize(
    # brackets are defined in current dollars, so interpolate on nominal income
    med_hhinc_nominal = binned_median_fun(x = hhinc, w = hhwgt),
    # then convert the median to 2025 dollars
    med_hhinc_real = med_hhinc_nominal * first(c_cpi_u_base / c_cpi_u_extended),
    .by = year
  )

med_hhinc_real_pts <- med_hhinc_real |>
  filter(year %in% c(1967, 2019, 2024, 2025)) |>
  mutate(
    lbl = label_comma()(med_hhinc_real),
    # per-label placement: hjust < 0 puts the label right of the point, > 1 left of it;
    # vjust < 0 lifts it above the point, > 1 drops it below
    hj = 
      case_when(
        year == 2024 ~ 1.15, 
        .default = -0.15
      ),
    vj = 
      case_when(
        year == 2024 ~ -0.8, 
        year == 2025 ~ 1.6, 
        .default = 0.5
      )
  )

med_hhinc_census_pts <- med_hhinc_census |>
  filter(year %in% c(1967, 2019, 2024, 2025)) |>
  mutate(
    lbl = label_comma()(med_hhinc_real),
    # per-label placement: hjust < 0 puts the label right of the point, > 1 left of it;
    # vjust < 0 lifts it above the point, > 1 drops it below
    hj = 
      case_when(
        year == 2024 ~ 1.15, 
        .default = -0.15
      ),
    vj = 
      case_when(
        year == 2024 ~ -0.8, 
        year == 2025 ~ 1.6, 
        .default = 0.5
      )
  )

ggplot(data = med_hhinc_real, aes(x = year, y = med_hhinc_real)) +
  geom_line() +
  # highlight and label standout years
  geom_point(data = med_hhinc_real_pts) +
  geom_text(data = med_hhinc_real_pts, aes(label = lbl), hjust = -0.15, size = 3.5) +
  # widen the right side of the x-axis so the labels aren't clipped
  scale_x_continuous(expand = expansion(mult = c(0.02, 0.12))) +
  labs(
    title = "Real Median U.S. Household Income: 1967–2025", 
    x = NULL, 
    y = NULL
  ) +
  scale_y_continuous(labels = label_comma()) +
  theme_bw() +
  theme(
    strip.background = element_blank(),
    strip.text       = element_text(face = "bold", hjust = 0)
  ) +
   ylim(0, 90000)


hicovly_fun <- function(data, x) {
  data |> 
    # keep only years/records where this series is defined
    filter(!is.na({{ x }})) |> 
    crosstab(year, {{ x }}, w = asecwgt, percent = "row") |> 
    select(year, `Covered`)
}

hicovly_long <- bind_rows(
  hicovly_fun(asec_final, hicovly1) |> mutate(series = "hicovly1"),
  hicovly_fun(asec_final, hicovly2) |> mutate(series = "hicovly2"),
  hicovly_fun(asec_final, hicovly3) |> mutate(series = "hicovly3"),
  hicovly_fun(asec_final, hicovly4) |> mutate(series = "hicovly4"),
  hicovly_fun(asec_final, hicovly5) |> mutate(series = "hicovly5")
)

ggplot(hicovly_long, aes(x = year, y = `Not covered`, color = series)) +
  geom_line() +
  # points make the single-year overlaps (1999, 2013, 2017) visible
  geom_point(size = 1) +
  labs(
    title = "Uninsured rate by Census series: 1987–2025",
    x = NULL, y = NULL, color = NULL
  ) +
  scale_y_continuous(labels = label_percent(accuracy = 0.1)) +
  theme_bw()


### POVERTY ####
offpov_fun <- function(data, x = NULL) {
  data |> 
    filter(!is.na(offpov)) |> 
    crosstab(year, offpov, w = asecwgt, percent = x) |> 
    select(year, `Below poverty threshold`) 
}


# stack both series into one long data frame for faceting
offpov_long <- bind_rows(
  offpov_fun(data = asec_final, x = "row") |> 
    mutate(panel = "Percent"),
  offpov_fun(data = asec_final) |> 
    mutate(`Below poverty threshold` = `Below poverty threshold`/1000000) |> 
    mutate(panel = "Number in millions")
)

# keep only the most recent year in each panel and format its label
offpov_last_pts <- offpov_long |>
  filter(year == max(year, na.rm = TRUE), .by = panel) |>
  mutate(lbl = if_else(
    panel == "Percent",
    label_percent(accuracy = 0.1)(`Below poverty threshold`),
    label_number(accuracy = 0.1)(`Below poverty threshold`)
  ))

ggplot(offpov_long, aes(x = year, y = `Below poverty threshold`)) +
  geom_line() +
  # highlight and label the last point in each panel
  geom_point(data = offpov_last_pts) +
  geom_text(data = offpov_last_pts, aes(label = lbl), hjust = -0.15, size = 3.5) +
  facet_wrap(~ panel, ncol = 1, scales = "free_y") +
  ggh4x::facetted_pos_scales(y = list(
    panel == "Percent" ~ scale_y_continuous(limits = c(0, 0.25), labels = label_percent()),
    panel == "Number in millions" ~ scale_y_continuous(labels = label_comma())
  )) +
  # widen the right side of the x-axis so the labels aren't clipped
  scale_x_continuous(expand = expansion(mult = c(0.02, 0.12))) +
  labs(
    title = "Number in poverty and poverty rate using the official poverty measure", 
    x = NULL, 
    y = NULL
  ) +
  theme_bw() +
  theme(
    strip.background = element_blank(),
    strip.text       = element_text(face = "bold", hjust = 0)
  )
