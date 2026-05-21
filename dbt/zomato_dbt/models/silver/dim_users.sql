WITH source AS (

    SELECT *
    FROM {{ ref('bronze_users') }}

),

cleaned AS (

    SELECT

        "c2"::INTEGER AS user_id,

        TRIM("c3") AS full_name,

        LOWER(TRIM("c4")) AS email,

        TRIM("c5") AS password_hash,

        "c6"::INTEGER AS age,

        INITCAP(TRIM("c7")) AS gender,

        INITCAP(TRIM("c8")) AS marital_status,

        INITCAP(TRIM("c9")) AS occupation,

        TRIM("c10") AS income_range,

        INITCAP(TRIM("c11")) AS education_level,

        "c12"::INTEGER AS family_size

    FROM source

),

deduplicated AS (

    SELECT *
    FROM cleaned

    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY user_id
        ORDER BY user_id
    ) = 1

)

SELECT *
FROM deduplicated
