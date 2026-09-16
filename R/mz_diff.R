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
#' @param tol the tolerance. In ppm by default (the usual way an instrument's
#'   mass accuracy is quoted); switch to \code{unit = "Da"} for a flat window
#'   instead. When \code{ref_mz} is supplied the ppm tolerance is applied
#'   relative to \code{ref_mz} (i.e. the window is \code{ref_mz * tol / 1e6}),
#'   matching the scale of the returned \code{error_ppm} column. When
#'   \code{ref_mz} is \code{NULL} the tolerance is instead ppm of the
#'   DIFFERENCE, not of either peak's own m/z -- for a small delta that is an
#'   unrealistically tight window (10 ppm of a 1 Da delta is 0.00001 Da), since
#'   the true uncertainty of a difference comes from BOTH peaks' own mass
#'   accuracy, not from the size of the gap between them. Widen \code{tol}
#'   accordingly, supply \code{ref_mz}, or pass an absolute \code{unit = "Da"}
#'   tolerance if you already know the window you want.
#' @param unit \code{"ppm"} (default) or \code{"Da"}.
#' @param ref_mz reference m/z the ppm figures are relative to, typically the
#'   parent ion's own m/z. Instrument mass accuracy is quoted as ppm of a
#'   measured m/z, so a difference between two peaks should be judged against
#'   the m/z those peaks were measured at, not against the size of the gap: a
#'   0.002 Da error on a 1 Da difference is 2000 ppm of the difference but only
#'   6.7 ppm of a 300 Da parent ion, and the latter is the realistic number.
#'   Supplying \code{ref_mz} makes both the \code{unit = "ppm"} tolerance and
#'   the returned \code{error_ppm} column relative to it. The default
#'   \code{NULL} keeps the legacy behaviour of dividing by \code{abs(delta)},
#'   which is not recommended for small deltas.
#' @param mode passed to \code{\link{mz_diff_table}} if \code{table} is not
#'   supplied.
#' @param table a table from \code{\link{mz_diff_table}}; computed
#'   automatically from \code{mode} if omitted. Pass your own to avoid
#'   recomputing it when calling this repeatedly (e.g. over every peak pair
#'   in a spectrum).
#'
#' @return \code{table}, filtered to rows within tolerance of \code{delta},
#'   with added \code{error_Da} and \code{error_ppm} columns,
#'   sorted by \code{abs(error_Da)}. \code{error_ppm} is relative to
#'   \code{ref_mz} when supplied, otherwise to \code{abs(delta)}.
#'
#' @examples
#' # 20 ppm of a 300 Da parent ion, reported as ppm of that parent ion
#' mz_diff_lookup(18.0106, tol = 20, unit = "ppm", ref_mz = 300)  # water
#' mz_diff_lookup(18.0106, tol = 0.002, unit = "Da")  # same, as a flat window
#'
#' @author Jan Stanstrup, \email{stanstrup@gmail.com}
#' @export
mz_diff_lookup <- function(delta, tol = 100, unit = c("ppm", "Da"),
                           ref_mz = NULL,
                           mode = c("both", "pos", "neg"),
                           table = mz_diff_table(match.arg(mode))) {
  unit <- match.arg(unit)
  if (!is.null(ref_mz)) {
    if (!is.numeric(ref_mz) || length(ref_mz) != 1L || !is.finite(ref_mz) ||
        ref_mz <= 0)
      stop("`ref_mz` must be a single positive, finite number (or NULL).")
  }
  denom  <- if (is.null(ref_mz)) abs(delta) else ref_mz
  tol_da <- if (unit == "ppm") denom * tol / 1e6 else tol
  err <- table$mz_diff - delta
  keep <- abs(err) <= tol_da
  hit <- table[keep, , drop = FALSE]
  hit$error_Da  <- err[keep]
  hit$error_ppm <- err[keep] / denom * 1e6
  hit[order(abs(hit$error_Da)), , drop = FALSE]
}
