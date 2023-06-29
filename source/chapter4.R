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

#' back to the book
#' controling behaviour of column order after mutate. The arguments start with
#' a '.' to indicate they are not variable names (what would happen without
#' the period?). Demonstrate using numeric order as well as column names to
#' select location of new variables
flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .before = 1
  )

flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .after = day
  )

#' Also showing .keep argument
flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours,
    .keep = "used"
  )

# 4.3.2 select() ----

#' First mention of the term 'subset', which I think is what base R select
#' functions (these >> [] ) are called.
#' 
#' Will skip most of these, but the select and rename option is interesting
flights |> 
  select(tail_num = tailnum)

#' There is a lot to take in here, but still no mention of tidyselect and why 
#' columns do not need to have quotes around them.

# 4.3.3 rename() ----

#' This seems self-explanatory, and differs from the above rename example in
#' that the other columns are kept. Very useful function, particularly with
#' very raw datasets, like the ones I deal with in NHS Lothian.

# 4.3.4 relocate() ----

#' Don't think the name is as self-explanatory as the others, but can't think of
#' a better name! It moves columns around (would move() be a better name?)
flights |> 
  relocate(time_hour, air_time)

# 4.3.5 Exercises ----

#' again, just a subset of these
#' 3.
flights |>
  select(time_hour, time_hour)
# A tibble: 336,776 × 1
# time_hour          
# <dttm>             
#   1 2013-01-01 05:00:00
# 2 2013-01-01 05:00:00
# 3 2013-01-01 05:00:00
# 4 2013-01-01 05:00:00
# 5 2013-01-01 06:00:00
# 6 2013-01-01 05:00:00
# 7 2013-01-01 06:00:00
# 8 2013-01-01 06:00:00
# 9 2013-01-01 06:00:00
# 10 2013-01-01 06:00:00
# # ℹ 336,766 more rows
# # ℹ Use `print(n = ...)` to see more rows

#' 4. any_of() is very useful, especially when writing your own functions

#' 5. case insensitive
flights |> select(contains("TIME"))

#' the question asks you to change default behaviour. I would automatically use
#' ?select to find the help page, but I don't recall seeing help files being
#' mentioned anywhere yet, maybe chapter 2?

#' 7. You have piped through a data frame with only the tailnum column...
#' 

# 4.4. The pipe ----
flights |> 
  filter(dest == "IAH") |> 
  mutate(speed = distance / air_time * 60) |> 
  select(year:day, dep_time, carrier, flight, speed) |> 
  arrange(desc(speed))

#' showing how useful the pipe is, and demonstrates non-pipe ways of doing this
#' which I agree are a bit tedious, although sometimes necessary.
#' Also introduces the magrittr %>% pipe
#' 

# 4.5 groups ----

#' most useful part of dplyr, I think, along with summarize. Worth looking at 
#' the janitor 'tabyl' function as well.

# 4.5.1 group_by() ----

#' partitions data according to values in one or more variables, when combined
#' with 

# 4.5.2 summarise() (zeds dead...)
flights |> 
  group_by(month) |> 
  summarise(
    delay = mean(dep_delay, na.rm = TRUE)
  )

# using n() to count rows
flights |> 
  group_by(month) |> 
  summarise(
    delay = mean(dep_delay, na.rm = TRUE),
    n = n()
  )


# 4.5.3 slice ----

#' again useful functions, especially with grouped data. Fairly self-explanatory
#' used in place of filter i think. Remember ties, and number of rows to keep.
#' 

# 4.5.4 grouping by multiple variables ----

#' as described. Has a basic description of the summarise behaviour with groups
#' and some options to get what you need. I don't really have any issues with 
#' this, it usually does what I want it to.

# 4.5.5 Ungrouping ----

#' Again fairly self-explanatory, but also very important to be aware of, as can
#' cause some unexpected behaviour if you forget you have grouped data
#' 

# 4.5.6. .by ----

#' I haven't used this, but it effectively combins group_by and ungroup inside 
#' the summarise function.
#' 

# 4.7 Exercises ----

#' Skipping these for now.

# 4.6 Case study ----

#' Baseball, my favourite sport... joking aside, I really don't understand this
#' dataset, so find these examples hard to follow.

batters <- Lahman::Batting |> 
  group_by(playerID) |> 
  summarize(
    performance = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    n = sum(AB, na.rm = TRUE)
  )


#' Plotting this summary. Makes an interesting point about change in variance as
#' sample size increases - anyone have any thoughts about this in relation to
#' using p-values in hypothesis testing?

batters |> 
  filter(n > 100) |> 
  ggplot(aes(x = n, y = performance)) +
  geom_point(alpha = 1 / 10) + 
  geom_smooth(se = FALSE)

#' using arrange to show why rates are not always the best measure to rank things
#' by e.g. risk
#' 

#' My final thoughts.
#' Overall a good work introductory run through of dplyr/tidy data concept of
#' data manipulation.
#' However, it is firmly based in tidyverse (understandably given the identity
#' of the main author), when there are base R, data table alternatives. There
#' may be others. Having worked with molecular biology data, dplyr is not used
#' very often, at least not very often the last time I worked in that field
#' about 4 years ago.
#' 
#' No mention of other data structures in R yet (lists), although this may come
#' later in the book.
#' 
#' The only major criticism is no clear guidance on using help files for
#' packages and functions. Otherwise, very much improved since first edition.
