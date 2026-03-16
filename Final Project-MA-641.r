
# MA 641 – Time Series Analysis Project
# Author: Mayank Choudhary
# Description: Analysis of Deposits (Nonseasonal) and Retail Sales (Seasonal)

# 0. Load Required Packages
install.packages("lubridate")
library(lubridate)
install.packages("tidyverse")
install.packages("lubridate")
install.packages("forecast")
install.packages("tseries")
install.packages("urca")
install.packages("gridExtra")
install.packages("Rcpp")
install.packages("colorspace")
install.packages("timeDate")
install.packages("fracdiff")
install.packages("quadprog")
install.packages("zoo")
install.packages("Matrix")
library(tidyverse)
library(lubridate)
library(forecast)
library(tseries)
library(urca)
library(gridExtra)


# 1. Import Data

# Read deposits dataset
dep_raw <- read.csv("deposits_all_commercial_banks.csv",
                    stringsAsFactors = FALSE)
dep_raw$observation_date <- as.Date(dep_raw$observation_date)

# Read retail sales dataset
ret_raw <- read.csv("advance_retail_sales_retail_trade.csv",
                    stringsAsFactors = FALSE)
ret_raw$observation_date <- as.Date(ret_raw$observation_date)

# 2. Create Time Series Objects

dep_ts <- ts(dep_raw$H8B1058NCBCMG,
             start = c(year(dep_raw$observation_date[1]),
                       month(dep_raw$observation_date[1])),
             frequency = 12)

ret_ts <- ts(ret_raw$RSXFSN,
             start = c(year(ret_raw$observation_date[1]),
                       month(ret_raw$observation_date[1])),
             frequency = 12)

# Log transform retail sales (variance stabilizing)
ret_ts_log <- log(ret_ts)

# 3. Descriptive Plots & Summary

# Deposits plot
png("plot_deposits_raw.png", width=900, height=500)
autoplot(dep_ts) + ggtitle("Deposits – Raw Series") +
  xlab("Year") + ylab("Deposits (billions)")
dev.off()

summary(dep_ts)

# Retail raw plot
png("plot_retail_raw.png", width=900, height=500)
autoplot(ret_ts) + ggtitle("Retail Sales – Raw Series") +
  xlab("Year") + ylab("Retail Sales")
dev.off()

summary(ret_ts)

# STL decomposition (Retail)
png("plot_retail_stl.png", width=900, height=600)
autoplot(stl(ret_ts_log, s.window = "periodic"))
dev.off()

# 4. Stationarity Testing

# Deposits
adf_dep <- adf.test(dep_ts)
adf_dep

kpss_dep <- kpss.test(dep_ts, null = "Level")
kpss_dep

# Retail
adf_ret <- adf.test(ret_ts_log)
adf_ret

kpss_ret <- kpss.test(ret_ts_log, null = "Level")
kpss_ret

# First difference retail
ret_log_diff1 <- diff(ret_ts_log)

# Seasonal + first difference
ret_log_diff_full <- diff(diff(ret_ts_log), lag = 12)

# 5. ACF & PACF Plots  ----

# Deposits
png("plot_acf_pacf_deposits.png", width = 900, height = 600)
par(mfrow = c(1, 2))  # 1 row, 2 columns

acf(dep_ts, lag.max = 36, main = "Deposits – ACF")
pacf(dep_ts, lag.max = 36, main = "Deposits – PACF")

par(mfrow = c(1, 1))  # reset layout
dev.off()

# Retail (use differenced log series)
png("plot_acf_pacf_retail.png", width = 900, height = 600)
par(mfrow = c(1, 2))

acf(na.omit(ret_log_diff_full), lag.max = 48,
    main = "Retail – ACF (diff + seasonal diff)")
pacf(na.omit(ret_log_diff_full), lag.max = 48,
     main = "Retail – PACF (diff + seasonal diff)")

par(mfrow = c(1, 1))
dev.off()

# 6. Model Identification

# Deposits auto.arima
dep_auto <- auto.arima(dep_ts, seasonal = FALSE,
                       stepwise = FALSE, approximation = FALSE)
dep_auto

