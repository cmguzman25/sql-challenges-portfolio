-- Clean up previous runs
DROP TABLE IF EXISTS transactions;

-- 1. Create Table
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    account_id INT,
    transaction_date TIMESTAMP,
    amount DECIMAL(10, 2),
    description VARCHAR(50)
);

-- 2. Insert Data (Mixed accounts and dates)
INSERT INTO transactions (account_id, transaction_date, amount, description) VALUES
-- Account 101 Flow
(101, '2024-02-01 10:00:00', 1000.00, 'Initial Deposit'),
(101, '2024-02-02 14:30:00', -200.00, 'Grocery Store'),
(101, '2024-02-03 09:15:00', 500.00, 'Wire Transfer'),
(101, '2024-02-05 18:00:00', -100.00, 'Utility Bill'),

-- Account 202 Flow
(202, '2024-02-01 11:00:00', 500.00, 'Initial Deposit'),
(202, '2024-02-04 16:20:00', -50.00,  'Uber Ride'),
(202, '2024-02-06 12:00:00', -50.00,  'Coffee Shop');