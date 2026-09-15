#' @importFrom magrittr %>%
#' @importFrom dplyr filter count pull mutate if_else left_join select coalesce transmute row_number group_by lag ungroup arrange desc
#' @importFrom tidyr pivot_longer
#' @importFrom CAMERA getPeaklist
#' @importFrom plotly plot_ly layout
#' @importFrom ggplot2 ggplot geom_col aes geom_segment geom_text scale_fill_manual coord_radial theme_void position_stack
#' @importFrom RColorBrewer brewer.pal
NULL

# Extract the isotope-group label from a CAMERA isotope string, e.g.
# "[M+1]+[5]" -> "[M+1]"
.iso_of <- function(x) sub("^.*?\\[M([^\\]]*)\\].*$", "[M\\1]", x, perl = TRUE)

# Return the destinations of edges leaving `sources`, sorted by total flow.
.col_order <- function(edges, sources) {
  edges %>%
    filter(from %in% sources) %>%
    count(to, wt = n, sort = TRUE) %>%
    pull(to)
}

# Proportional y-centres for nodes in one Sankey column (top=0, bottom=1).
.calc_y <- function(nodes, flows, gap = 0.01) {
  f   <- pmax(flows[nodes], 1)
  h   <- f / sum(f) * (1 - gap * (length(f) - 1))
  mid <- cumsum(c(0, h[-length(h)] + gap)) + h / 2
  setNames(pmin(pmax(mid, 0.001), 0.999), nodes)
}


#' Build Sankey node/link data from a CAMERA annotation result
#'
#' Extracts the peak list from a CAMERA \code{xsAnnotate} result and builds
#' the node/link tables needed to draw a four-column Sankey diagram showing
#' how annotated peaks flow through isotope type, multiplicity, and adduct rule.
#'
#' The four columns are:
#' \enumerate{
#'   \item \strong{All annotations} — every annotated peak.
#'   \item \strong{Isotope type} — \code{no isotope annotation}, \code{[M]},
#'     \code{[M+1]}, \code{[M+2]}, \ldots  Satellite peaks (\code{[M+1]} etc.\
#'     without an adduct match) terminate here.
#'   \item \strong{Multiplicity} — \code{[1M]}, \code{[2M]}, \ldots
#'   \item \strong{Adduct rule} — the matched rule name, ordered by frequency.
#' }
#'
#' @param cam_result An \code{xsAnnotate} object returned by
#'   \code{CAMERA::findAdducts()}. The rules used during annotation are read
#'   from \code{cam_result@@ruleset}.
#'
#' @return A list with two data frames:
#' \describe{
#'   \item{\code{nodes}}{Columns \code{label}, \code{x}, \code{y}.}
#'   \item{\code{links}}{Columns \code{source}, \code{target}, \code{value}
#'     (0-indexed node indices, as required by plotly).}
#' }
#'
#' @seealso \code{\link{camera_sankey}}
#' @author Jan Stanstrup, \email{stanstrup@gmail.com}
#' @export
camera_sankey_data <- function(cam_result) {
  peaklist <- getPeaklist(cam_result)
  rules    <- cam_result@ruleset

  iso_lvl <- c("no isotope annotation", "[M]", "[M+1]", "[M+2]", "[M+3]", "[M+4]")

  paths <- peaklist %>%
    mutate(
      rule_name = if_else(
        trimws(adduct) != "",
        trimws(sub("\\s+[0-9.]+$", "", adduct)),
        NA_character_
      ),
      iso_raw = if_else(
        trimws(isotopes) != "",
        .iso_of(isotopes),
        NA_character_
      )
    ) %>%
    left_join(select(rules, name, nmol), by = c("rule_name" = "name")) %>%
    filter(!is.na(nmol) | (trimws(adduct) == "" & !is.na(iso_raw))) %>%
    mutate(
      iso_type = coalesce(iso_raw, "no isotope annotation"),
      through  = !is.na(nmol) & iso_type %in% c("[M]", "no isotope annotation")
    ) %>%
    transmute(
      n1 = "All annotations", n2 = iso_type,
      n3 = if_else(through, paste0("[", nmol, "M]"), NA_character_),
      n4 = if_else(through, rule_name,               NA_character_)
    )

  edges <- paths %>%
    mutate(.id = row_number()) %>%
    pivot_longer(-.id, values_to = "to", values_drop_na = TRUE) %>%
    group_by(.id) %>%
    mutate(from = lag(to)) %>%
    filter(!is.na(from)) %>%
    ungroup() %>%
    count(from, to, name = "n")

  iso_nodes <- .col_order(edges, "All annotations")
  iso_ord   <- c(intersect(iso_lvl, iso_nodes), setdiff(iso_nodes, iso_lvl))
  mult_ord  <- .col_order(edges, c("[M]", "no isotope annotation"))
  rule_ord  <- .col_order(edges, mult_ord)

  col_nodes <- list("All annotations", iso_ord, mult_ord, rule_ord)
  col_x_val <- c(0.01, 0.33, 0.66, 0.99)
  all_nodes <- unlist(col_nodes)

  links <- edges %>%
    transmute(
      source = match(from, all_nodes) - 1L,
      target = match(to,   all_nodes) - 1L,
      value  = n
    )

  m <- matrix(0L, length(all_nodes), length(all_nodes))
  m[cbind(links$source + 1L, links$target + 1L)] <- links$value
  node_flow <- setNames(pmax(rowSums(m), colSums(m)), all_nodes)

  node_x <- rep(col_x_val, lengths(col_nodes))
  node_y <- unname(unlist(lapply(col_nodes, .calc_y, flows = node_flow)))

  list(
    nodes = data.frame(label = all_nodes, x = node_x, y = node_y,
                       stringsAsFactors = FALSE),
    links = as.data.frame(links)
  )
}


