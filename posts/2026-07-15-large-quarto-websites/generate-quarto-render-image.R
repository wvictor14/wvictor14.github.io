# To generate an image assocaited with blog post
# x-axis is number of pages in a quarto project
# y-axis is render time in seconds

library(fs)
library(quarto)
library(ggplot2)
library(dplyr)
library(withr)
library(furrr)
library(here)
library(readr)

# STEP 1: generate a temporary quarto project with X number of pages

generate_quarto_project <- function(dir = fs::path_temp(), n_page = 3) {
  # Create _quarto.yml
  quarto_config <- "project:
  type: website
  output-dir: _site
format:
  html:
    theme: cosmo
"
  cat(quarto_config, file = fs::path(dir, "_quarto.yml"))

  # Create index.qmd
  index_content <- "---
title: \"Benchmark Project\"
---

# Home

This is the index page for benchmarking.
"
  cat(index_content, file = fs::path(dir, "index.qmd"))

  # Create n_page additional pages
  for (i in seq_len(n_page)) {
    page_content <- sprintf(
      "---
title: \"Page %d\"
---

# Page %d

This is page %d with some content to render.

```{r}
# Simple computation
x <- rnorm(1000)
y <- rnorm(1000)
plot(x, y)
```
",
      i,
      i,
      i
    )

    page_name <- sprintf("page_%d.qmd", i)
    cat(page_content, file = fs::path(dir, page_name))
  }

  dir
}

# STEP 2: render and record time

benchmark_one <- function(n_pages) {
  cat("Benchmarking with", n_pages, "pages...\n")

  render_time <- local({
    project_dir <- withr::local_tempdir(pattern = "quarto_bench_")
    generate_quarto_project(dir = project_dir, n_page = n_pages)
    withr::local_dir(project_dir)

    start_time <- Sys.time()
    tryCatch(
      quarto::quarto_render(),
      error = function(e) {
        cat(
          "Error rendering project with",
          n_pages,
          "pages:",
          conditionMessage(e),
          "\n"
        )
      }
    )
    as.numeric(difftime(Sys.time(), start_time, units = "secs"))
  })

  data.frame(
    n_pages = n_pages,
    render_time_sec = render_time,
    avg_time_per_page = render_time / n_pages,
    stringsAsFactors = FALSE
  )
}

benchmark_render <- function(n_pages_seq = seq(1, 500, by = 25)) {
  future::plan(future::multisession, workers = future::availableCores() - 1)

  furrr::future_map_dfr(n_pages_seq, benchmark_one)
}

# STEP 3: generate figure

benchmark_results <- benchmark_render(
  n_pages_seq = c(1, 5, 10, 25, 50, 100, 250, 500)
)

p <- ggplot(benchmark_results, aes(x = n_pages, y = render_time_sec)) +
  geom_point(size = 3) +
  geom_line() +
  labs(
    x = "Number of Pages",
    y = "Render Time\n(seconds)",
    caption = "Single-threaded render on a typical machine"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    axis.title.y = element_text(angle = 0, vjust = 0.5),
    axis.ticks.x = element_line()
  )
p

ggsave(
  here::here(
    'posts',
    '2026-07-15-large-quarto-websites',
    "quarto-render-time.png"
  ),
  p,
  width = 5,
  height = 4,
  dpi = 150
)

cat("Plot saved to quarto-render-time.png\n")
print(benchmark_results)
benchmark_results |>
  readr::write_csv(
    here::here(
      'posts',
      '2026-07-15-large-quarto-websites',
      'render-time.csv'
    )
  )
