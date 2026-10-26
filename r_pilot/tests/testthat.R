# Run the pipeline's unit tests: Rscript tests/testthat.R (from r_pilot/)
library(testthat)
test_dir("tests/testthat", reporter = "summary", stop_on_failure = TRUE)
