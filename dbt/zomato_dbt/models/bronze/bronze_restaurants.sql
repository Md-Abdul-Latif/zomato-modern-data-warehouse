SELECT
    *
FROM {{ source('raw', 'raw_restaurant') }}
