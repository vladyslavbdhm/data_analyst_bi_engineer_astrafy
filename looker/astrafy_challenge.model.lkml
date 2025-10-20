# ==========================================================
# MODEL FILE: astrafy_challenge.model.lkml
# Project: Astrafy Data Challenge
# Description:
#   Defines the LookML connection and the main Explore for 2023 Orders,
#   built on top of the semantic layer (orders_2023_analysis view).
# ==========================================================

connection: "bigquery_connection"

include: "*.view.lkml"

explore: orders_2023_analysis {
  label: "Orders 2023 Analysis"
  description: "Explore customer behavior, segmentation, and product volume with period-over-period analysis."
}
