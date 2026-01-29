/*
    Project: Logistics Dashboard (Pivoting Data)
    Description: Transforms transactional rows into a summary table 
                 using Conditional Aggregation.
*/

-- APPROACH 1: Standard SQL (Works everywhere)
-- We use SUM(CASE WHEN...) to create binary counters for each column.
SELECT 
    client_name,
    SUM(CASE WHEN status = 'Pending'   THEN 1 ELSE 0 END) AS pending_orders,
    SUM(CASE WHEN status = 'Shipped'   THEN 1 ELSE 0 END) AS shipped_orders,
    SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_orders,
    COUNT(*) AS total_orders
FROM orders
GROUP BY client_name
ORDER BY total_orders DESC;

-- APPROACH 2: PostgreSQL Specific (Modern Syntax)
-- The FILTER clause is more readable and specific to Postgres (9.4+).

SELECT 
    client_name,
    COUNT(*) FILTER (WHERE status = 'Pending')   AS pending_orders,
    COUNT(*) FILTER (WHERE status = 'Shipped')   AS shipped_orders,
    COUNT(*) FILTER (WHERE status = 'Delivered') AS delivered_orders,
    COUNT(*) AS total_orders
FROM orders
GROUP BY client_name;