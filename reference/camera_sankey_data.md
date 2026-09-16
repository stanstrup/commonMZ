# Build Sankey node/link data from a CAMERA annotation result

Extracts the peak list from a CAMERA `xsAnnotate` result and builds the
node/link tables needed to draw a four-column Sankey diagram showing how
annotated peaks flow through isotope type, multiplicity, and adduct
rule.

## Usage

``` r
camera_sankey_data(cam_result)
```

## Arguments

- cam_result:

  An `xsAnnotate` object returned by
  [`CAMERA::findAdducts()`](https://rdrr.io/pkg/CAMERA/man/findAdducts-methods.html).
  The rules used during annotation are read from `cam_result@ruleset`.

## Value

A list with two data frames:

- `nodes`:

  Columns `label`, `x`, `y`.

- `links`:

  Columns `source`, `target`, `value` (0-indexed node indices, as
  required by plotly).

## Details

The four columns are:

1.  **All annotations** — every annotated peak.

2.  **Isotope type** — `no isotope annotation`, `[M]`, `[M+1]`, `[M+2]`,
    ... Satellite peaks (`[M+1]` etc.\\ without an adduct match)
    terminate here.

3.  **Multiplicity** — `[1M]`, `[2M]`, ...

4.  **Adduct rule** — the matched rule name, ordered by frequency.

## See also

[`camera_sankey`](https://stanstrup.github.io/commonMZ/reference/camera_sankey.md)

## Author

Jan Stanstrup, <stanstrup@gmail.com>
