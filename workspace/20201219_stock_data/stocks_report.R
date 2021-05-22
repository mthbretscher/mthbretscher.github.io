source("get_raw_data.R")


library(dplyr)
library(ggplot2)
library(kableExtra)

#'# Stock Symbols in report

d.all_prices %>%
  count(symbol) %>%
  kable() %>%
  kable_styling()

#'# Closing prices in the past year
#'
#' The following plots show the development of closing prices over the last year. 

ggplot(d.all_prices %>% filter(stringr::str_detect(symbol, "AA")), 
       aes(x = date, y = close)
       ) +
  geom_line() +
  facet_wrap(vars(symbol)) +
  theme_light()
  
