# Build the Quarto site. Run from website/: Rscript build.R
# (figure data is built separately and less often: Rscript R/figure_data.R)

# generate variable pages and the variable index
source("R/build_variable_pages.R")

# render the whole site into _site/
quarto::quarto_render(as_job = FALSE)
