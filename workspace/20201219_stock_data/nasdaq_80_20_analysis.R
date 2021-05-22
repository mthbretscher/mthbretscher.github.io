

library(kableExtra)
source("nasdaq_data_preparation.R")


#'# 80-20 analysis of stocks



plotData <- d.analysis_data_wide %>%
  mutate(
    
    cat_next = case_when(
      actual_next_return > quantile(actual_next_return, probs = 0.8,  na.rm = TRUE) ~ "top_20",
      actual_next_return <= quantile(actual_next_return, probs = 0.8, na.rm = TRUE) ~ "bottom_80",
      TRUE ~ NA_character_
    ),
    
    cat_lag_0 = case_when(
      return_lag_0 > quantile(return_lag_0, probs = 0.8,  na.rm = TRUE) ~ "top_20",
      return_lag_0 <= quantile(return_lag_0, probs = 0.8,  na.rm = TRUE) ~ "bottom_80",    
    )
    
  ) %>%
  filter(!is.na(cat_next) & !is.na(cat_lag_0))
  
#'Correspondence of being in the top 20 % or bottom 80% during lag_0 or next period

plotData %>% 
  count(cat_next, cat_lag_0) %>%
  kable() %>%
  kable_styling(full_width = F)


table(plotData$cat_next, plotData$cat_lag_0) %>% 
  kable %>%
  kable_styling(full_width = F)

table(plotData$cat_next, plotData$cat_lag_0) %>% 
  prop.table() %>%
  kable %>%
  kable_styling(full_width = F)



