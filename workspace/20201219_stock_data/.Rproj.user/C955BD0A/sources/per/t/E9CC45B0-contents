source("data_preparation.R")



library(ggplot2)
library(kableExtra)

#'# Stock Symbols in report

d.stocks %>%
  count(ticker) %>%
  kable() %>%
  kable_styling()

#'# Closing prices in the past year
#'
#' The following plots show the development of closing prices over the last year. 

ggplot(d.stocks, aes(x = ref.date, y = price.close)) +
  geom_line() +
  facet_wrap(vars(ticker)) +
  theme_light()
  
