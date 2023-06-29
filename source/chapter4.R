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

#' dplyr functions covered: filter, arrange, distinct
#'
# dplyr filter ----
#' Introducing filter and logical tests
#' Finding rows where flights were delayed by more than two hours
flights |>
  filter(dep_delay > 120)

#' Introduces other equality operators and & and | boolean logical operators
#' Flights departing on 1st January, uses two operators and logical AND.
flights |>
  filter(month == 1 & day == 1)


#' Flights departing in Jan or Feb, using OR operator
flights |> 
  filter(month == 1 | month == 2)

#' Introducing %in%, as a combined | and == operators. I didn't really think of
#' %in% this way!
flights |>
  filter(month %in% c(1,2))

#' Description of dplyr not modifying the original data frame, rather returns a
#' new data frame. Quite important to remember this, makes for good workflow: 
#' check the results before you commit to the changes by e.g. overwriting the
#' input data frame.
#' 
#' I think its also important to not create lots of new data frames, by piping
#' together all of the required operations in one go. May need a few
#' intermediates to check along the way though.
#' 
#' Example of assigning output from piped operation to a new variable
jan1 <- flights |>
  filter(month == 1 & day == 1)


# 4.2.2 Common mistakes ----

#' equality operator (==) vs assignment (=). Suggests an informative error
#' message appears. I think this is only a recent addition, so may not apply
#' in older versions of R. Useful though!
flights |> 
  filter(month = 1)
# Error in `filter()`:
#   ! We detected a named input.
# ℹ This usually means that you've used `=` instead of `==`.
# ℹ Did you mean `month == 1`?
# Run `rlang::last_trace()` to see where the error occurred.

# tests with OR statements, I sometimes do this...
flights |> 
  filter(month == 1 | 2)


# 4.2.3 arrange() ----

#' Describing function of arrange to change order of rows based on values of
#' selected variables (columns). Stil no description of tidy data concept.
flights |> 
  arrange(year, month, day, dep_time)

#' introducing desc() to set which values come first, default is lowest first, 
#' desc() is highest first
flights |> 
  arrange(desc(dep_delay))


# 4.2.4 distinct ----

#' I find distinct hard to get my head around....
#' Thankfully, describes the default behaviour where distinct drops columns if
#' any columns are used as arguments in the distinct function. Just realised
#' that the use of tidyselect has not been mentioned yet, but has been used
#' several times. Back to distinct, you can choose to keep the other columns as well.
#' Some other behaviour here that may not be obvious, but is described here: 
#' all but the first occurence are dropped, regardless of the other columns

flights |> 
  distinct(origin, dest, .keep_all = TRUE)


#' Intoducing count() here
flights |>
  count(origin, dest, sort = TRUE)

#' which is possibly more useful than distinct

# 4.2.5 Exercises ----
#' Answers to some of these:
#' 1.
flights |>
  filter(arr_delay >= 120) |>
  select(arr_delay) |>
  arrange(arr_delay)

#'
flights |>
  filter(dest %in% c("IAH", "HOU"))

#' 2.
flights |>
  arrange(desc(dep_delay))

flights |>
  arrange(dep_time)

#' throws up some questions about the data: does 'day' reflect departure day (
#' I think so), or scheduled day?

#' 3. Not sure about the hint here...
flights |>
  arrange(air_time) |>
  select(air_time)


#' 6. Yes I think it does matter. If you arrange first, then filter, arrange is sorting
#' more rows (it returns a data frame) before filtering. The order may then be
#' affected after you filter. So probably makes sense to filter first. I always
#' use arrange as the last step in almost all work that I need to sort the 
#' outputs


# 4.3 Columns ----

#' Introduces more dplyr functions (I can't think of them as verbs...):
#' mutate, select, rename and relocate. Most of the names seems obvious.

# mutate ----
flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60
  ) |>
  select(
    gain, speed
  )

#' Just for a laugh, lets try the same in base R
flights2 <- flights

flights2$gain <- flights2$dep_delay - flights2$arr_delay
flights2$speed <- flights2$distance / flights2$air_time * 60
flights2[, c("gain", "speed")]

# remove this data frame
rm(flights2)


