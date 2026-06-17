---
name: draft-preparation-assistant
description: Prepare Quarto (.qmd) draft files for blog posts. Use when the user says "create a draft", "prepare the file", "set up the Qmd", or "generate the post file". Creates the directory structure, YAML front matter, and initial content shell for a new blog post on victoryuan.com.
---

# Draft Preparation Assistant

## Overview
Creates and structures Quarto (.qmd) draft files for new blog posts, following the site conventions.

## Conventions (victoryuan.com)
- Posts live in `posts/<YYYY-MM-DD-title>/index.qmd`
- YAML front matter includes: `title`, `date`, `categories`, optional `image`, optional `format` with `toc: true`
- R code chunks use `{r}` with appropriate chunk options
- Images go in the post directory alongside `index.qmd`

## When creating a new draft
1. Create the directory: `posts/<YYYY-MM-DD-<short-hyphenated-title>>/`
2. Create `index.qmd` with:
   ```yaml
   ---
   title: "<Article Title>"
   date: <YYYY-MM-DD>
   categories:
     - R
     - <topic>
   ---
   ```
3. Insert the outline from **blog-writing-assistant** as section headers
4. Add placeholder R code chunks where code is expected
5. Validate the file with `quarto render posts/<post-dir>/index.qmd`

## After creating the draft
- Suggest running `quarto render <path>` to validate the file
- Remind the user that images/shinylive assets need to be in the post directory