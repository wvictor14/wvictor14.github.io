# Brand colors and fonts for R graphics (ggplot2, gt), sourced from
# _brand.yml so plots/tables match the website's visual identity.
#
# Usage in a post's setup chunk:
#   source(here::here("R", "brand.R"))
#   register_brand_fonts()
#   ggplot(mpg, aes(displ, hwy, color = class)) +
#     geom_point() +
#     scale_color_brand_d() +
#     theme_brand()
#
# Python equivalent (for future use, not implemented here since no
# Python code exists in this repo yet): read _brand.yml with PyYAML,
# register fonts via matplotlib.font_manager.fontManager.addfont(),
# and consider the `great_tables` package's native brand.yml support
# for tables.

brand_colors <- function() {
  brand <- yaml::read_yaml(here::here("_brand.yml"))
  palette <- brand$color$palette
  unlist(palette)
}

register_brand_fonts <- function() {
  sysfonts::font_add_google("Source Serif 4", "brand-serif")
  sysfonts::font_add_google("IBM Plex Mono", "brand-mono")
  showtext::showtext_auto()
  invisible(NULL)
}

theme_brand <- function(base_size = 15) {
  colors <- brand_colors()
  ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      text = ggplot2::element_text(color = colors[["black"]]),
      plot.title = ggplot2::element_text(family = "brand-serif"),
      plot.subtitle = ggplot2::element_text(family = "brand-serif"),
      axis.text = ggplot2::element_text(family = "brand-mono", size = ggplot2::rel(0.8)),
      axis.title = ggplot2::element_text(family = "brand-mono", size = ggplot2::rel(0.9)),
      legend.text = ggplot2::element_text(family = "brand-mono", size = ggplot2::rel(0.8)),
      legend.title = ggplot2::element_text(family = "brand-mono", size = ggplot2::rel(0.9)),
      plot.background = ggplot2::element_rect(fill = colors[["paper"]], color = NA),
      panel.background = ggplot2::element_rect(fill = colors[["paper"]], color = NA),
      panel.grid = ggplot2::element_line(color = colors[["hairline"]], linewidth = 0.2)
    )
}

brand_palette_d <- function() {
  colors <- brand_colors()
  unname(colors[c("orange", "teal", "pink", "black")])
}

scale_color_brand_d <- function(...) {
  ggplot2::scale_color_manual(values = brand_palette_d(), ...)
}

scale_fill_brand_d <- function(...) {
  ggplot2::scale_fill_manual(values = brand_palette_d(), ...)
}

gt_brand <- function(gt_tbl) {
  colors <- brand_colors()
  gt_tbl |>
    gt::opt_table_font(font = "brand-mono") |>
    gt::tab_style(
      style = gt::cell_text(font = "brand-serif"),
      locations = gt::cells_title()
    ) |>
    gt::tab_options(
      table.border.top.color = colors[["hairline"]],
      table.border.bottom.color = colors[["hairline"]],
      column_labels.border.bottom.color = colors[["hairline"]],
      table_body.border.bottom.color = colors[["hairline"]],
      table.background.color = colors[["paper"]]
    )
}
