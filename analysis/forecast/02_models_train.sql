-- Trains ARIMA_PLUS models for revenue, orders, and AOV
-- Outputs:
--   ...marts_kpis.ml_rev_forecast
--   ...marts_kpis.ml_orders_forecast
--   ...marts_kpis.ml_aov_forecast

-- Revenue model
CREATE OR REPLACE MODEL `enduring-honor-460514-p2.astrafy_challenge_marts_kpis.ml_rev_forecast`
OPTIONS(
  MODEL_TYPE = 'ARIMA_PLUS',
  TIME_SERIES_TIMESTAMP_COL = 'ds',
  TIME_SERIES_DATA_COL = 'revenue',
  AUTO_ARIMA = TRUE,
  HOLIDAY_REGION = 'US' -- optional
) AS
SELECT ds, revenue
FROM `enduring-honor-460514-p2.astrafy_challenge_marts_kpis.daily_kpis`;

-- Orders model
CREATE OR REPLACE MODEL `enduring-honor-460514-p2.astrafy_challenge_marts_kpis.ml_orders_forecast`
OPTIONS(
  MODEL_TYPE = 'ARIMA_PLUS',
  TIME_SERIES_TIMESTAMP_COL = 'ds',
  TIME_SERIES_DATA_COL = 'orders',
  AUTO_ARIMA = TRUE
) AS
SELECT ds, orders
FROM `enduring-honor-460514-p2.astrafy_challenge_marts_kpis.daily_kpis`;

-- AOV model
CREATE OR REPLACE MODEL `enduring-honor-460514-p2.astrafy_challenge_marts_kpis.ml_aov_forecast`
OPTIONS(
  MODEL_TYPE = 'ARIMA_PLUS',
  TIME_SERIES_TIMESTAMP_COL = 'ds',
  TIME_SERIES_DATA_COL = 'aov',
  AUTO_ARIMA = TRUE
) AS
SELECT ds, aov
FROM `enduring-honor-460514-p2.astrafy_challenge_marts_kpis.daily_kpis`;
