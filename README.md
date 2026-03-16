# 📈 Time Series Forecasting of U.S. Bank Deposits & Retail Sales

> A complete Box-Jenkins time series analysis and 12-month forecasting project using ARIMA and SARIMA models in R - applied to two major U.S. macroeconomic indicators.

---

## 📌 Project Overview

| Detail | Info |
|---|---|
| **Series 1** | U.S. Bank Deposits (FRED, Monthly, Billions USD) |
| **Series 2** | U.S. Retail Trade Sales (Census Bureau via FRED, Monthly) |
| **Models** | ARIMA(2,0,1) & SARIMA(2,1,1)×(0,1,1)[12] |
| **Forecast Horizon** | 12 months ahead |
| **Language** | R |

---

## ❓ Research Questions

| # | Question |
|---|---|
| 1 | What ARIMA/SARIMA model best captures U.S. bank deposit dynamics? |
| 2 | How can seasonal retail sales patterns be modeled and forecasted? |
| 3 | Do gig earnings align with local cost-of-living requirements? |
| 4 | What do 12-month forecasts suggest about near-term economic conditions? |

---

## 🔬 Methodology — Box-Jenkins Framework
```
1. Data Acquisition      → FRED API (Federal Reserve Economic Data)
2. Stationarity Testing  → ADF & KPSS Tests
3. Transformation        → Log transform (Retail), Differencing
4. Model Identification  → ACF & PACF Analysis
5. Model Estimation      → AIC Comparison across candidates
6. Diagnostic Checking   → Residual plots, Ljung-Box Test
7. Forecasting           → 12-month ahead with 95% CI
```

---

## 📊 Final Models & Results

### Series 1: U.S. Bank Deposits
| Detail | Value |
|---|---|
| **Final Model** | ARIMA(2,0,1) with non-zero mean |
| **AIC** | 4306.95 |
| **Residual Variance** | 52.83 |
| **Forecast** | Stable mean-reverting trajectory (~$5–5.5B) |

**Coefficients:**
- AR(1) = 1.0114 | AR(2) = –0.0684 | MA(1) = –0.8516 | Mean = 6.2244

### Series 2: U.S. Retail Trade Sales
| Detail | Value |
|---|---|
| **Final Model** | SARIMA(2,1,1)×(0,1,1)[12] |
| **AIC** | –1764.87 |
| **Residual Variance** | 0.00062 |
| **Forecast** | Peak values exceeding 650,000 (holiday season) |

**Coefficients:**
- AR(1) = –0.7801 | AR(2) = –0.4306 | MA(1) = 0.3753 | Seasonal MA(1) = –0.7758

---

## 📉 Key Findings

- **Deposits** exhibit mean-reverting behavior — stable outside major economic shocks (2008 crisis, COVID-19)
- **Retail Sales** show strong upward trend + pronounced November–December holiday peaks
- SARIMA successfully captures both seasonal and trend components with strong fit
- 12-month retail forecast peaks exceed **$650,000** — confirming enduring seasonal consumer demand
- Deposits forecast remains stable near **$5–5.5 billion** — useful for liquidity planning

---

## 🗃️ Data Sources

| Dataset | Source | Link |
|---|---|---|
| Bank Deposits | Federal Reserve (FRED) | [H8B1058NCBCMG](https://fred.stlouisfed.org/series/H8B1058NCBCMG) |
| Retail Trade Sales | U.S. Census Bureau via FRED | [RSXFSN](https://fred.stlouisfed.org/series/RSXFSN) |

---

## 📁 Repository Structure
```
time-series-forecasting-us-economy/
├── Final_Project-MA-641.r          # Full R analysis script
├── Final_Report-Time_Series.pdf    # Complete project report
├── README.md                       # This file
└── plots/                          # All generated visualizations
    ├── plot_deposits_raw.png
    ├── plot_retail_raw.png
    ├── plot_retail_stl.png
    ├── plot_acf_pacf_deposits.png
    ├── plot_acf_pacf_retail.png
    ├── plot_residuals_deposits.png
    ├── plot_residuals_retail.png
    ├── plot_forecast_deposits.png
    └── plot_forecast_retail.png
```

---

## ⚙️ How to Run

1. Install required R packages:
```r
install.packages(c("forecast", "tseries", "ggplot2", "dplyr", "fredr"))
```

2. Run the analysis script:
```r
source("Final_Project-MA-641.r")
```

---

## 🛠️ Tools & Technologies

![R](https://img.shields.io/badge/R-276DC3?style=flat&logo=r&logoColor=white)
![Time Series](https://img.shields.io/badge/Time%20Series-E53935?style=flat&logo=python&logoColor=white)
![ARIMA](https://img.shields.io/badge/ARIMA%2FSARIMA-7B1FA2?style=flat&logo=scipy&logoColor=white)
![FRED](https://img.shields.io/badge/FRED%20Data-1565C0?style=flat&logo=databricks&logoColor=white)
![ggplot2](https://img.shields.io/badge/ggplot2-2E7D32?style=flat&logo=r&logoColor=white)

---

## 👤 Author

**Mayank Choudhary**
MS Data Science | Stevens Institute of Technology

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/mayankchoudhary23/)
[![Email](https://img.shields.io/badge/Email-D14836?style=flat&logo=gmail&logoColor=white)](mailto:mayankchoudharystevens909@gmail.com)
```
