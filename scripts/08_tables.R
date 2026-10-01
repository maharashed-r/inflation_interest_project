source("scripts/00_packages.R")

# Archival closure (2026-10) - reproducibility only, no change to any computation:
# - this script was written to run in the same R session after scripts/02_build_dataset.R,
#   because it uses the monthly object `raw_data` created there;
# - modelsummary is used by datasummary_skim() below before the original
#   library(modelsummary) call, so it is attached here first;
# - the three section titles (Table 1-3) were bare text and are now comments.
# NOTE: the tables written here come from a MONTHLY, BIVARIATE specification
# (inflation ~ interest), not from the quarterly model in scripts/04-06.
# See docs/SCIENTIFIC_LIMITATIONS.md.
library(here)
if (!exists("raw_data")) source(here("scripts", "02_build_dataset.R"))
library(modelsummary)

table_desc <- data.frame(
  Variable = c("Inflation", "Interest Rate"),
  Mean = c(mean(raw_data$inflation_monthly, na.rm = TRUE),
           mean(raw_data$FEDFUNDS, na.rm = TRUE)),
  SD = c(sd(raw_data$inflation_monthly, na.rm = TRUE),
         sd(raw_data$FEDFUNDS, na.rm = TRUE))
)

write.csv(
  table_desc,
  "tables/descriptive_statistics.csv",
  row.names = FALSE
)

# Table 1 – Descriptive Statistics
datasummary_skim(
  raw_data[,c("inflation_monthly","FEDFUNDS")],
  output = "tables/descriptive_statistics.html"
)

# Table 2 – Correlation Matrix
library(modelsummary)

datasummary_correlation(
  raw_data[,c("inflation_monthly","FEDFUNDS")],
  output = "tables/correlation_matrix.html"
)

# Table 3 – Unit Root Test (ADF)
library(urca)

# حذف القيم المفقودة
inflation_series <- na.omit(raw_data$inflation_monthly)
interest_series  <- na.omit(raw_data$FEDFUNDS)

# اختبار المستوى
adf_infl_level <- ur.df(inflation_series, type="trend", lags=4)
adf_int_level  <- ur.df(interest_series, type="trend", lags=4)

# الفرق الأول
inflation_diff <- diff(inflation_series)
interest_diff  <- diff(interest_series)

# اختبار الفرق الأول
adf_infl_diff <- ur.df(inflation_diff, type="drift", lags=4)
adf_int_diff  <- ur.df(interest_diff, type="drift", lags=4)

# استخراج الإحصاءات
infl_level <- adf_infl_level@teststat[1]
int_level  <- adf_int_level@teststat[1]

infl_diff <- adf_infl_diff@teststat[1]
int_diff  <- adf_int_diff@teststat[1]

# بناء الجدول
adf_table <- data.frame(
  Variable = c("Inflation","Interest Rate"),
  Level = c(infl_level, int_level),
  First_Difference = c(infl_diff, int_diff)
)

# تقريب الأرقام
adf_table[,2:3] <- round(adf_table[,2:3],3)

# حفظ الجدول
write.csv(
  adf_table,
  "tables/adf_results.csv",
  row.names = FALSE
)


# Table 4 – ARDL Bounds Test for Cointegration
library(ARDL)

# تجهيز البيانات
data_model <- na.omit(
  data.frame(
    inflation = raw_data$inflation_monthly,
    interest  = raw_data$FEDFUNDS
  )
)

# اختيار أفضل نموذج ARDL
model_auto <- auto_ardl(
  inflation ~ interest,
  data = data_model,
  max_order = c(4,4)
)

# استخراج أفضل نموذج
best_model <- model_auto$best_model

# اختبار Bounds
bounds <- bounds_f_test(best_model, case = 3)

# استخراج قيمة F
f_value <- bounds$statistic

# إنشاء جدول
bounds_table <- data.frame(
  Test = "ARDL Bounds Test",
  F_statistic = round(f_value,3)
)

# حفظ الجدول
write.csv(
  bounds_table,
  "tables/bounds_test.csv",
  row.names = FALSE
)


#Table 5 – Long-Run ARDL Coefficients
long_run <- coint_eq(best_model, case = 3)
summary(long_run)

coeff <- coef(best_model)

longrun_table <- data.frame(
  Variable = names(coeff),
  Coefficient = round(coeff,4)
)

longrun_table

write.csv(
  longrun_table,
  "tables/long_run_coefficients.csv",
  row.names = FALSE
)



# Table 6 – Error Correction Model (ECM)

# استخراج نموذج ECM
ecm_model <- recm(best_model, case = 3)

# استخراج المعاملات
ecm_coef <- coef(ecm_model)

# إنشاء الجدول
ecm_table <- data.frame(
  Variable = names(ecm_coef),
  Coefficient = round(ecm_coef,4)
)

# عرض الجدول
ecm_table

# حفظ الجدول
write.csv(
  ecm_table,
  "tables/ecm_results.csv",
  row.names = FALSE
)