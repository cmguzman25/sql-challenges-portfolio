/*
    Project: Excessive Discount Audit
    Description: Identifies salespeople giving average discounts strictly > 15% 
                 on category volumes > $5,000 during 2023.
*/

-- Step 1: Filter by Year and Calculate Aggregations
WITH category_metrics AS (
    SELECT 
        sp.name AS salesperson,
        c.name AS category,
        -- Real Revenue: (Price * Quantity) - Discount
        SUM((p.base_price * s.quantity) - s.total_discount) AS real_revenue,
        -- Average Discount Percentage
        ROUND(
            (SUM(s.total_discount) / SUM(p.base_price * s.quantity)) * 100, 
            2
        ) AS avg_discount_pct
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    JOIN categories c ON p.category_id = c.category_id
    JOIN salespeople sp ON s.salesperson_id = sp.salesperson_id
    -- WHERE executes before GROUP BY
    WHERE EXTRACT(YEAR FROM s.sale_date) = 2023
    GROUP BY sp.name, c.name
)
-- Step 2: Filter the Aggregated Results
SELECT 
    salesperson,
    category,
    real_revenue,
    avg_discount_pct
FROM category_metrics
-- HAVING logic moved to the main query's WHERE clause thanks to the CTE
WHERE real_revenue > 5000 
  AND avg_discount_pct > 15.00;