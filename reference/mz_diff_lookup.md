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
  ref_mz = NULL,
  mode = c("both", "pos", "neg"),
  table = mz_diff_table(match.arg(mode))
)
```

## Arguments

- delta:

  the observed difference, in Da.

- tol:

  the tolerance. In ppm by default (the usual way an instrument's mass
  accuracy is quoted); switch to `unit = "Da"` for a flat window
  instead. When `ref_mz` is supplied the ppm tolerance is applied
  relative to `ref_mz` (i.e. the window is `ref_mz * tol / 1e6`),
  matching the scale of the returned `error_ppm` column. When `ref_mz`
  is `NULL` the tolerance is instead ppm of the DIFFERENCE, not of
  either peak's own m/z – for a small delta that is an unrealistically
  tight window (10 ppm of a 1 Da delta is 0.00001 Da), since the true
  uncertainty of a difference comes from BOTH peaks' own mass accuracy,
  not from the size of the gap between them. Widen `tol` accordingly,
  supply `ref_mz`, or pass an absolute `unit = "Da"` tolerance if you
  already know the window you want.

- unit:

  `"ppm"` (default) or `"Da"`.

- ref_mz:

  reference m/z the ppm figures are relative to, typically the parent
  ion's own m/z. Instrument mass accuracy is quoted as ppm of a measured
  m/z, so a difference between two peaks should be judged against the
  m/z those peaks were measured at, not against the size of the gap: a
  0.002 Da error on a 1 Da difference is 2000 ppm of the difference but
  only 6.7 ppm of a 300 Da parent ion, and the latter is the realistic
  number. Supplying `ref_mz` makes both the `unit = "ppm"` tolerance and
  the returned `error_ppm` column relative to it. The default `NULL`
  keeps the legacy behaviour of dividing by `abs(delta)`, which is not
  recommended for small deltas.

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

`table`, filtered to rows within tolerance of `delta`, with added
`error_Da` and `error_ppm` columns, sorted by `abs(error_Da)`.
`error_ppm` is relative to `ref_mz` when supplied, otherwise to
`abs(delta)`.

## Author

Jan Stanstrup, <stanstrup@gmail.com>

## Examples

``` r
# 20 ppm of a 300 Da parent ion, reported as ppm of that parent ion
mz_diff_lookup(18.0106, tol = 20, unit = "ppm", ref_mz = 300)  # water
#> # A tibble: 3 × 7
#>   mz_diff category        mode  origin              reference error_Da error_ppm
#>     <dbl> <chr>           <chr> <chr>               <chr>        <dbl>     <dbl>
#> 1    18.0 adduct/fragment both  ± H2O, water addit… F         -3.00e-5   -0.1000
#> 2    18.0 repeating unit  pos   H2O, water clusters F         -3.00e-5   -0.1000
#> 3    18.0 repeating unit  neg   H2O, water clusters F         -3.00e-5   -0.1000
mz_diff_lookup(18.0106, tol = 0.002, unit = "Da")  # same, as a flat window
#> # A tibble: 3 × 7
#>   mz_diff category        mode  origin              reference error_Da error_ppm
#>     <dbl> <chr>           <chr> <chr>               <chr>        <dbl>     <dbl>
#> 1    18.0 adduct/fragment both  ± H2O, water addit… F         -3.00e-5     -1.67
#> 2    18.0 repeating unit  pos   H2O, water clusters F         -3.00e-5     -1.67
#> 3    18.0 repeating unit  neg   H2O, water clusters F         -3.00e-5     -1.67
```