#' Sankey diagram of CAMERA annotation results
#'
#' Draws an interactive four-column Sankey diagram showing how peaks annotated
#' by CAMERA flow from isotope type through multiplicity to adduct rule.
#'
#' @inheritParams camera_sankey_data
#' @param height Plot height in pixels. Default \code{800}.
#' @param margin_right Right margin in pixels, to leave room for the rightmost
#'   node labels. Default \code{160}.
#'
#' @return A \code{plotly} htmlwidget.
#'
#' @seealso \code{\link{camera_sankey_data}}
#' @author Jan Stanstrup, \email{stanstrup@gmail.com}
#' @export
camera_sankey <- function(cam_result, height = 800, margin_right = 160) {
  sk <- camera_sankey_data(cam_result)

  plot_ly(
    type        = "sankey",
    arrangement = "fixed",
    height      = height,
    node = list(
      label     = sk$nodes$label,
      x         = sk$nodes$x,
      y         = sk$nodes$y,
      pad       = 15,
      thickness = 20
    ),
    link = list(
      source = sk$links$source,
      target = sk$links$target,
      value  = sk$links$value
    )
  ) %>%
    layout(margin = list(r = margin_right))
}


#' Pie chart of fired adduct/fragment rules from a CAMERA annotation
#'
#' Shows how many times each rule was assigned across all annotated peaks,
#' with labelled leader lines ordered by frequency.
#'
#' @inheritParams camera_sankey_data
#'
#' @return A \code{ggplot} object.
#'
#' @author Jan Stanstrup, \email{stanstrup@gmail.com}
#' @export
camera_pie <- function(cam_result) {
  rules <- cam_result@ruleset

  rules_count <- cam_result@annoID[, "ruleID"] %>%
    factor(levels = seq_len(nrow(rules))) %>%
    table() %>%
    as.data.frame() %>%
    setNames(c("ruleID", "n")) %>%
    mutate(name = rules$name[as.integer(ruleID)]) %>%
    arrange(desc(n))

  pie_data <- rules_count %>%
    filter(n > 0) %>%
    mutate(
      name     = factor(name, levels = name),
      cumend   = cumsum(n),
      cumstart = cumend - n,
      mid      = (cumstart + cumend) / 2,
      on_right = mid / sum(n) < 0.5
    )

  set1 <- brewer.pal(9, "Set1")
  pie_colors <- rep(set1[set1 != "#FFFF33"], length.out = nrow(pie_data))

  ggplot(pie_data) +
    geom_col(
      aes(x = 0.5, y = n, fill = name),
      width = 1, color = "white", linewidth = 0.3, show.legend = FALSE,
      position = position_stack(reverse = TRUE)
    ) +
    geom_segment(
      aes(x = 1.0, xend = 1.2, y = mid, yend = mid),
      linewidth = 0.3, color = "grey50"
    ) +
    geom_text(
      aes(x = 1.25, y = mid, label = name, hjust = ifelse(on_right, 0, 1)),
      size = 3
    ) +
    scale_fill_manual(values = setNames(pie_colors, levels(pie_data$name))) +
    coord_radial(theta = "y", start = 0, expand = FALSE) +
    theme_void()
}
