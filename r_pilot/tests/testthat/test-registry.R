test_that("every registry function exists and there are no dependency cycles", {
  expect_length(recode_functions, length(unique(c(registry$fn, registry$fn_unicon))))
  for (stage in unique(registry$stage)) {
    expect_setequal(stage_order(registry, recode_functions, stage), registry$variable[registry$stage == stage])
  }
})

test_that("exported variables have a label, samples and a tolerance", {
  exported <- dplyr::filter(registry, export)
  expect_true(all(exported$label != ""))
  expect_true(all(exported$samples == "basic;org"))
  expect_true(all(exported$tolerance %in% c(0, 0.01)))
})

test_that("table-kind variables declare the columns they read", {
  tables <- dplyr::filter(registry, kind == "table")
  expect_true(all(tables$depends != ""))
  # every declared column is computed by the registry
  expect_true(all(unlist(strsplit(tables$depends, ";")) %in% registry$variable))
})

test_that("value labels only cover exported variables", {
  expect_true(all(value_labels$variable %in% registry$variable[registry$export]))
  expect_false(any(duplicated(value_labels[, c("variable", "value")])))
})

test_that("every raw column exists in at least one dictionary the configured years use", {
  years <- pipeline_years(config, read_release_month(file.path(repo_dir, "config/release.yml")))
  years <- years[years >= census_first_year]
  dicts <- purrr::map(years, \(y) purrr::map_chr(1:12, ~ select_dictionary(y, .x))) |>
    unlist() |>
    unique()
  dict_columns <- purrr::map(dicts, ~ parse_dictionary(file.path(config$paths$dictionaries, paste0(.x, ".dct")))$varname) |>
    unlist()
  # reweight-only columns come from the reweight dictionaries, telework ones from the supplement
  rw_columns <- parse_dictionary(file.path(config$paths$dictionaries, "reweights", "rw0001.dct"))$varname
  tw_columns <- parse_dictionary(file.path(config$paths$dictionaries, "twoct2022.dct"))$varname
  raw <- registry_raw_columns(registry, recode_functions)
  expect_equal(setdiff(raw, c(dict_columns, rw_columns, tw_columns)), character(0))
})

test_that("export columns follow registry order and exclude intermediates", {
  basic <- export_columns(registry, "basic")
  expect_false(any(c("raw_age", "indcode", "ptwk", "ptdtrace") %in% basic))
  expect_equal(basic, registry$variable[registry$export])
  expect_equal(export_columns(registry, "org"), basic)
})

test_that("Unicon-era raw columns are all u_-prefixed Unicon columns", {
  raw <- registry_raw_columns(registry, recode_functions, "unicon")
  expect_true(all(startsWith(raw, "u_")))
  # and the Census era reads none of them
  expect_false(any(startsWith(registry_raw_columns(registry, recode_functions, "census"), "u_")))
})
