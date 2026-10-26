library(ggplot2)

# yearly educational attainment shares, built by R/figure_data.R
educ_labels <- c(
  lths = "Less than\nhigh school", hs = "High school", some = "Some college",
  college = "College", advanced = "Advanced"
)
educ_figdata <- read.csv("data/educ_figdata.csv") |>
  tidyr::pivot_longer(-year, names_to = "educ", values_to = "share") |>
  dplyr::mutate(
    educ = factor(educ_labels[educ], levels = educ_labels),
    # the 1992 question change breaks each series
    era = year >= 1992
  )

educ_colors <- setNames(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00"), educ_labels)

# label each line just past its last year; some college and college end close together, so spread them
educ_end_labels <- dplyr::filter(educ_figdata, year == max(year)) |>
  dplyr::mutate(share = share + dplyr::case_match(as.character(educ), "Some college" ~ 0.9, "College" ~ -0.9, .default = 0))

ggplot(educ_figdata, aes(year, share, color = educ, group = interaction(educ, era))) +
  geom_line() +
  geom_text(data = educ_end_labels, aes(x = year + 0.5, label = educ), hjust = 0, size = 3.5, lineheight = 0.9) +
  scale_color_manual(values = educ_colors, guide = "none") +
  scale_x_continuous(breaks = seq(1975, 2020, 5), expand = expansion(add = c(1, 10))) +
  scale_y_continuous(breaks = seq(0, 40, 5), labels = \(x) ifelse(x == 40, "40%", x)) +
  labs(x = NULL, y = NULL, title = "Share of population age 25 and over by educational attainment") +
  theme_minimal()
