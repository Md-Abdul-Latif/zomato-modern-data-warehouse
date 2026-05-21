WITH source AS (

    SELECT *
    FROM {{ ref('bronze_foods') }}

),

cleaned AS (

    SELECT

        TRIM("c2") AS food_id,

        INITCAP(TRIM("c3")) AS food_name,

        INITCAP(TRIM("c4")) AS food_category

    FROM source

),

deduplicated AS (

    SELECT *
    FROM cleaned

    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY food_id
        ORDER BY food_id
    ) = 1

)

SELECT *
FROM deduplicated
