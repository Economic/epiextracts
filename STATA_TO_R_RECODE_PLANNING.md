# Planning: Recode Census-Era Pipeline to R (tidyverse/targets)

Scope as discussed: leave the Unicon-era Stata code untouched, and rebuild the
Census-era ingestion + variable-generation logic (Basic/ORG 1994+, March
1998+) as a `targets`-based R pipeline. This doc lays out how to plan the
project — the questions to answer before writing the first line of R, and the
prep work that's worth doing regardless of how those questions land.

---

## Recommended Planning Sequence

1. **Freeze scope in writing** — exact samples/years in scope, and a precise
   definition of "done" per variable.
2. **Build the parity-diffing harness before porting anything.** This is the
   real bottleneck of the whole project (see prior discussion) — build it
   first so effort estimates are based on evidence, not guesses.
3. **Pilot 4–5 variables across complexity tiers** (e.g. `union` — simple;
   `wage` — medium, has dependencies; `ind70` or a topcode variable — hard,
   crosswalk/imputation-heavy). Use this to validate the harness and the
   `targets` architecture before committing to all 141 variables.
4. **Re-forecast off pilot data**, not off an abstract estimate.
5. **Sequence remaining variables by dependency graph**, not alphabetically —
   weights/filters/core demographics first.
6. **Split roles deliberately** between the two people (+ me) — e.g. one
   drafts ports and runs the diff harness, the other reviews flagged
   mismatches and signs off; or split by variable domain.
7. **Track status per variable** on a living board (not started / ported /
   parity-testing / mismatch under review / signed off) rather than a single
   timeline estimate.

---

## Questions to Answer Before Starting

### Scope & definition of done
- Which samples and years exactly count as "Census era" for this migration?
  (Confirm: Basic/ORG 1994+, March 1998+ — does ORG track Basic's cutover or
  have its own?)
- Does "recode Census files" include the raw ASCII → Stata conversion step
  (`process_rawbasic.ado`, `process_rawmarch.ado` + the ~107 NBER dictionary
  files), or only the variable-generation logic in `generate_*.do`? (Worth
  confirming explicitly — dictionaries are Census-only regardless, since
  Unicon arrives pre-parsed as `.dta`, so there's no reason to exclude them.)
- What counts as parity for a ported variable — byte-identical values,
  a numeric tolerance, or "no material difference in published aggregates"?
  This threshold changes how long validation takes for every single variable.
- Who has final sign-off authority, and does it differ by variable domain
  (e.g. does a specific person need to approve wage/topcode logic vs.
  geography/demographics)?

### Technical & compatibility
- Do the R-produced extracts need to be schema-compatible (column names,
  order, value labels) with existing `.dta`/`.feather` output, so
  `load_epiextracts.ado` and public users see no difference?
- How will Census-era (R) and Unicon-era (Stata) output get stitched into a
  single per-sample release — separate year files combined at the
  `extracts/` step, or something else?
- Do downstream consumers — the `*_analysis.do` webdoc scripts, `mkdocs`
  build — need to keep working completely unmodified, or can those also
  change as part of this effort?
- What's the R package stack — `targets` + `tidyverse` confirmed, but also:
  `haven` for `.dta` read/write with labels? `arrow` for feather? A specific
  testing package (`testthat`/`tinytest`) for the parity harness?
- Is there a rollback plan if R output diverges in a way that can't be
  resolved before a monthly release deadline — delay the release, or ship
  Stata output for that month while investigating?
- How long is the parallel-run period (both pipelines producing output side
  by side) before fully cutting Census-era production over to R?

### Process & roles
- How much dedicated time can each of you realistically give this per week,
  given the monthly release cadence continues throughout?
- Is there tribal knowledge — deliberate Stata quirks, undocumented
  workarounds, "why" behind specific thresholds (e.g. the 2025m10 skip, the
  $2,884.61 topcode ceiling, era-cutover dates) — that lives only in one
  person's head and should be captured before porting starts?

### Timeline & constraints
- Is there an external deadline or pressure driving this (a specific
  release, funder deliverable, etc.), or is the timeline genuinely open?

---

## Preliminary Work We Can Start Now

These don't require the questions above to be settled, and de-risk the
project regardless of how scope shakes out:

- **Triage the 141 variable scripts into complexity tiers** (simple / medium
  / hard) based on line count, presence of era-branching, and cross-variable
  dependencies. I can generate this inventory directly from the codebase.
- **Map the variable dependency graph** — which variables reference which
  others (e.g. `wage` depends on `hours`, `topcode`, CPI adjustment) — so
  Step 5 (sequencing) can be done with real data instead of guesswork.
- **Draft the parity-diffing harness skeleton** — even a minimal version that
  loads a Stata `.dta` and an R output for the same variable/year/sample and
  reports mismatches — so the pilot has something to run against from day
  one.
- **Scaffold the R project structure** — `targets` pipeline skeleton, package
  dependencies, directory layout — in parallel with the above, so the pilot
  variables have somewhere to land.
- **Write down known Stata quirks and tribal knowledge** in one reference
  doc now, before context is lost to time or memory — this is cheap to do
  today and expensive to reconstruct later.
- **Confirm test-data availability** — enough raw Census ASCII files across
  the target year range, and enough historical Stata `.dta` output, to
  actually run the pilot and diff against.

---

*Next step: once scope questions are answered, run the pilot (Step 3) to
replace this plan's estimates with real per-variable timing data.*
