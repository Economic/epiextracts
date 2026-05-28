# EPI CPS Microdata Extracts — CLAUDE.md

## Project Overview

This project produces uniform, cleaned extracts of the Current Population Survey (CPS) for public release at https://microdata.epi.org. It covers four CPS samples:

| Sample | Years | Source |
|--------|-------|--------|
| **Basic Monthly** | 1976–present | Unicon (pre-1994), Census/BLS raw ASCII (1994+) |
| **May** | 1973–1981 | Unicon |
| **ORG** (Outgoing Rotation Group) | 1979–present | Unicon (pre-1994), Census (1994+) |
| **March (ASEC)** | 1962–present | Unicon (pre-1998), Census (1998+) |

Output files: `epi_cps{basic|march|may|org}_{year}.{dta|feather}` in `extracts/`.

---

## Tech Stack

- **Primary language:** Stata (`.do`, `.ado`)
- **R:** used only for `.dta → .feather` conversion (`extracts_to_feather.R`, 6-core parallel)
- **Documentation:** MkDocs + Material theme (source: `documentation/docs/`)
- **Deployment:** AWS S3 via `aws s3 sync`, `rsync` for internal data dirs
- **Orchestration:** `Makefile` (not `targets`/`make` for data; Stata is called manually)

---

## Directory Structure

```
master.do                    # Entry point — sets globals, loads programs, example calls
Makefile                     # Release pipeline (feather conversion, docs, deploy)
extracts_to_feather.R        # DTA → Feather converter (R, parallel)
suppdata/
  cpiurs_extended.csv        # CPI-U-RS values used for wage trimming and deflation
  state_geocodes.csv         # State FIPS, Census codes, divisions, regions
code/
  ado/                       # Stata programs loaded via adopath
    create_extracts.ado      # Main workhorse — month-by-month extract creation
    process_rawbasic.ado     # Converts Census/BLS raw ASCII to Stata (1994+)
    load_epiextracts.ado     # Public user-facing utility to load extracts
    load_rawcps.ado          # Dev utility to load raw CPS data
    merge_rawextracts.ado    # Dev utility: merge raw + processed for testing
    topcode_impute.ado       # Pareto-based top-code adjustment for wages
    keepifexist.ado          # Safely keep only existing variables
    valuelabel2md.ado        # Converts value labels to markdown tables
  variables/
    generate_*.do            # One script per variable (139 total)
  dictionaries/              # NBER/Census format dicts for raw ASCII parsing (~100 files)
    reweights/               # Reweight dictionaries
  docs/
    variables_groups.csv     # Master variable list with groups/categories
    descriptions/
      shortdesc/*.md         # One-line variable descriptions
      longdesc/*.md          # Full variable documentation
      availability/*.md      # Year/sample availability per variable
    analysis/
      *_analysis.do          # Webdoc scripts generating analysis figures for docs
    createdocs.do            # Generates MkDocs markdown from Stata/CSV sources
documentation/
  mkdocs.yml                 # Site config (version, latestdata, theme)
  docs/                      # MkDocs source pages
    variables/               # Auto-generated variable doc pages (10 subdirs)
    changes/changelog.md     # Release changelog (versioned)
    methodology/             # Technical methodology docs
packages/stata/              # Stata package files for public distribution
```

---

## Global Variables Set by `master.do`

```stata
global dataversion   "2026.5.14"   /* YYYY.M.DD — embedded in dataset labels/notes */
global code          "code/"
global extracts      "extracts/"
global suppdata      "suppdata/"
global codevars      "code/variables/"
global codedocs      "code/docs/"
global dictionaries  "code/dictionaries/"
global reweights     "code/dictionaries/reweights/"
global docs          "documentation/docs/"

* Raw data paths (external — not in repo)
global censusbasicraw   "/data/cps/basic/census/raw/"
global censusbasicstata "/data/cps/basic/census/stata/"
global censusmarchraw   "/data/cps/march/census/raw/"
global censusmarchstata "/data/cps/march/census/stata/"
global uniconbasic      "/data/cps/basic/unicon/"
global uniconmay        "/data/cps/may/unicon/"
global uniconmarch      "/data/cps/march/unicon/"
global uniconorg        "/data/cps/org/unicon/"
```

