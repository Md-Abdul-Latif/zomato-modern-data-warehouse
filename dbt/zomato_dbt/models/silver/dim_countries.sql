WITH source AS (

    SELECT *
    FROM {{ ref('bronze_countries') }}

),

cleaned AS (

    SELECT

        "NUM_CODE"::INTEGER AS country_id,

        TRIM("ALPHA_2_CODE") AS alpha_2_code,

        TRIM("ALPHA_3_CODE") AS alpha_3_code,

        INITCAP(TRIM("EN_SHORT_NAME")) AS country_name,

        INITCAP(TRIM("NATIONALITY")) AS nationality

    FROM source

),

deduplicated AS (

    SELECT *
    FROM cleaned

    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY country_id
        ORDER BY country_id
    ) = 1

)

SELECT *
FROM deduplicated
