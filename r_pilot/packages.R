library(targets)
library(tarchetypes)

library(conflicted)
conflict_prefer("filter", "dplyr", quiet = TRUE)
conflict_prefer("lag", "dplyr", quiet = TRUE)

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(purrr)
  library(tibble)
  library(stringr)
  library(readr)
  library(haven)
  library(arrow)
  library(fs)
})
