---
widget: portfolio
headless: true  # This file represents a page section.
weight: 3

# ... Put Your Section Options Here (title etc.) ...

title: "Code"
subtitle: R packages, Shiny apps

content:
  # Page type to display. E.g. project.
  page_type: project

  # Default filter index (e.g. 0 corresponds to the first `filter_button` instance below)
  filter_default: 0

  # Filter toolbar (optional).
  # Add or remove as many filters (`filter_button` instances) as you like.
  # To show all items, set `tag` to "*".
  # To filter by a specific tag, set `tag` to an existing tag name.
  # To remove toolbar, delete/comment all instances of `filter_button` below.
  #filter_button:
  #  - name: All
  #    tag: '*'
  #  - name: Deep Learning
  #    tag: Deep Learning
  #  - name: Other
  #    tag: Demo
design:
  # Choose how many columns the section has. Valid values: 1 or 2.
  columns: '2'
  # Toggle between the various page layout types.
  #   1 = List
  #   2 = Compact  
  #   3 = Card
  #   5 = Showcase
  view: 3
  # For Showcase view, flip alternate rows?
  flip_alt_rows: false

---

- [planet](/planet): an R package for analysis of placental methylation data
- [Placental Methylome Browser](https://robinsonlab.shinyapps.io/Placental_Methylome_Browser/): A Robinson lab Shiny app that me and Yifan Yin created