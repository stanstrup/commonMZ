# Fine isotopologue pattern for a molecular formula

Wraps
[`enviPat::isopattern()`](https://rdrr.io/pkg/enviPat/man/isopattern.html)
to compute the exact fine isotopic structure of a neutral molecular
formula: every isotopologue combination above `threshold`, its exact
mass and its abundance relative to the monoisotopic (base) peak. Unlike
a nominal-mass isotope pattern (M, M+1, M+2, ...), this resolves the
individual contributors within a nominal level – e.g. the M+2 satellite
of a sulfur-containing compound is really a 34S isotopologue and a (13C,
13C) isotopologue sitting at two different exact masses, and this
function tells them apart.

## Usage

``` r
isotope_fine_pattern(formula, threshold = 0.01, charge = 0)
```

## Arguments

- formula:

  a molecular formula string, e.g. `"C5H11NO2S"`.

- threshold:

  minimum abundance to keep, in percent of the base peak.

- charge:

  charge state passed to
  [`enviPat::isopattern()`](https://rdrr.io/pkg/enviPat/man/isopattern.html).
  This only applies the electron-mass correction for an intrinsically
  charged species (e.g. a metal ion); it does NOT add a proton or any
  other adduct. To simulate an ion such as `[M+H]+`, leave `charge = 0`
  (the default, i.e. the neutral formula's own pattern) and add the
  adduct's mass difference to `mz` afterwards, e.g.
  `pattern$mz + 1.007276` for protonation – the same `massdiff`
  convention used by
  [`MZ_CAMERA`](https://stanstrup.github.io/commonMZ/reference/MZ_CAMERA.md).

## Value

A tibble with columns `mz`, `abundance` (percent of the base peak, 100 =
tallest) and `label`, a human-readable isotope label built from the
isotope composition of that isotopologue (e.g. `"34S"`, `"13C, 13C"`;
`""` for the monoisotopic peak).

## Author

Jan Stanstrup, <stanstrup@gmail.com>

## Examples

``` r
# \donttest{
pat <- isotope_fine_pattern("C5H11NO2S")
pat[order(-pat$abundance), ]
#> # A tibble: 16 × 3
#>       mz abundance label     
#>    <dbl>     <dbl> <chr>     
#>  1  149.  100      ""        
#>  2  150.    5.41   "13C"     
#>  3  151.    4.47   "34S"     
#>  4  150.    0.790  "33S"     
#>  5  151.    0.411  "18O"     
#>  6  150.    0.365  "15N"     
#>  7  152.    0.242  "13C, 34S"
#>  8  150.    0.127  "2H"      
#>  9  151.    0.117  "13C, 13C"
#> 10  150.    0.0762 "17O"     
#> 11  151.    0.0427 "13C, 33S"
#> 12  152.    0.0222 "13C, 18O"
#> 13  151.    0.0198 "13C, 15N"
#> 14  153.    0.0184 "18O, 34S"
#> 15  152.    0.0163 "15N, 34S"
#> 16  153.    0.0105 "36S"     
# }
```
