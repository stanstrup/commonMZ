

# commonMZ

This is a collection of common *m/z* values found in mass spectrometry.
The tables are available through an R package. You can find the table
files in the “inst” subfolder.

Contributions are welcomed.

It contains these tab delimited files:

- **`contaminants_+.tsv`**: A table of common contaminant masses in
  positive ionization mode.
- **`contaminants_-.tsv`**: A table of common contaminant masses in
  negative ionization mode.
- **`adducts_fragments.tsv`**: A table of common fragment and adducts.
  The listed mass refers to mass differences.
- **`repeating_units_+.tsv`**: A table of common series of repeated
  units (mass differences) in positive ionization mode.
- **`repeating_units_-.tsv`**: A table of common series of repeated
  units (mass differences) in negative ionization mode.

And these excel files:

- **`CAMERA_rules_pos.xlsx`**: A table of common fragment and adducts
  for use with CAMERA in positive mode. The listed mass refers to mass
  differences to the uncharged species.
- **`CAMERA_rules_neg.xlsx`**: A table of common fragment and adducts
  for use with CAMERA in negative mode. The listed mass refers to mass
  differences to the uncharged species.
- **`CAMERA_rules_EI.xlsx`**: A table of common fragment and adducts for
  use with CAMERA in EI mode. The listed mass refers to mass differences
  to the uncharged species.

*Excel files are used to make it easier to work with since
adducts/fragment types have been color coded*.

## Glossary

| Type of ions: | Explanation |
|----|----|
| f+ | fragment ion |
| \[f+H\]+ | protonated fragment ion, e.g. in-source fragmentation of peptide ions |
| \[M+H\]+ | protonated molecular ion (pseudomolecular ion) |
| \[M+Na\]+ | sodiated molecular ion |
| \[M+K\]+ | potassiated molecular ion |
| \[M2+H\]+, \[M3+H\]+ etc… | protonated dimeric, trimeric, etc… molecular ion |
| \[AnBm+H\]+ | protonated molecular ion consisting of n A and m B subunits |

| Abbreviations | Explanation |
|----|----|
| 4-HCCA | α-cyano-4-hydroxycinnamic acid, common matrix substance for MALDI MS analysis |
| 2,5-DHB | 2,5-Dihydroxy benzoic acid, common matrix substance for MALDI MS analysis |
| MeCN, ACN | acetonitrile, solvent |
| MeOH | methanol, solvent |
| MeNO2 | nitromethane, solvent |
| HABA | 2-(4-hydroxyphenyl-azo)-benzoic acid, matrix substance for MALDI MS analysis |
| SA | sinapic or sinapinic acid, common matrix substance for MALDI MS analysis |
| PEG | Polyethylene glycol, Repeat unit: -\[O-CH2-CH2-\]-; 44 Da |
| PPG | Polypropylene glycol, Repeat unit: -\[O-C(CH3)H-CH2-\]-; 58 Da |
| XaaCcamXaa | carbamidomethylated cysteine residue (+ICH2CONH2 - HI), +57Da |
| XaaMoxXaa | singly oxidized methionine residue (+O, 16 Da) |

## References

The data in these tables are primarily from:

- the Supplementary Data from: Keller BO, Sui J, Young AB, Whittal RM.
  Interferences and contaminants encountered in modern mass
  spectrometry. Anal Chim Acta. 2008;627(1):71-81.

In the tables each entry references refers to the following table:

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
| P | Purves, R. W.; Gabryelski, W.; Li, L. | Rev. Sci. Instrum., 68 (1997) 3252 |
| Q | Gibson, C. R.; Brown, C. M. | J. Am. Soc. Mass Spectrom., 14 (2003) 1247 |
| R | Beavis, R. C.; Chait, B. T. | Anal. Chem., 62 (1990) 1836 |
| S | Guzzetta, A. | [ionsource.com](http://www.ionsource.com) — Carbohydrate marker ions |
| T | Clauser, K. R.; Hall, S. C.; Smith, D. M.; Webb, J. W.; Andrews, L. E.; Tran, H. M.; Epstein, L. B.; Burlingame, A. L. | Proc. Natl. Acad. Sci. USA, 92 (1995) 5072; [prospector.ucsf.edu](http://prospector.ucsf.edu) |
| U | Macha, S. F.; Limbach, P. A.; Hanton, S. D.; Owens, K. G. | J. Am. Soc. Mass Spectrom., 12 (2001) 732 |
| V | Pleasance, S.; Thibault, P.; Sim, P. G.; Boyd, R. K. | Rapid Commun. Mass Spectrom., 5 (1991) 307 |
| W | Xia, Y.; Patel, S.; Bakhtiar, R.; Franklin, R. B.; Doss, G. A. | J. Am. Soc. Mass Spectrom., 16 (2005) 417 |
| X | Guo, X.; Bruins, A. P.; Covey, T. R. | Rapid Commun. Mass Spectrom., 20 (2006) 3145 |
| Y | Ijames, C. F.; Dutky, R. C.; Fales, H. M. | J. Am. Soc. Mass Spectrom., 6 (1995) 1226 |
| Z | Hesse, M.; Meier, H.; Zeeh, B. | Spektroskopische Methoden in der organischen Chemie, Georg Thieme Verlag, Stuttgart, 3rd ed. 1987, ISBN: 3-13-576103-7 |
| AA | Stanstrup, J. | — |
