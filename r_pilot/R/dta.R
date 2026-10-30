# Writing Stata .dta files in format 117, which Stata's `saveold, version(13)`
# writes for the published extracts. haven can't write Stata's compact types
# (byte, int, float) or notes, and readstata13 only writes value labels for
# factors, so this writes the format directly: storage types as Stata's
# `compress` leaves them, variable and value labels, the data label, and
# notes (stored as characteristics, including _dta[note1] with the version,
# which load_epiextracts reads).
#
# Format reference: https://www.stata.com/help.cgi?dta_117

# Stata's storage type codes, sizes and missing-value (.) codes
stata_type_code <- c(byte = 65530L, int = 65529L, long = 65528L, float = 65527L, double = 65526L)
stata_type_size <- c(byte = 1L, int = 2L, long = 4L, float = 4L, double = 8L)
stata_missing <- list(byte = 101L, int = 32741L, long = 2147483621L, float = 2^127, double = 2^1023)

#' Storage type Stata's `compress` leaves a column in. Stata creates numeric
#' variables as float unless told otherwise; compress shrinks whole numbers
#' to byte or int when they fit, but leaves other whole-number floats alone
#' (a long saves nothing over a float). A variable created as byte/int/long
#' (`integer`) is promoted to a larger integer type as values grow, never to
#' float, so its whole numbers end as byte, int or long. Strings are as wide
#' as the longest value.
stata_storage_type <- function(x, integer = FALSE) {
  if (is.character(x)) return(paste0("str", max(1L, nchar(x, type = "bytes"), na.rm = TRUE)))
  v <- x[!is.na(x)]
  if (length(v) == 0) return("byte")
  if (any(v != round(v))) return("float")
  if (min(v) >= -127 && max(v) <= 100) return("byte")
  if (min(v) >= -32767 && max(v) <= 32740) return("int")
  if (integer && min(v) >= -2147483647 && max(v) <= 2147483620) return("long")
  # whole numbers a float holds exactly (|x| <= 2^24) stay float
  if (max(abs(v)) <= 2^24) return("float")
  if (min(v) >= -2147483647 && max(v) <= 2147483620) return("long")
  "double"
}

#' Values as a float stores them (single precision), as Stata's float
#' variables hold them. Missing values stay missing.
float_round <- function(x) {
  y <- readBin(writeBin(as.double(x), raw(), size = 4, endian = "little"), "double",
               n = length(x), size = 4, endian = "little")
  y[is.na(x)] <- NA_real_
  y
}

#' Display format: Stata's defaults, widened to fit the longest value label.
stata_format <- function(type, labels = NULL) {
  if (startsWith(type, "str")) return(sprintf("%%%ds", max(9L, as.integer(sub("str", "", type)))))
  width <- c(byte = 8L, int = 8L, long = 12L, float = 9L, double = 10L)[[type]]
  if (length(labels) > 0) width <- max(width, nchar(names(labels), type = "bytes"))
  sprintf("%%%d.0g", width)
}

# --- binary helpers (little-endian) -----------------------------------------
tag <- function(x) charToRaw(x)
int_bytes <- function(x, size) writeBin(as.integer(x), raw(), size = size, endian = "little")
# 8-byte unsigned offsets for the map
uint64_bytes <- function(x) as.raw(unlist(lapply(x, function(v) (v %/% 256^(0:7)) %% 256)))

#' Text in a fixed-width, null-padded field (always null-terminated).
fixed_text <- function(x, width) {
  bytes <- charToRaw(enc2utf8(x %||% ""))
  bytes <- bytes[seq_len(min(length(bytes), width - 1))]
  c(bytes, raw(width - length(bytes)))
}

#' One column's bytes for the data section: a (size x N) raw matrix.
column_bytes <- function(x, type) {
  if (startsWith(type, "str")) {
    width <- as.integer(sub("str", "", type))
    x <- dplyr::coalesce(enc2utf8(x), "")
    nbytes <- nchar(x, type = "bytes")
    if (all(nbytes == nchar(x))) {
      # single-byte text: pad with spaces in one pass, then turn padding into nulls
      m <- matrix(charToRaw(paste(formatC(x, width = -width), collapse = "")), nrow = width)
      m[row(m) > rep(nbytes, each = width)] <- as.raw(0)
      return(m)
    }
    return(vapply(x, fixed_text, raw(width), width = width + 1, USE.NAMES = FALSE)[seq_len(width), , drop = FALSE])
  }
  size <- stata_type_size[[type]]
  if (type %in% c("float", "double")) {
    values <- dplyr::coalesce(as.double(x), stata_missing[[type]])
    return(matrix(writeBin(values, raw(), size = size, endian = "little"), nrow = size))
  }
  values <- dplyr::coalesce(as.integer(x), stata_missing[[type]])
  matrix(writeBin(values, raw(), size = size, endian = "little"), nrow = size)
}

