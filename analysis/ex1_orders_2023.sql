-- Ex.1: Number of orders in 2023
SELECT
  COUNT(DISTINCT order_id) AS orders_2023_count
FROM {{ ref('stg_orders') }}
WHERE EXTRACT(YEAR FROM order_date) = 2023
