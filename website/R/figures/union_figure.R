library(ggplot2)

# yearly union membership and representation, built by R/figure_data.R
union_figdata <- read.csv("data/union_figdata.csv") |>
  tidyr::pivot_longer(-year, names_to = "measure", values_to = "share") |>
  dplyr::mutate(
    measure = ifelse(measure == "unmem", "Membership", "Representation"),
    # no union data in 1982: May (1973-1981) and ORG (1983+) series are drawn separately
    era = year > 1982
  )

union_colors <- c(Membership = "#4DAF4A", Representation = "#377EB8")

# label each line at 1977, nudged off the line
union_labels <- union_figdata |>
  dplyr::filter(year == 1977) |>
  dplyr::mutate(share = share + ifelse(measure == "Membership", -3, 2))

ggplot(union_figdata, aes(year, share, color = measure, group = interaction(measure, era))) +
  geom_line(na.rm = TRUE) +
  geom_text(data = union_labels, aes(label = measure), size = 3.5) +
  scale_color_manual(values = union_colors, guide = "none") +
  scale_x_continuous(breaks = seq(1975, 2020, 5)) +
  scale_y_continuous(breaks = seq(0, 30, 5), labels = \(x) ifelse(x == 30, "30%", x), limits = c(0, 30)) +
  labs(x = NULL, y = NULL, title = "Union representation and membership as a share of the workforce") +
  theme_minimal()
