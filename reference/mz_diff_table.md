# Reference table of theoretical m/z differences

Combines commonMZ's `adducts_fragments` and
`repeating_units_pos`/`repeating_units_neg` tables into one tibble
tagged by category and ionisation mode, for comparing a difference you
measured between two peaks in the same spectrum against every known
adduct/fragment/repeating-unit mass difference at once. See
[`mz_diff_lookup`](https://stanstrup.github.io/commonMZ/reference/mz_diff_lookup.md)
to filter it to a specific observed difference.

## Usage

``` r
mz_diff_table(mode = c("both", "pos", "neg"))
```

## Arguments

- mode:

  which repeating-unit table(s) to include: `"both"` (default), `"pos"`
  or `"neg"`. `adducts_fragments` has no polarity split and is always
  included.

## Value

A tibble with columns `mz_diff`, `category` (`"adduct/fragment"` or
`"repeating unit"`), `mode` (`"both"`, `"pos"` or `"neg"`), `origin` and
`reference`.

## Details

Isotope spacings are deliberately not included here – they depend on
which formula produced the peaks, so they belong to
[`isotope_fine_pattern`](https://stanstrup.github.io/commonMZ/reference/isotope_fine_pattern.md)
instead of this formula-agnostic table.

## Author

Jan Stanstrup, <stanstrup@gmail.com>

## Examples

``` r
mz_diff_table("pos")
#> # A tibble: 116 × 5
#>    mz_diff category        mode  origin                                reference
#>      <dbl> <chr>           <chr> <chr>                                 <chr>    
#>  1   0.984 adduct/fragment both  OH <-> NH2, e.g. de-amidiation, CHNO… F        
#>  2   1.98  adduct/fragment both  K+ <-> Cl-+2H2+, salt adduct          AA       
#>  3   2.00  adduct/fragment both  F <-> OH, halogen exchange with hydr… F        
#>  4   2.02  adduct/fragment both  ± 2H, opening or forming of double b… F        
#>  5   4.96  adduct/fragment both  Na+<-> NH4+, salt adduct              F        
#>  6   7.00  adduct/fragment both  F <-> CN, halogen exchange with cyan… F        
#>  7   8.97  adduct/fragment both  Cl <-> CN, halogen exchange with cya… F        
#>  8  14.0   adduct/fragment both  O <-> 2H, e.g. Oxidation follwed by … F        
#>  9  14.0   adduct/fragment both  Cl-+2H2+ <-> Na+, salt adduct         AA       
#> 10  14.0   adduct/fragment both  ± CH2, alkane chains, waxes, fatty a… F        
#> # ℹ 106 more rows
```
