
library(dplyr)
library(tidyquant)
library(readr)

#get stock symbols & info
#all_stocks <- tq_exchange("NASDAQ")
#write_rds(all_stocks, "all_stocks.rds")
d.all_stocks <- read_rds("all_stocks.rds")

#TODO incrememntally update data (only download what's missing)
#TODO fetch symbols individually, check if there's missing (if yes, refetch)
#get prices

# fetch_start_date <- as_date("20210201")#as_date("20190429")
# fetch_end_date <- as_date("20210429")
# 
# nasdaq_prices <- tq_get(d.all_stocks  %>% pull(symbol),
#                         get  = "stock.prices",
#                         from = fetch_start_date,
#                         to   = fetch_end_date)

# nasdaq_prices %<>% group_by(symbol, date) %>% slice(1) %>% ungroup()
# 
# write_rds(nasdaq_prices, "nasdaq_prices.rds")


d.all_prices <- read_rds("all_prices.rds") 

#FIXME: Ad-hoc: remove those with any missing values (it's a connection problem)
na_symbols <- d.all_prices %>% 
  filter(is.na(open)) %>%
  distinct(symbol) %>% pull()
d.all_prices %<>%
  filter(!(symbol %in% na_symbols))



