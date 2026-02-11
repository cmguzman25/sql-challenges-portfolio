/*
    Project: Cumulative Balance History (Running Total)
    Author: [Your Name]
    
    Solution:
    Using SUM() as a window function with an ORDER BY clause creates 
    a "Running Total" effect.
*/

SELECT 
    account_id,
    transaction_date,
    description,
    amount,
    -- Window Function Breakdown:
    -- PARTITION BY account_id: Restarts the calculation for each new account.
    -- ORDER BY transaction_date: Tells the SUM to add up rows cumulatively 
    --                            (row 1, row 1+2, row 1+2+3...) rather than summing the whole group.
    SUM(amount) OVER (
        PARTITION BY account_id 
        ORDER BY transaction_date
    ) as running_balance
FROM transactions
ORDER BY account_id, transaction_date;