---
name: technical-verification-planner
description: Plan and document technical verification for R code in blog posts. Use when the user says "I want to verify", "I need to check how this works", "test this approach", or "validate this code". Creates a structured verification plan with hypotheses, steps, and expected outcomes. Designed for R/Quarto content with executable code chunks.
---

# Technical Verification Planner

## Overview
Helps plan and document technical verification for blog posts that involve R code, data analysis, or computational methods. Ensures claims in the article are backed by reproducible evidence.

## Verification Plan Template
When the user proposes a technical claim or approach, produce a plan:

```
## Verification Plan

### Claim to verify
<what are we checking?>

### Hypothesis
<what do we expect to happen?>

### Dependencies
<required R packages, data sources, external tools>

### Steps
1. <step 1 — specific R code or operation>
2. <step 2>
3. ...

### Expected results
<what output or figure should confirm the hypothesis?>

### Edge cases to check
<missing data, extreme values, alternative inputs>
```

## Guidelines
- Identify minimum viable R packages needed (`library()` calls)
- Check if the code can run inside a `.qmd` chunk (some Shiny code needs `standalone: true`)
- Flag any external data dependencies (CSV files, API keys, etc.)
- If the verification takes >30s to run, suggest using `#| eval: false` with cached output
- After the plan is accepted, generate the actual R code chunks ready for insertion into the .qmd