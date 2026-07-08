# R Pilot: Basic Monthly CPS, 4 Variables, 2000-2024

Pilot `targets` pipeline recoding `age`, `female`, `emp`, and `basicwgt` for
CPS Basic Monthly, Census era, 2000-2024, ported from the Stata logic in
`../code/variables/generate_{age,female,emp,basicwgt,lfstat,cmpwgt}.do` and
`../code/sample_cpsbasic.do`.

Reads from the already Stata-converted intermediate monthly files at
`/data/cps/basic/census/stata/cps_<yyyy>_<m>.dta.zip` (produced by
`process_rawbasic.ado`) rather than re-parsing raw Census ASCII — porting the
raw-ingestion/dictionary system is out of scope for this pilot.

This is a proof-of-concept for the Stata-to-R/`targets` migration effort
described in `../STATA_TO_R_RECODE_PLANNING.md`. It does not feed the
production pipeline (`../master.do`, `../Makefile`) and does not modify
anything under `../extracts/`.

## Running

From within this directory:

```r
targets::tar_make()
```

Or from the repo root:

```r
targets::tar_make(script = "r_pilot/_targets.R", store = "r_pilot/_targets")
```

## Output

- `output/pilot_cpsbasic_<year>.feather` — recoded per-year extract
- `reports/parity_report.csv` — per-year, per-variable comparison against
  the published `../extracts/epi_cpsbasic_<year>.dta` reference extracts.
  Every row should show zero mismatches; `n_only_r`/`n_only_stata` should be
  zero at the year level.
