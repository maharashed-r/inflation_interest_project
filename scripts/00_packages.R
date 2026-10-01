packages <- c(
  "dplyr",
  "lubridate",
  "here",
  "ARDL",
  "dynlm",
  "Formula",
  "lmtest",
  "sandwich",
  "strucchange",
  "tseries",
  "urca",
  "ggplot2"
)

# Archival closure (2026-10): packages are no longer installed from inside the
# analysis. Install them once with scripts/install_packages.R. The packages are
# attached in the same order as before, so masking behaviour is unchanged.
missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing) > 0) {
  stop("Missing R packages: ", paste(missing, collapse = ", "),
       "\nInstall them first with: source(\"scripts/install_packages.R\")")
}
for (p in packages) {
  library(p, character.only = TRUE)
}