---

## Pipeline: Creating Extracts

### 1. Convert raw ASCII to Stata (Census data, 1994+)
```stata
do master.do
process_rawbasic, begin(2025m5) end(2026m4)
```
Uses NBER dictionaries in `code/dictionaries/` to parse fixed-width ASCII files from Census.

### 2. Create EPI extracts (all samples, all years)
```stata
create_extracts, begin(1962m1) end(2026m4)
do ${code}tc_fix.do     /* retroactive top-code corrections for 2023-2024 */
```
`create_extracts.ado` loops year-by-year and month-by-month, setting context globals then running each `generate_*.do` variable script. Output: one `.dta` per year per sample in `extracts/`.

**Context globals set inside `create_extracts`:**
- `$monthlycps`, `$maycps`, `$marchcps` — which sample is active
- `$basicfile` — 1 if this month has a basic monthly file
- `$earnerinfo` — 1 if ORG/earnings data available
- `$date` — current month in Stata monthly date format

### 3. Generate documentation
```stata
do code/docs/createdocs.do
```
Uses `webdoc` to create MkDocs markdown from variable descriptions and analysis scripts.

---

## Pipeline: Release

Run via `make` from the project root:

```makefile
all: createdocs deploywebdocs createfeather deploydata deploywebcode deploywebdata
```

| Target | Action |
|--------|--------|
| `createfeather` | `Rscript extracts_to_feather.R` — parallel DTA→Feather (6 cores) |
| `deploydata` | `rsync` `.dta`/`.feather` to `/data/cps/{sample}/epi/` |
| `createdocs` | `mkdocs build` in `documentation/` |
| `deploywebdocs` | `aws s3 sync documentation/site/ s3://microdata.epi.org/` |
| `deploywebcode` | Copy `.ado` files to S3 (Stata package distribution) |
| `deploywebdata` | Zip by decade, tar.gz Feather bundles, sync to S3 |

---

## Variable System

### 139 variables across 10 categories

Each variable has its own `code/variables/generate_{varname}.do` script. The master list with group assignments is `code/docs/variables_groups.csv`.

| Category | Count | Key Variables |
|----------|-------|---------------|
| Demographics | ~20 | `age`, `female`, `hispanic`, `wbho`, `wbhao`, `wbhom`, `married`, `veteran`, `citizen`, disability flags (`diffhear`, `diffmemory`, etc.) |
| Employment | ~20 | `lfstat`, `emp`, `unemp`, `union`, `unmem`, `uncov`, `selfemp`, `cow1`, `cow2`, `pubsec`, `pubst`, `pubfed`, `publoc` |
| Income/Wages | ~12 | `wage`, `wageotc`, `weekpay`, `wage_noadj`, `earnhour`, `otcamt`, `faminc`, `a_weekpay`, `tc_weekpay` |
| Hours | ~10 | `hoursu1`, `hoursu2`, `hourslw1`, `hourslw2`, `hoursumay`, `hoursvary`, `hoursu1i` (imputed), `hourslwtw` (telework) |
| Education | 4 | `educ`, `gradecom`, `gradehi`, `gradeatn` |
| Geography | ~8 | `statefips`, `division`, `region`, `countyfips`, `cbsafips`, `cbsasize`, `metstat` |
| Industry | ~10 | `indcode`, `ind70/80/90/02/07/12/17/22`, `mind03`, `mind16`, `dind03` |
| Occupation | ~10 | `occcode`, `occ70/80/90/00/10/18`, `mocc03`, `mocc10`, `docc03` |
| Identifiers | ~15 | `hrhhid`, `hhid`, `famid`, `year`, `month`, `hhseq`, `pernum` |
| Weights | ~12 | `finalwgt`, `basicwgt`, `cmpwgt`, `orgwgt`, `hhwgt`, `famwgt`, `earnwgt` |

### Variable script conventions

Scripts check context globals to handle era-specific source variable names:
```stata
* typical pattern in a generate_*.do script
if $monthlycps {
    if $date < tm(1994m1) {
        * Unicon era variable names
        gen wage = prernwa ...
    }
    else {
        * Census era variable names
        gen wage = pternwa ...
    }
}
```

---

## Key Technical Details

