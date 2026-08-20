# Looking up an unexplained mass difference

[*Isotope fine
structure*](https://stanstrup.github.io/commonMZ/articles/isotope-fine-structure.md)
starts from a candidate formula. Most of the time you don’t have one
yet: you have two peaks in a spectrum and a delta between them, and the
question is “what family of thing produces a gap this size?” An
in-source fragment loses a neutral (water, CO₂, a whole side chain). A
homologous series steps by a repeating unit (CH₂, C₂H₄O, a whole PEG
monomer). An adduct swaps one attached ion for another (Na⁺ for K⁺,
formate for acetate). All three are catalogued in commonMZ already:
`adducts_fragments` and `repeating_units_pos`/`repeating_units_neg`,
merged by
[`mz_diff_table()`](https://stanstrup.github.io/commonMZ/reference/mz_diff_table.md)
into one searchable reference:

``` r

diffs <- mz_diff_table("both")
nrow(diffs)
```

    [1] 128

Isotope spacings are deliberately not in this table; they depend on
which formula produced the peaks and belong to [the isotope
fine-structure
tool](https://stanstrup.github.io/commonMZ/articles/isotope-fine-structure.md)
instead.

## The calculator: search by a difference and a ppm tolerance

This is
[`mz_diff_lookup()`](https://stanstrup.github.io/commonMZ/reference/mz_diff_lookup.md)’s
job for a single value called from R. Tolerance is in ppm of the
difference by default (the usual way instrument accuracy is quoted),
though note that is *not* the same as ppm of either peak’s own m/z; see
the function’s documentation
([`?mz_diff_lookup`](https://stanstrup.github.io/commonMZ/reference/mz_diff_lookup.md))
for why that distinction matters and when to widen the tolerance or pass
an absolute `unit = "Da"` window instead.

``` r

mz_diff_lookup(18.0106, tol = 100) %>%   # water, 100 ppm of the delta
  mutate(error_ppm = round(error_ppm, 1)) %>%
  DT::datatable(rownames = FALSE,
                options = list(pageLength = 10, dom = "t"))
```

And a delta genuinely ambiguous without more context: several catalogued
differences sit within a few ppm of each other, so the delta alone does
not decide; you still need to ask whether the sample plausibly contains
an alkane chain, an acrylamide adduct, or neither:

``` r

mz_diff_lookup(14.0157, tol = 50) %>%
  mutate(error_ppm = round(error_ppm, 1)) %>%
  DT::datatable(rownames = FALSE,
                options = list(pageLength = 10, dom = "t"))
```

## Working interactively

For browsing without writing R code, type a difference and a ppm
tolerance and click *Search*. The table’s own *Search:* box (top right)
still works as usual for browsing by category, mode or origin text.

``` r

## the exact DataTables core version DT bundles, for the CDN fallback below --
## read from the widget's own dependency metadata rather than hard-coded, so
## it can't drift out of sync with whatever DT version is installed.
mdl_widget_probe <- datatable(data.frame(x = 1))
DT_CORE_VERSION <- Filter(function(d) d$name == "dt-core", mdl_widget_probe$dependencies)[[1]]$version

htmltools::tagList(
  htmltools::tags$div(
    style = "display:flex; gap:1em; align-items:end; margin-bottom:0.75em; flex-wrap:wrap;",
    htmltools::tags$div(
      htmltools::tags$label("m/z difference (Da)", `for` = "mdl_mz"),
      htmltools::tags$br(),
      htmltools::tags$input(id = "mdl_mz", type = "number", step = "any",
                            class = "form-control", style = "width:12em;")
    ),
    htmltools::tags$div(
      htmltools::tags$label("tolerance (ppm)", `for` = "mdl_ppm"),
      htmltools::tags$br(),
      htmltools::tags$input(id = "mdl_ppm", type = "number", step = "any", value = "50",
                            class = "form-control", style = "width:10em;")
    ),
    htmltools::tags$button("Search", id = "mdl_go", type = "button", class = "btn btn-primary"),
    htmltools::tags$button("Clear", id = "mdl_clear", type = "button", class = "btn btn-outline-secondary")
  ),
  datatable(diffs, rownames = FALSE, elementId = "mdl_table",
           colnames = c("mz_diff (Da)", "category", "mode", "origin", "reference"),
           options = list(pageLength = 8, order = list(list(0, "asc")))),
  htmltools::tags$script(htmltools::HTML(sprintf("
    // Some documentation-site rebuilds of this page have been observed to drop
    // the bundled DataTables core script while keeping its CSS (a
    // pkgdown/htmlwidgets packaging issue, not a data issue) -- which would
    // otherwise also break DT's OWN widget initialisation, not just the code
    // below (both happen on document-ready). document.write() is deprecated
    // for most uses, but this is its one still-legitimate case: called
    // synchronously from a plain, non-deferred inline script WHILE THE PAGE
    // IS STILL PARSING, it inserts the <script> tag directly into the parse
    // stream, so the browser fetches and runs it before parsing continues --
    // i.e. before DOMContentLoaded, before jQuery's ready queue, and before
    // DT's own widget render. That ordering guarantee is why this, and not
    // an appendChild()'d script, is used here.
    if (typeof $ === 'undefined' || typeof $.fn.dataTable === 'undefined') {
      document.write('<script src=\"https://cdn.datatables.net/%s/js/jquery.dataTables.min.js\"><\\/script>');
    }
    $(document).ready(function() {
      // DT's elementId lands on the WRAPPER DIV, not the <table> inside it --
      // grab the real table (and its live DataTables API), and compare DOM
      // nodes rather than ids in the search predicate below.
      var $tbl = $('#mdl_table').find('table').first();
      if (!$tbl.length) return;
      var dt = $tbl.DataTable();
      var target = null, tolDa = null;

      $.fn.dataTable.ext.search.push(function(settings, data, dataIndex) {
        if (settings.nTable !== $tbl.get(0)) return true;
        if (target === null) return true;
        var val = parseFloat(data[0]);
        return !isNaN(val) && Math.abs(val - target) <= tolDa;
      });
      $('#mdl_go').on('click', function() {
        var mz  = parseFloat(document.getElementById('mdl_mz').value);
        var ppm = parseFloat(document.getElementById('mdl_ppm').value);
        if (isNaN(mz) || isNaN(ppm)) { target = null; }
        else { target = mz; tolDa = Math.abs(mz) * ppm / 1e6; }
        dt.draw();
      });
      $('#mdl_clear').on('click', function() {
        document.getElementById('mdl_mz').value = '';
        target = null;
        dt.draw();
      });
    });
  ", DT_CORE_VERSION)))
)
```

m/z difference (Da)  

tolerance (ppm)  

Search

Clear

The search only re-filters when you click *Search* (not on every
keystroke), so typing a value never triggers a redraw mid-edit – click
once you’ve entered both numbers, or press *Clear* to go back to the
full table.

## Checklist

1.  **Search first, don’t guess one hypothesis at a time.**
    [`mz_diff_lookup()`](https://stanstrup.github.io/commonMZ/reference/mz_diff_lookup.md)
    (or the interactive table above) checks your delta against every
    known adduct/fragment/repeating-unit difference in commonMZ at once.
2.  **A delta rarely has only one explanation.** When several catalogued
    differences land within tolerance of each other, use what you know
    about the sample (the matrix, the method, what’s chemically
    plausible) to break the tie, the same way the mobile-phase
    composition was what actually resolved the ambiguous formulas in
    `contaminants_+.tsv`’s metal-complex entries.
3.  **Mind the tolerance convention.** ppm of a small delta is a much
    tighter window than ppm of a large one; if nothing matches, try a
    wider tolerance or an absolute Da window before concluding the delta
    is uncatalogued.
4.  **If you do have (or can guess) a formula**, switch to [*Isotope
    fine
    structure*](https://stanstrup.github.io/commonMZ/articles/isotope-fine-structure.md):
    an isotope satellite is a different kind of delta than this table
    covers.
