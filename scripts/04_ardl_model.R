cat("Step 3: ARDL model estimation\n")

library(ARDL)
library(here)
source("scripts/00_packages.R")
# قراءة البيانات
df <- read.csv(here("results","final_dataset.csv"))

# تقدير نموذج ARDL واختيار الإبطاءات تلقائيًا
model_ardl <- auto_ardl(
  Inflation ~ Interest_Rate + GDP,
  data = df,
  max_order = c(4,4,4)
)

# عرض النموذج الأفضل
best_model <- model_ardl$best_model

cat("\nBest ARDL Model:\n")
print(best_model)
# Bounds Test
cat("\nBounds Test:\n")
bounds <- bounds_f_test(best_model, case = 3)
print(bounds)