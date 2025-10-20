-- Ex.4: One row per order (2022–2023) with qty_product
{{ config(
    materialized='table'
)
}}

WITH order_qty AS (
  SELECT
    s.order_id,
    SUM(s.quantity) AS qty_product,
    SUM(s.net_sales) AS net_sales
  FROM {{ ref('stg_sales') }} s
  GROUP BY 1
)

SELECT
  o.order_id,
  o.client_id,
  o.order_date,
  COALESCE(q.qty_product, 0) AS qty_product,
  COALESCE(q.net_sales, 0) AS net_sales
FROM {{ ref('stg_orders') }} o
LEFT JOIN order_qty q USING(order_id)
WHERE o.order_date BETWEEN DATE('2022-01-01') AND DATE('2023-12-31')
