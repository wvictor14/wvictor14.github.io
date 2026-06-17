---
name: blog-writing-assistant
description: Support for writing technical blog posts in Quarto (.qmd) format. Use when the user says "I want to write an article", "I want to plan a blog post", "outline this topic", or "help me structure a post". Creates outlines, proposes structure, and coordinates research/verification steps. Focuses on R/data-science content with executable code chunks.
---

# Blog Writing Assistant

## Overview
This skill supports writing technical blog posts for victoryuan.com (Quarto/R site). Given a topic, it:
1. Clarifies the article's purpose, audience, and key takeaway
2. Proposes an article outline in Quarto .qmd format
3. Suggests related skills (deep-research-agent, technical-verification-planner) when appropriate

## Writing Style Guidelines
- **Experience-based**: Structure around struggles, insights, and failures from real R/data-science work
- **Process-focused**: Emphasize the path of trial and error, not just the final solution
- **Honest reflection**: Include retrospectives — "In retrospect..." or "What I'd do differently..."
- **Code-driven**: R code chunks should be executable (`{r}`) with `#| eval: false` for non-run blocks or live code for shinylive/gt examples
- **Concise**: This blog values brevity over exhaustive explanation

## Outline Structure (standard)
```yaml
---
title: "Descriptive title"
date: today
categories: [R, <topic>]
image: <optional-screenshot-or-diagram>
---
```

1. **Introduction** — motivation, the problem context, what the reader will learn
2. **The approach** — technical trial and error, code walkthrough
3. **Results / key insight** — what worked, with concrete R output or figures
4. **Discussion / reflection** — trade-offs, alternatives, retrospective

## Coordination with other skills
- If the topic requires external research (e.g., latest package docs, benchmarks), suggest **deep-research-agent**
- If the topic requires running R code to validate an approach, suggest **technical-verification-planner**
- Output the outline as a markdown code block so the user can review before drafting