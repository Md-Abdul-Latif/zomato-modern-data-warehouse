WITH source AS (

    SELECT *
    FROM {{ ref('bronze_restaurants') }}

),

cleaned AS (

    SELECT

        "c2"::INTEGER AS restaurant_id,

	NULLIF(TRIM("c3"), '') AS restaurant_name,

        INITCAP(TRIM("c4")) AS city,

        CASE
            WHEN "c5" = '--' THEN NULL
            ELSE TRY_TO_DECIMAL("c5")
        END AS rating,

        TRIM("c6") AS rating_text,

        TRY_TO_NUMBER(
            REGEXP_REPLACE("c7", '[^0-9]', '')
        ) AS average_cost,

        SPLIT("c8", ',') AS cuisine_list,

        "c9" AS license_id,

        "c10" AS restaurant_url,

        TRIM("c11") AS address,

        "c12" AS menu_file

    FROM source

),

deduplicated AS (

    SELECT *
    FROM cleaned
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY restaurant_id
        ORDER BY restaurant_id
    ) = 1

)

SELECT *
FROM deduplicated
WHERE restaurant_name IS NOT NULL
