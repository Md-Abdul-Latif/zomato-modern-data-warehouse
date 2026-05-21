{{ config(
    materialized='incremental',
    unique_key='order_id'
) }}

WITH source AS (

    SELECT *
    FROM {{ ref('bronze_orders') }}

),

cleaned AS (

    SELECT

        "c1"::INTEGER AS order_id,

        "c2"::DATE AS order_date,

        "c3"::INTEGER AS order_quantity,

        "c4"::INTEGER AS order_amount,

        TRIM("c5") AS currency,

        "c6"::INTEGER AS customer_id,

        "c7"::INTEGER AS restaurant_id

    FROM source

    WHERE "c1" IS NOT NULL

),

validated AS (

    SELECT *
    FROM cleaned
    WHERE restaurant_id IN (

        SELECT restaurant_id
        FROM {{ ref('dim_restaurants') }}

    )

),
deduplicated AS (
	SELECT * 
	FROM validated
	
	QUALIFY ROW_NUMBER() OVER (
	PARTITION BY order_id
	ORDER BY order_id DESC
	) = 1
)

SELECT *
FROM deduplicated

{% if is_incremental() %}

WHERE order_id > (
    SELECT COALESCE(MAX(order_id), 0)
    FROM {{ this }}
)

{% endif %}
