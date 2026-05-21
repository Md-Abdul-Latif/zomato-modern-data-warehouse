WITH source AS (

    -- Flatten cuisine array into individual rows

    SELECT

        m.restaurant_id,
        m.menu_id,
        m.food_id,
        m.menu_price,

        TRIM(f.value::STRING) AS cuisine

    FROM {{ ref('fact_menu') }} m,

    LATERAL FLATTEN(input => m.cuisine_list) f

),

order_metrics AS (

    -- Associate cuisines with orders

    SELECT

        s.cuisine,

        COUNT(DISTINCT o.order_id) AS order_count,

        SUM(o.order_amount) AS total_revenue,

        SUM(o.order_quantity) AS total_quantity

    FROM source s

    INNER JOIN {{ ref('fact_orders') }} o
        ON s.restaurant_id = o.restaurant_id

    GROUP BY s.cuisine

)

SELECT

    cuisine,

    order_count AS total_orders,

    total_revenue,

    total_quantity AS total_items_sold,

    ROUND(
        total_revenue / NULLIF(order_count, 0),
        2
    ) AS avg_order_value,

    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank,

    RANK() OVER (
        ORDER BY order_count DESC
    ) AS popularity_rank

FROM order_metrics

ORDER BY total_revenue DESC
