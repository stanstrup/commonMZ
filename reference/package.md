# Collection of common \*m/z\*

This is a collection of common \*m/z\* values found in mass
spectrometry.

## Author

Jan Stanstrup

## Details

This package contains:

- [`MZ_CAMERA`](https://stanstrup.github.io/commonMZ/reference/MZ_CAMERA.md):
  A function that returns a table of common fragment and adducts for use
  with CAMERA in positive mode. The listed mass refers to mass
  differences to the uncharged species.

- `adducts_fragments`: A table of common fragment and adducts. The
  listed mass refers to mass differences.

- `contaminants_neg`: A table of common contaminant masses in negative
  ionization mode.

- `contaminants_pos`: A table of common contaminant masses in positive
  ionization mode.

- `repeating_units_neg`: A table of common series of repeated units
  (mass differences) in negative ionization mode.

- `repeating_units_pos`: A table of common series of repeated units
  (mass differences) in positive ionization mode.

## References

The data in these tables are primarily from:

- The Supplementary Data from: Keller BO, Sui J, Young AB, Whittal RM.
  [Interferences and contaminants encountered in modern mass
  spectrometry.](https://doi.org/10.1016/j.aca.2008.04.043) Anal Chim
  Acta. 2008;627(1):71-81.
