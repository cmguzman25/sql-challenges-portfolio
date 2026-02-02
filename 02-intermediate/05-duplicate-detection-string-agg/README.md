# 🧹 Duplicate Detection & ID Concatenation

## 📌 Project Overview

**Business Context:** A bug in the user registration system allowed multiple accounts to be created with the same email address but different user IDs. The Data Quality team needs a report to identify these duplicates to merge or purge them.

**Key Techniques Used:**

- **`GROUP BY` & `HAVING`**: To filter groups based on aggregate conditions (count > 1).
- **`STRING_AGG`**: A powerful PostgreSQL function to concatenate values from multiple rows into a single string.
- **Type Casting (`::TEXT`)**: Converting integers to text to allow concatenation.

## 🛠️ The Challenge

The query needs to return:

1.  The Email address (only for duplicates).
2.  The Count of occurrences.
3.  **ID List**: A comma-separated string of all `user_ids` associated with that email (e.g., "10, 15, 33").

---

## 💻 The Solution

_Note: This solution is written for PostgreSQL._

```sql
SELECT
    email,
    COUNT(*) AS total_duplicates,
    -- Concatenates IDs into a readable list: "1, 6"
    STRING_AGG(user_id::TEXT, ', ' ORDER BY user_id ASC) AS id_list
FROM beta_users
GROUP BY email
HAVING COUNT(*) > 1; -- Filter to keep only duplicates
📊 Sample OutputNotice how unique users (like Pedro or Sofia) are excluded, and Ana's three IDs are aggregated into one cell.emailtotal_duplicatesid_listana@test.com32, 4, 7carlos@test.com21, 6⚙️ Setup (Reproduce this Analysis)If you want to run this query, use the following SQL schema:SQL-- Create Table

DROP TABLE IF EXISTS beta_users;

CREATE TABLE beta_users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100),
    signup_date DATE
);

-- Seed Data (With intentional duplicates)
INSERT INTO beta_users (name, email, signup_date) VALUES
('Carlos', 'carlos@test.com', '2024-01-01'),        -- ID 1
('Ana', 'ana@test.com', '2024-01-02'),              -- ID 2
('Pedro', 'pedro@test.com', '2024-01-03'),          -- ID 3
('Ana Duplicate', 'ana@test.com', '2024-01-05'),    -- ID 4 (Duplicate)
('Luis', 'luis@test.com', '2024-01-06'),            -- ID 5
('Carlos Clone', 'carlos@test.com', '2024-01-07'),  -- ID 6 (Duplicate)
('Ana Triple', 'ana@test.com', '2024-01-10'),       -- ID 7 (Triplicate)
('Sofia', 'sofia@test.com', '2024-01-11');          -- ID 8
```
