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
| Telework supplement, 2022m10–2024m5 | `process_rawbasic.ado` merges it, but the published 2026.10.13 files have `telework`/`hourslwtw` all missing in those months | Merged from `<mon><yy>cpucvr_pub.zip` (own cache, `parse_telework()`), joined in `read_raw_year()` | The changelog documents these months; the published files lost them | Values where Stata has none; listed in `parity_exceptions.csv` so the gate reports but allows them |
| `hhwgt`/`famwgt`, 1994+ | Published 2026.10.13 files divide the raw weight by 10,000 although the dictionaries already apply its 4 decimals (fixed in `marchcps` commit 6efa92c, after those files were built) | Raw weight as read, except `hhwgt` 1994m4–1995m8 (dictionaries without the decimals) | Follows the fixed scripts | Values 10,000× the published ones; listed in `parity_exceptions.csv` |
| `.dta` writing | Stata `saveold, version(13)` after `compress` | `write_stata_dta()` (R/dta.R) writes format 117 directly, with the same storage types, labels and notes | haven can't write byte/int/float or notes; readstata13 can't write value labels on non-factors | None in Stata (`cf` matches), except below |
| Float precision of computed earnings | Stata computes from intermediates already stored as float | R computes in double, then stores float | R keeps full precision until storing | Last-digit float differences (relative ≤ 3e-7) in `wage_noadj`, `wageotc_noadj`, `weekpay`, `wage`, `wageotc` on about 3% of rows; within parity tolerance |
| Notes source | Whatever the scripts held at build time | `variable_notes.csv`, seeded from the marchcps scripts as Stata runs them (`scripts/seed_notes.R`) | The scripts are the source | Newer than the published files: the `hhwgt`/`famwgt` fix notes and `paidhre` note 2 (updated 2026-10-26). Stata's partial-year monthly files also carry the previous year's notes: the window starts from the previous release's file and `append` keeps its notes, adding new ones at the end (seen in the 2026m8 simulation) |
| Unicon era (1976-1993) | Era branches inside each `generate_*.do`, switched by `$date`, `$earnerinfo` and `$basicfile` | A second function per variable (`fn_unicon` in variables.csv, R/unicon.R); each year runs one era's functions; the file flags come from the cached file name | One rule set per era, so the verified Census-era code is untouched | None |
| Values beyond float range | Stata stores every generated variable as float/byte/int/long, so a value above about 1.7e38 becomes missing when stored | `stata_store()` applies the same at every computed column | Unicon's own missing code (about 1.75e100, in `ernwgt` and `famwgt` from 1985) must become missing, as in Stata | None |
| 1976-1977 geography | `generate_statefips.do` merges on a `statefips` the data doesn't have and keeps unmatched rows, so `statefips`, `statecensus`, `division` and `region` are missing | Reproduced: missing before 1978 | Matches the published files; Unicon's `state` would allow filling these in (a future fix) | None |
| 1978-1993 column order | The geocode merge leaves `statefips` before `division`/`region` and `statecensus` after them | `export_columns()` swaps the two for those years | Matches the published files | None |
| `mocc10` code ranges | 825 lines of `replace ... if` in `generate_mocc10.do` | `crosswalks/mocc10.csv` (542 ranges, generated by `scripts/convert_mocc10.R`), applied in script order | Data, not code; editable without touching R | None |
| Wage adjustments on Basic | `adjust_wages.do` runs on the Basic file and the ORG file separately | `build_extract_year()` runs the `wages` stage on each sample's table | Same as Stata; 2023–2024 monthly maxima come from the table being adjusted, as in `tc_fix.do` | None |

## Not yet ported (known gaps)

| Gap | Affects | Plan phase |
|---|---|---|

## Open decisions

- **CPI-U-RS 2025.** `suppdata/cpiurs_extended.csv` has 476.1; EPI's
  `realtalk` package has 474.7 (the mean of 2025's 11 published months).
  Confirm against the BLS CPI-U-RS table and update the CSV; R and Stata
  both read it.
- **Stata quirks**, decided while porting Basic/ORG (Phase 3):
  - *Reproduced:* `tc_weekpay`/`a_weekpay` reference `weekpay` before it
    exists, so Stata abbreviates to `weekpay_noadj`; R reads `weekpay_noadj`.
  - *Reproduced:* the race variants read the `ptdtrace` that
    `generate_wbho.do` creates from `prdtrace` in 2004m5–2005m7; R has a
    `ptdtrace` intermediate (`recode_ptdtrace()`) every race variable reads.
  - *Reproduced:* `wageotc_noadj` checks `peernhro` but divides by
    `hoursuorg`; the two are equal whenever the check passes.
  - *Reproduced:* unguarded comparisons where Stata treats missing as +∞
    (e.g. `hoursvary2 = 0 if pehrusl2 >= 0`), via `as_stata()`.
  - *Ported from `marchcps`:* the published 2026.10.13 extracts were built
    from the `marchcps` branch (`i_faminc`, `i_faminc_det`, `hoursvary`,
    published column order), so its `generate_*.do` scripts are the source.
  - *March/May:* `marchwgt` is never run; `generate_finalwgt.do` reads the
    March weight under `$maycps`, so March `finalwgt` is missing (reproduced).
- **March quirks, reproduced (Phase 5.3)**; fixing any of them is a Phase 7
  decision, made for both pipelines:
  - `hoursuorg` from 1995: `if ernel == 1 {` (`prerelg` from 1998) is a
    block `if`, so Stata reads only the first record, after the geocode
    merge has sorted by state with ties in no fixed order. Every row gets
    the hours in the years that record happened to be in the earnings
    sample (1996, 2000, 2006, 2011, 2014), none in the others. R uses that
    list of years (`march_hoursuorg_years`); a new year is missing. The
    intended rule is a per-row qualifier.
  - `statecensus` in 1998–2000 is Census's `hg_st60` renamed: it is the
    first column and carries full state names as value labels
    (`value_label_overrides`, `statecensus_first_years` in R/registry.R).
  - 1962 geography is missing (the merge keeps only unmatched rows), as
    for Basic 1976–1977.
  - 1962 race codes (0 white, 1 black, 2 other) go through the 1963 rules
    in `wbho`/`wbho_only`, so white is missing and black/other read as
    white/black; `raceorig`/`wbo_only` have their own 1962 rules.
  - `wbhom`/`wbhaom`: the 2003 window ends at 2012m1, so March 2012 is
    missing. `wbo_only` 1988–1995 leaves American Indian (race 3) missing.
  - No branch, so missing: `i_faminc` 1989, `famrel` 1968–1987,
    `a_weekpay` (it reads `weekpay`, abbreviated to `weekpay_noadj`, which
    is missing in March), `hoursu1`, the `hoursvary*` items,
    `i_faminc_det`, `tc_earnhour` and the disability items.
  - Note/label typos: `pubfed` (class6 vs class8), `schenrl` (1993 vs 1984),
    `difficulty` ("Doesn't not"). Labels are copied as published, typos
    included; fixing them is a docs decision (Phase 5).
