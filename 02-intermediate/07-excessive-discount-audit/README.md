# 📉 Excessive Discount Audit (Order of Execution)

## 📌 Project Overview

**Business Context:** The Finance team suspects that certain sales representatives are abusing discretionary discounts to inflate their sales volume, particularly on high-ticket items. This practice is eating into the company's profit margins.

**The Challenge:**
Create an audit report identifying salespeople who are giving excessively high average discounts. To avoid flagging minor offenses, the report must only highlight cases where the monetary volume is significant and occurred during the fiscal year 2023.

**Key Techniques Used:**

- **SQL Order of Execution**: Understanding the sequence of `FROM` $\rightarrow$ `JOIN` $\rightarrow$ `WHERE` $\rightarrow$ `GROUP BY` $\rightarrow$ `HAVING` $\rightarrow$ `SELECT`.
- **Multi-Table Joins**: Connecting four normalized tables to gather the necessary context.
- **Complex Aggregations**: Calculating dynamic percentages and conditional sums.

---

## 🛠️ Requirements

Write a query that returns:

1.  Salesperson Name.
2.  Product Category.
3.  **Real Revenue**: (Base Price \* Quantity) - Total Discount.
4.  **Average Discount %**: `(Total Discount / Total Base Price) * 100`, rounded to 2 decimal places.

**Filter Conditions:**

- **Timeframe**: Only include sales from the year **2023** (`WHERE` clause).
- **Grouping**: Analyze the data per Salesperson and Category.
- **Thresholds (`HAVING` clause)**:
  - Real Revenue for that category must strictly exceed **$5,000**.
  - Average Discount Percentage must be strictly greater than **15%**.

---

## 📊 Data Preview

### Expected Output

Based on the seed data, Ana is the only representative who meets all criteria (Year = 2023, Revenue > 5000, and Discount > 15%) for the Smartphones category. Her laptop sales fail the revenue threshold, Roberto fails the discount threshold, and Carmen's sales happened in 2024.

| salesperson | category    | real_revenue | avg_discount_pct |
| :---------- | :---------- | :----------- | :--------------- |
| Ana         | Smartphones | 6400.00      | 20.00            |

## 💡 Hints

- You will need three `JOIN` statements.
- Remember that aliases created in the `SELECT` clause cannot be used in the `HAVING` clause in standard PostgreSQL. You must either repeat the formula or wrap the initial query in a CTE (Common Table Expression).
