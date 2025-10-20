-- Staging: orders
{{ config(
    materialized='view'
    ) 
}}

SELECT
  SAFE_CAST(date_date AS date) AS order_date,
  SAFE_CAST(customers_id AS int64) AS client_id,
  SAFE_CAST(orders_id AS int64) AS order_id
FROM {{ ref('orders_recrutement') }}
