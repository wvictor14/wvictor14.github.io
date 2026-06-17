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

## Agent skills (blog writing workflow)

Skills live in `.opencode/skills/<name>/SKILL.md`. Six skills form a blog-writing pipeline:

| Skill | Trigger keywords | Role |
|---|---|---|
| [blog-writing-assistant](.opencode/skills/blog-writing-assistant/SKILL.md) | "write an article", "plan a post", "outline" | Creates outlines, proposes structure |
| [deep-research-agent](.opencode/skills/deep-research-agent/SKILL.md) | "research", "find latest", "check docs" | Multi-source research (CRAN, GitHub, blogs) |
| [technical-verification-planner](.opencode/skills/technical-verification-planner/SKILL.md) | "verify", "check how this works", "validate" | R code verification plans |
| [draft-preparation-assistant](.opencode/skills/draft-preparation-assistant/SKILL.md) | "create a draft", "prepare file", "set up qmd" | Creates `.qmd` files with front matter |
| [article-review-assistant](.opencode/skills/article-review-assistant/SKILL.md) | "review", "check draft", "critique" | 5-dimension quality review (1–10 each) |
| [publication-preparation-assistant](.opencode/skills/publication-preparation-assistant/SKILL.md) | "publish", "finalize", "optimize tags" | Metadata check, render validation, CI readiness |

Use them individually or in sequence. Claude auto-selects based on your request.

## Key config files

- `_quarto.yml` — site structure, navbar, footer, format, Google Analytics, freeze behavior.
- `_brand.yml` — brand colors, fonts (Figtree from Google Fonts), logo.
- `posts/_metadata.yml` — post defaults (freeze, giscus comments repo).
- `opencode.json` — agent skill registration.
