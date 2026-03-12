cat("Step 4: Error Correction Model\n")


source("scripts/00_packages.R")
df <- read.csv(here("results","final_dataset.csv"))

model_ardl <- auto_ardl(
  Inflation ~ Interest_Rate + GDP,
  data = df,
  max_order = c(4,4,4)
)

best_model <- model_ardl$best_model

# UECM
ecm_model <- uecm(best_model)
summary(ecm_model)

# RECM (لإظهار ECT بوضوح)
recm_model <- recm(best_model, case = 3)

cat("\nRestricted ECM (ECT shown explicitly):\n")
summary(recm_model)
