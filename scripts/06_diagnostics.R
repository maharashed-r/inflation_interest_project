

source("scripts/00_packages.R")
# ----------------------------
# اختبار الارتباط الذاتي
# ----------------------------

dw <- dwtest(best_model)
print(dw)

# ----------------------------
# اختبار عدم تجانس التباين
# ----------------------------

bp <- bptest(best_model)
print(bp)

# ----------------------------
# Robust Standard Errors
# ----------------------------

robust <- coeftest(best_model, vcov = vcovHC(best_model))
print(robust)

# ----------------------------
# اختبار الاستقرار CUSUM
# ----------------------------
cusum_test <- efp(
  residuals(best_model) ~ 1,
  type = "Rec-CUSUM"
)

