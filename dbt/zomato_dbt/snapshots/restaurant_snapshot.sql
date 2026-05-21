{% snapshot restaurant_snapshot %}

{{
    config(
        target_database='ZOMATO_DB',
        target_schema='SNAPSHOTS',
        unique_key='restaurant_id',

        strategy='check',
        check_cols=[
            'restaurant_name',
            'city',
            'rating',
            'rating_text',
            'average_cost',
            'cuisine_list',
            'address'
        ]
    )
}}

SELECT
    restaurant_id,
    restaurant_name,
    city,
    rating,
    rating_text,
    average_cost,
    cuisine_list,
    license_id,
    restaurant_url,
    address,
    menu_file
FROM {{ ref('dim_restaurants') }}

{% endsnapshot %}
