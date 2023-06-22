package_list <- c(
  "skimr",
  "plyr",
  "tidyverse",
  "lubridate",
  "data.table",
  "knitr",
  "stringi",
  "readxl",
  "writexl",
  "openxlsx",
  "purrr",
  "readODS",
  "anytime",
  "vroom",
  "magrittr",
  "plotly",
  "DT",
  "scales"
)

# Install loop
for(i in seq_along(package_list)) {
  if(!require(package_list[i], character.only = TRUE)) {
    install.packages(package_list[i])
    library(package_list[i], character.only = TRUE)
  } else {
    library(package_list[i], character.only = TRUE)
    }
  }

rm(i)
rm(package_list)

