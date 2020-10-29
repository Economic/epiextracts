library(tidyverse)
library(doParallel)

# function to type.convert vector and preserve labels
type_convert_labels <- function(x) {
  # grab labels
  if ( haven::is.labelled(x) ) {
    is_labelled <- TRUE
    labels <- attributes(x)[["labels"]]
  }
  else is_labelled <- FALSE
  
  # compress columns as best as possible
  # this will discard labels
  x <- type.convert(x)
  # labelled class does not work on logical vectors, 
  # converting back to integer for now.
  # I think/hope this won't introduce problems over different years of data?
  if (is.logical(x)) {
    x <- as.integer(x)
  }

  # add labels back if needed
  if ( is_labelled ) {
    haven::labelled(x, labels)
  }
  else x
}

# function to copy foo.dta as foo.feather
dta_to_feather <- function(x) {
  # read in .dta
  dta <- haven::read_dta(x)

  # correct column types
  dta <- mutate(dta, across(where(is.numeric), type_convert_labels))

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