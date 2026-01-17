DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;


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