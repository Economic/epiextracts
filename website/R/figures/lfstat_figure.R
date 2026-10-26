library(ggplot2)

# yearly prime-age LFPR by gender, built by R/figure_data.R
lfstat_figdata <- read.csv("data/lfstat_figdata.csv") |>
  dplyr::mutate(gender = ifelse(female == 1, "Female", "Male"))

gender_colors <- c(Male = "#984EA3", Female = "#377EB8")

# label each line at 2009, nudged off the line
lfstat_labels <- lfstat_figdata |>
  dplyr::filter(year == 2009) |>
  dplyr::mutate(lfpr = lfpr + ifelse(gender == "Male", 3, -3))

ggplot(lfstat_figdata, aes(year, lfpr, color = gender)) +
  geom_line() +
  geom_text(data = lfstat_labels, aes(label = gender), size = 3.5) +
  scale_color_manual(values = gender_colors, guide = "none") +
  scale_x_continuous(breaks = seq(1975, 2020, 5)) +
  scale_y_continuous(breaks = seq(50, 100, 10), labels = \(x) ifelse(x == 100, "100%", x), limits = c(50, 100)) +
  labs(x = NULL, y = NULL, title = "Prime-age labor force participation rates, by gender") +
  theme_minimal()
