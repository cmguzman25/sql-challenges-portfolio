# 💰 Cumulative Balance History (Running Total)

## 📌 Project Overview

**Business Context:** In Fintech and Banking, knowing the final balance of an account isn't enough. Customer Support and Fraud Detection teams need to see the _history_ of the balance after every single transaction to understand cash flow anomalies or detect overdrafts at specific points in time.

**The Challenge:**
You need to calculate the running total (cumulative sum) for each bank account, ordered chronologically. The calculation must reset for each new account.

## 📊 Data Preview

### Input Table: `transactions`

This table records every deposit (positive) and withdrawal (negative).

| transaction_id | account_id | transaction_date    | amount  | description     |
| :------------- | :--------- | :------------------ | :------ | :-------------- |
| 1              | 101        | 2024-02-01 10:00:00 | 1000.00 | Initial Deposit |
| 2              | 202        | 2024-02-01 11:00:00 | 500.00  | Initial Deposit |
| 3              | 101        | 2024-02-02 14:30:00 | -200.00 | Grocery Store   |
| 4              | 101        | 2024-02-03 09:15:00 | 500.00  | Wire Transfer   |
| 5              | 202        | 2024-02-04 16:20:00 | -50.00  | Uber Ride       |

### Expected Output

Notice how the `running_balance` updates row by row based on the `amount`.

| account_id | transaction_date    | description     | amount  | running_balance |
| :--------- | :------------------ | :-------------- | :------ | :-------------- |
| 101        | 2024-02-01 10:00:00 | Initial Deposit | 1000.00 | **1000.00**     |
| 101        | 2024-02-02 14:30:00 | Grocery Store   | -200.00 | **800.00**      |
| 101        | 2024-02-03 09:15:00 | Wire Transfer   | 500.00  | **1300.00**     |
| 202        | 2024-02-01 11:00:00 | Initial Deposit | 500.00  | **500.00**      |
| 202        | 2024-02-04 16:20:00 | Uber Ride       | -50.00  | **450.00**      |

## 💡 Hints

- You are not looking for a simple `GROUP BY`.
- You need a Window Function that sums the `amount`.
- Think about how to restart the calculation for every `account_id` (Partitioning).
- Think about how to force the sum to respect the timeline (Ordering).
