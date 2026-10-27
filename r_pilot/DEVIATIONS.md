# Deviations from the Stata pipeline

Every place the R pipeline deliberately does something different from the
Stata code, or doesn't (yet) do something it does. Add an entry before
porting anything that departs from Stata; the parity gate assumes everything
not listed here matches.

## Deliberate differences

| Area | Stata | R | Why | Output effect |
|---|---|---|---|---|
| Top-code fix for 2023–2024 | `generate_weekpay.do`, then a separate manual `code/tc_fix.do` rewrite of the 2023/2024 files | One era-aware pass in `add_weekpay()` (`R/topcode.R`) | No manual post-step to forget | None: parity matches the fixed files |
| Dictionary end date | `cpsbjun2024` capped at 2026m9 in `process_rawbasic.ado:131` | Open-ended in `select_dictionary()` | The cap marks how far it was tested, not a format change; Stata will fail on 2026m10 data | None for covered years |
| metstat eras | Separate 1994m1–1995m5 and 1995m9–2004m4 branches | One 2004m5 boundary | Both branches read the same raw column | None for 2000+ |
| Raw parsing | Converts each month to a `.dta` with the dictionary's columns | Parses every dictionary column once into `cache/raw/` parquet | Adding variables never re-parses raw files | None |
| NUL bytes in 1994-1997 raw files | `infile` reads each record whole; the field is missing | NULs are replaced with spaces before parsing (`without_nul_bytes()`) | readr would split the record at a NUL | None |
| Partial-year top-coding | One top-code pass over the whole trailing window | Each calendar year in the window top-coded separately | Same result whenever the window's years are 2025+ (no imputation, passthrough), which holds for every partial year the pipeline builds | None for 2026 |
| CPI source | `suppdata/cpiurs_extended.csv`, 2026 projected with CBO levels hardcoded in `create_extracts.ado` | Same CSV, projection from `config/cpi_projection.yml` via `cpi_annual_fun()` | One copy of the CBO numbers, works for any year | None (wage limits identical 1962–2026) |

## Not yet ported (known gaps)

| Gap | Affects | Plan phase |
|---|---|---|
| `hoursu1i`, `weekpay`, `wage` only computed for ORG; the published Basic files also have them | Basic extracts | Phase 3 |
| Telework supplement merge (2022m10–2024m5). The raw supplement files (`<mon><yy>cpucvr_pub.zip`) are not on disk anywhere; the merged columns survive only in Stata's monthly intermediates (`/data/cps/basic/census/stata/cps_<yyyy>_<m>.dta.zip`, e.g. `ptcovr1`–`ptcovr4`). Re-download the supplement from Census, or read those columns from the intermediates. | `telework`, `hourslwtw` | Phase 3 |
| `tc_weekpay` computed internally for 2023–2024 only, not exported | `tc_weekpay` | Phase 3 |
| Stata `notes` (per-variable and `note1` version note) | `.dta` output; `load_epiextracts` reads `note1` | Phase 4 |

## Open decisions

- **CPI-U-RS 2025.** `suppdata/cpiurs_extended.csv` has 476.1; EPI's
  `realtalk` package has 474.7 (the mean of 2025's 11 published months).
  Confirm against the BLS CPI-U-RS table and update the CSV; R and Stata
  both read it.
- **Stata quirks to reproduce or fix** before porting the variables involved:
  - `marchwgt` is never run (missing from `generate_variables.do`).
  - `generate_finalwgt.do` reads the March weight under `$maycps`, not `$marchcps`.
  - `tc_weekpay`/`a_weekpay` reference `weekpay` before it exists; Stata
    abbreviates to `weekpay_noadj`. Port with `weekpay_noadj`.
  - The race variants rely on `ptdtrace` created inside `generate_wbho.do`.
  - `wageotc_noadj` checks `peernhro` but divides by `hoursuorg`.
  - Note/label typos: `pubfed` (class6 vs class8), `schenrl` (1993 vs 1984), `difficulty`.
