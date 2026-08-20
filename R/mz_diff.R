#' Reference table of theoretical m/z differences
#'
#' Combines commonMZ's \code{adducts_fragments} and
#' \code{repeating_units_pos}/\code{repeating_units_neg} tables into one
#' tibble tagged by category and ionisation mode, for comparing a
#' difference you measured between two peaks in the same spectrum against
#' every known adduct/fragment/repeating-unit mass difference at once. See
#' \code{\link{mz_diff_lookup}} to filter it to a specific observed
#' difference.
#'
#' Isotope spacings are deliberately not included here -- they depend on
#' which formula produced the peaks, so they belong to
#' \code{\link{isotope_fine_pattern}} instead of this formula-agnostic table.
#'
#' @param mode which repeating-unit table(s) to include: \code{"both"}
#'   (default), \code{"pos"} or \code{"neg"}. \code{adducts_fragments} has no
#'   polarity split and is always included.
#'
#' @return A tibble with columns \code{mz_diff}, \code{category}
#'   (\code{"adduct/fragment"} or \code{"repeating unit"}), \code{mode}
#'   (\code{"both"}, \code{"pos"} or \code{"neg"}), \code{origin} and
#'   \code{reference}.
#'
#' @examples
#' mz_diff_table("pos")
#'
#' @author Jan Stanstrup, \email{stanstrup@gmail.com}
#' @export
mz_diff_table <- function(mode = c("both", "pos", "neg")) {
  mode <- match.arg(mode)
  af <- commonMZ::adducts_fragments
  af$category <- "adduct/fragment"; af$mode <- "both"
  ru_pos <- commonMZ::repeating_units_pos
  ru_pos$category <- "repeating unit"; ru_pos$mode <- "pos"
  ru_neg <- commonMZ::repeating_units_neg
  ru_neg$category <- "repeating unit"; ru_neg$mode <- "neg"

  cols <- c("mz_diff", "category", "mode", "origin", "reference")
  out <- rbind(af[, cols], ru_pos[, cols], ru_neg[, cols])
  if (mode != "both") out <- out[out$mode %in% c("both", mode), , drop = FALSE]
  # the source tsv files carry Latin-1 bytes (e.g. the "±" in "± H2O"); re-encode
  # so grepl/printing/DT rendering downstream sees valid UTF-8 instead of NA/mojibake.
  out$origin <- iconv(out$origin, from = "latin1", to = "UTF-8")
  tibble::as_tibble(out)
}

#' Look up an observed m/z difference against the theoretical differences table
#'
#' The interpretation workhorse behind "what could this delta be": given a
#' mass difference measured between two peaks in the same spectrum (an
#' in-source fragment, a homologous-series step, a suspected adduct...),
#' returns every entry of \code{\link{mz_diff_table}} within tolerance.
#'
#' @param delta the observed difference, in Da.
#' @param tol the tolerance. In ppm of \code{delta} by default (the usual way
#'   an instrument's mass accuracy is quoted); switch to \code{unit = "Da"}
#'   for a flat window instead. Note this is ppm of the DIFFERENCE, not of
#'   either peak's own m/z -- for a small delta that can be an unrealistically
#'   tight window (10 ppm of a 1 Da delta is 0.00001 Da), since the true
#'   uncertainty of a difference comes from BOTH peaks' own mass accuracy, not
#'   from the size of the gap between them. Widen \code{tol} accordingly, or
#'   pass an absolute \code{unit = "Da"} tolerance if you already know the
#'   window you want.
#' @param unit \code{"ppm"} (default) or \code{"Da"}.
#' @param mode passed to \code{\link{mz_diff_table}} if \code{table} is not
#'   supplied.
#' @param table a table from \code{\link{mz_diff_table}}; computed
#'   automatically from \code{mode} if omitted. Pass your own to avoid
#'   recomputing it when calling this repeatedly (e.g. over every peak pair
#'   in a spectrum).
#'
#' @return \code{table}, filtered to rows within tolerance of \code{delta},
#'   with an added \code{error_Da} column, sorted by \code{abs(error_Da)}.
#'
#' @examples
#' mz_diff_lookup(18.0106, tol = 100, unit = "ppm")   # water
#' mz_diff_lookup(18.0106, tol = 0.002, unit = "Da")  # same, as a flat window
#'
#' @author Jan Stanstrup, \email{stanstrup@gmail.com}
#' @export
mz_diff_lookup <- function(delta, tol = 100, unit = c("ppm", "Da"),
                           mode = c("both", "pos", "neg"),
                           table = mz_diff_table(match.arg(mode))) {
  unit <- match.arg(unit)
  tol_da <- if (unit == "ppm") abs(delta) * tol / 1e6 else tol
  err <- table$mz_diff - delta
  keep <- abs(err) <= tol_da
  hit <- table[keep, , drop = FALSE]
  hit$error_Da <- err[keep]
  hit[order(abs(hit$error_Da)), , drop = FALSE]
}
