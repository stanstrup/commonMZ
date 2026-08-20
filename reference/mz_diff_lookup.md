# Look up an observed m/z difference against the theoretical differences table

The interpretation workhorse behind "what could this delta be": given a
mass difference measured between two peaks in the same spectrum (an
in-source fragment, a homologous-series step, a suspected adduct...),
returns every entry of
[`mz_diff_table`](https://stanstrup.github.io/commonMZ/reference/mz_diff_table.md)
within tolerance.

## Usage

``` r
mz_diff_lookup(
  delta,
  tol = 100,
  unit = c("ppm", "Da"),
  mode = c("both", "pos", "neg"),
  table = mz_diff_table(match.arg(mode))
)
```

## Arguments

- delta:

  the observed difference, in Da.

- tol:

  the tolerance. In ppm of `delta` by default (the usual way an
  instrument's mass accuracy is quoted); switch to `unit = "Da"` for a
  flat window instead. Note this is ppm of the DIFFERENCE, not of either
  peak's own m/z – for a small delta that can be an unrealistically
  tight window (10 ppm of a 1 Da delta is 0.00001 Da), since the true
  uncertainty of a difference comes from BOTH peaks' own mass accuracy,
  not from the size of the gap between them. Widen `tol` accordingly, or
  pass an absolute `unit = "Da"` tolerance if you already know the
  window you want.

- unit:

  `"ppm"` (default) or `"Da"`.

- mode:

  passed to
  [`mz_diff_table`](https://stanstrup.github.io/commonMZ/reference/mz_diff_table.md)
  if `table` is not supplied.

- table:

  a table from
  [`mz_diff_table`](https://stanstrup.github.io/commonMZ/reference/mz_diff_table.md);
  computed automatically from `mode` if omitted. Pass your own to avoid
  recomputing it when calling this repeatedly (e.g. over every peak pair
  in a spectrum).

## Value

`table`, filtered to rows within tolerance of `delta`, with an added
`error_Da` column, sorted by `abs(error_Da)`.

## Author

Jan Stanstrup, <stanstrup@gmail.com>

## Examples

``` r
mz_diff_lookup(18.0106, tol = 100, unit = "ppm")   # water
#> # A tibble: 3 × 6
#>   mz_diff category        mode  origin                     reference   error_Da
#>     <dbl> <chr>           <chr> <chr>                      <chr>          <dbl>
#> 1    18.0 adduct/fragment both  ± H2O, water addition/loss F         -0.0000300
#> 2    18.0 repeating unit  pos   H2O, water clusters        F         -0.0000300
#> 3    18.0 repeating unit  neg   H2O, water clusters        F         -0.0000300
mz_diff_lookup(18.0106, tol = 0.002, unit = "Da")  # same, as a flat window
#> # A tibble: 3 × 6
#>   mz_diff category        mode  origin                     reference   error_Da
#>     <dbl> <chr>           <chr> <chr>                      <chr>          <dbl>
#> 1    18.0 adduct/fragment both  ± H2O, water addition/loss F         -0.0000300
#> 2    18.0 repeating unit  pos   H2O, water clusters        F         -0.0000300
#> 3    18.0 repeating unit  neg   H2O, water clusters        F         -0.0000300
```
