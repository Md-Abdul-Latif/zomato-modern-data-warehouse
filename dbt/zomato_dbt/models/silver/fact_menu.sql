{{ config(
    materialized='incremental',
    unique_key='menu_id'
) }}

WITH source AS (

    SELECT *
    FROM {{ ref('bronze_menu') }}

),

cleaned AS (

    SELECT

        "c1"::INTEGER AS restaurant_id,
        TRIM("c2") AS menu_id,
        "c3"::INTEGER AS food_id,
        TRIM("c4") AS food_code,

        SPLIT("c5", ',') AS cuisine_list,

        TRY_TO_DECIMAL("c6", 10, 2) AS menu_price,

        CASE
            WHEN "c1" IS NULL THEN TRUE
            ELSE FALSE
        END AS has_restaurant_id_error,

        CASE
            WHEN TRY_TO_DECIMAL("c6", 10, 2) IS NULL THEN TRUE
            ELSE FALSE
        END AS has_price_error,

        CURRENT_TIMESTAMP() AS loaded_at

    FROM source

),

validated AS (

    SELECT
        restaurant_id,
        menu_id,
        food_id,
        food_code,
        cuisine_list,
        menu_price,
        has_restaurant_id_error,
        has_price_error,
        loaded_at

    FROM cleaned

    WHERE restaurant_id IS NOT NULL

      AND restaurant_id IN (

            SELECT DISTINCT restaurant_id
            FROM {{ ref('dim_restaurants') }}

      )

),

deduplicated AS (

    SELECT *
    FROM validated

    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY menu_id
        ORDER BY loaded_at DESC
    ) = 1

)

SELECT *
FROM deduplicated

{% if is_incremental() %}

WHERE loaded_at >
(
    SELECT COALESCE(MAX(loaded_at), '1900-01-01')
    FROM {{ this }}
)

{% endif %}
