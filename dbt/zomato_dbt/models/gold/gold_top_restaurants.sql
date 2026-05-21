WITH orders AS (

    SELECT *
    FROM {{ ref('fact_orders') }}

),

restaurants AS (

    SELECT *
    FROM {{ ref('dim_restaurants') }}

),

restaurant_sales AS (

    SELECT

        r.restaurant_id,

        r.restaurant_name,

        COUNT(o.order_id) AS total_orders,

        SUM(o.order_amount) AS total_revenue,

        AVG(o.order_amount) AS avg_order_value

    FROM orders o

    INNER JOIN restaurants r
        ON o.restaurant_id = r.restaurant_id

    GROUP BY
        r.restaurant_id,
        r.restaurant_name

)

SELECT *
FROM restaurant_sales
ORDER BY total_revenue DESC
