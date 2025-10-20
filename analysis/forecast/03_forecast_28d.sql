-- Materializes 28-day forecasts with 95% intervals
-- Outputs:
--   ...marts_kpis.forecast_revenue_28d
--   ...marts_kpis.forecast_orders_28d
--   ...marts_kpis.forecast_aov_28d

-- Revenue forecast
CREATE OR REPLACE TABLE `enduring-honor-460514-p2.astrafy_challenge_marts_kpis.forecast_revenue_28d` AS
SELECT
  forecast_timestamp AS ds,
  forecast_value AS y_hat,
  prediction_interval_lower_bound AS y_lo,
  prediction_interval_upper_bound AS y_hi
FROM ML.FORECAST(
  MODEL `enduring-honor-460514-p2.astrafy_challenge_marts_kpis.ml_rev_forecast`,
  STRUCT(28 AS horizon, 0.95 AS confidence_level)
);

-- Orders forecast
CREATE OR REPLACE TABLE `enduring-honor-460514-p2.astrafy_challenge_marts_kpis.forecast_orders_28d` AS
SELECT
  forecast_timestamp AS ds,
  forecast_value AS y_hat,
  prediction_interval_lower_bound AS y_lo,
  prediction_interval_upper_bound AS y_hi
FROM ML.FORECAST(
  MODEL `enduring-honor-460514-p2.astrafy_challenge_marts_kpis.ml_orders_forecast`,
  STRUCT(28 AS horizon, 0.95 AS confidence_level)
);

-- AOV forecast
CREATE OR REPLACE TABLE `enduring-honor-460514-p2.astrafy_challenge_marts_kpis.forecast_aov_28d` AS
SELECT
  forecast_timestamp AS ds,
  forecast_value AS y_hat,
  prediction_interval_lower_bound AS y_lo,
  prediction_interval_upper_bound AS y_hi
FROM ML.FORECAST(
  MODEL `enduring-honor-460514-p2.astrafy_challenge_marts_kpis.ml_aov_forecast`,
  STRUCT(28 AS horizon, 0.95 AS confidence_level)
);
