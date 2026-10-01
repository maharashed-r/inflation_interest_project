# One-time installation of the packages used by this project.
# This script is NOT part of the analysis pipeline and is never sourced by it.
# Versions used by the original author are UNKNOWN (renv.lock records only R
# 4.5.2 and renv). The versions that reproduced the committed outputs during
# the 2026-10 archival closure are listed in docs/ENVIRONMENT.md.
pkgs <- c("dplyr", "lubridate", "here", "ARDL", "dynlm", "Formula", "lmtest",
          "sandwich", "strucchange", "tseries", "urca", "ggplot2",
          "modelsummary")
install.packages(setdiff(pkgs, rownames(installed.packages())))
