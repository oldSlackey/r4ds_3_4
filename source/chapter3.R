#' Chapter 3 of R for Data Science 2e
#' https://r4ds.hadley.nz/
#' 
#' @author Jules Augley

# 1. Setup ----
library(here)
here::i_am("source/chapter3.R")
# not required for this chapter!
# source(here::here("source", "dependencies.R"))

# 3.1 Coding basics ----

#' These are the very basics of using R interactively. Could have spent a little
#' more time on these, for very beginners?

1/200 * 30
# [1] 0.15
(59 + 73 + 2) / 3
# [1] 44.66667
sin(pi / 2)
# [1] 1

#' Assignment operator
#' Again, fundamentals of base R
x <- 3 * 4
# print value to console
x

#' assigning a vector to a named variable
primes <- c(2, 3, 5, 7, 11, 13)
primes

#' Vectorised operations
primes * 2
primes - 1 

# formula for creating objects in R
# object_name <- value

#' RStudio shortcut, works in source editor and console
#' Alt + -
# <- 

# 3.2 Comments ----
#' Recommendation to use comments to explain why you have written this code,
#' rather than what the code is doing. I tend to agree, but some complex
#' series of statements might need some explanation

# 3.3 What's in a name? ----
# Introducing some conventions, with preference for snake_case, rather than
# syntax rules (is that what they are called?)

# Introducing completion facility using TAB and Ctrl + <cursor_up_arrow>. I was only vaguely aware of these,
# linux has a similar function. Could be useful, but if using script files,
# then I think it has limited utility

# Some description of the 'rules' of syntax (you need to be precise/specific)

# Calling functions ----

#' Quite an important (and useful) section. In my view, getting to grips with
#' the structure of functions is a big step forward in writing your own code.
#' I feel this section could have been expanded a little, e.g. to describe the
#' structure of help files in R packages, which is predicated on the structure
#' of functions in R i.e. arguments, values and returning 'something'
#' 
#' Besides that, the other information is useful, particularly pairs of quotation
#' marks. I think it may have been good to show that R also has similar behaviour
#' with other punctuation e.g. {}, [], (),  but not '. There may be others...


