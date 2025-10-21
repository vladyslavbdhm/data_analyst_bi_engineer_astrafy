# ==========================================================
# VIEW FILE: orders_2023_analysis.view.lkml
# ==========================================================

view: orders_2023_analysis {
  sql_table_name: `enduring-honor-460514-p2.astrafy_challenge_marts.ex6_fct_orders_2023_with_segmentation` ;;

  # =========================
  # DIMENSIONS
  # =========================
  dimension: order_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.order_id ;;
    description: "Unique identifier of each order."
  }

  dimension: client_id {
    type: number
    sql: ${TABLE}.client_id ;;
    description: "Unique identifier of the customer placing the order."
  }

  dimension: dynamic_order_segmentation {
  type: string
  sql:
    (
      SELECT
        CASE
          WHEN cnt = 0 THEN 'New'
          WHEN cnt BETWEEN 1 AND 3 THEN 'Returning'
          ELSE 'VIP'
        END
      FROM (
        SELECT COUNT(1) AS cnt
        FROM `enduring-honor-460514-p2.astrafy_challenge_marts.ex4_fct_orders_enriched` o2
        WHERE o2.client_id = ${TABLE}.client_id
          AND o2.order_date >= DATE_SUB(${TABLE}.order_date, INTERVAL 12 MONTH)
          AND o2.order_date < ${TABLE}.order_date
      )
    ) ;;
  description: "Dynamic segmentation per order using prior 12 months of history (New / Returning / VIP)."
  }

  dimension: order_segmentation {
    type: string
    sql: ${TABLE}.order_segmentation ;;
    description: "Customer segment based on prior 12-month orders: New, Returning, VIP."
  }  

  dimension: qty_product {
    type: number
    sql: ${TABLE}.qty_product ;;
    description: "Total number of products included in the order."
    value_format: "#,##0"
  }

  dimension: net_sales {
    type: number
    sql: ${TABLE}.net_sales ;;
    description: "Order net sales amount."
    value_format: "#,##0.00 €"
  }

  # =========================
  # DIMENSION GROUP — Order Date
  # =========================
  dimension_group: order_date {
    type: time
    timeframes: [date, week, month, quarter, year]
    sql: ${TABLE}.order_date ;;
    description: "Order date, available in multiple granularities."
  }

  # =========================
  # PARAMETER — Dynamic Granularity
  # =========================
  parameter: timeframe_picker {
    view_label: "→ Parameters"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    allowed_value: { value: "Quarter" }
    default_value: "Month"
    description: "Select the desired time granularity for metrics and PoP analysis."
  }

  # =========================
  # DYNAMIC DATE DIMENSION
  # =========================
  dimension: order_date_dynamic {
    type: date
    sql:
      {% if timeframe_picker._parameter_value == 'Day' %}
        ${TABLE}.order_date
      {% elsif timeframe_picker._parameter_value == 'Week' %}
        DATE_TRUNC(${TABLE}.order_date, WEEK(MONDAY))
      {% elsif timeframe_picker._parameter_value == 'Month' %}
        DATE_TRUNC(${TABLE}.order_date, MONTH)
      {% elsif timeframe_picker._parameter_value == 'Quarter' %}
        DATE_TRUNC(${TABLE}.order_date, QUARTER)
      {% else %}
        NULL
      {% endif %} ;;
    description: "Order date truncated dynamically according to the selected timeframe."
  }

  # =========================
  # BUSINESS MEASURES (€, counts)
  # =========================
  measure: total_orders {
    type: count_distinct
    sql: ${order_id} ;;
    description: "Total number of unique orders."
    drill_fields: [detail*]
  }

  measure: total_customers {
    type: count_distinct
    sql: ${client_id} ;;
    description: "Number of unique customers who placed orders."
    drill_fields: [detail*]
  }

  measure: total_products {
    type: sum
    sql: ${qty_product} ;;
    description: "Total quantity of products sold."
    value_format: "#,##0"
    drill_fields: [detail*]
  }

  measure: total_revenue {
    type: sum
    sql: ${net_sales} ;;
    description: "Total net revenue."
    value_format: "#,##0.00 €"
    drill_fields: [detail*]
  }

  measure: aov {
    type: number
    sql: ${total_revenue} / NULLIF(${total_orders}, 0) ;;
    description: "Average Order Value (net sales per order)."
    value_format: "#,##0.00 €"
    drill_fields: [detail*]
  }

  measure: new_orders {
    type: count
    sql: CASE WHEN ${dynamic_order_segmentation} = 'New' THEN 1 ELSE NULL END ;;
    description: "Count of orders from New customers."
    drill_fields: [detail*]
  }

  measure: returning_orders {
    type: count
    sql: CASE WHEN ${dynamic_order_segmentation} = 'Returning' THEN 1 ELSE NULL END ;;
    description: "Count of orders from Returning customers."
    drill_fields: [detail*]
  }

  measure: vip_orders {
    type: count
    sql: CASE WHEN ${dynamic_order_segmentation} = 'VIP' THEN 1 ELSE NULL END ;;
    description: "Count of orders from VIP customers."
    drill_fields: [detail*]
  }

  # =========================
  # PERIOD-OVER-PERIOD (PoP)
  # =========================
  measure: total_orders_dod_change {
    type: period_over_period
    based_on: total_orders
    based_on_time: order_date_dynamic
    period: day
    kind: relative_change
    value_format_name: percent_1
    label: "Orders DoD % Change"
    description: "Day-over-day percentage change in total orders."
  }

  measure: total_orders_mom_change {
    type: period_over_period
    based_on: total_orders
    based_on_time: order_date_dynamic
    period: month
    kind: relative_change
    value_format_name: percent_1
    label: "Orders MoM % Change"
    description: "Month-over-month percentage change in total orders."
  }

  measure: aov_mom_change {
    type: period_over_period
    based_on: aov
    based_on_time: order_date_dynamic
    period: month
    kind: relative_change
    value_format_name: percent_1
    label: "AOV MoM % Change"
    description: "Month-over-month percentage change in AOV."
  }

  # =========================
  # DRILL-DOWN DETAIL SET
  # =========================
  set: detail {
    fields: [
      order_id,
      client_id,
      order_segmentation,
      dynamic_order_segmentation,
      qty_product,
      net_sales,
      order_date,
      order_date_dynamic
    ]
  }
}
