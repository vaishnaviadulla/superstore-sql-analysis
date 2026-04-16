🛒 Superstore Sales Analysis (SQL Project)

📌 Project Overview

This project focuses on analyzing a retail Superstore dataset using SQL to extract meaningful business insights.
The goal is to understand sales performance, customer behavior, and profitability across different regions and categories.

---

📂 Dataset

- Sample Superstore dataset (Excel/CSV)
- Contains: Orders, Sales, Profit, Customers, Region, Category, etc.

---

🛠️ Tools Used

- MySQL Workbench
- SQL

---

📊 Key Analysis Performed

🔹 Basic Analysis

- Total Sales & Profit
- Average Sales
- Order counts

🔹 Grouping & Filtering

- Sales by Category
- Sales by Region
- HAVING clause for filtering high-performing groups

🔹 Sorting & Ranking

- Top customers by sales
- Top products by revenue

🔹 Joins

- Combined multiple tables to enrich analysis

🔹 Conditional Logic

- Identified profit vs loss categories using CASE

🔹 Advanced SQL

- CTE (Common Table Expressions) for structured queries
- Window Functions:
  - RANK() → Top performers
  - LAG() → Previous sales comparison

---

💡 Key Insights

- Few products generate most revenue
- Some regions perform better
- Not all categories are profitable
- Customer contribution is uneven


---

📸 Sample Outputs

Total Sales

"Sales" (agg_sales.png)

Category Analysis

"Category" (groupby_category.png)

Region Analysis

"Region" (groupby_region.png)

Top Products

"Products" (top_products.png)

Profit vs Loss

"Case" (case_profit.png)

Ranking

"Rank" (rank_customers.png)

Trend Analysis

"Trend" (lag_sales.png)

---

📁 Files in Repository

- "superstore_analysis.sql" → SQL queries
- "sample_superstore.csv" → Dataset
- Screenshots → Query outputs

---

🚀 Conclusion

This project demonstrates how SQL can be used to analyze real-world data and generate business insights.

---

🚀 Future Improvements

- Build interactive dashboards using Power BI
- Perform advanced analysis using Python
- Optimize SQL queries for better performance
- Automate data loading using ETL tools
