# 📊 Logistics Dashboard (Manual Pivoting)

## 📌 Project Overview

**Business Context:** The Operations team needs a high-level summary of order statuses per client. Currently, the data is stored in a transactional format (one row per order). The goal is to transform this into a report with one row per client, showing columns for each status count.

**Key Techniques Used:**

- **Conditional Aggregation (`CASE WHEN`)**: The standard SQL method to pivot rows into columns without a native `PIVOT` function.
- **PostgreSQL `FILTER` Clause**: A modern, cleaner syntax for conditional counting (Specific to Postgres).
- **Data Transformation**: converting "Long Format" data into "Wide Format".

## 🛠️ The Challenge

The query needs to return one row per client with:

1.  Client Name.
2.  Count of 'Pending' orders.
3.  Count of 'Shipped' orders.
4.  Count of 'Delivered' orders.
5.  **Grand Total** of orders.

---

## 💻 The Solution

_Note: This solution provides two approaches. The 'Standard SQL' approach works in almost any database (Snowflake, BigQuery, SQL Server), while the 'Modern Postgres' approach is cleaner and more readable._

### Approach 1: Standard SQL (Universal)

```sql
SELECT
    client_name,
    -- "Pivoting" logic: If the condition matches, count 1, else 0.
    SUM(CASE WHEN status = 'Pending'   THEN 1 ELSE 0 END) AS pending_orders,
    SUM(CASE WHEN status = 'Shipped'   THEN 1 ELSE 0 END) AS shipped_orders,
    SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_orders,
    COUNT(*) AS total_orders
FROM orders
GROUP BY client_name
ORDER BY total_orders DESC;
Approach 2: PostgreSQL FILTER (Cleaner)SQLSELECT
    client_name,
    COUNT(*) FILTER (WHERE status = 'Pending')   AS pending_orders,
    COUNT(*) FILTER (WHERE status = 'Shipped')   AS shipped_orders,
    COUNT(*) FILTER (WHERE status = 'Delivered') AS delivered_orders,
    COUNT(*) AS total_orders
FROM orders
GROUP BY client_name;
📊 Sample Outputclient_namepending_ordersshipped_ordersdelivered_orderstotal_ordersTechCorp1023Innovatech1113DataWiz3003SoftSolutions0202⚙️ Setup (Reproduce this Analysis)If you want to run this query, use the following SQL schema:SQL-- Create Table

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    client_name VARCHAR(50),
    status VARCHAR(20),
    amount DECIMAL(10,2)
);



-- Seed Data
INSERT INTO orders (client_name, status, amount) VALUES
('TechCorp', 'Delivered', 500.00),
('TechCorp', 'Delivered', 200.00),
('TechCorp', 'Pending', 1200.00),
('SoftSolutions', 'Shipped', 300.00),
('SoftSolutions', 'Shipped', 150.00),
('DataWiz', 'Pending', 50.00),
('DataWiz', 'Pending', 50.00),
('DataWiz', 'Pending', 100.00),
('Innovatech', 'Delivered', 2000.00),
('Innovatech', 'Shipped', 1000.00),
('Innovatech', 'Pending', 500.00);
```
