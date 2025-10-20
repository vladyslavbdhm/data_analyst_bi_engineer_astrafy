-- Unifies actuals (daily_kpis) and 28-day forecasts into one view for Looker Studio
-- Output view: ...marts_kpis.v_dashboard_forecast

CREATE OR REPLACE VIEW `enduring-honor-460514-p2.astrafy_challenge_marts_kpis.v_dashboard_forecast` AS

-- Actuals (ds = DATE, values = FLOAT64)
SELECT
  'revenue' AS metric,
  'actual'  AS series,
  ds,
  CAST(revenue AS FLOAT64) AS value,
  CAST(NULL AS FLOAT64)    AS y_hat,
  CAST(NULL AS FLOAT64)    AS y_lo,
  CAST(NULL AS FLOAT64)    AS y_hi
FROM `enduring-honor-460514-p2.astrafy_challenge_marts_kpis.daily_kpis`

UNION ALL
SELECT 'orders', 'actual', ds,
  CAST(orders AS FLOAT64), CAST(NULL AS FLOAT64), CAST(NULL AS FLOAT64), CAST(NULL AS FLOAT64)
FROM `enduring-honor-460514-p2.astrafy_challenge_marts_kpis.daily_kpis`

UNION ALL
SELECT 'aov', 'actual', ds,
  CAST(aov AS FLOAT64), CAST(NULL AS FLOAT64), CAST(NULL AS FLOAT64), CAST(NULL AS FLOAT64)
FROM `enduring-honor-460514-p2.astrafy_challenge_marts_kpis.daily_kpis`

UNION ALL
-- Forecasts (TIMESTAMP -> DATE; unify as FLOAT64)
SELECT
  'revenue' AS metric,
  'forecast' AS series,
  DATE(ds) AS ds,
  CAST(NULL AS FLOAT64) AS value,
  CAST(y_hat AS FLOAT64) AS y_hat,
  CAST(y_lo  AS FLOAT64) AS y_lo,
  CAST(y_hi  AS FLOAT64) AS y_hi
FROM `enduring-honor-460514-p2.astrafy_challenge_marts_kpis.forecast_revenue_28d`

UNION ALL
SELECT 'orders', 'forecast', DATE(ds),
  CAST(NULL AS FLOAT64), CAST(y_hat AS FLOAT64), CAST(y_lo AS FLOAT64), CAST(y_hi AS FLOAT64)
FROM `enduring-honor-460514-p2.astrafy_challenge_marts_kpis.forecast_orders_28d`

UNION ALL
SELECT 'aov', 'forecast', DATE(ds),
  CAST(NULL AS FLOAT64), CAST(y_hat AS FLOAT64), CAST(y_lo AS FLOAT64), CAST(y_hi AS FLOAT64)
FROM `enduring-honor-460514-p2.astrafy_challenge_marts_kpis.forecast_aov_28d`;
