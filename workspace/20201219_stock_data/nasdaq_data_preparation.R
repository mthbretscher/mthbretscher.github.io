library(dplyr)
library(tidyquant)
library(magrittr)
library(lubridate)
library(ggplot2)
library(readr)
library(quantmod)
library(stringr)
library(tidyr)


source("get_raw_data.R")

#All dates should be last day of month
#data has last day of trading of a month, which may be earlier

data_start <- d.all_prices %>% 
  summarise(x = min(date)) %>% 
  pull(x) 

data_end <- d.all_prices %>% 
  summarise(x = max(date)) %>% 
  pull(x) 




#Length of important date intervals
pred_interval <- months(1)
history_interval <- months(4) #duration(1, units = "years")




#Derive dates from intervals
prediction_date <- data_end %m-% 
  months(0)  %>%                #change this manually to go back in time
  round_date(unit = "month") %>%
  rollback()

history_end_date <- prediction_date %m-% pred_interval %>% 
  round_date(unit = "month") %>%
  rollback()

history_start_date <- history_end_date %m-% history_interval %>% 
  round_date(unit = "month") %>%
  rollback()





# #only keep symbols with complete history data
# prices <- all_prices %>%
#   group_by(symbol) %>%
#   summarise(max_date = max(date, na.rm = TRUE), min_date = min(date, na.rm = TRUE)) %>%
#   filter(round_date(max_date, unit = "month") >= round_date(prediction_date, unit = "month") & 
#            round_date(min_date, unit = "month") <= round_date(history_start_date, unit = "months")) %>%
#   select(symbol) %>%
#   left_join(
#     all_prices,
#     by = "symbol"
#   ) %>%
#   
#   #Only keep dates within required range
#   filter(date <= prediction_date & 
#            date > history_start_date
#          )


#Work with a subset of stocks, for increased speed.
# prices <- prices %>% 
#   filter(symbol %in% sample(d.all_stocks %>%
#                               pull(symbol),
#                             3
#                             )
#           )


prices <- d.all_prices 

#calculate returns from prices
period_returns <- prices %>%
  group_by(symbol) %>%
  tq_transmute(
    adjusted,
    mutate_fun = periodReturn, 
    period = "monthly",
    #leading= FALSE,
    col_rename = "monthly_return", 
  ) %>%
  ungroup() 
  


#Create dataset with all period variables 
d.period_variables <- bind_cols(
  tibble(
    actual_next_return = NA_real_,
    predicted_next_return = NA_real_,
    predicted_next_return_se = NA_real_,
   # predicted_prediction_error = NA_real_,
    pred_truth_diff = NA_real_
  ),
  period_returns
)
  



#Label periods
d.analysis_data_long <- d.period_variables %>%
  mutate(
      analysis_period = case_when(
      date > prediction_date ~ "future",
      date <= prediction_date & date > history_end_date ~ "prediction",
      date <= history_end_date & date >= history_start_date ~ "history",
      date < history_start_date ~ "past",
      TRUE ~ NA_character_
    ),
  ) %>%
  filter(analysis_period != "future") 



#DEBUG these stocks caused errors before 
#d.analysis_data %>% filter(symbol == "IIVIP")
# d.analysis_data %>% filter(symbol == "IBRX")

  #make sure it's only ever one prediction period
stopifnot(
d.analysis_data_long %>%  
  filter(analysis_period == "prediction") %>%
  group_by(symbol) %>% 
  summarize(n = n()) %>%
  ungroup() %>%
  {
    sum(.$n, na.rm = T) == nrow(.) 
  } 
)
  


# Transfer key info from prediction interval to columns
# and remove prediction rows
# Pivot to wide format

d.analysis_data_wide <- d.analysis_data_long %>%
  ungroup() %>%
  mutate(
    actual_next_return = if_else(
      analysis_period == "prediction",
      monthly_return,
      NA_real_
    )
  ) %>%
  group_by(symbol) %>%
  mutate(
    actual_next_return = suppressWarnings(min(monthly_return, na.rm = T))
  ) %>% 
  filter(analysis_period != "prediction") %>%
  
  mutate(
    lag_months = round(
      as.numeric(max(date) - date, unit = "days")/
        (months(1) %>% as.numeric("days"))
      )
    ) %>%
  select(-date, -analysis_period) %>%
  distinct() %>% 
  pivot_wider(
    names_from = lag_months,
    values_from = monthly_return,
    names_sort = TRUE,
    names_prefix = "return_lag_",
    #values_fn = as.numeric
    values_fn = f <- function(x){
      ifelse(
        length(x) != 1  | class(x) != "numeric",
        NA_real_, 
        x
      )
    }
  ) %>%
  left_join(
    d.all_stocks,
    by = "symbol"
  ) %>%
  ungroup()

# 
#   #plot
# d.analysis_data_wide  %>%
#     #filter(return_lag_0 > 0. & return_lag_1 > 0. & return_lag_2 > 0.) %>% 
#     mutate(
#       recent_return = mean(return_lag_0, return_lag_1, return_lag_2)
#     ) %>% 
#     ggplot(aes(x = recent_return, y = actual_next_return, color = industry)) +
#     geom_point() +
#     #coord_cartesian(xlim = c(-1, 1), ylim = c(-1, 1)) +
#     theme_tq() +
#     theme(legend.position = "none")
# 
# d.analysis_data_wide  %>%
#     #filter(return_train > 0.1) %>% 
#     #filter(return_test > 0.1) %>%
#     knitr::kable() %>%
#     kableExtra::kable_styling()
