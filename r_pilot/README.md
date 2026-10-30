# EPI CPS extracts in R (targets pipeline)

Builds the EPI CPS Basic and ORG extracts from raw Census files without
Stata, and checks every output column against the published Stata extracts.
Covers Basic from 1976 and ORG from 1979 through the latest month in
`config/release.yml`, all 140 published variables (`variables.csv`): Unicon
.dta files for 1976-1993 (with separate ORG files for 1979-1983) and raw
Census files from 1994. The latest year, if incomplete, is written as
monthly files, as Stata does.
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
| `variable_functions.csv` | Each variable's recode function per data source (`census_basic`, `unicon_basic`, ...) |
| `value_labels.csv` | Value labels for exported variables |
| `variable_notes.csv` | Stata notes for each variable (from `scripts/seed_notes.R`) |
| `crosswalks/mocc10.csv` | `mocc10` occupation code ranges by era (from `scripts/convert_mocc10.R`) |
| `parity_exceptions.csv` | Known, documented differences the gate reports but allows |
| `R/raw_ascii.R`, `R/dictionary.R` | Raw fixed-width parsing with the NBER dictionaries, the telework supplement, and the Unicon .dta files |
| `R/registry.R` | Reads the registry and computes variables in dependency order |
| `R/recode.R`, `R/demographics.R`, `R/labor.R`, `R/industry.R`, `R/geography.R` | Column recode functions (Census era) |
| `R/unicon.R` | Unicon-era recode functions (the registry's `fn_unicon` column) |
| `R/helpers.R` | Stata semantics in R: rounding, `replace ... if`, missing as +∞ |
| `R/org.R` | Universe filters; builds each sample's extract |
| `R/hoursu1i.R`, `R/topcode.R`, `R/wage.R` | The `wages` stage: hours imputation, top-coding, wage, wageotc (run on Basic and ORG) |
| `R/parity.R` | Comparison with the published extracts and the gate |
| `R/output.R`, `R/dta.R` | Labelled extract writing (.feather, and .dta in Stata 13 format) |

## Adding a variable

1. Write a recode function for each data source. Its arguments are the
   columns it reads: raw columns, or other registry variables. Unicon columns
   are prefixed `u_`; use `unicon_missing` where a source has no data. Context objects
   (`reweight_years`, `state_geocodes`, `wage_bounds`, `mocc10_crosswalk`)
   can also be arguments.
2. Add a row to `variables.csv` with its stage, whether it's
   exported, its samples and its parity tolerance (0 for codes, 0.01 for Stata
   float columns). The row's position sets the output column order, so put it
   where the published extracts have it. Add one row per source to
   `variable_functions.csv`; the pipeline stops if a source is missing.
3. Run `Rscript scripts/seed_labels.R` to copy its variable and value labels
   from the published extract.
4. Run `tar_make()`. Raw columns it needs are read from the cache
   automatically; the gate fails if anything differs from the published files.
5. For the docs site, fill in its `snippet` column and run
   `Rscript code/docs/generate_r_snippets.R` from the repo root.

## Outputs

- `output/epi_cps{basic,org}_<year>.feather` and `.dta`: labelled extracts with
  the data label `EPI CPS Basic Monthly Extracts, Version <version>` (ORG:
  `EPI CPS ORG Extracts, ...`). The `.dta` files are Stata 13 format with
  Stata's storage types and each variable's notes (`variable_notes.csv`),
  including `_dta[note1]`, which `load_epiextracts` reads.
- `reports/parity_values.csv`: per year, sample and variable: rows compared,
  missingness and value mismatches, non-whole values in integer columns, and
  rows in documented exception windows (`n_excepted`, `n_excepted_mismatch`).
- `reports/parity_metadata.csv`: variable labels, value labels, column order
  and data label against each published year.
- `parity_summary` target: fails the build if either report has a mismatch
  outside `parity_exceptions.csv`.
