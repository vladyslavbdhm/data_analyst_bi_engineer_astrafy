-- Ex.6: 1 line per order in 2023 with order_segmentation
{{ 
  config(
    materialized='table'
    ) 
}}

SELECT
  e.order_id,
  e.client_id,
  e.order_date,
  e.qty_product,
  e.net_sales,
  s.order_segmentation
FROM {{ ref('ex4_fct_orders_enriched') }} e
JOIN {{ ref('ex5_fct_orders_segmentation_2023') }} s USING(order_id)
WHERE EXTRACT(YEAR FROM e.order_date) = 2023