### CPI adjustment
- Uses **CPI-U-RS** (extended) from `suppdata/cpiurs_extended.csv`
- Base year: **1989**
- Wage trimming bounds: `wage_lower = $0.50 × CPI_ratio`, `wage_upper = $100.00 × CPI_ratio`
- 2026 CPI: projected using CBO's 2025–2026 growth rate (applied in `create_extracts.ado`)

### Top-code handling
| Period | Method |
|--------|--------|
| Pre-April 2023 | Fixed ceiling ($2,884.61/week); Pareto imputation via `topcode_impute.ado` |
| April 2023–March 2024 | Dynamic Census top-codes (phased rollout by `minsamp`); `tc_fix.do` applies retroactive corrections |
| April 2024+ | No adjustment needed (dynamic codes fully standard) |

### Hours imputation (`hoursu1i`)
For non-hourly workers (`paidhre == 0`) who report "hours vary," hours are imputed via regression on demographics and industry. Used in wage calculation.

### Race/ethnicity coding evolution
- `wbho`: White, Black, Hispanic, Other (1989+)
- `wbhao`: adds Asian category (1989+)
- `wbhom`: multiracial-aware version (2003+)
- `wbo_only`, `wbho_only`: single-race only variants

### Industry/occupation over time
Census reclassifies codes periodically. Both raw Census codes (`ind02`, `ind07`, etc.) and harmonized codes (`mind16`, `mocc10`) are included. Harmonized codes require manual crosswalk maintenance.

---

## Stata Dependencies (must be installed)

```stata
ssc install webdoc, replace
ssc install gtools
ssc install ashell, replace
ssc install moreobs, replace
ssc install maptile, replace
ssc install spmap, replace
ssc install labutil, replace
maptile_install using "http://files.michaelstepner.com/geo_statehex.zip"
maptile_install using "http://files.michaelstepner.com/geo_cbsa2013.zip"
maptile_install using "http://files.michaelstepner.com/geo_state.zip"
maptile_install using "http://files.michaelstepner.com/geo_county2014.zip"
```

Also requires: Python `tabulate` module, EPI CPI Stata package (`github.com/Economic/cpi`).

---

## Versioning & Release Cadence

- **Version format:** `YYYY.M.DD` (e.g., `2026.5.14` = May 14, 2026)
- **Frequency:** Monthly, typically ~2 weeks after Census releases new CPS data
- **Version is set** in `master.do` (`global dataversion`) and `documentation/mkdocs.yml` (`extra.version`, `extra.latestdata`)
- **Changelog:** `documentation/docs/changes/changelog.md` — must be updated with every release
- **Critical bugs** may trigger retroactive updates across prior releases (e.g., the 2023–2024 top-code fix)

### Steps to update for a new month
1. Update `global dataversion` in `master.do`
2. Update `version` and `latestdata` in `documentation/mkdocs.yml`
3. `process_rawbasic, begin(...) end(...)` for new months
4. `create_extracts, begin(1962m1) end(...)` (or targeted date range)
5. `do ${code}tc_fix.do` if applicable
6. `do code/docs/createdocs.do`
7. `make` (or individual make targets as needed)

---

## Development & Testing

- **Test template:** `code/variables/test_variable.do` — loads a date range, merges raw+processed via `merge_rawextracts.ado`, runs crosstabs
- **No automated test suite** — testing is manual spot-checks and crosstab review
- **Log file:** `test_create_extracts.log` — generated during test runs
- **Dev workflow:** use `merge_rawextracts.ado` to load a processed extract and merge back specific raw Census variables for comparison

---

## Common Gotchas

- **October 2025 is skipped** in `create_extracts.ado` (hardcoded `continue` for 2025m10) — likely a data quality issue with that month's release
- **Unicon vs Census era** variable names differ; all `generate_*.do` scripts must handle both
- **`keepifexist.ado`** is used throughout because not all variables exist in all samples/years — use it instead of `keep varlist` to avoid errors
- **`adopath ++ ${code}ado`** in `master.do` must run before any program is called; always run `master.do` first
- **CPI 2026** is a projection, not official data — will need updating when BLS releases actuals
- The `.feather` files use Apache Arrow format; `extracts_to_feather.R` uses the `arrow` R package with `haven` for label preservation