# Retail auto.arima
ret_auto <- auto.arima(ret_ts_log, seasonal = TRUE,
                       stepwise = FALSE, approximation = FALSE)
ret_auto

# 7. Manual ARIMA/SARIMA Candidate Models

# Deposits (Modify based on ACF/PACF)
dep_fit1 <- Arima(dep_ts, order = c(1,0,0))
dep_fit2 <- Arima(dep_ts, order = c(2,0,0))
dep_fit3 <- Arima(dep_ts, order = c(1,0,1))
dep_fit4 <- Arima(dep_ts, order = c(2,0,1))
dep_fit5 <- Arima(dep_ts, order = c(3,1,3)) # Example differenced model

# Compare AIC
dep_AIC_table <- data.frame(
  Model = c("ARIMA(1,0,0)", "ARIMA(2,0,0)", "ARIMA(1,0,1)",
            "ARIMA(2,0,1)", "ARIMA(3,1,3)"),
  AIC = c(AIC(dep_fit1), AIC(dep_fit2), AIC(dep_fit3),
          AIC(dep_fit4), AIC(dep_fit5))
)
write.csv(dep_AIC_table, "table_deposits_AIC.csv", row.names = FALSE)

# Retail Candidate Models

ret_fit1 <- Arima(
  ret_ts_log,
  order = c(1,1,1),
  seasonal = list(order = c(0,1,1), period = 12)
)

ret_fit2 <- Arima(
  ret_ts_log,
  order = c(2,1,1),
  seasonal = list(order = c(0,1,1), period = 12)
)

ret_fit3 <- Arima(
  ret_ts_log,
  order = c(2,1,2),
  seasonal = list(order = c(0,1,1), period = 12)
)

# Compare AIC
ret_AIC_table <- data.frame(
  Model = c("SARIMA(1,1,1)(0,1,1)[12]",
            "SARIMA(2,1,1)(0,1,1)[12]",
            "SARIMA(2,1,2)(0,1,1)[12]"),
  AIC = c(AIC(ret_fit1), AIC(ret_fit2), AIC(ret_fit3))
)
write.csv(ret_AIC_table, "table_retail_AIC.csv", row.names = FALSE)

# 8. Choose Final Models

# Replace with your chosen best-fit model
dep_final <- dep_fit4          # example
ret_final <- ret_fit2          # example

summary(dep_final)
summary(ret_final)

# 9. Residual Diagnostics

# Deposits residuals
png("plot_residuals_deposits.png", width=900, height=600)
checkresiduals(dep_final)
dev.off()

# Retail residuals
png("plot_residuals_retail.png", width=900, height=600)
checkresiduals(ret_final)
dev.off()

# 10. Forecasts (12 Months Ahead)

# Deposits forecast
dep_fc <- forecast(dep_final, h = 12)

png("plot_forecast_deposits.png", width=900, height=500)
autoplot(dep_fc) +
  ggtitle("Deposits – 12-Month Forecast")
dev.off()

write.csv(
  data.frame(
    Date = time(dep_fc$mean),
    Mean = dep_fc$mean,
    Lower95 = dep_fc$lower[,"95%"],
    Upper95 = dep_fc$upper[,"95%"]
  ),
  "table_forecast_deposits.csv",
  row.names = FALSE
)

# Retail forecast
ret_fc_log <- forecast(ret_final, h = 12)
ret_fc_mean  <- exp(ret_fc_log$mean)
ret_fc_lower <- exp(ret_fc_log$lower[,"95%"])
ret_fc_upper <- exp(ret_fc_log$upper[,"95%"])

png("plot_forecast_retail.png", width=900, height=500)
autoplot(ret_ts) +
  autolayer(ret_fc_mean, series="Forecast") +
  ggtitle("Retail Sales – 12-Month Forecast") +
  ylab("Sales")
dev.off()

write.csv(
  data.frame(
    Date = time(ret_fc_log$mean),
    Mean = ret_fc_mean,
    Lower95 = ret_fc_lower,
    Upper95 = ret_fc_upper
  ),
  "table_forecast_retail.csv",
  row.names = FALSE
)

