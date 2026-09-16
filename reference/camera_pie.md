# Pie chart of fired adduct/fragment rules from a CAMERA annotation

Shows how many times each rule was assigned across all annotated peaks,
with labelled leader lines ordered by frequency.

## Usage

``` r
camera_pie(cam_result)
```

## Arguments

- cam_result:

  An `xsAnnotate` object returned by
  [`CAMERA::findAdducts()`](https://rdrr.io/pkg/CAMERA/man/findAdducts-methods.html).
  The rules used during annotation are read from `cam_result@ruleset`.

## Value

A `ggplot` object.

## Author

Jan Stanstrup, <stanstrup@gmail.com>
