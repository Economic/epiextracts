library(ggplot2)

# yearly public sector shares by gender, built by R/figure_data.R
pubsec_figdata <- read.csv("data/pubsec_figdata.csv") |>
  dplyr::mutate(
    gender = ifelse(female == 1, "Female", "Male"),
    # survey changes break the series: May to Basic (1976), 1989 and 1994 redesigns
    era = cut(year, breaks = c(-Inf, 1975, 1988, 1993, Inf))
  )

gender_colors <- c(Male = "#984EA3", Female = "#377EB8")

# label each line at 2014, nudged off the line
pubsec_labels <- pubsec_figdata |>
  dplyr::filter(year == 2014) |>
  dplyr::mutate(pubsec = pubsec + ifelse(gender == "Male", -2, 2))

ggplot(pubsec_figdata, aes(year, pubsec, color = gender, group = interaction(gender, era))) +
  geom_line() +
  geom_text(data = pubsec_labels, aes(label = gender), size = 3.5) +
  scale_color_manual(values = gender_colors, guide = "none") +
  scale_x_continuous(breaks = seq(1975, 2020, 5)) +
  scale_y_continuous(breaks = seq(0, 25, 5), labels = \(x) ifelse(x == 25, "25%", x), limits = c(0, 25)) +
  labs(x = NULL, y = NULL, title = "Public sector share of workforce, ages 16-64, by gender") +
  theme_minimal()
