library(ggplot2)

# yearly employment-to-population ratios, built by R/figure_data.R
emp_figdata <- read.csv("data/emp_figdata.csv") |>
  tidyr::pivot_longer(-year, names_to = "group", values_to = "epop") |>
  dplyr::mutate(group = ifelse(group == "allepop", "Overall", "Prime-age"))

emp_colors <- c(Overall = "#E41A1C", `Prime-age` = "#377EB8")

# label each line just past its last year
emp_end_labels <- dplyr::filter(emp_figdata, year == max(year))

ggplot(emp_figdata, aes(year, epop, color = group)) +
  geom_line() +
  geom_text(data = emp_end_labels, aes(x = year + 0.5, label = group), hjust = 0, size = 3.5) +
  scale_color_manual(values = emp_colors, guide = "none") +
  scale_x_continuous(breaks = seq(1975, 2020, 5), expand = expansion(add = c(1, 8))) +
  scale_y_continuous(breaks = seq(55, 80, 5), labels = \(x) ifelse(x == 80, "80%", x)) +
  labs(x = NULL, y = NULL, title = "Employment-to-population ratios, overall and prime-age (25-54)") +
  theme_minimal()
