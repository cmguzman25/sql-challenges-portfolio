-- Clean up previous runs
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS salespeople;

-- 1. Create Tables
CREATE TABLE salespeople (
    salesperson_id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    category_id INT REFERENCES categories(category_id),
    base_price DECIMAL(10,2)
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    salesperson_id INT REFERENCES salespeople(salesperson_id),
    sale_date DATE,
    quantity INT,
    total_discount DECIMAL(10,2) 
);

-- 2. Seed Data
INSERT INTO salespeople (name) VALUES ('Ana'), ('Roberto'), ('Carmen');
INSERT INTO categories (name) VALUES ('Laptops'), ('Smartphones'), ('Accessories');

INSERT INTO products (name, category_id, base_price) VALUES
('Laptop Pro', 1, 1000.00), 
('Phone X', 2, 800.00), 
('Headphones', 3, 50.00);

-- Sales Data
INSERT INTO sales (product_id, salesperson_id, sale_date, quantity, total_discount) VALUES
-- Ana: Laptops (2023). Total Price = 6000. Discount = 1200 (20%). Real Rev = 4800.
-- Fails HAVING: Revenue <= 5000.
(1, 1, '2023-05-10', 6, 1200.00),

-- Ana: Smartphones (2023). Total Price = 8000. Discount = 1600 (20%). Real Rev = 6400.
-- Passes ALL conditions. -> MUST APPEAR IN OUTPUT.
(2, 1, '2023-06-15', 10, 1600.00),

-- Roberto: Laptops (2023). Total Price = 10000. Discount = 1000 (10%). Real Rev = 9000.
-- Fails HAVING: Discount <= 15%.
(1, 2, '2023-08-20', 10, 1000.00),

-- Carmen: Smartphones (2024). Total Price = 8000. Discount = 2000 (25%). Real Rev = 6000.
-- Fails WHERE: Year is 2024.
(2, 3, '2024-01-10', 10, 2000.00);