#' One value-label table (<lbl> ... </lbl>).
value_label_bytes <- function(name, labels) {
  labels <- labels[order(labels)]
  text <- lapply(names(labels), function(l) c(charToRaw(enc2utf8(l)), as.raw(0)))
  offsets <- c(0L, cumsum(lengths(text)))[seq_along(text)]
  table <- c(int_bytes(length(labels), 4), int_bytes(sum(lengths(text)), 4),
             int_bytes(offsets, 4), int_bytes(unname(labels), 4), unlist(text))
  c(tag("<lbl>"), int_bytes(length(table), 4), fixed_text(name, 33), raw(3), table, tag("</lbl>"))
}

#' One characteristic (<ch> ... </ch>): a note is varname[noteN] = text.
characteristic_bytes <- function(variable, name, contents) {
  body <- c(fixed_text(variable, 33), fixed_text(name, 33), charToRaw(enc2utf8(contents)), as.raw(0))
  c(tag("<ch>"), int_bytes(length(body), 4), body, tag("</ch>"))
}

#' Write a labelled table as a Stata 13 (format 117) .dta file.
#'
#' data: columns with "label" attributes and, for value-labelled ones,
#'   haven_labelled "labels"; attr(data, "label") is the data label.
#' notes: variable_notes.csv rows (variable, note, text); the data label is
#'   also written as _dta[note1], as Stata's `notes _dta:` does.
#' label_names: value-label names that differ from the variable's
#'   (mocc10's label is called occ_lab).
#' uncompressed: variables Stata creates after `compress` (adjust_wages.do's
#'   hoursu1i, weekpay, wage, wageotc), which keep Stata's default float.
#' integer_vars: variables the scripts create as byte/int/long (stata_type in
#'   variables.csv; see stata_storage_type()).
write_stata_dta <- function(data, path, notes, label_names = c(mocc10 = "occ_lab"), uncompressed = character(0),
                            integer_vars = character(0)) {
  k <- ncol(data)
  n <- nrow(data)
  vars <- names(data)
  types <- vapply(vars, function(v) stata_storage_type(data[[v]], v %in% integer_vars), character(1))
  types[vars %in% uncompressed & !startsWith(types, "str")] <- "float"
  # bytes per value: a string's width, or the numeric type's size
  type_size <- vapply(types, function(t) if (startsWith(t, "str")) as.integer(sub("str", "", t)) else stata_type_size[[t]], integer(1))
  labels <- lapply(data, function(x) attr(x, "labels"))
  label_name <- ifelse(lengths(labels) > 0, dplyr::coalesce(unname(label_names[vars]), vars), "")
  data_label <- attr(data, "label") %||% ""

  # header: release, byte order, K, N, data label, timestamp
  now <- as.POSIXlt(Sys.time())
  stamp <- sprintf("%02d %s %d %02d:%02d", now$mday, month.abb[now$mon + 1], now$year + 1900, now$hour, now$min)
  label_raw <- charToRaw(enc2utf8(data_label))[seq_len(min(80, nchar(data_label, type = "bytes")))]
  header <- c(tag("<stata_dta><header><release>117</release><byteorder>LSF</byteorder><K>"), int_bytes(k, 2),
              tag("</K><N>"), int_bytes(n, 4), tag("</N><label>"), as.raw(length(label_raw)), label_raw,
              tag("</label><timestamp>"), as.raw(nchar(stamp)), charToRaw(stamp), tag("</timestamp></header>"))

  # descriptors: types, names, sort order (none), formats, label names, variable labels
  type_codes <- ifelse(startsWith(types, "str"), type_size, stata_type_code[types])
  sections <- list(
    variable_types = c(tag("<variable_types>"), int_bytes(type_codes, 2), tag("</variable_types>")),
    varnames = c(tag("<varnames>"), unlist(lapply(vars, fixed_text, 33)), tag("</varnames>")),
    sortlist = c(tag("<sortlist>"), raw(2 * (k + 1)), tag("</sortlist>")),
    formats = c(tag("<formats>"), unlist(lapply(seq_len(k), function(i) fixed_text(stata_format(types[i], labels[[i]]), 49))),
                tag("</formats>")),
    value_label_names = c(tag("<value_label_names>"), unlist(lapply(label_name, fixed_text, 33)), tag("</value_label_names>")),
    variable_labels = c(tag("<variable_labels>"),
                        unlist(lapply(data, function(x) fixed_text(attr(x, "label") %||% "", 81))), tag("</variable_labels>"))
  )

  # characteristics: each variable's notes (note0 = count), then the version note
  notes <- notes[notes$variable %in% vars, ]
  chars <- c(
    characteristic_bytes("_dta", "note0", "1"),
    characteristic_bytes("_dta", "note1", data_label),
    unlist(lapply(split(notes, factor(notes$variable, levels = unique(notes$variable))), function(d) {
      c(characteristic_bytes(d$variable[1], "note0", as.character(nrow(d))),
        unlist(purrr::map2(d$note, d$text, ~ characteristic_bytes(d$variable[1], paste0("note", .x), .y))))
    }))
  )
  sections$characteristics <- c(tag("<characteristics>"), chars, tag("</characteristics>"))

  # data: rows of fixed-width fields, built column by column
  row_width <- sum(type_size)
  rows <- matrix(as.raw(0), nrow = row_width, ncol = n)
  offset <- 0L
  for (i in seq_len(k)) {
    bytes <- column_bytes(data[[i]], types[i])
    rows[offset + seq_len(nrow(bytes)), ] <- bytes
    offset <- offset + nrow(bytes)
  }

  # value labels: one table per label name
  first_use <- which(label_name != "" & !duplicated(label_name))
  value_labels <- c(tag("<value_labels>"), unlist(lapply(first_use, function(i) value_label_bytes(label_name[i], labels[[i]]))),
                    tag("</value_labels>"))

  # map: where each section starts (computed from section sizes), then write
  data_open <- tag("<data>")
  data_close <- tag("</data>")
  strls <- tag("<strls></strls>")
  close_tag <- tag("</stata_dta>")
  map_size <- length(tag("<map>")) + 14 * 8 + length(tag("</map>"))
  sizes <- c(header = length(header), map = map_size, lengths(sections),
             data = length(data_open) + as.double(row_width) * n + length(data_close),
             strls = length(strls), value_labels = length(value_labels), close = length(close_tag))
  starts <- c(0, cumsum(sizes))
  # map entries: <stata_dta>, <map>, the 7 descriptor sections, <data>, <strls>,
  # <value_labels>, </stata_dta>, end of file
  map <- c(0, starts[2:12], starts[13], starts[14])
  map_bytes <- c(tag("<map>"), uint64_bytes(map), tag("</map>"))

  con <- file(path, "wb")
  on.exit(close(con))
  writeBin(c(header, map_bytes, unlist(sections, use.names = FALSE), data_open), con)
  writeBin(as.vector(rows), con)
  writeBin(c(data_close, strls, value_labels, close_tag), con)
  invisible(path)
}

