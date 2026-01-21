/*
    Project: Top 3 Salaries per Department (Handling Ties)
    Author: [Your Name]
    Description: Retrieves the top 3 highest-paid employees per department.
                 Uses DENSE_RANK to ensure ties share the same rank 
                 without gaps in the sequence.
*/

-- Step 1: Calculate Ranks using a CTE
WITH ranked_employees AS (
    SELECT 
        d.name AS department,
        e.name AS employee,
        e.salary,
        -- PARTITION BY resets the counter for each department
        -- DENSE_RANK handles the "1, 1, 2" requirement (RANK would give 1, 1, 3)
        DENSE_RANK() OVER(
            PARTITION BY d.name 
            ORDER BY e.salary DESC
        ) as ranking
    FROM employees e
    JOIN departments d ON e.department_id = d.id
)
-- Step 2: Filter for the Top 3
SELECT 
    department,
    employee,
    salary,
    ranking
FROM ranked_employees
WHERE ranking <= 3
ORDER BY department, ranking;