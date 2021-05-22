#install.packages("BatchGetSymbols", dependencies = T)

library(BatchGetSymbols)

first.date <- Sys.Date() - 365
last.date <- Sys.Date()
freq.data <- 'daily'


#tickers <- c('FB', 'MMM', 'PETR4.SA', 'abcdef')

tickers <- c('PLUG', 'BLDP', 'PLUN.F','PO0.F', 'D7G', '8NI', '27W')

l.out <- BatchGetSymbols(tickers = tickers, 
                         first.date = first.date, 
                         last.date = last.date, 
                         freq.data = freq.data)
#cache.folder = file.path(tempdir(), 'BGS_Cache') 

#View(l.out$df.tickers)

d.stocks <- l.out$df.tickers

# 
# 
# .df <- as_tibble(l.out$df.tickers)
# .window_size_days <- 10
# 
# 
# latest_end_date <- .df %>%
#   summarize(start_date = max(ref.date, na.rm = TRUE)) %>%
#   pull()
# 
# earliest_end_date <- .df %>%
#   summarize(start_date = min(ref.date, na.rm = TRUE)) %>%
#   pull() + 
#   .window_size_days - 1
# 
# 
# dates <- tibble(
#   end_date = earliest_end_date + 0:(latest_end_date - earliest_end_date),
#   start_date = end_date - .window_size_days + 1,
# )
#   
#   .dates <- dates[1,]
#   
#   
#   
# window_summaries <- function(.dates, .df, .window_size_days){
#  
#   stopifnot(nrow(.dates)==1)
#   
#   prices_in_window <- .df %>%
#     filter(ref.date >= .dates$start_date & ref.date <= .dates$end_date) %>%
#     pull(price.close)
#   
#   .dates %>%
#     transmute(
#       window_end_date = end_date,
#       window_start_date = start_date,
#       window_mid_date = start_date + (end_date - start_date)/2,
#       window_mean = mean(prices_in_window, na.rm = T),
#       window_sd = sd(prices_in_window, na.rm = T),
#       window_size_days = .window_size_days
#     )
#   
# }
#   
# window_summaries(.dates, .df, .window_size_days = 20)
#   
# purrr::map(dates[1,], window_summaries, .df = .df, .window_size_days = 15)
#   
#   
#   
#   
#   
#   mutate(id = row_number()) %>%
#   full_join(.df %>%
#               mutate(id = row_number()),
#             by = 'id') %>%
#   tidyr::expand(
#     start_date, ref.date
#   )
#   
#   
#   mutate(window_mean = mean(price.close[ref.date >= start_date && ref.date <= end_date],
#                             na.rm = T)
#          ) %>%
#   View()
# 
#   tidyr::expand(bind_cols(
#     .df %>% 
#       select(ref.date),
#     . %>% 
#       select(end_dates)
#   )
#             ) %>%
#   View()
# 
# 
# 
# 
# 
# 
# 
# start_dates <- .df %>%
#   summarize(start_date = min(ref.date)) %>%
#   pull() + 
#   1:(.window_days - 1)
# 
# 
# stop_date <- 
#   
#   select(ref.date) %>%
#   arrange(ref.date) %>% min()
