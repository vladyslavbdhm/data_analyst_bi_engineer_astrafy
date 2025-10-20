# Astrafy Data Challenge — Final Delivery  
**Owner:** Vladyslav Dodonov  
**Date:** 2025  

---

## Overview

This repository contains the full implementation of the **Astrafy Data Challenge**, covering three main parts:

1. **Data Modeling (dbt)** — cleaning, transformation, and KPI computation.  
2. **Semantic Layer (LookML)** — reusable business metrics for exploration.  
3. **Dashboard (Looker Studio)** — interactive visualization and forecasting.  

All assets were developed using **BigQuery**, **dbt**, and **Looker Studio**, following analytics engineering best practices.  

---

## Setup & Installation

### 1. Clone the Repository
```bash
git clone <repository_url>
cd Astrafy_challenge_Vladyslav_Dodonov
```

### 2. Create and Activate a Virtual Environment
**Windows**
```bash
python -m venv .venv
.venv\Scripts\activate
```

**Mac/Linux**
```bash
python3 -m venv .venv
source .venv/bin/activate
```

### 3. Install Requirements
```bash
pip install -r requirements.txt
```

Contents of `requirements.txt`:
```
dbt-bigquery==1.7.16
```

### 4. Configure dbt Profile
Ensure your `profiles.yml` includes a valid BigQuery connection pointing to your dataset.

### 5. Run dbt Pipeline
```bash
dbt seed
dbt run
dbt test
```

---

## Project Structure

```
Astrafy_challenge_Vladyslav_Dodonov/
│
├── analysis/
│   ├── ex1_orders_2023.sql
│   ├── ex2_orders_per_month_2023.sql
│   ├── ex3_avg_products_per_order_per_month_2023.sql
│   └── forecast/
│       ├── 01_daily_kpis.sql
│       ├── 02_models_train.sql
│       ├── 03_forecast_28d.sql
│       └── 04_view_dashboard_forecast.sql
│
├── dashboard_looker_studio/
│   └── Marketing_Report_-_Sales_2022_23_(Astrafy).pdf   # Exported Looker Studio dashboard
│
├── looker/
│   ├── astrafy_challenge.model.lkml                     # LookML model definition
│   └── orders_2023_analysis.view.lkml                   # View with metrics, parameters, PoP logic
│
├── models/
│   ├── marts/
│   │   ├── ex4_fct_orders_enriched.sql
│   │   ├── ex5_fct_orders_segmentation_2023.sql
│   │   ├── ex6_fct_orders_2023_with_segmentation.sql
│   │   ├── schema.yml
│   │   └── kpis/
│   │       ├── ex1_orders_2023_count.sql
│   │       ├── ex2_orders_2023_by_month.sql
│   │       └── ex3_avg_products_per_order_2023_by_month.sql      
│   │ 
│   ├── staging/
│   │   ├── stg_orders.sql
│   │   ├── stg_sales.sql
│   │   └── schema.yml
│
├── seeds/
│   ├── orders_recrutement.csv
│   ├── sales_recrutement.csv
│   └── schema.yml
│
├── README.md
├── dbt_project.yml
├── requirements.txt
└── .gitignore
```

---

## Part 1 — Data Modeling (dbt)

### Goal
Model a clean, reliable dataset to analyze orders and customers, following the exercises defined in the challenge.

### Exercises Implemented

#### Ex.1 — Orders 2023 Count
Aggregates the total number of orders in 2023, grouped by year and month.
Value: 2573


#### Ex.2 — Orders 2023 by Month
Calculates the count of monthly orders to detect seasonality and peaks.

| Row | Month | Orders Count |
|------|--------|--------------|
| 1 | 2023-01-01 | 232 |
| 2 | 2023-02-01 | 176 |
| 3 | 2023-03-01 | 203 |
| 4 | 2023-04-01 | 188 |
| 5 | 2023-05-01 | 172 |
| 6 | 2023-06-01 | 169 |
| 7 | 2023-07-01 | 193 |
| 8 | 2023-08-01 | 167 |
| 9 | 2023-09-01 | 212 |
| 10 | 2023-10-01 | 223 |
| 11 | 2023-11-01 | 389 |
| 12 | 2023-12-01 | 249 |

#### Ex.3 — Average Products per Order
Computes the average quantity of products per order, measuring customer purchase behavior.

| Row | Month | Avg Products per Order |
|------|--------|------------------------|
| 1 | 2023-01-01 | 12.57 |
| 2 | 2023-02-01 | 12.62 |
| 3 | 2023-03-01 | 13.07 |
| 4 | 2023-04-01 | 15.10 |
| 5 | 2023-05-01 | 14.63 |
| 6 | 2023-06-01 | 14.18 |
| 7 | 2023-07-01 | 13.75 |
| 8 | 2023-08-01 | 14.46 |
| 9 | 2023-09-01 | 13.67 |
| 10 | 2023-10-01 | 13.03 |
| 11 | 2023-11-01 | 10.48 |
| 12 | 2023-12-01 | 11.37 |


