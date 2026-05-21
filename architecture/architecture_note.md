# Zomato Modern Data Platform Architecture

## Technologies Used

- Snowflake
- dbt
- Apache Airflow
- GitHub
- Tableau

## Architecture Layers

### Bronze Layer
Raw ingestion tables.

### Silver Layer
Cleaned dimensional and fact models.

### Gold Layer
Business-ready analytical models.

## Orchestration

Apache Airflow orchestrates:

1. dbt run
2. dbt test
3. dbt snapshot
4. dbt docs generate

## Data Quality

Implemented using dbt tests:
- not null
- unique
- relationships

## Slowly Changing Dimensions

Restaurant snapshot implemented using dbt snapshots (SCD Type 2).

## Analytics Models

Gold models:
- gold_daily_sales
- gold_monthly_sales
- gold_customer_metrics
- gold_top_restaurants
- gold_cuisine_performance
