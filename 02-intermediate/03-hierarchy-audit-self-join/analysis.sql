/*
    Project: Hierarchy Salary Audit
    Description: Identifies employees earning more than their direct managers
                 using a Self-Join technique.
*/

-- We join the table 'employees' to itself.
-- 'emp' represents the worker row.
-- 'mgr' represents the boss row.

SELECT 
    emp.name AS employee_name,
    emp.salary AS employee_salary,
    mgr.name AS manager_name,
    mgr.salary AS manager_salary
FROM employees emp
INNER JOIN employees mgr 
    ON emp.manager_id = mgr.id -- Match employee's boss ID to the boss's personal ID
WHERE emp.salary > mgr.salary; -- The core audit logic