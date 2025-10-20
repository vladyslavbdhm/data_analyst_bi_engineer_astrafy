{{ config(
    materialized='table'
    ) 
}}

SELECT
  DATE_TRUNC(order_date, month) AS month,
  COUNT(DISTINCT order_id) AS orders_count
FROM {{ ref('stg_orders') }}
WHERE EXTRACT(YEAR FROM order_date) = 2023
GROUP BY 1
ORDER BY 1