#' Read a format-117 .dta file's metadata without its data: row count, data
#' label, and per variable the storage type, display format, value-label
#' name, variable label and notes. (haven doesn't expose types or notes.)
read_dta_metadata <- function(path) {
  con <- file(path, "rb")
  on.exit(close(con))
  head_bytes <- readBin(con, "raw", 4096)
  stopifnot(identical(rawToChar(head_bytes[29:31]), "117"))
  read_uint <- function(bytes, at, size) {
    sum(as.numeric(bytes[at + seq_len(size) - 1]) * 256^(seq_len(size) - 1))
  }
  k <- read_uint(head_bytes, grepRaw("<K>", head_bytes) + 3, 2)
  n <- read_uint(head_bytes, grepRaw("<N>", head_bytes) + 3, 4)
  label_at <- grepRaw("<label>", head_bytes) + 7
  label_length <- as.integer(head_bytes[label_at])
  data_label <- if (label_length > 0) rawToChar(head_bytes[label_at + seq_len(label_length)]) else ""
  # the map: where each section starts
  map_at <- grepRaw("<map>", head_bytes) + 5
  map <- vapply(0:13, function(i) read_uint(head_bytes, map_at + 8 * i, 8), numeric(1))

  # everything before the data: the descriptors and characteristics
  seek(con, 0)
  meta <- readBin(con, "raw", map[10])
  text_fields <- function(start, tag_length, width) {
    vapply(seq_len(k), function(i) {
      field <- meta[start + 1 + tag_length + (i - 1) * width + seq_len(width) - 1]
      rawToChar(field[seq_len(max(0, which(field == as.raw(0))[1] - 1))])
    }, character(1))
  }
  codes <- vapply(seq_len(k), function(i) read_uint(meta, map[3] + 1 + 16 + 2 * (i - 1), 2), numeric(1))
  type_names <- setNames(names(stata_type_code), stata_type_code)
  types <- ifelse(codes <= 2045, paste0("str", codes), type_names[as.character(codes)])
  vars <- text_fields(map[4], 10, 33)

  # characteristics: <ch> length varname[33] charname[33] contents </ch>
  notes <- list()
  at <- map[9] + 1 + nchar("<characteristics>")
  while (identical(rawToChar(meta[at + 0:3]), "<ch>")) {
    len <- read_uint(meta, at + 4, 4)
    body <- meta[at + 8 + seq_len(len) - 1]
    field <- function(b) rawToChar(b[seq_len(max(0, which(b == as.raw(0))[1] - 1))])
    notes[[length(notes) + 1]] <- tibble::tibble(variable = field(body[1:33]), name = field(body[34:66]),
                                                 text = field(body[67:len]))
    at <- at + 8 + len + 5
  }
  notes <- dplyr::bind_rows(notes)

  list(
    n = n,
    data_label = data_label,
    variables = tibble::tibble(
      variable = vars, type = unname(types), format = text_fields(map[6], 9, 49),
      value_label = text_fields(map[7], 19, 33), label = text_fields(map[8], 17, 81)
    ),
    # notes as variable, note number, text (note0, the count, dropped)
    notes = notes |>
      dplyr::filter(grepl("^note[1-9][0-9]*$", name)) |>
      dplyr::transmute(variable, note = as.integer(sub("note", "", name)), text)
  )
}
