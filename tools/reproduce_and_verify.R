# Reproduce the historical pipeline in a temporary copy and compare the result
# with the committed outputs. Nothing in the repository is written or overwritten.
#
# Usage (from the project root):
#   Rscript tools/reproduce_and_verify.R
#
# Requires the packages listed in scripts/install_packages.R.
# Exit status 0 = no scientific numeric difference; 1 = difference found.

root <- normalizePath(".")
stopifnot(file.exists(file.path(root, "run_project.R")))

# Work directory outside the repository. R deletes its own session tempdir() on
# exit, so the copy is placed next to it to keep it for inspection. Set the
# environment variable IIP_REPRO_DIR to choose another location.
work <- Sys.getenv("IIP_REPRO_DIR", file.path(
  dirname(tempdir()), paste0("iip_repro_", format(Sys.time(), "%Y%m%d_%H%M%S"))))
work <- file.path(work, "project")
if (dir.exists(work)) stop("Work directory already exists: ", work)
if (startsWith(paste0(normalizePath(dirname(work), mustWork = FALSE), "/"), paste0(root, "/"))) {
  stop("The work directory must be outside the repository.")
}
dir.create(work, recursive = TRUE)
items <- c("data", "scripts", "run_project.R", "results", "tables", "figures",
           "inflation_interest_project.Rproj")
for (it in items) file.copy(file.path(root, it), work, recursive = TRUE)

# Remove the copied outputs so that every compared file is freshly generated.
unlink(file.path(work, "results", "final_dataset.csv"))
unlink(list.files(file.path(work, "tables"), full.names = TRUE))
unlink(list.files(file.path(work, "figures"), full.names = TRUE))

cat("Running run_project.R in", work, "\n")
rscript <- file.path(R.home("bin"), "Rscript")
# Run inside the temporary copy only (never in the repository itself).
old <- setwd(work)
status <- system2(rscript, "run_project.R", stdout = "run.log", stderr = "run.log")
setwd(old)
if (status != 0) {
  cat(readLines(file.path(work, "run.log")), sep = "\n")
  stop("Pipeline failed in the temporary copy (see log above).")
}

ok <- TRUE
report <- function(name, status, detail = "") {
  cat(sprintf("%-40s %-22s %s\n", name, status, detail))
}

# 1. CSV outputs: byte equality, then numeric equality.
csvs <- c("results/final_dataset.csv", file.path("tables", c(
  "adf_results.csv", "bounds_test.csv", "descriptive_statistics.csv",
  "ecm_results.csv", "long_run_coefficients.csv")))
for (f in csvs) {
  a <- file.path(root, f); b <- file.path(work, f)
  if (!file.exists(b)) { report(f, "MISSING"); ok <- FALSE; next }
  la <- sub("\r$", "", readLines(a, warn = FALSE))
  lb <- sub("\r$", "", readLines(b, warn = FALSE))
  if (identical(la, lb)) { report(f, "IDENTICAL (text)"); next }
  da <- read.csv(a); db <- read.csv(b)
  num <- vapply(da, is.numeric, logical(1))
  same <- identical(dim(da), dim(db)) && identical(names(da), names(db)) &&
    identical(da[!num], db[!num]) &&
    all(abs(as.matrix(da[num]) - as.matrix(db[num])) <= 1e-12)
  if (same) report(f, "NUMERICALLY EQUAL", "(text differs only in formatting)")
  else { report(f, "DIFFERENT"); ok <- FALSE }
}

# 2. HTML tables: compare the visible cell text (element ids are random).
cell_text <- function(path) {
  h <- paste(readLines(path, warn = FALSE), collapse = "\n")
  h <- gsub("(?s)<script.*?</script>|<style.*?</style>", "", h, perl = TRUE)
  cells <- regmatches(h, gregexpr("(?s)<t[hd][^>]*>.*?</t[hd]>", h, perl = TRUE))[[1]]
  cells <- gsub("<[^>]+>", "", cells)
  cells <- gsub("&nbsp;", " ", cells, fixed = TRUE)
  trimws(gsub("\\s+", " ", cells))
}
for (f in file.path("tables", c("descriptive_statistics.html", "correlation_matrix.html"))) {
  a <- file.path(root, f); b <- file.path(work, f)
  if (!file.exists(b)) { report(f, "MISSING"); ok <- FALSE; next }
  ca <- cell_text(a); cb <- cell_text(b)
  ca <- ca[ca != ""]; cb <- cb[cb != ""]
  if (identical(ca, cb)) report(f, "CELL TEXT EQUAL", "(markup/ids may differ)")
  else { report(f, "CELL TEXT DIFFERENT"); ok <- FALSE }
}

# 3. Figure: byte comparison is informative only (graphics devices and fonts
# differ across machines); the plotted values are checked by the numeric tests.
f <- "figures/cusum_stability_test.png"
b <- file.path(work, f)
if (!file.exists(b)) { report(f, "MISSING"); ok <- FALSE } else {
  same <- identical(unname(tools::md5sum(file.path(root, f))), unname(tools::md5sum(b)))
  report(f, if (same) "IDENTICAL (bytes)" else "REGENERATED",
         if (same) "" else "(bytes differ; compare visually)")
}

cat("\nTemporary copy kept at:", work, "\n")
cat(if (ok) "RESULT: no scientific numeric difference\n" else "RESULT: DIFFERENCE FOUND\n")
quit(status = if (ok) 0 else 1)
