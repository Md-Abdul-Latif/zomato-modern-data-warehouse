# Architecture Overview

## Data Ingestion
CSV files loaded into Snowflake RAW layer.

## Transformation
dbt transforms data through:
- Bronze
- Silver
- Gold

## Orchestration
Airflow orchestrates:
- dbt run
- dbt test
- dbt snapshot
- dbt docs generate

## Analytics
Gold models support Tableau dashboards.
