-- Creates daily KPIs table from marts (2023)
-- Output: enduring-honor-460514-p2.astrafy_challenge_marts_kpis.daily_kpis

CREATE OR REPLACE TABLE `enduring-honor-460514-p2.astrafy_challenge_marts_kpis.daily_kpis` AS
SELECT
  DATE(order_date) AS ds,
  SUM(net_sales) AS revenue,
  COUNT(DISTINCT order_id) AS orders,
  SAFE_DIVIDE(SUM(net_sales), COUNT(DISTINCT order_id)) AS aov
FROM `enduring-honor-460514-p2.astrafy_challenge_marts.ex6_fct_orders_2023_with_segmentation`
GROUP BY 1
ORDER BY 1;
