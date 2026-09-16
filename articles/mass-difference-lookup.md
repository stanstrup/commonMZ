# Looking up an unexplained mass difference

You have two peaks in a spectrum and a delta between them, and the
question is “what does this gap correspond to?”.

- It could be a fragment, usually a neutral loss, (water, CO₂, a whole
  side chain).
- It could also be an adduct (Na⁺ for K⁺, formate for acetate).
- Fragments sometimes appear in series of repeating units;
  e.g. sequential loss of CH₂ in an alkane chain.

All three are catalogued in commonMZ and accessible as individual
datasets:

- [`adducts_fragments`](https://github.com/stanstrup/commonMZ/blob/master/inst/extdata/adducts_fragments.tsv)
  — adduct and neutral-loss mass differences, mode-agnostic
- [`repeating_units_pos`](https://github.com/stanstrup/commonMZ/blob/master/inst/extdata/repeating_units_%2B.tsv)
  — homologous-series steps in positive mode
- [`repeating_units_neg`](https://github.com/stanstrup/commonMZ/blob/master/inst/extdata/repeating_units_-.tsv)
  — homologous-series steps in negative mode

[`mz_diff_table()`](https://stanstrup.github.io/commonMZ/reference/mz_diff_table.md)
merges them into one searchable reference, optionally filtered by mode:

``` r

commonMZ::adducts_fragments     # adducts and neutral losses only
```

    # A tibble: 88 × 3
       mz_diff origin                                                      reference
         <dbl> <chr>                                                       <chr>
     1   0.984 "OH <-> NH2, e.g. de-amidiation, CHNO compounds"            F
     2   1.98  "K+ <-> Cl-+2H2+, salt adduct"                              AA
     3   2.00  "F <-> OH, halogen exchange with hydroxy group (typically … F
     4   2.02  "\xb1 2H, opening or forming of double bond"                F
     5   4.96  "Na+<-> NH4+, salt adduct"                                  F
     6   7.00  "F <-> CN, halogen exchange with cyano group"               F
     7   8.97  "Cl <-> CN, halogen exchange with cyano group"              F
     8  14.0   "O <-> 2H, e.g. Oxidation follwed by H2O elimination"       F
     9  14.0   "Cl-+2H2+ <-> Na+, salt adduct"                             AA
    10  14.0   "\xb1 CH2, alkane chains, waxes, fatty acids, methylation"  F
    # ℹ 78 more rows

``` r

commonMZ::repeating_units_pos   # repeating units, positive mode only
```

    # A tibble: 28 × 3
       mz_diff origin                                                      reference
         <dbl> <chr>                                                       <chr>
     1    14.0 -[CH2]-, alkane chains, waxes, fatty acids, methylation     F
     2    16.0 O, oxidation                                                F
     3    18.0 H2O, water clusters                                         F
     4    28.0 -[C2H4]-, natural alkane chains such as fatty acids         F
     5    32.0 CH3OH, methanol clusters                                    F
     6    41.0 CH3CN, acetonitrile clusters                                F
     7    42.0 -[C3H6]-, propyl repeating units, propylation               F
     8    44.0 -[C2H4O]-; polyethylene glycol, PEG, and related component… D, F
     9    50.0 -[CF2]-, from perfluoro compounds                           F
    10    53.0 NH4Cl salt adducts/clusters                                 F
    # ℹ 18 more rows

``` r

diffs <- mz_diff_table("both")  # all three merged; use "pos" or "neg" to filter
```

## The calculator: search by a difference and a ppm tolerance

This is
[`mz_diff_lookup()`](https://stanstrup.github.io/commonMZ/reference/mz_diff_lookup.md)’s
job for a single value called from R.

An instrument’s mass accuracy is quoted as ppm of a *measured m/z*, so
the ppm error of a mass *difference* only means something when you say
which m/z it is relative to. That is what `ref_mz` is for: pass the m/z
of the parent ion the two peaks were measured at, and both the ppm
tolerance and the returned `error_ppm` column are expressed relative to
it. In the examples below `ref_mz = 300` stands in for a typical parent
ion, so `error_ppm` reads as “how far off would this assignment be for a
compound around m/z 300”. Without `ref_mz` the ppm is taken of the
difference itself, which inflates it badly for small deltas — a 0.002 Da
error on a 1 Da difference is 2000 ppm of the delta but only 6.7 ppm at
m/z 300. See
[`?mz_diff_lookup`](https://stanstrup.github.io/commonMZ/reference/mz_diff_lookup.md)
for the full argument.

``` r

mz_diff_lookup(18.0106, tol = 100, ref_mz = 300) %>%   # water, 100 ppm at m/z 300
  mutate(error_Da = signif(error_Da, 2), error_ppm = round(error_ppm, 1))
```

The 100 ppm window is 0.03 Da at m/z 300, wide enough to also catch the
F ↔︎ H halogen exchange two hundredths of a Da away — at −67 ppm, clearly
distinguishable from water’s −0.1 ppm.

And a genuinely ambiguous case: a 44 Da delta returns three completely
different explanations — CO₂ neutral loss (decarboxylation), a
double-sodium salt adduct, and a PEG repeat-unit step (polymer
contamination from the LC system). A flat Da window is used here because
the three entries span 62 mDa, more than even a 50 ppm window at m/z 300
(15 mDa) would cover; `ref_mz = 300` is still passed so the reported
`error_ppm` stays on the same realistic scale. The key point is that
mass alone cannot decide between them:

``` r

mz_diff_lookup(44, tol = 0.05, unit = "Da", ref_mz = 300) %>%
  mutate(error_Da = signif(error_Da, 2), error_ppm = round(error_ppm, 1))
```

## Working interactively

Here is a little interactive table to search for these differences:

m/z difference (Da)  

tolerance (ppm)  

reference m/z (Da)  

Search

Clear

The search only re-filters when you click *Search* (not on every
keystroke), so typing a value never triggers a redraw mid-edit; click
once you’ve entered both numbers, or press *Clear* to go back to the
full table.

## Glossary

### Ion types

| Notation | Meaning |
|----|----|
| `f+` | fragment ion |
| `[f+H]+` | protonated fragment ion (e.g. in-source fragmentation) |
| `[M+H]+` | protonated molecular ion (pseudomolecular ion) |
| `[M+Na]+` | sodiated molecular ion |
| `[M+K]+` | potassiated molecular ion |
| `[2M+H]+`, `[3M+H]+` | protonated dimer, trimer, etc. |
| `[AnBm+H]+` | protonated ion of a complex with *n* A and *m* B subunits |

### Abbreviations used in the *origin* column

| Abbreviation | Meaning                                                      |
|--------------|--------------------------------------------------------------|
| 4-HCCA       | α-cyano-4-hydroxycinnamic acid — common MALDI matrix         |
| 2,5-DHB      | 2,5-dihydroxybenzoic acid — common MALDI matrix              |
| MeCN, ACN    | acetonitrile (solvent)                                       |
| MeOH         | methanol (solvent)                                           |
| MeNO₂        | nitromethane (solvent)                                       |
| HABA         | 2-(4-hydroxyphenylazo)benzoic acid — MALDI matrix            |
| SA           | sinapic / sinapinic acid — common MALDI matrix               |
| PEG          | polyethylene glycol; repeat unit –\[O–CH₂–CH₂\]–, 44 Da      |
| PPG          | polypropylene glycol; repeat unit –\[O–C(CH₃)H–CH₂\]–, 58 Da |
| XaaCcamXaa   | carbamidomethylated cysteine residue (+57 Da)                |
| XaaMoxXaa    | singly oxidised methionine residue (+16 Da)                  |

### References for the *reference* column

| Ref | Author(s) | Citation or website |
|----|----|----|
| A | Waters Corporation | [Background Ion List](https://www2.waters.com/CEConversion.nsf/files/3929E3EC20E43AAA8525710D004AB62E/%24file/bkgrnd_ion_mstr_list.pdf) |
| B | Applied Biosystems | Appendix D: Commonly Observed Background Ions — Mariner Biospectrometry Workstation Users Guide |
| C | New Objective | [Common Background Ions for Electrospray (Technical Note)](http://www.newobjective.com/downloads/technotes/PV-3.pdf) |
| D | Sigma-Aldrich | [Chemical formulas for Tween, Triton, and reduced Triton from the Sigma-Aldrich catalogue](http://www.sigmaaldrich.com) |
| E | Thermo Corporation; Mahn, B. | [List of LC/MS contaminants](http://www.abrf.org/index.cfm/list.msg/66994) |
| F | Tong, H.; Bell, D.; Tabei, K.; Siegel, M. M. | [J. Am. Soc. Mass Spectrom., 10 (1999) 1174](https://doi.org/10.1016/s1044-0305(99)00090-2) |
| G | Andersen, J. S.; Kuester, B.; Podtelejnikov, A.; Mortz, E.; Mann, M. | Proc. 47th ASMS Conf. Mass Spectrom. Allied Topics, 1999, Dallas, TX |
| H | Keller, B. O.; Li, L. | [J. Am. Soc. Mass Spectrom., 11 (2000) 88](https://doi.org/10.1016/s1044-0305(99)00126-9) |
| I | Keller, B. O.; Li, L.; Keller, H. | [MaClust: matrix cluster mass prediction](http://www.chem.ualberta.ca/~liweb/links/MaClust.htm) |
| J | Harris, W. A.; Janecki, D. J.; Reilly, J. P. | [Rapid Commun. Mass Spectrom., 16 (2002) 1714](https://doi.org/10.1002/rcm.775) |
| K | Keller, B. O.; Sui, J.; Young, A. B.; Whittal, R. M. | [Unpublished results; ESI background ions — Tween, Triton, PEGs, PPGs](http://www.chem.ualberta.ca/~massspec/es_ions.pdf) |
| L | Schlosser, A.; Volkmer-Engert, R. | [J. Mass Spectrom., 38 (2003) 523](https://doi.org/10.1002/jms.465) |
| M | Tran, J. C.; Doucette, A. A. | [J. Am. Soc. Mass Spectrom., 17 (2006) 652](https://doi.org/10.1016/j.jasms.2006.01.008) |
| N | Verge, K. M.; Agnes, G. R. | [J. Am. Soc. Mass Spectrom., 13 (2002) 901](https://doi.org/10.1016/s1044-0305(02)00386-0) |
| O | Paez, A.; Howe, A. | Canadian Chemical News, 56 (2004) 14 |
| P | Purves, R. W.; Gabryelski, W.; Li, L. | [Rev. Sci. Instrum., 68 (1997) 3252](https://doi.org/10.1063/1.1148276) |
| Q | Gibson, C. R.; Brown, C. M. | [J. Am. Soc. Mass Spectrom., 14 (2003) 1247](https://doi.org/10.1016/s1044-0305(03)00534-8) |
| R | Beavis, R. C.; Chait, B. T. | [Anal. Chem., 62 (1990) 1836](https://doi.org/10.1021/ac00216a020) |
| S | Guzzetta, A. | [ionsource.com — Carbohydrate marker ions](http://www.ionsource.com) |
| T | Clauser, K. R.; Hall, S. C.; Smith, D. M.; Webb, J. W.; Andrews, L. E.; Tran, H. M.; Epstein, L. B.; Burlingame, A. L. | [Proc. Natl. Acad. Sci. USA, 92 (1995) 5072](http://prospector.ucsf.edu) |
| U | Macha, S. F.; Limbach, P. A.; Hanton, S. D.; Owens, K. G. | [J. Am. Soc. Mass Spectrom., 12 (2001) 732](https://doi.org/10.1016/s1044-0305(01)00225-2) |
| V | Pleasance, S.; Thibault, P.; Sim, P. G.; Boyd, R. K. | [Rapid Commun. Mass Spectrom., 5 (1991) 307](https://doi.org/10.1002/rcm.1290050612) |
| W | Xia, Y.; Patel, S.; Bakhtiar, R.; Franklin, R. B.; Doss, G. A. | [J. Am. Soc. Mass Spectrom., 16 (2005) 417](https://doi.org/10.1016/j.jasms.2004.11.020) |
| X | Guo, X.; Bruins, A. P.; Covey, T. R. | [Rapid Commun. Mass Spectrom., 20 (2006) 3145](https://doi.org/10.1002/rcm.2715) |
| Y | Ijames, C. F.; Dutky, R. C.; Fales, H. M. | [J. Am. Soc. Mass Spectrom., 6 (1995) 1226](https://doi.org/10.1016/1044-0305(95)00579-x) |
| Z | Hesse, M.; Meier, H.; Zeeh, B. | Spektroskopische Methoden in der organischen Chemie, Georg Thieme Verlag, Stuttgart, 3rd ed. 1987, ISBN: 3-13-576103-7 |
| AA | Stanstrup, J. | [commonMZ R package](https://github.com/stanstrup/commonMZ) |
