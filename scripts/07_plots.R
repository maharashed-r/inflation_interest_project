source("scripts/00_packages.R")

# Archival closure (2026-10): on-screen copy only in interactive sessions.
if (interactive()) plot(
  cusum_test,
  main = "CUSUM Stability Test",
  xlab = "Time",
  ylab = "CUSUM",
  col = "blue",
  lwd = 2
)

source("scripts/00_packages.R")

png("figures/cusum_stability_test.png", width = 900, height = 600)

plot(
  cusum_test,
  main = "CUSUM Stability Test",
  xlab = "Time",
  ylab = "CUSUM",
  col = "blue",
  lwd = 2
)

dev.off()