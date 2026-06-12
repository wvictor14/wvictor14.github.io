# AGENTS.md — wvictor14.github.io

Personal website at [victoryuan.com](https://victoryuan.com), built with Quarto (R/knitr engine).

## Setup

```bash
# Restore R packages
R -e "renv::restore(prompt = FALSE)"

# Start local dev server (port 4210, bound to 0.0.0.0)
quarto preview

# Build site
quarto render
```

## Key quirks

- `freeze: true` in `_quarto.yml` — R code chunks are NOT re-executed on render.
  To force re-execution: `quarto render --no-freeze` or delete `_freeze/`.
- Dev port is 4210 (set in `_quarto.yml` to match devcontainer port mapping).
- No test/lint/typecheck commands — this is a static site, not an R package.
- No Python files live in the repo. All content is R/Quarto.

## Editing content

- After editing any `.qmd` file, always validate it by running:
  ```bash
  quarto render <path/to/file>.qmd
  ```
  This re-renders the specific file (including executing R code chunks).

## Deployment

- CI: `.github/workflows/publish.yml` — triggers on push to `main`, renders and publishes to `gh-pages` via `quarto-dev/quarto-actions/publish`.
- `CNAME` file is committed — do not delete (enables custom domain victoryuan.com).
- Manual deploy: `quarto publish gh-pages` (authenticated).

## R dependencies

- Lockfile: `renv.lock` (restore with `renv::restore()`).
- Key packages: quarto, dplyr, tidyr, knitr, rmarkdown, shinylive, shiny, gt.
- Devcontainer sets up all dependencies via `renv::restore()` then `renv::install()`.

## Key config files

- `_quarto.yml` — site structure, navbar, footer, format, Google Analytics, freeze behavior.
- `_brand.yml` — brand colors, fonts (Figtree from Google Fonts), logo.
- `posts/_metadata.yml` — post defaults (freeze, giscus comments repo).
