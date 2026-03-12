source("scripts/00_packages.R")

# قراءة البيانات
data <- read.csv("data/data.csv")

# تحويل التاريخ
data$date <- as.Date(data$date)

# حذف القيم المفقودة
data <- na.omit(data)

# التأكد من البيانات
head(data)
dim(data)

names(data) <- c("date","inflation","interest","gdp")
