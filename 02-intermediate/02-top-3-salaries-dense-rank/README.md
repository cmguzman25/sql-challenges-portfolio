# 🏆 Top 3 Salaries per Department

## 📌 Project Overview

**Business Context:** The HR department requires a report to identify the highest-paid employees within each department for an upcoming budget review. The goal is to retrieve the top 3 earners per department, while handling salary ties fairly.

**Key Techniques Used:**

- **Window Functions (`DENSE_RANK`)**: To rank rows within a specific partition (department).
- **Handling Ties**: Implementing logic where employees with identical salaries share the same rank without skipping subsequent numbers (e.g., 1, 1, 2).
- **CTEs**: To isolate the ranking logic before filtering.

## 🛠️ The Challenge

The query needs to return:

1.  Department Name.
2.  Employee Name.
3.  Salary.
4.  **Ranking**: The salary rank within that specific department.

**The Twist (Tie-Breaker Logic):**
If two employees have the same salary, they must share the same rank. The next rank should **not** skip a number.

- _Requirement:_ Rank 1, Rank 1, Rank 2...
- _Why `DENSE_RANK`?_ A standard `RANK()` would skip numbers (1, 1, 3), and `ROW_NUMBER()` would arbitrarily force a unique number (1, 2, 3). `DENSE_RANK` is the only function that meets the business requirement.

---

## 💻 The Solution

_Note: This solution is written for PostgreSQL._

```sql
WITH ranked_employees AS (
    SELECT
        d.name AS department,
        e.name AS employee,
        e.salary,
        -- DENSE_RANK assigns the same rank to ties without skipping the next number
        DENSE_RANK() OVER(
            PARTITION BY d.name
            ORDER BY e.salary DESC
        ) as ranking
    FROM employees e
    JOIN departments d ON e.department_id = d.id
)
SELECT
    department,
    employee,
    salary,
    ranking
FROM ranked_employees
WHERE ranking <= 3;
📊 Sample OutputNotice how in Engineering, Carlos and Ana are tied for 1st place, and Pedro is correctly ranked 2nd.departmentemployeesalaryrankingEngineeringCarlos900001EngineeringAna900001EngineeringPedro850002EngineeringSofia800003Human ResourcesLaura500001Human ResourcesRoberto480002SalesLuis600001SalesMaria580002SalesJorge550003⚙️ Setup (Reproduce this Analysis)If you want to run this query, use the following SQL schema:SQL-- Create Tables
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
```
