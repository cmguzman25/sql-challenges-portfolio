# 📈 Monthly Sales Growth Analysis

## 📌 Project Overview

**Business Context:** As a Data Analyst for an e-commerce platform, I was tasked with generating a performance report tracking sales momentum. The goal was to calculate the month-over-month percentage growth for each product category to identify trends, seasonality, or underperforming sectors.

**Key Techniques Used:**

- **Window Functions (`LAG`)**: To access data from previous rows without self-joins.
- **CTEs (Common Table Expressions)**: To structure the query into readable, logical steps.
- **Data Aggregation**: Grouping transactional data into monthly insights.
- **Error Handling**: Using `NULLIF` to prevent division-by-zero errors.

## 🛠️ The Challenge

The query needs to return:

1.  Product Category.
2.  The Month of sale.
3.  Total Revenue for that month.
4.  Previous Month's Revenue.
5.  **Growth Rate (%)**: The percentage increase or decrease compared to the previous month.

---

## 💻 The Solution

_Note: This solution is written for PostgreSQL._

```sql
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
```

````

## 📊 Sample Output

| category    | sales_month | total_revenue | prev_month_revenue | growth_percentage |
| ----------- | ----------- | ------------- | ------------------ | ----------------- |
| Electronics | 2024-01-01  | 2650.00       | NULL               | NULL              |
| Electronics | 2024-02-01  | 4800.00       | 2650.00            | 81.13             |
| Electronics | 2024-03-01  | 525.00        | 4800.00            | -89.06            |
| Furniture   | 2024-01-01  | 1200.00       | NULL               | NULL              |
| Furniture   | 2024-02-01  | 300.00        | 1200.00            | -75.00            |
| Furniture   | 2024-03-01  | 2850.00       | 300.00             | 850.00            |

---

## ⚙️ Setup (Reproduce this Analysis)

If you want to run this query, use the following SQL schema:

```sql
-- Create Tables
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    sale_date DATE,
    quantity INT
);

-- Seed Data
INSERT INTO products (name, category, price) VALUES
('Laptop Pro', 'Electronics', 1200.00),
('Wireless Mouse', 'Electronics', 25.00),
('Mechanical Keyboard', 'Electronics', 80.00),
('Ergonomic Chair', 'Furniture', 300.00),
('Standing Desk', 'Furniture', 450.00),
('4K Monitor', 'Electronics', 400.00);

INSERT INTO sales (product_id, sale_date, quantity) VALUES
(1, '2024-01-05', 2), (2, '2024-01-10', 10), (4, '2024-01-15', 1), (5, '2024-01-20', 2), -- Jan
(1, '2024-02-02', 3), (3, '2024-02-05', 5), (6, '2024-02-15', 2), (4, '2024-02-20', 1),  -- Feb
(2, '2024-03-05', 5), (6, '2024-03-10', 1), (5, '2024-03-15', 5), (4, '2024-03-25', 2);  -- Mar

```

```
````
