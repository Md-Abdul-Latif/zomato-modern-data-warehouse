WITH orders AS (

    SELECT *
    FROM {{ ref('fact_orders') }}

),

monthly_sales AS (

    SELECT

        DATE_TRUNC('MONTH', order_date) AS sales_month,

        COUNT(DISTINCT order_id) AS total_orders,

        SUM(order_quantity) AS total_items_sold,

        SUM(order_amount) AS total_revenue,

        AVG(order_amount) AS avg_order_value

    FROM orders

    GROUP BY sales_month

),

growth_metrics AS (

    SELECT

        sales_month,

        total_orders,

        total_items_sold,

        total_revenue,

        avg_order_value,

        LAG(total_revenue) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue,

        ROUND(
            (
                total_revenue
                - LAG(total_revenue) OVER (
                    ORDER BY sales_month
                )
            )
            /
            NULLIF(
                LAG(total_revenue) OVER (
                    ORDER BY sales_month
                ),
                0
            ) * 100,
            2
        ) AS revenue_growth_percent

    FROM monthly_sales

)

SELECT

    sales_month,

    total_orders,

    total_items_sold,

    total_revenue,

    avg_order_value,

    previous_month_revenue,

    revenue_growth_percent,

    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank

FROM growth_metrics

ORDER BY sales_month
