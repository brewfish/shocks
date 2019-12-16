## A function to detect shocks in a time series and append the results to the original data frame
##
## Danielle Ferraro 
## UC Santa Barbara
## 2019

detect_shocks <- function(df, cooks_d_threshold, n_baseline_yrs) {
  
  # Fit loess model
  fit <- loess(df$sum_quantity ~ df$year, span = 0.6)
  
  # Regress lag-1 residuals
  errors <- lm(resid(fit)[2:fit$n] ~ resid(fit)[1:fit$n-1])
  
  # Append columns to data frame:
  # 1. Add loess model outputs
  # 2. Add Cook's Distance data and dd an NA at the beginning so the vector is the same length as the df
  # 3. Identify and name rows where Cook's distance passes the chosen threshold as shocks
  # 4. For all shocks, calculate the median quantity of the prior n years (i.e. "baseline")
  # 5. For all shocks, calculate the absolute change in quantity relative to the baseline
  # 6. For all shocks, calculate the relative change in quantity relative to the baseline 
  # 7. For all shocks, calculate the shock recovery time 
  
  df <- df %>% 
    broom::augment_columns(x = fit) %>% 
    dplyr::mutate(
      cooks_d = c(NA_real_, cooks.distance(errors)),
      is_shock = cooks_d > cooks_d_threshold,
      median_baseline = dplyr::if_else(is_shock == TRUE, 
                                       zoo::rollapplyr(sum_quantity, width = list(-seq(1:n_baseline_yrs)), median, fill = NA), 
                                       NA_real_)) %>% 
    dplyr::mutate(
      abs_change = dplyr::if_else(is_shock == TRUE, median_baseline - sum_quantity, NA_real_),
      prop_change = dplyr::if_else(is_shock == TRUE, 1 - (sum_quantity/median_baseline), NA_real_))
  #recovery_time = dplyr::if_else(is_shock == TRUE, 
  #zoo::rollapply(width = list(seq(1:length(year))), functionhere, align = "left", fill = NA)[1], 
  #NA_real_))

}