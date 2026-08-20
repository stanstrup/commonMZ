# Load adduct/fragment rules for CAMERA

This function loads rules for use with CAMERA adduct annotation.

## Usage

``` r
MZ_CAMERA(mode, warn_clash = TRUE, clash_ppm)
```

## Arguments

- mode:

  The ionization mode. Can be "pos", "neg" or "ei".

- warn_clash:

  Warn for adducts/fragments that gives rise to the same m/z difference
  in spectra.

- clash_ppm:

  ppm to use for the above check.

## Value

tibble defining adduct rules.

## Author

Jan Stanstrup, <stanstrup@gmail.com>

## Examples

``` r
MZ_CAMERA(mode="pos", warn_clash = TRUE, clash_ppm=30)
#> Warning: The following adducts/fragments seem to collide. 
#> # A tibble: 2 × 2
#>   first       second                             
#>   <chr>       <chr>                              
#> 1 [M+H-NH3]+  [M+NH4]+                           
#> 2 [M+H-C3H4]+ [M+H+(CH3)2CO-H2O]+ (acetone cond.)
#> 
#> 
#> Consider removing one of them. Example: 
#>  rules=rules[            !grepl("[M+NH4]+",rules[,"name"],fixed=TRUE)         ,]
#> # A tibble: 159 × 7
#>    name       nmol charge massdiff oidscore quasi   ips
#>    <chr>     <int>  <int>    <dbl>    <int> <int> <dbl>
#>  1 [M+H]+        1      1     1.01        1     1  1   
#>  2 [2M+H]+       2      1     1.01        1     0  1   
#>  3 [3M+H]+       3      1     1.01        1     0  1   
#>  4 [4M+H]+       4      1     1.01        1     0  1   
#>  5 [M+2H]2+      1      2     2.01        2     0  0.75
#>  6 [2M+2H]2+     2      2     2.01        2     0  0.75
#>  7 [3M+2H]2+     3      2     2.01        2     0  0.75
#>  8 [4M+2H]2+     4      2     2.01        2     0  0.75
#>  9 [M+3H]3+      1      3     3.02        3     0  0.75
#> 10 [2M+3H]3+     2      3     3.02        3     0  0.75
#> # ℹ 149 more rows

```
