library(ggplot2)

# yearly age-group shares, built by R/figure_data.R
age_figdata <- read.csv("data/age_figdata.csv")

age_colors <- c(
  "Ages 0-15" = "#E41A1C", "Ages 16-24" = "#377EB8", "Ages 25-39" = "#4DAF4A",
  "Ages 40-54" = "#984EA3", "Ages 55-64" = "#FF7F00", "Ages 65+" = "#A65628"
)

# label each line at 1987, nudged so the labels don't overlap
age_labels <- age_figdata |>
  dplyr::filter(year == 1987) |>
  dplyr::mutate(share = share + c(
    "Ages 0-15" = -1.1, "Ages 16-24" = 0.9, "Ages 25-39" = 1.0,
    "Ages 40-54" = 3.0, "Ages 55-64" = -1.9, "Ages 65+" = -0.7
  )[age_group])

ggplot(age_figdata, aes(year, share, color = age_group)) +
  geom_line() +
  geom_text(data = age_labels, aes(label = age_group), hjust = 0, size = 3.5) +
  scale_color_manual(values = age_colors, guide = "none") +
  scale_x_continuous(breaks = seq(1985, 2020, 5)) +
  scale_y_continuous(breaks = seq(5, 25, 5), labels = \(x) ifelse(x == 25, "25%", x), limits = c(5, 27)) +
  labs(x = NULL, y = NULL, title = "Share of civilian population by age group") +
  theme_minimal()
