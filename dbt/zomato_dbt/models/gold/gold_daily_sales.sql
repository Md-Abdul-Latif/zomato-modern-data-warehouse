WITH orders AS (

    SELECT *
    FROM {{ ref('fact_orders') }}

),

daily_sales AS (

    SELECT

        order_date,

        COUNT(order_id) AS total_orders,

        SUM(order_quantity) AS total_items_sold,

        SUM(order_amount) AS total_revenue,

        AVG(order_amount) AS avg_order_value

    FROM orders

    GROUP BY order_date

)

SELECT *
FROM daily_sales
ORDER BY order_date
