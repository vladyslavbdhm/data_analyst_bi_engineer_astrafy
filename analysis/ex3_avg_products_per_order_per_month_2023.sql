-- Ex.3: Average number of products per order for each month of 2023
WITH qty_per_order AS (
  SELECT
    order_id,
    SUM(quantity) AS qty_product
  FROM {{ ref('stg_sales') }}
  GROUP BY 1
)

SELECT
  DATE_TRUNC(o.order_date, month) AS month,
  AVG(q.qty_product) AS avg_products_per_order
FROM {{ ref('stg_orders') }} o
JOIN qty_per_order q USING(order_id)
WHERE EXTRACT(YEAR FROM o.order_date) = 2023
GROUP BY 1
ORDER BY 1