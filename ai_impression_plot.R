library(ggplot2)

impression <- data.frame(
  week = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
  rating = c(5, 8, 9, 9.5, 9.8, 9.5, 7, 4, 3, 2.5, 2)
)

ggplot(impression, aes(x = week, y = rating)) +
  geom_line(color = "#FF6B35", linewidth = 1.5) +
  geom_point(color = "#FF6B35", size = 2.5) +
  annotate("text", x = 1.5, y = 9.2,
           label = '"The Solution? It\'s simpler than you think..."',
           size = 3.2, hjust = 0, color = "#FF6B35", fontface = "italic") +
  annotate("text", x = 7, y = 3.5,
           label = '"Empty plots, unreadable tables,\nnon-sensical narratives"',
           size = 3.2, hjust = 0, color = "#888", fontface = "italic") +
  annotate("segment", x = 4, xend = 6, y = 9.5, yend = 7.5,
           arrow = arrow(length = unit(0.2, "cm")), color = "#88888870", linewidth = 0.5) +
  annotate("text", x = 2, y = 9.8, label = "honeymoon phase",
           size = 3, color = "#88888870", fontface = "italic") +
  scale_x_continuous(breaks = seq(0, 10, 2)) +
  coord_cartesian(ylim = c(1, 10)) +
  labs(
    title = "Impression of AI-Assisted Data Science",
    subtitle = "Enthusiasm over time",
    x = "Weeks since adopting AI coding assistants",
    y = "Rating (1–10)"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(color = "grey40", size = 10),
    panel.grid.minor = element_blank()
  )