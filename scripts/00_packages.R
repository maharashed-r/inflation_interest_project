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

for(p in packages){
  if(!require(p, character.only = TRUE)){
    install.packages(p)
    library(p, character.only = TRUE)
  }
}