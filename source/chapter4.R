#' Chapter 4 of R for Data Science 2e
#' https://r4ds.hadley.nz/
#' 
#' @author Jules Augley

# 1. Setup ----
library(here)
here::i_am("source/chapter4.R")
# not required for this chapter!
# source(here::here("source", "dependencies.R"))

# 4.1 Introduction ----
#' This chapter basically departs from base R, and introduces tidyverse,
#' specifically dplyr, and how it can be used to tidy(tm), clean and summarise
#' data for downstream analysis.

# 4.1.2 Prerequisites ----
if(!require(nycflights13)) {
  install.packages("nycflights13")
  library(nycflights13)
} else {
  library(nycflights13)
}

library(tidyverse)

#' Also talking about function masking here, starting on parsing R errors,
#' warnings and messages. Useful to get to know these, if a bit obscure at first.
#' Useful to know about namespaces and using 'package::function' to call
#' functions without R method dispatch getting in the way...

# 4.1.2 nycflights13 ----

#' Starting on dplyr verbs right away
flights

#' returns a 'tibble', which is explained in this section as a 'special type
#' of data frame'. Its not really... but good to think of in this way.
#' If you are interested you can use
class(flights)
# [1] "tbl_df"     "tbl"        "data.frame"
class(as.data.frame(flights))
# [1] "data.frame"

#' to see whats going on

#' Some other useful data browsing functions introduced
glimpse(flights)

# mixture of named and un-named arguments here
print(flights, width = Inf)

View(flights)

# 4.1.3 dplyr basics ----

#' Good concise description of dplyr functions structure, arguments and return 
#' values, and introducing base R pipe (since version 4.1?)

# Example:
flights |>
  # dont see a description of equality operator here
  filter(dest == "IAH") |>
  group_by(year, month, day) |>
  # begone Z!
  summarise(
    arr_delay = mean(arr_delay, na.rm = TRUE)
  )

#' again, concise explanation of what verbs are doing, i.e. rows, columns,
#' groups or tables. Might be missing the implicit use of 'tidy' rectangular 
#' datasets here.

# 4.2 Rows ----

