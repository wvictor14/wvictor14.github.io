# Reference: KDE theme format, and the Lavi port as a worked example

## KDE `text-styles` keys (skylighting / pandoc)

These are the only keys pandoc's HTML writer actually maps to rendered
`span` classes. Full list, with the pandoc span class each corresponds to:

| KDE key | pandoc class | KDE key | pandoc class |
|---|---|---|---|
| Normal | (untokenized text) | Import | `im` |
| Keyword | `kw` | Preprocessor | `pp` |
| ControlFlow | `cf` | Annotation | `an` |
| Function | `fu` | CommentVar | `cv` |
| BuiltIn | `bu` | Comment | `co` |
| Extension | `ex` | Documentation | `do` |
| Variable | `va` | RegionMarker | `re` |
| Attribute | `at` | Information | `in` |
| DataType | `dt` | Warning | `wa` |
| DecVal | `dv` | Alert | `al` |
| BaseN | `bn` | Error | `er` |
| Float | `fl` | Others | (fallback) |
| Constant | `cn` | | |
| Operator | `op` | | |
| SpecialChar | `sc` | | |
| Char | `ch` | | |
| String | `st` | | |
| VerbatimString | `vs` | | |
| SpecialString | `ss` | | |

Local built-in themes for comparison/inspiration live at
`/home/vyuan/.local/quarto/share/pandoc/highlight-styles/*.theme` (e.g.
`oblivion.theme`, `printing.theme` — both good examples of the full
expected JSON shape, including the optional `editor-colors` block, which
doesn't affect pandoc HTML output but is part of the spec).

## Worked example: Lavi scope → KDE key mapping

This is the actual mapping used for this site's `highlight-styles/lavi.theme`
— included as a concrete example of how to translate a VS Code/TextMate
theme's scopes into skylighting's `text-styles` keys. When porting a
different source theme, redo this table from that theme's own scopes;
don't reuse these Lavi-specific hex values.

Source: `lavi-color-theme.json` `tokenColors[].scope` and
`colors["editor.background"/"editor.foreground"]`, fetched from
`github.com/wvictor14/lavi-positron-theme`.

| KDE key(s) | Lavi TextMate scope |
|---|---|
| `background-color` | `editor.background` (`#25213B`) — NOT used as-is; see SKILL.md constraint on staying light |
| `Normal` | site brand black `#14181C` (not derived from Lavi — see SKILL.md) |
| `Keyword`, `ControlFlow` | `keyword` (`#FF9D00`) |
| `Function`, `BuiltIn`, `Extension` | `entity.name.function`, `support.function` (`#FAD000`) |
| `Variable` | `variable` (`#E1EFFF`) |
| `Attribute` | `entity.other.attribute-name` (`#80BDFF`) |
| `DataType` | `support.type`, `support.class` (`#80FFBB`) |
| `DecVal`, `BaseN`, `Float` | `constant.numeric*` (`#FFEE80`) |
| `Constant` | `constant.language` (true/false/null) (`#FF628C`) |
| `Operator`, `SpecialChar` | `punctuation` (`#A599E9`) |
| `Char`, `String`, `VerbatimString`, `SpecialString` | `string` (`#A5FF90`) |
| `Import` | no explicit scope; matches yaml/tag blue (`#94C8FF`) |
| `Preprocessor` | `storage`, `storage.modifier` (`#FB94FF`) |
| `Annotation`, `CommentVar` | caret/accent purple, no explicit scope (`#BDA5EE`) |
| `Comment` | `comment` (`#7E7490`) |
| `Documentation` | no doc-comment scope in Lavi; nearest mint accent (`#9CF2DE`) |
| `Others` | fallback teal (`#2CEDC0`) |
| `Warning`/`Information` | `editorWarning.foreground` (`#FFD080`) |
| `Error`/`Alert` | `editorError.foreground` (`#F2637E`) / `invalid` scope (`#EC3A37` bg) |

If re-deriving from scratch, re-fetch the source file rather than trusting
this table blindly — it may drift if the upstream theme changes:

```bash
curl -s https://raw.githubusercontent.com/wvictor14/lavi-positron-theme/main/themes/lavi-color-theme.json
```

## Contrast-preserving darken formula

WCAG relative luminance (sRGB, 0–1 range per channel):

```python
def rel_luminance(rgb):  # rgb = (r, g, b) each 0-1
    def lin(c):
        return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4
    r, g, b = (lin(c) for c in rgb)
    return 0.2126 * r + 0.7152 * g + 0.0722 * b

def contrast(rgb1, rgb2):
    l1, l2 = sorted((rel_luminance(rgb1), rel_luminance(rgb2)), reverse=True)
    return (l1 + 0.05) / (l2 + 0.05)
```

To darken a source color to hit a target contrast against a given
background, convert to HSL (`colorsys.rgb_to_hls`), then decrement
lightness in small steps (e.g. 0.01) — recomputing `contrast()` each step
— until it clears the target (the Lavi port used ~3.2:1 against
`#F5F3FB`), then convert back to RGB (`colorsys.hls_to_rgb`). Keep hue
(`h`) and saturation (`s`) fixed throughout; only `l` moves.
