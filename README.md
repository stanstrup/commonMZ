
# commonMZ

A curated collection of common *m/z* values, mass differences, and annotation
rules for mass spectrometry, distributed as an R package.

**Documentation:** [stanstrup.github.io/commonMZ](https://stanstrup.github.io/commonMZ/)

Contributions are welcomed.

## Articles

| Article | What it covers |
|---|---|
| [Looking up a mass difference](https://stanstrup.github.io/commonMZ/articles/mass-difference-lookup.html) | Search a measured peak-to-peak delta against every catalogued adduct, fragment, and repeating-unit difference |
| [Using commonMZ rules with CAMERA](https://stanstrup.github.io/commonMZ/articles/camera-rules.html) | Build CAMERA annotation rule tables and annotate an LC-MS dataset end-to-end |
| [Isotope fine structure](https://stanstrup.github.io/commonMZ/articles/isotope-fine-structure.html) | Simulate and resolve the individual isotopologues hidden inside an M+1 or M+2 peak |
| [Looking up an isotopologue offset](https://stanstrup.github.io/commonMZ/articles/isotope-offset-lookup.html) | Identify which element a satellite peak a few mDa from M+1/M+2 comes from |

## Installation

```r
# Bioconductor dependency
if (!require("BiocManager")) install.packages("BiocManager")
BiocManager::install("CAMERA")

# commonMZ from GitHub
if (!require("remotes")) install.packages("remotes")
remotes::install_github("stanstrup/commonMZ")
```

## Raw data files

The underlying tables are plain-text TSV files in `inst/` and colour-coded Excel
files, usable independently of R:

- **`adducts_fragments.tsv`**: adduct and neutral-loss mass differences
- **`repeating_units_+.tsv`** / **`repeating_units_-.tsv`**: homologous-series
  steps in positive and negative mode
- **`contaminants_+.tsv`** / **`contaminants_-.tsv`**: common background ions
- **`CAMERA_rules_pos.xlsx`**, **`CAMERA_rules_neg.xlsx`**,
  **`CAMERA_rules_EI.xlsx`**: CAMERA annotation rule tables

## References

The data in these tables are primarily from:

- Keller BO, Sui J, Young AB, Whittal RM. Interferences and contaminants
  encountered in modern mass spectrometry. *Anal Chim Acta.* 2008;627(1):71–81.

Per-entry references in the tables map to the following sources:

| Ref | Author(s) | Citation or Website |
|----|----|----|
| A | Waters Corporation | [Background Ion List](https://www2.waters.com/CEConversion.nsf/files/3929E3EC20E43AAA8525710D004AB62E/$file/bkgrnd_ion_mstr_list.pdf) |
| B | Applied Biosystems | Appendix D: Commonly Observed Background Ions — Mariner Biospectrometry Workstation Users Guide |
| C | New Objective | [Common Background Ions for Electrospray](http://www.newobjective.com/downloads/technotes/PV-3.pdf) (Technical Note) |
| D | Sigma-Aldrich | Chemical formulas for Tween, Triton, and reduced Triton from the [Sigma-Aldrich catalogue](http://www.sigmaaldrich.com) |
| E | Thermo Corporation; Mahn, B. | [List of LC/MS contaminants](http://www.abrf.org/index.cfm/list.msg/66994) |
| F | Tong, H.; Bell, D.; Tabei, K.; Siegel, M. M. | J. Am. Soc. Mass Spectrom., 10 (1999) 1174 |
| G | Andersen, J. S.; Kuester, B.; Podtelejnikov, A.; Mortz, E.; Mann, M. | Proc. 47th ASMS Conf. Mass Spectrom. Allied Topics, 1999, Dallas, TX |
| H | Keller, B. O.; Li, L. | J. Am. Soc. Mass Spectrom., 11 (2000) 88 |
| I | Keller, B. O.; Li, L.; Keller, H. | [MaClust: matrix cluster mass prediction](http://www.chem.ualberta.ca/~liweb/links/MaClust.htm) |
| J | Harris, W. A.; Janecki, D. J.; Reilly, J. P. | Rapid Commun. Mass Spectrom., 16 (2002) 1714 |
| K | Keller, B. O.; Sui, J.; Young, A. B.; Whittal, R. M. | Unpublished results; [ESI background ions — Tween, Triton, PEGs, PPGs](http://www.chem.ualberta.ca/~massspec/es_ions.pdf) |
| L | Schlosser, A.; Volkmer-Engert, R. | J. Mass Spectrom., 38 (2003) 523 |
| M | Tran, J. C.; Doucette, A. A. | J. Am. Soc. Mass Spectrom., 17 (2006) 652 |
| N | Verge, K. M.; Agnes, G. R. | J. Am. Soc. Mass Spectrom., 13 (2002) 901 |
| O | Paez, A.; Howe, A. | Canadian Chemical News, 56 (2004) 14 |
| P | Purves, R. W.; Gabryelski, W.; Li, L. | Rev. Sci. Instrum., 68 (1997) 3252 |
| Q | Gibson, C. R.; Brown, C. M. | J. Am. Soc. Mass Spectrom., 14 (2003) 1247 |
| R | Beavis, R. C.; Chait, B. T. | Anal. Chem., 62 (1990) 1836 |
| S | Guzzetta, A. | [ionsource.com](http://www.ionsource.com) — Carbohydrate marker ions |
| T | Clauser, K. R.; Hall, S. C.; Smith, D. M.; Webb, J. W.; Andrews, L. E.; Tran, H. M.; Epstein, L. B.; Burlingame, A. L. | Proc. Natl. Acad. Sci. USA, 92 (1995) 5072; [prospector.ucsf.edu](http://prospector.ucsf.edu) |
| U | Macha, S. F.; Limbach, P. A.; Hanton, S. D.; Owens, K. G. | J. Am. Soc. Mass Spectrom., 12 (2001) 732 |
| V | Pleasance, S.; Thibault, P.; Sim, P. G.; Boyd, R. K. | Rapid Commun. Mass Spectrom., 5 (1991) 307 |
| W | Xia, Y.; Patel, S.; Bakhtiar, R.; Franklin, R. B.; Doss, G. A. | J. Am. Soc. Mass Spectrom., 16 (2005) 417 |
| X | Guo, X.; Bruins, A. P.; Covey, T. R. | Rapid Commun. Mass Spectrom., 20 (2006) 3145 |
| Y | Ijames, C. F.; Dutky, R. C.; Fales, H. M. | J. Am. Soc. Mass Spectrom., 6 (1995) 1226 |
| Z | Hesse, M.; Meier, H.; Zeeh, B. | Spektroskopische Methoden in der organischen Chemie, Georg Thieme Verlag, Stuttgart, 3rd ed. 1987, ISBN: 3-13-576103-7 |
| AA | Stanstrup, J. | — |
