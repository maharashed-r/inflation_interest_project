library(dplyr)
library(lubridate)
library(here)
source("scripts/00_packages.R")
# قراءة البيانات الخام
raw_data <- read.csv(here("data","data.csv"))

# تحويل التاريخ
raw_data$date <- as.Date(raw_data$date)

# حساب التضخم الشهري
raw_data$inflation_monthly <- c(NA, 100 * diff(log(raw_data$CPIAUCSL)))

# تعديل الصفوف بعد diff
raw_data <- raw_data[-1,]

# إنشاء متغير الربع
raw_data$quarter <- paste(year(raw_data$date), "Q", quarter(raw_data$date), sep="")

# تحويل البيانات الشهرية إلى ربع سنوية
quarter_data <- raw_data %>%
  group_by(quarter) %>%
  summarise(
    Inflation = mean(inflation_monthly, na.rm = TRUE),
    Interest_Rate = mean(FEDFUNDS, na.rm = TRUE),
    GDP = mean(GDP, na.rm = TRUE)
  )

# حذف القيم المفقودة
quarter_data <- na.omit(quarter_data)

# حفظ dataset النهائي
dir.create(here("results"), showWarnings = FALSE)

write.csv(quarter_data,
          here("results","final_dataset.csv"),
          row.names = FALSE)

View(quarter_data)