#### Ex.4 — fct_orders_enriched
Aggregates orders for **2022–2023**, ensuring one record per order with:
- `order_id`, `client_id`, `order_date`, and `qty_product`.

#### Ex.5 — fct_orders_segmentation_2023
Adds segmentation logic based on previous 12 months of customer history:
- **New**: 0 orders in the past 12 months  
- **Returning**: 1–3 prior orders  
- **VIP**: ≥ 4 prior orders  

#### Ex.6 — fct_orders_2023_with_segmentation
Final unified dataset joining previous outputs with `net_sales` to support business KPIs.

---

### Data Quality & Tests

All models include data tests defined in `schema.yml`:
- **not_null** for key identifiers (`order_id`, `client_id`, `order_date`).  
- **unique** for `order_id` (no duplicates).  
- **accepted_values** for `order_segmentation` (`New`, `Returning`, `VIP`).  

Validation was performed via:
```bash
dbt seed
dbt run
dbt test
```

All tests passed successfully.  
Minor warnings related to BigQuery partition pruning are expected and documented.

---

## Part 2 — Semantic Layer (LookML)

### Goal
Expose the dbt marts as a semantic, human-readable layer for business exploration.

### Files
- `astrafy_challenge.model.lkml` — defines the BigQuery connection and main explore.  
- `orders_2023_analysis.view.lkml` — defines dimensions, measures, and period-over-period metrics.  

### Features
- Dynamic **time granularity parameter** (`Day`, `Week`, `Month`, `Quarter`).
- **Customer segmentation** integrated directly in the semantic layer.  
- **Drill-down set** for order-level details.  
- Measures formatted in **euros (€)**.  
- **Period-over-Period (PoP)** metrics:
  - Day-over-Day (%)
  - Month-over-Month (%)

### Example Measures
| Measure | Type | Description |
|----------|------|-------------|
| `total_orders` | count_distinct | Total orders |
| `total_customers` | count_distinct | Unique customers |
| `avg_products_per_order` | average | Average quantity per order |
| `new_orders` | count | Orders from new customers |
| `vip_orders` | count | Orders from VIP customers |
| `total_orders_mom_change` | PoP | Month-over-Month % change |

---

## Part 3 — Dashboard (Looker Studio)

### Goal
Provide the marketing team with a daily, business-relevant view of KPIs and trends.

### Final Dashboard  
[View Dashboard in Looker Studio](https://lookerstudio.google.com/reporting/d5c2f76e-d140-474e-abe0-4b9431ae9360)

### Pages & KPIs

#### Page 1 — Overview
- KPIs: Total Revenue (€), Total Orders, Average Order Value (AOV)
- Visuals:
  - Orders & Revenue Over Time
  - Orders by Day of Week
  - Customer Segmentation Breakdown
  - Top Customers Table

#### Page 2 — Forecast & Trends
- 28-Day Forecast using **BigQuery ML (ARIMA_PLUS)**:
  - Predicted Revenue / Orders / AOV  
  - Confidence Interval (95%)  
- KPI Cards with next 28-day projections


---

## Bonus Forecasting (BigQuery ML)

All scripts located in `/analytics/bqml_forecast/`:
1. `01_daily_kpis.sql` — aggregate daily KPIs from marts  
2. `02_models_train.sql` — train ARIMA+ models for revenue, orders, AOV  
3. `03_forecast_28d.sql` — generate 28-day forecast with confidence intervals  
4. `04_view_dashboard_forecast.sql` — unify actuals and forecasted data for Looker Studio  

Unified output view:  
`enduring-honor-460514-p2.astrafy_challenge_marts_kpis.v_dashboard_forecast`

---

## Execution Order

1. Run dbt pipeline (`dbt seed`, `dbt run`, `dbt test`).  
2. Execute BigQuery ML scripts sequentially (`01_` → `04_`).  
3. Connect `v_dashboard_forecast` and `ex6_fct_orders_2023_with_segmentation` to Looker Studio.  
4. Import LookML into Looker for semantic layer exploration (optional).  

---

## Data Validation Summary

| Model | Tests Applied | Status |
|--------|----------------|--------|
| seeds (orders/sales) | not_null, valid type | Passed |
| stg_orders / stg_sales | not_null, valid casts | Passed |
| ex4_fct_orders_enriched | unique, not_null | Passed |
| ex5_fct_orders_segmentation_2023 | accepted_values, not_null | Passed |
| ex6_fct_orders_2023_with_segmentation | not_null, type consistency | Passed |

---

## Documentation & Reproducibility

Every model includes:
- Descriptions in `schema.yml`
- Inline comments for business logic
- Structured folder naming for maintainability
- Forecast scripts organized by execution step

---

