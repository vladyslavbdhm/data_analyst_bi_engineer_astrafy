-- Ex.5: Order segmentation for each order in 2023 (New, Returning, VIP)
{{ 
  config(
    materialized='table'
    ) 
}}

WITH base AS (
  SELECT
    o.order_id,
    o.client_id,
    o.order_date
  FROM {{ ref('stg_orders') }} o
  WHERE EXTRACT(YEAR FROM o.order_date) = 2023
), 

prior_counts AS (
  SELECT
    b.order_id,
    b.client_id,
    b.order_date,
    (
      SELECT COUNT(1) 
      FROM {{ ref('stg_orders') }} o2
      WHERE o2.client_id = b.client_id
        AND o2.order_date >= DATE_SUB(b.order_date, INTERVAL 12 MONTH)
        AND o2.order_date < b.order_date
    ) AS prior_12m_orders
  FROM base b
)

SELECT
  order_id,
  client_id,
  order_date,
  prior_12m_orders,
  CASE
    WHEN prior_12m_orders = 0 THEN 'New'
    WHEN prior_12m_orders BETWEEN 1 AND 3 THEN 'Returning'
    ELSE 'VIP'
  END AS order_segmentation
FROM prior_counts