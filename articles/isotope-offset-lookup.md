# Looking up an isotopologue offset

When you zoom into the M+1 or M+2 region of a high-resolution spectrum
you see several peaks separated by a few millidaltons. The question is:
which pair of isotope substitutions produces the gap you just measured?

This page precomputes every pairwise separation between isotopologues of
common elements within the same nominal level. Enter the observed gap
and a tolerance, click **Search**, and the table returns every element
pair that could explain it.

Show code

``` r

## Build one row per element × isotopologue for M+1 and M+2
ref_raw <- map_dfr(REF_ELEMENTS, function(el) {
  p <- tryCatch(isotope_fine_pattern(el), error = function(e) NULL)
  if (is.null(p) || nrow(p) == 0) return(NULL)
  base <- p %>% filter(label == "") %>% pull(mz)
  if (length(base) == 0) return(NULL)
  p %>%
    filter(label != "") %>%
    mutate(
      element  = el,
      nominal  = round(mz - base),
      offset_M = round(mz - base, 6)
    ) %>%
    filter(nominal %in% 1:2) %>%
    select(element, level = nominal, isotopologue = label, offset_M, abundance)
})

## All pairwise separations within each nominal level
pairs <- map_dfr(split(ref_raw, ref_raw$level), function(d) {
  if (nrow(d) < 2) return(NULL)
  level_label <- paste0("M+", d$level[1])
  idx <- combn(nrow(d), 2)
  map_dfr(seq_len(ncol(idx)), function(i) {
    ra <- d[idx[1, i], ]; rb <- d[idx[2, i], ]
    tibble(
      level          = level_label,
      `isotopologue A` = paste0(ra$element, ": ", ra$isotopologue),
      `isotopologue B` = paste0(rb$element, ": ", rb$isotopologue),
      `difference (Da)` = round(ra$offset_M - rb$offset_M, 6),
      `abundance A (% of M)` = round(ra$abundance, 4),
      `abundance B (% of M)` = round(rb$abundance, 4)
    )
  })
}) %>%
  arrange(level, abs(`difference (Da)`)) %>%
  mutate(`ppm error` = "")
```

## Search by observed separation

Enter the gap you measured between two fine-structure peaks and a
tolerance in millidaltons (mDa). A Da window makes more physical sense
here than ppm — these separations are just a few tenths of a
millidalton, so a 1 mDa window already covers the instrument’s
measurement uncertainty regardless of the parent ion’s m/z. The
**reference m/z** is used only to compute the **ppm error** display
column, so you can judge the match in the units your instrument reports.

observed gap (Da)  

tolerance (mDa)  

reference m/z (Da)  

level  
All M+1 M+2

Search

Clear

The table shows every pair of isotopologues within the same nominal
level (M+1 or M+2). Search by entering the gap you measured between two
peaks in the fine structure.

## How to use this table

1.  Zoom into the M+1 or M+2 region of your spectrum and measure the
    separation between any two peaks you can resolve.
2.  Enter that gap in the **observed gap** field and a **tolerance in
    mDa** matching your instrument’s mass accuracy. Use the **level**
    dropdown to restrict results to M+1 or M+2 if you already know which
    region you are working in. Click **Search**.
3.  Each returned row names the pair of isotopologues whose exact-mass
    positions are that far apart. The **ppm error** column shows how far
    off the theoretical value is relative to the reference m/z — a
    useful cross-check against your instrument’s quoted mass accuracy.
    Check the abundance columns: if one member of the pair is far too
    small to see at your current resolution, rule it out.

For a formula-specific analysis — how large each peak should be, and
what resolving power you need to separate them — see [*Isotope fine
structure*](https://stanstrup.github.io/commonMZ/articles/isotope-fine-structure.md).
