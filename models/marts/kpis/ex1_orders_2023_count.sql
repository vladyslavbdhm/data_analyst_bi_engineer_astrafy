{{ config(
    materialized='table'
    ) 
}}

SELECT
  2023 AS year,
  COUNT(DISTINCT order_id) AS orders_2023_count
FROM {{ ref('stg_orders') }}
WHERE EXTRACT(YEAR FROM order_date) = 2023
