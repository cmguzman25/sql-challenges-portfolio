sql
WITH monthly_sales AS (
    -- STEP 1: Aggregate sales by month and category
    SELECT 
        p.category,
        DATE_TRUNC('month', s.sale_date)::DATE as sales_month,
        SUM(s.quantity * p.price) as total_revenue
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    GROUP BY 1, 2
),
previous_month_calc AS (
    -- STEP 2: Use Window Functions to fetch the previous month's revenue
    SELECT 
        category,
        sales_month,
        total_revenue,
        LAG(total_revenue) OVER(PARTITION BY category ORDER BY sales_month) as prev_month_revenue
    FROM monthly_sales
)
-- STEP 3: Calculate the Growth Percentage
SELECT 
    category,
    sales_month,
    total_revenue,
    prev_month_revenue,
    ROUND(
        ((total_revenue - prev_month_revenue) / NULLIF(prev_month_revenue, 0)) * 100, 
        2
    ) as growth_percentage
FROM previous_month_calc
ORDER BY category, sales_month;