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

| Label | First author(s)            | Year |
|-------|----------------------------|------|
| A     | Waters Corporation         | —    |
| B     | Applied Biosystems         | —    |
| C     | New Objective              | —    |
| D     | Sigma-Aldrich              | —    |
| E     | Thermo Corporation, Mahn   | —    |
| F     | Tong et al.                | 1999 |
| G     | Andersen et al.            | 1999 |
| H     | Keller & Li                | 2000 |
| I     | Keller et al.              | —    |
| J     | Harris et al.              | 2002 |
| K     | Keller et al.              | —    |
| L     | Schlosser & Volkmer-Engert | 2003 |
| M     | Tran & Doucette            | 2006 |
| N     | Verge & Agnes              | 2002 |
| O     | Paez & Howe                | 2004 |
| P     | Purves et al.              | 1997 |
| Q     | Gibson & Brown             | 2003 |
| R     | Beavis & Chait             | 1990 |
| S     | Guzzetta                   | —    |
| T     | Clauser et al.             | 1995 |
| U     | Macha et al.               | 2001 |
| V     | Pleasance et al.           | 1991 |
| W     | Xia et al.                 | 2005 |
| X     | Guo et al.                 | 2006 |
| Y     | Ijames et al.              | 1995 |
| Z     | Hesse et al.               | 1987 |
| AA    | Stanstrup                  | —    |

Full bibliographic details:

Andersen, J. S., B. Kuester, A. Podtelejnikov, E. Mortz, and M. Mann.
1999. *Proc. 47th ASMS Conf. Mass Spectrom. Allied Topics* (Dallas, TX).

Applied Biosystems. n.d. *Appendix D: Commonly Observed Background
Ions*. Mariner Biospectrometry Workstation Users Guide.

Beavis, R. C., and B. T. Chait. 1990. *Anal. Chem.* 62: 1836.

Clauser, K. R., S. C. Hall, D. M. Smith, et al. 1995. *Proc. Natl. Acad.
Sci. USA* 92: 5072.

Gibson, C. R., and C. M. Brown. 2003. *J. Am. Soc. Mass Spectrom.* 14:
14.

Guo, X., A. P. Bruins, and T. R. Covey. 2006. *Rapid Commun. Mass
Spectrom.* 20: 3145.

Guzzetta, A. n.d. *Carbohydrate Marker Ions*.
[Http://www.ionsource.com](http://www.ionsource.com).

Harris, W. A., D. J. Janecki, and J. P. Reilly. 2002. *Rapid Commun.
Mass Spectrom.* 16: 1714.

Hesse, M., H. Meier, and B. Zeeh. 1987. *Spektroskopische Methoden in
Der Organischen Chemie*. 3rd ed. Georg Thieme Verlag.

Ijames, C. F., R. C. Dutky, and H. M. Fales. 1995. *J. Am. Soc. Mass
Spectrom.* 6: 1226.

Keller, B. O., and L. Li. 2000. *J. Am. Soc. Mass Spectrom.* 11: 88.

Keller, B. O., L. Li, and H. Keller. n.d. *MaClust: Program to Predict
and Confirm Matrix Cluster Masses*.
[Http://www.chem.ualberta.ca/~liweb/links/MaClust.htm](http://www.chem.ualberta.ca/~liweb/links/MaClust.htm).

Keller, B. O., J. Sui, A. B. Young, and R. M. Whittal. n.d. *ESI
Background Ions — Tween, Triton, PEGs, PPGs*. Unpublished results.
<http://www.chem.ualberta.ca/~massspec/es_ions.pdf>.

Macha, S. F., P. A. Limbach, S. D. Hanton, and K. G. Owens. 2001. *J.
Am. Soc. Mass Spectrom.* 12: 732.

New Objective. n.d. *Common Background Ions for Electrospray*. Technical
Note. <http://www.newobjective.com/downloads/technotes/PV-3.pdf>.

Paez, A., and A. Howe. 2004. *Canadian Chemical News* 56: 14.

Pleasance, S., P. Thibault, P. G. Sim, and R. K. Boyd. 1991. *Rapid
Commun. Mass Spectrom.* 5: 307.

Purves, R. W., W. Gabryelski, and L. Li. 1997. *Rev. Sci. Instrum.* 68:
3252.

Schlosser, A., and R. Volkmer-Engert. 2003. *J. Mass Spectrom.* 38: 523.

Sigma-Aldrich. n.d. *Chemical Formulas for Tween, Triton, and Reduced
Triton*. [Http://www.sigmaaldrich.com](http://www.sigmaaldrich.com).

Stanstrup, Jan. n.d. *commonMZ: Common* m/z *Values in Mass
Spectrometry*.
[Https://github.com/stanstrup/commonMZ](https://github.com/stanstrup/commonMZ).

Thermo Corporation, and B. Mahn. n.d. *List of LC/MS Contaminants*.
[Http://www.abrf.org/index.cfm/list.msg/66994](http://www.abrf.org/index.cfm/list.msg/66994).

Tong, H., D. Bell, K. Tabei, and M. M. Siegel. 1999. *J. Am. Soc. Mass
Spectrom.* 10: 1174.

Tran, J. C., and A. A. Doucette. 2006. *J. Am. Soc. Mass Spectrom.* 17:
652.

Verge, K. M., and G. R. Agnes. 2002. *J. Am. Soc. Mass Spectrom.* 13:
901.

Waters Corporation. n.d. *Background Ion List*.
[Https://www2.waters.com/CEConversion.nsf/files/3929E3EC20E43AAA8525710D004AB62E/\$file/bkgrnd_ion_mstr_list.pdf](https://www2.waters.com/CEConversion.nsf/files/3929E3EC20E43AAA8525710D004AB62E/%24file/bkgrnd_ion_mstr_list.pdf).

Xia, Y.-Q., S. Patel, R. Bakhtiar, R. B. Franklin, and G. A. Doss. 2005.
*J. Am. Soc. Mass Spectrom.* 16: 417.
