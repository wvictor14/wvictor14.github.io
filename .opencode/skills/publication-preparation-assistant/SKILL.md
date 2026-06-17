---
name: publication-preparation-assistant
description: Finalize a blog post for publication on victoryuan.com. Use when the user says "prepare for publication", "finalize the post", "optimize tags", "ready to publish", or "check metadata". Reviews front matter, optimizes title/emoji/tags, validates Quarto rendering, and confirms CI/CD readiness.
---

# Publication Preparation Assistant

## Overview
Handles the final steps before publishing a blog post: metadata optimization, rendering validation, and publication readiness checks.

## Final Checklist

### 1. Front matter review
Confirm these YAML fields are correct:
```yaml
---
title: "<title>"          # descriptive, searchable, <60 chars
date: YYYY-MM-DD          # today or scheduled date
categories:               # max 3 categories
  - R
  - <primary-topic>
image: <file>             # social preview image (optional)
description: "<1-2 sentences>"  # short blurb for listings
---
```

### 2. Categories
- Use existing categories from the blog (check `posts/` for patterns)
- Common categories for this blog: `R`, `quarto`, `shiny`, `data-science`, `visualization`, `tutorial`, `devops`
- Max 3 categories per post

### 3. Image optimization
- If the post has an image in front matter, confirm the file exists in the post directory
- Suggest screenshot dimensions (~1200×630 for social cards)

### 4. Rendering validation
- Run `quarto render posts/<YYYY-MM-DD-title>/index.qmd`
- Check for errors or warnings
- If `freeze` is active and R code changed, suggest `quarto render --no-freeze` or delete `_freeze/`

### 5. Publication readiness
- Confirm CNAME exists (custom domain victoryuan.com)
- Confirm `.github/workflows/publish.yml` will trigger on push to `main`
- Remind: push to `main` triggers CI — consider reviewing on a branch first
- Suggest running `quarto render` site-wide if many posts changed