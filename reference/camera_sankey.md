# Sankey diagram of CAMERA annotation results

Draws an interactive four-column Sankey diagram showing how peaks
annotated by CAMERA flow from isotope type through multiplicity to
adduct rule.

## Usage

``` r
camera_sankey(cam_result, height = 800, margin_right = 160)
```

## Arguments

- cam_result:

  An `xsAnnotate` object returned by
  [`CAMERA::findAdducts()`](https://rdrr.io/pkg/CAMERA/man/findAdducts-methods.html).
  The rules used during annotation are read from `cam_result@ruleset`.

- height:

  Plot height in pixels. Default `800`.

- margin_right:

  Right margin in pixels, to leave room for the rightmost node labels.
  Default `160`.

## Value

A `plotly` htmlwidget.

## See also

[`camera_sankey_data`](https://stanstrup.github.io/commonMZ/reference/camera_sankey_data.md)

## Author

Jan Stanstrup, <stanstrup@gmail.com>
