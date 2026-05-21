WITH orders AS (

    SELECT *
    FROM {{ ref('fact_orders') }}

),

customer_metrics AS (

    SELECT

        customer_id,

        COUNT(order_id) AS total_orders,

        SUM(order_amount) AS total_spent,

        AVG(order_amount) AS avg_order_value,

        MIN(order_date) AS first_order_date,

        MAX(order_date) AS last_order_date

    FROM orders

    GROUP BY customer_id

)

SELECT *
FROM customer_metrics
ORDER BY total_spent DESC
