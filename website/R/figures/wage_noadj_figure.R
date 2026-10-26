library(ggplot2)

# yearly mean real wages, adjusted vs unadjusted, built by R/figure_data.R
wage_noadj_figdata <- read.csv("data/wage_noadj_figdata.csv") |>
  tidyr::pivot_longer(-year, names_to = "variable", values_to = "wage") |>
  dplyr::mutate(variable = ifelse(variable == "wage", "wage (adjusted)", "wage_noadj (unadjusted)"))

wage_colors <- c(`wage (adjusted)` = "#377EB8", `wage_noadj (unadjusted)` = "#984EA3")

# label each line at 2008, nudged off the line
wage_noadj_labels <- wage_noadj_figdata |>
  dplyr::filter(year == 2008) |>
  dplyr::mutate(wage = wage + ifelse(variable == "wage (adjusted)", 1, -1))

ggplot(wage_noadj_figdata, aes(year, wage, color = variable)) +
  geom_line() +
  geom_text(data = wage_noadj_labels, aes(label = variable), size = 3.5) +
  scale_color_manual(values = wage_colors, guide = "none") +
  scale_x_continuous(breaks = seq(1975, 2020, 5)) +
  scale_y_continuous(breaks = seq(18, 36, 2), labels = scales::label_dollar(accuracy = 1)) +
  labs(x = NULL, y = NULL, title = "Mean real wages (in 2024$)") +
  theme_minimal()
