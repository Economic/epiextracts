library(tidyverse)
library(doParallel)

# function to copy foo.dta as foo.feather
# this will strip the labels and other attributes of foo.dta
dta_to_feather <- function(x) {
  # read in .dta
  dta <- haven::read_dta(x)

  # correct column types
  dta <- mutate(dta, across(where(is.numeric), type.convert))

  # write feather
  feather_filename <- gsub("\\.dta$", ".feather", x)
  arrow::write_feather(dta, feather_filename)
  return(NULL)
}

# grab filenames to convert
extractsdir <- "extracts"
files <- list.files(extractsdir, pattern = "*.dta", full.names = TRUE)

# process files in parallel
registerDoParallel(cores=6)
mcoptions <- list(preschedule=FALSE, set.seed=FALSE)
foreach(i=files, .options.multicore = mcoptions) %dopar% dta_to_feather(i)

extract_labels <- function(x) {
  variable_label <- attributes(cps_data[[x]])[["label"]]
  value_label <- attributes(cps_data[[x]])[["labels"]] %>%  enframe() %>% list()
  tibble(
    variable_name = quo_name(enquo(x)),
    variable_label = variable_label,
    value_label = value_label
  )
}

# save labels
cps_data <- haven::read_dta(file.path(extractsdir, "epi_cpsorg_1979.dta"))
epi_cpsorg_labels <- map_df(colnames(cps_data), extract_labels)
save_label_rds <- function(x) {
  filename <- file.path(extractsdir, paste0("epi_cps", x, "_labels.rds"))
  saveRDS(epi_cpsorg_labels, filename)
}
map(c("org", "march", "may", "basic"), ~ save_label_rds(.))


