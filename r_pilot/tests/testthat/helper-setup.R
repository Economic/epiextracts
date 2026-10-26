# Load the pipeline's packages and functions; tests run from tests/testthat/.
pilot_dir <- normalizePath("../..")
repo_dir <- dirname(pilot_dir)

suppressMessages(source(file.path(pilot_dir, "packages.R")))
for (f in list.files(file.path(pilot_dir, "R"), full.names = TRUE)) source(f)

registry <- read_registry(file.path(pilot_dir, "variables.csv"))
recode_functions <- registry_functions(registry)
value_labels <- readr::read_csv(file.path(pilot_dir, "value_labels.csv"), col_types = "cdc")
config <- read_pipeline_config(file.path(repo_dir, "config/pipeline.yml"))
