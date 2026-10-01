# تنظيف البيئة
rm(list = ls())

library(here)

cat("Starting project...\n")

# تحميل المكتبات
cat("Step 0: Packages...\n")
source(here("scripts","00_packages.R"))

# تنظيف البيانات
cat("Step 1: Data cleaning...\n")
source(here("scripts","01_data_cleaning.R"))

# بناء البيانات
cat("Step 2: Build dataset...\n")
source(here("scripts","02_build_dataset.R"))

# اختبار الاستقرارية
cat("Step 3: Stationarity tests...\n")
source(here("scripts","03_stationarity_tests.R"))

# نموذج ARDL
cat("Step 4: ARDL model...\n")
source(here("scripts","04_ardl_model.R"))

# نموذج ECM
cat("Step 5: ECM model...\n")
source(here("scripts","05_ecm_model.R"))

# اختبارات التشخيص
cat("Step 6: Diagnostics...\n")
source(here("scripts","06_diagnostics.R"))

# الرسوم
cat("Step 7: Plots...\n")
source(here("scripts","07_plots.R"))

# الجداول (Archival closure 2026-10: added so the committed tables have an explicit run order)
# Step 8 re-creates tables/* from a MONTHLY BIVARIATE specification, different from the
# QUARTERLY model of steps 3-7. It must run after step 7 because it replaces `best_model`.
# It overwrites tables/*. To check the committed outputs without overwriting them, use
# tools/reproduce_and_verify.R instead.
cat("Step 8: Tables (monthly specification)...\n")
source(here("scripts","08_tables.R"))

cat("Project finished successfully.\n")