---
name: quarto-syntax-highlighting
description: Create or edit custom Quarto/pandoc syntax-highlighting themes (KDE skylighting .theme JSON files) for code blocks, including porting an existing editor theme (VS Code, Positron, etc.) into one. Use when the user wants to adjust code block colors, create a custom highlight-style, port a personal editor theme to Quarto, or reports contrast/readability issues in rendered code on a Quarto site.
---

# Quarto custom syntax-highlighting themes

## What this is

Quarto's `format.html.highlight-style` accepts either a built-in name
(`printing`, `oblivion`, ...) or a path to a custom **KDE
syntax-highlighting theme** (skylighting's format — a JSON file, despite
the `.theme` extension, unrelated to VS Code/TextMate `.json` themes).

This site's worked example: `highlight-styles/lavi.theme`, wired in via
`_quarto.yml`: `format.html.highlight-style: highlight-styles/lavi.theme`.
It's a port of the user's own VS Code/Positron theme
([wvictor14/lavi-positron-theme](https://github.com/wvictor14/lavi-positron-theme)),
adapted to sit on this site's light page background. Use it as a reference
for the file shape and the porting method below — but this skill applies
to creating/editing *any* custom highlight-style theme, not just Lavi.

If porting a different source theme (another VS Code theme, an existing
`.tmTheme`, etc.), the same method applies: the source format's colors
must be manually mapped onto skylighting's `text-styles` keys — there is
no direct file conversion. See [REFERENCE.md](REFERENCE.md) for the full
key list, the pandoc span-class mapping, and the current Lavi mapping as
a worked example.

## Design constraints to check before changing colors

These aren't universal rules — they're this site's standing decisions,
settled through iteration on the Lavi theme. Confirm current values in
`_brand.yml` and the theme file before assuming they still apply, and
don't relitigate them without reason:

- **Background must stay light**, close to white — this site's page
  background is pure white (`_brand.yml` `paper: "#FFFFFF"`, so ggplot2
  output blends in) — a dark code-block card was tried and rejected.
  Current `background-color` is `#F5F3FB` (a barely-tinted near-white).
- **No bold token styles** — tried once, rejected as "thick and ugly."
- **Colors must be traceable to the source theme's real hex values**, not
  invented substitutes. When a color needs adjusting for contrast, darken
  it in HSL space — change lightness only, keep hue and saturation — see
  "Adjusting a color" below.

## Adjusting a color

1. Find the token's real color in the source theme (fetch from GitHub /
   the source repo if not already local).
2. Convert to HSL. Reduce **lightness only** until contrast against the
   target background reaches a reasonable minimum (this site currently
   targets ~3.2:1 against `#F5F3FB`; use the WCAG relative-luminance
   formula — REFERENCE.md has a ready `colorsys`-based recipe).
3. Never touch hue or saturation — that's what keeps a color "clearly a
   darkened version of the source theme's color" instead of a generic
   substitute.
4. Plain/untokenized text (`Normal`) is often the one exception: on this
   site it uses the brand black (`#14181C`) rather than the source
   theme's own foreground color, for full-strength body-text contrast and
   consistency with the rest of the page.

## Verification workflow (always do all three)

1. Validate JSON: `python3 -m json.tool <path-to-theme>.theme`
2. Render a post with real code in the target language, ideally one with
   variety: strings, comments, function calls, operators, and a heading
   that contains inline code (e.g. `## \`some_function()\``).
   `quarto render <path>/index.qmd --to html`
3. Start `quarto preview --port <port> --no-browser` in the background,
   then use `agent-browser` to screenshot and check **all three**
   contexts — regressions have hit each of these independently:
   - A fenced code block (`div.sourceCode`)
   - Inline code in body text (`` `code` `` inside a paragraph)
   - **The TOC sidebar**, specifically a heading that contains inline
     code — Quarto force-resets inline-code *background* to transparent
     inside `nav`, so if `Normal` text isn't dark enough on its own, TOC
     entries go pale-on-white and become unreadable. This exact bug has
     recurred on this site; always check it.

Do not add CSS overrides in `styles.css` to patch contrast issues —
everything should be fixable in the theme file itself, since
`background-color` and `Normal` are reused everywhere (fenced blocks,
inline chips, TOC) via Quarto's own generated CSS.

## Scope

Changes should stay confined to the theme file and, if the highlight
style name/path changes, `_quarto.yml`. Never touch existing blog posts'
content, embedded code-chunk output, or `_freeze/` results for unrelated
posts — re-rendering to preview a theme change is fine, but don't commit
unrelated re-renders.
