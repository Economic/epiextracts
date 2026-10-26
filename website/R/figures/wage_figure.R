library(ggplot2)

# yearly median real wages by gender, built by R/figure_data.R
wage_figdata <- read.csv("data/wage_figdata.csv") |>
  dplyr::mutate(gender = ifelse(female == 1, "Female", "Male"))

gender_colors <- c(Male = "#984EA3", Female = "#377EB8")

# label each line at 2009, nudged below the line
wage_labels <- wage_figdata |>
  dplyr::filter(year == 2009) |>
  dplyr::mutate(wage = wage + ifelse(gender == "Male", -1.2, -1))

ggplot(wage_figdata, aes(year, wage, color = gender)) +
  geom_line() +
  geom_text(data = wage_labels, aes(label = gender), size = 3.5) +
  scale_color_manual(values = gender_colors, guide = "none") +
  scale_x_continuous(breaks = seq(1975, 2020, 5)) +
  scale_y_continuous(breaks = seq(12, 30, 2), labels = scales::label_dollar(accuracy = 1)) +
  labs(x = NULL, y = NULL, title = "Median real wages by gender (in 2024$)") +
  theme_minimal()
