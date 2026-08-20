#' enviPat's isotope table, lazy-loaded once. It is a dataset (not in enviPat's
#' namespace env), so reach it with utils::data into a private env and cache.
#' @noRd
.envipat_isotopes <- local({
  cache <- NULL
  function() {
    if (is.null(cache)) {
      e <- new.env()
      utils::data("isotopes", package = "enviPat", envir = e)
      cache <<- get("isotopes", envir = e)
    }
    cache
  }
})

#' Fine isotopologue pattern for a molecular formula
#'
#' Wraps \code{enviPat::isopattern()} to compute the exact fine isotopic
#' structure of a neutral molecular formula: every isotopologue combination
#' above \code{threshold}, its exact mass and its abundance relative to the
#' monoisotopic (base) peak. Unlike a nominal-mass isotope pattern (M, M+1,
#' M+2, ...), this resolves the individual contributors within a nominal
#' level -- e.g. the M+2 satellite of a sulfur-containing compound is really
#' a 34S isotopologue and a (13C, 13C) isotopologue sitting at two different
#' exact masses, and this function tells them apart.
#'
#' @param formula a molecular formula string, e.g. \code{"C5H11NO2S"}.
#' @param threshold minimum abundance to keep, in percent of the base peak.
#' @param charge charge state passed to \code{enviPat::isopattern()}. This
#'   only applies the electron-mass correction for an intrinsically charged
#'   species (e.g. a metal ion); it does NOT add a proton or any other
#'   adduct. To simulate an ion such as \code{[M+H]+}, leave
#'   \code{charge = 0} (the default, i.e. the neutral formula's own pattern)
#'   and add the adduct's mass difference to \code{mz} afterwards, e.g.
#'   \code{pattern$mz + 1.007276} for protonation -- the same
#'   \code{massdiff} convention used by \code{\link{MZ_CAMERA}}.
#'
#' @return A tibble with columns \code{mz}, \code{abundance} (percent of the
#'   base peak, 100 = tallest) and \code{label}, a human-readable isotope
#'   label built from the isotope composition of that isotopologue (e.g.
#'   \code{"34S"}, \code{"13C, 13C"}; \code{""} for the monoisotopic peak).
#'
#' @examples
#' \donttest{
#' pat <- isotope_fine_pattern("C5H11NO2S")
#' pat[order(-pat$abundance), ]
#' }
#'
#' @author Jan Stanstrup, \email{stanstrup@gmail.com}
#' @export
#' @importFrom tibble tibble
isotope_fine_pattern <- function(formula, threshold = 0.01, charge = 0) {
  empty <- tibble::tibble(mz = numeric(), abundance = numeric(), label = character())
  iso <- .envipat_isotopes()
  pat <- tryCatch(
    enviPat::isopattern(iso, formula, threshold = threshold, charge = charge,
                        verbose = FALSE),
    error = function(e) NULL)
  if (is.null(pat) || !length(pat) || !is.matrix(pat[[1]])) return(empty)

  m <- pat[[1]]
  comp <- m[, !(colnames(m) %in% c("m/z", "abundance")), drop = FALSE]

  # The monoisotopic isotopologue carries every atom as its element's LIGHTEST
  # isotope. Determine "lightest per element" from enviPat's own isotope
  # masses (not column order, which is not guaranteed to be mass-sorted --
  # enviPat lists e.g. 16O, 18O, 17O for oxygen).
  els    <- sub("^[0-9]+", "", colnames(comp))
  masses <- iso$mass[match(colnames(comp), iso$isotope)]
  lightest_mass <- stats::ave(masses, els, FUN = min)
  minor_cols <- colnames(comp)[masses > lightest_mass]

  label <- if (length(minor_cols))
    apply(comp[, minor_cols, drop = FALSE], 1, function(r)
      paste(rep(minor_cols, r), collapse = ", "))
  else rep("", nrow(comp))

  tibble::tibble(mz = m[, "m/z"], abundance = m[, "abundance"], label = label)
}

#' Simulate a resolving-power-dependent profile from a fine isotope pattern
#'
#' Sums a Gaussian peak of the appropriate width for each isotopologue in an
#' \code{\link{isotope_fine_pattern}} result, at a chosen resolving power. At
#' low resolving power, isotopologues that are close in mass merge into one
#' apparent peak; at high resolving power they separate -- this is what an
#' Orbitrap or FT-ICR spectrum of the same ion actually looks like. Because
#' \code{abundance} is already expressed as percent of the base peak,
#' overlapping isotopologues sum the way real overlapping peaks do, so the
#' simulated apex can exceed any single isotopologue's own abundance.
#'
#' @param pattern output of \code{\link{isotope_fine_pattern}} (or any
#'   \code{tibble(mz, abundance)}).
#' @param resolution resolving power (R = m/z / FWHM) AT the m/z of this
#'   pattern. If your instrument's resolving power is quoted at a reference
#'   m/z (the usual Orbitrap convention, typically 200), convert it first,
#'   e.g. \code{R_ref * sqrt(200 / mean(pattern$mz))}.
#' @param oversample grid points per FWHM.
#' @param pad_fwhm how many FWHM of m/z padding to add on each side.
#'
#' @return A tibble with columns \code{mz} and \code{intensity} (percent of
#'   the base peak's abundance, same scale as \code{isotope_fine_pattern()}'s
#'   \code{abundance} column).
#'
#' @examples
#' \donttest{
#' pat  <- isotope_fine_pattern("C5H11NO2S")
#' prof <- isotope_profile(pat, resolution = 60000)
#' plot(prof$mz, prof$intensity, type = "l")
#' }
#'
#' @author Jan Stanstrup, \email{stanstrup@gmail.com}
#' @export
#' @importFrom tibble tibble
isotope_profile <- function(pattern, resolution = 120000, oversample = 12,
                            pad_fwhm = 6) {
  empty <- tibble::tibble(mz = numeric(), intensity = numeric())
  if (!nrow(pattern) || !isTRUE(is.finite(resolution)) || resolution <= 0)
    return(empty)
  sigma_of <- function(mz) (mz / resolution) / (2 * sqrt(2 * log(2)))
  fwhm <- pattern$mz / resolution
  lo <- min(pattern$mz) - pad_fwhm * max(fwhm)
  hi <- max(pattern$mz) + pad_fwhm * max(fwhm)
  step <- min(fwhm) / oversample
  grid <- seq(lo, hi, by = step)
  y <- numeric(length(grid))
  for (i in seq_len(nrow(pattern))) {
    s <- sigma_of(pattern$mz[i])
    y <- y + pattern$abundance[i] * exp(-0.5 * ((grid - pattern$mz[i]) / s)^2)
  }
  tibble::tibble(mz = grid, intensity = y)
}
