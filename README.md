

# commonMZ

A curated collection of common *m/z* values, mass differences, and
annotation rules for mass spectrometry, distributed as an R package.

**Documentation:**
[stanstrup.github.io/commonMZ](https://stanstrup.github.io/commonMZ/)

Contributions are welcomed.

## Articles

| Article | What it covers |
|----|----|
| [Looking up a mass difference](https://stanstrup.github.io/commonMZ/articles/mass-difference-lookup.html) | Search a measured peak-to-peak delta against every catalogued adduct, fragment, and repeating-unit difference |
| [Using commonMZ rules with CAMERA](https://stanstrup.github.io/commonMZ/articles/camera-rules.html) | Build CAMERA annotation rule tables and annotate an LC-MS dataset end-to-end |
| [Isotope fine structure](https://stanstrup.github.io/commonMZ/articles/isotope-fine-structure.html) | Simulate and resolve the individual isotopologues hidden inside an M+1 or M+2 peak |
| [Looking up an isotopologue offset](https://stanstrup.github.io/commonMZ/articles/isotope-offset-lookup.html) | Identify which element a satellite peak a few mDa from M+1/M+2 comes from |

## Installation

``` r
# Bioconductor dependency
if (!require("BiocManager")) install.packages("BiocManager")
BiocManager::install("CAMERA")

# commonMZ from GitHub
if (!require("remotes")) install.packages("remotes")
remotes::install_github("stanstrup/commonMZ")
```

## Raw data files

The underlying tables are plain-text TSV files in `inst/` and
colour-coded Excel files, usable independently of R:

- **`adducts_fragments.tsv`**: adduct and neutral-loss mass differences
- **`repeating_units_+.tsv`** / **`repeating_units_-.tsv`**:
  homologous-series steps in positive and negative mode
- **`contaminants_+.tsv`** / **`contaminants_-.tsv`**: common background
  ions
- **`CAMERA_rules_pos.xlsx`**, **`CAMERA_rules_neg.xlsx`**,
  **`CAMERA_rules_EI.xlsx`**: CAMERA annotation rule tables

## References

The data in these tables are primarily from Keller BO, Sui J, Young AB,
Whittal RM. Interferences and contaminants encountered in modern mass
spectrometry. *Anal Chim Acta.* 2008;627(1):71–81. Per-entry source
references are listed in the [mass difference lookup
article](https://stanstrup.github.io/commonMZ/articles/mass-difference-lookup.html#references-for-the-reference-column).
