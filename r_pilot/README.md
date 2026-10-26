# EPI CPS extracts in R (targets pipeline)

Builds the EPI CPS Basic and ORG extracts from raw Census files without
Stata, and checks every output column against the published Stata extracts.
Currently covers Basic/ORG 2000–2024 for the variables in `variables.csv`.
The migration plan and phases are tracked outside the repo; deliberate
differences from Stata are in [DEVIATIONS.md](DEVIATIONS.md).

## Running

```r
# from r_pilot/
targets::tar_make()
```

The first run parses every raw month (about 18 seconds each) into
`cache/raw/` and caches the published extracts in `cache/reference/`. Later
runs only redo what changed. Run the tests with:

```sh
Rscript tests/testthat.R
```

`renv` pins package versions (`renv.lock`); run `renv::restore()` on a new machine.

## How it fits together

| File | Role |
|---|---|
| `../config/pipeline.yml` | Years, skipped months, reweight years, paths, worker count |
| `../config/release.yml` | Release version (written into each extract's data label) |
| `../config/cpi_projection.yml` | CBO levels used to project CPI-U-RS past the last actual year |
| `variables.csv` | The variable registry: one row per variable (see below) |
| `value_labels.csv` | Value labels for exported variables |
| `R/raw_ascii.R`, `R/dictionary.R` | Raw fixed-width parsing with the NBER dictionaries |
| `R/registry.R` | Reads the registry and computes variables in dependency order |
| `R/recode.R`, `R/demographics.R`, `R/geography.R` | Column recode functions |
| `R/org.R`, `R/hoursu1i.R`, `R/topcode.R`, `R/wage.R` | Universe filters and the ORG-stage imputations |
| `R/parity.R` | Comparison with the published extracts and the gate |
| `R/output.R` | Labelled extract writing |

## Adding a variable

1. Write a recode function. Its arguments are the columns it reads: raw
   Census columns, or other registry variables. Context objects
   (`reweight_years`, `state_geocodes`, `wage_bounds`) can also be arguments.
2. Add a row to `variables.csv` with the function name, stage, whether it's
   exported, its samples and its parity tolerance (0 for codes, 0.01 for Stata
   float columns). The row's position sets the output column order, so put it
   where the published extracts have it.
3. Run `Rscript scripts/seed_labels.R` to copy its variable and value labels
   from the published extract.
4. Run `tar_make()`. Raw columns it needs are read from the cache
   automatically; the gate fails if anything differs from the published files.
5. For the docs site, fill in its `snippet` column and run
   `Rscript code/docs/generate_r_snippets.R` from the repo root.

## Outputs

- `output/epi_cps{basic,org}_<year>.feather`: labelled extracts with the data
  label `EPI CPS Basic Monthly Extracts, Version <version>` (ORG: `EPI CPS ORG Extracts, ...`).
- `reports/parity_values.csv`: per year, sample and variable: rows compared,
  missingness and value mismatches, non-whole values in integer columns.
- `reports/parity_metadata.csv`: variable labels, value labels, column order
  and data label against each published year.
- `parity_summary` target: fails the build if either report has a mismatch.
