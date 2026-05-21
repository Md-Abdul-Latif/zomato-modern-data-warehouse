SELECT *
FROM {{ source('raw', 'raw_orders') }}
