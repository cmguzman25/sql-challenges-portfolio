# 🕵️ Hierarchy Salary Audit (Self-Join)

## 📌 Project Overview

**Business Context:** The HR Audit department has flagged potential anomalies in the salary structure. They need to identify cases where a subordinate earns more than their direct manager. This structural imbalance often indicates a need for salary leveling or role re-evaluation.

**Key Techniques Used:**

- **Self-Join**: Joining a table to itself to compare rows within the same dataset.
- **Hierarchical Data**: Navigating parent-child relationships (Manager-Employee) in a flat table structure.

## 🛠️ The Challenge

The query needs to return:

1.  Employee Name.
2.  Employee Salary.
3.  Manager Name.
4.  Manager Salary.

**Condition:**
Filter only for employees whose salary is strictly **greater** than their direct manager's salary.

---

## 💻 The Solution

_Note: This solution is written for PostgreSQL._

To solve this, we treat the `employees` table as two separate entities:

1.  `emp` (The Subordinate)
2.  `mgr` (The Manager)

We join them on the condition: `emp.manager_id = mgr.id`.

```sql
SELECT
    emp.name AS employee_name,
    emp.salary AS employee_salary,
    mgr.name AS manager_name,
    mgr.salary AS manager_salary
FROM employees emp
JOIN employees mgr ON emp.manager_id = mgr.id
WHERE emp.salary > mgr.salary;
📊 Sample OutputIn this dataset, the "Star Employee" earns 80k while their manager only earns 70k, and the "Senior Tech" out-earns Manager A.employee_nameemployee_salarymanager_namemanager_salaryStar Employee80000Manager B70000Senior Tech95000Manager A90000⚙️ Setup (Reproduce this Analysis)If you want to run this query, use the following SQL schema:SQL-- Create Table
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    salary INT,
    manager_id INT -- References the 'id' of the same table
);

-- Seed Data (Hierarchy)
INSERT INTO employees (id, name, salary, manager_id) VALUES
(1, 'The CEO', 200000, NULL),        -- No manager
(2, 'Manager A', 90000, 1),          -- Reports to CEO
(3, 'Manager B', 70000, 1),          -- Reports to CEO
(4, 'Star Employee', 80000, 3),      -- Reports to Manager B (Target: 80k > 70k)
(5, 'Junior Dev', 40000, 2),         -- Reports to Manager A
(6, 'Senior Tech', 95000, 2);        -- Reports to Manager A (Target: 95k > 90k)
```
