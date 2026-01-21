DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS employees;




CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    salary INT,
    department_id INT REFERENCES departments(id)
);

-- Seed Data (With strategic ties)
INSERT INTO departments (name) VALUES
('Engineering'), ('Sales'), ('Human Resources');

INSERT INTO employees (name, salary, department_id) VALUES
-- Engineering (Tie for 1st place)
('Carlos', 90000, 1),
('Ana', 90000, 1),
('Pedro', 85000, 1),
('Sofia', 80000, 1),
('Miguel', 70000, 1),

-- Sales (Standard stepped values)
('Luis', 60000, 2),
('Maria', 58000, 2),
('Jorge', 55000, 2),
('Elena', 40000, 2),

-- HR (Fewer than 3 employees)
('Laura', 50000, 3),
('Roberto', 48000, 3);