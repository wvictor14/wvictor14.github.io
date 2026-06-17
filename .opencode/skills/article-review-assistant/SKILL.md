---
name: article-review-assistant
description: Review a drafted blog post for quality, accuracy, and risk. Use when the user says "review this", "check my draft", "critique this article", or "is this ready to publish". Scores on 5 dimensions (10 points each) and provides specific, actionable feedback. Adapted for R/Quarto data-science content.
---

# Article Review Assistant

## Overview
Reviews a completed blog post draft against 5 quality dimensions. Each dimension scored 1–10. Provides specific positive points, areas for improvement, and before/after correction examples.

## Review Dimensions

### 1. Originality (1–10)
Does the article offer unique value beyond repackaging documentation?
- Avoid: pure API walkthroughs that mirror the docs
- Reward: personal experience, hard-won insights, unexpected use cases

### 2. Structural Readability (1–10)
Is the article logical and easy to follow?
- Clear section hierarchy (H1 → H2 → H3)
- Code chunks are placed after the prose that explains them
- Figures/images have descriptive captions
- TOC-friendly (descriptive section headers)

### 3. Factual Accuracy (1–10)
Does the R code and technical content work?
- R code should be syntactically valid
- Package functions should exist and have correct signatures
- Check for deprecated functions or packages
- Output figures/results should match the code shown

### 4. Flaming Risk (1–10; higher = safer)
Could this post attract negative reactions?
- Avoid: disparaging other packages/tools without nuance
- Avoid: overly promotional tone for specific products
- Avoid: presenting opinion as universal fact
- **Score 10** = balanced, measured, caveats included
- **Score 1** = inflammatory, dismissive of alternatives

### 5. Sharing Value (1–10)
Is it worth sharing on social/community channels?
- Does it solve a real problem others face?
- Does it include reusable code patterns?
- Is the key insight clearly stated upfront?

## Output Format
```
## Review Summary

| Dimension | Score | Key Issue |
|-----------|-------|-----------|
| Originality | X/10 | ... |
| Structural Readability | X/10 | ... |
| Factual Accuracy | X/10 | ... |
| Flaming Risk | X/10 | ... |
| Sharing Value | X/10 | ... |
**Total: X/50**

### What works well
- <specific positive points>

### Priority improvements
1. **[High/Med/Low]** <issue> → <specific suggestion>
2. ...

### Before/After examples
<show concrete rewrites for the most impactful changes>
```

## Guidelines
- Be specific: "Line 42: the `dplyr::filter()` call will fail if `species` is NA" not "check your filter"
- Always show the corrected code or prose
- Prioritize factual accuracy and flaming risk over style