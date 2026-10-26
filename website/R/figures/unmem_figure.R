library(ggplot2)

# yearly union membership by gender, built by R/figure_data.R
unmem_figdata <- read.csv("data/unmem_figdata.csv") |>
  dplyr::mutate(
    gender = ifelse(female == 1, "Women", "Men"),
    # no union data in 1982: May (1973-1981) and ORG (1983+) series are drawn separately
    era = year > 1982
  )

gender_colors <- c(Men = "#4DAF4A", Women = "#377EB8")

# label each line at 1977, nudged off the line
unmem_labels <- unmem_figdata |>
  dplyr::filter(year == 1977) |>
  dplyr::mutate(unmem = unmem + ifelse(gender == "Men", 2.5, -4))

ggplot(unmem_figdata, aes(year, unmem, color = gender, group = interaction(gender, era))) +
  geom_line() +
  geom_text(data = unmem_labels, aes(label = gender), size = 3.5) +
  scale_color_manual(values = gender_colors, guide = "none") +
  scale_x_continuous(breaks = seq(1975, 2020, 5)) +
  scale_y_continuous(breaks = seq(0, 35, 5), labels = \(x) ifelse(x == 35, "35%", x), limits = c(0, 35)) +
  labs(x = NULL, y = NULL, title = "Union members as a share of the workforce, by gender") +
  theme_minimal()
