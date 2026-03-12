cat("Step 2: Stationarity tests\n")

library(tseries)
library(here)
source("scripts/00_packages.R")
df <- read.csv(here("results","final_dataset.csv"))

# ADF المستوى
adf_inflation_level <- adf.test(df$Inflation)
adf_interest_level  <- adf.test(df$Interest_Rate)
adf_gdp_level       <- adf.test(df$GDP)

# الفرق الأول
d_inflation <- na.omit(diff(df$Inflation))
d_interest  <- na.omit(diff(df$Interest_Rate))
d_gdp       <- na.omit(diff(df$GDP))

# ADF الفرق الأول
adf_inflation_diff <- adf.test(d_inflation)
adf_interest_diff  <- adf.test(d_interest)
adf_gdp_diff       <- adf.test(d_gdp)

cat("\nADF Level\n")
print(adf_inflation_level)
print(adf_interest_level)
print(adf_gdp_level)

cat("\nADF First Difference\n")
print(adf_inflation_diff)
print(adf_interest_diff)
print(adf_gdp_diff)