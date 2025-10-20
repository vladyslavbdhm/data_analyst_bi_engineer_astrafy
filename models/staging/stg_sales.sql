{{ config(
    materialized='view'
    ) 
}}

SELECT
  SAFE_CAST(order_id AS int64) AS order_id,
  SAFE_CAST(products_id AS string) AS product_id,
  SAFE_CAST(qty AS int64) AS quantity,
  SAFE_DIVIDE(CAST(net_sales AS numeric), CAST(qty AS numeric)) AS price,
  SAFE_CAST(net_sales AS numeric) AS net_sales
FROM {{ ref('sales_recrutement') }}
