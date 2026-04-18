# Customer Behavior Analysis
### SQL + Power BI Project

![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?logo=mysql) ![PowerBI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow?logo=powerbi) ![Python](https://img.shields.io/badge/Python-Jupyter-orange?logo=python) ![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

---

##  Project Overview

This project analyzes **customer shopping behavior** using a MySQL database and visualizes insights through a Power BI dashboard.

**Key goals:**
- Understand customer spending patterns by gender and age group
- Identify high-value discount users
- Compare subscriber vs non-subscriber revenue
- Segment customers into New, Returning, and Loyal
- Find top-rated and most discounted products

---

##  Project Structure

```
customer-behavior-analysis/
│
├──  dashboard.pbix           # Power BI dashboard
├──  project__sql_file.sql    # All SQL analysis queries
├──  customer_project.ipynb   # Python EDA notebook
└──  README.md
```

---

##  Database

- **Database Name:** `costomer_behavior`
- **Table:** `costomer`

| Column | Description |
|--------|-------------|
| `customer_id` | Unique customer identifier |
| `gender` | Male / Female |
| `age_group` | Age bracket |
| `purchase_amount` | Transaction value |
| `item_purchased` | Product name |
| `category` | Product category |
| `review_rating` | Rating (1–5) |
| `subscription_status` | Yes / No |
| `discount_applied` | Yes / No |
| `shipping_type` | Standard / Express |
| `previous_purchases` | Past purchase count |

---

##  SQL Queries

### 1. Revenue by Gender
```sql
SELECT gender, SUM(purchase_amount) AS revenue
FROM costomer
GROUP BY gender;
```

### 2. Discount Users Who Spent Above Average
```sql
SELECT customer_id, purchase_amount
FROM costomer
WHERE discount_applied = 'Yes'
AND purchase_amount >= (SELECT AVG(purchase_amount) FROM costomer);
```

### 3. Top 5 Products by Average Rating
```sql
SELECT item_purchased,
       ROUND(AVG(review_rating), 2) AS "Average product rating"
FROM costomer
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;
```

### 4. Shipping Type vs Average Spend
```sql
SELECT shipping_type, ROUND(AVG(purchase_amount), 2)
FROM costomer
WHERE shipping_type IN ('standard', 'express')
GROUP BY shipping_type;
```

### 5. Subscriber vs Non-Subscriber Spending
```sql
SELECT subscription_status,
       COUNT(customer_id) AS total_customer,
       ROUND(AVG(purchase_amount), 2) AS avg_spend,
       ROUND(SUM(purchase_amount), 2) AS total_revenue
FROM customer
GROUP BY subscription_status
ORDER BY total_revenue DESC;
```

### 6. Top 5 Products by Discount Usage %
```sql
SELECT item_purchased,
       ROUND(SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)
       AS discount_percentage
FROM customer
GROUP BY item_purchased
ORDER BY discount_percentage DESC
LIMIT 5;
```

### 7. Customer Segmentation
```sql
WITH customer_type AS (
  SELECT customer_id, previous_purchases,
    CASE
      WHEN previous_purchases = 1 THEN 'New'
      WHEN previous_purchases BETWEEN 2 AND 4 THEN 'Returning'
      ELSE 'Loyal'
    END AS customer_segment
  FROM customer
)
SELECT customer_segment, COUNT(*) AS "Number of customers"
FROM customer_type
GROUP BY customer_segment;
```

| Segment | Criteria |
|---------|----------|
|  New | 1 previous purchase |
|  Returning | 2–4 previous purchases |
|  Loyal | 5+ previous purchases |

### 8. Top 3 Products per Category
```sql
WITH item_counts AS (
  SELECT category, item_purchased,
         COUNT(customer_id) AS total_orders,
         ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
  FROM customer
  GROUP BY category, item_purchased
)
SELECT item_rank, category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <= 3;
```

### 9. Repeat Buyers & Subscription Correlation
```sql
SELECT subscription_status, COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status;
```

### 10. Revenue by Age Group
```sql
SELECT age_group, SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC;
```

---

## 📊 Power BI Dashboard

The `dashboard.pbix` file connects directly to MySQL and includes:

-  Revenue breakdown by gender
-  Customer segmentation visual (New / Returning / Loyal)
-  Top products by rating and discount usage
-  Subscription vs non-subscription revenue
-  Age group revenue distribution
-  Shipping type spending comparison

---

##  Setup Instructions

### Prerequisites
- MySQL Server 8.0+
- Power BI Desktop
- MySQL Connector/NET 9.6.0
- MySQL ODBC 8.0.43

### Connect Power BI to MySQL

1. Open **Power BI Desktop**
2. Click **Get Data → MySQL database**
3. Enter `localhost` as Server, `costomer_behavior` as Database
4. Select **Database** tab (not Windows)
5. Enter `root` and your MySQL password
6. Click **Connect**

### Run SQL File
```bash
mysql -u root -p costomer_behavior < project__sql_file.sql
```

---

##  Key Insights

-  **Loyal customers** (5+ purchases) are far more likely to be subscribers
-  **Discount users** spending above average are a high-value target segment
-  **Express shipping** customers have a higher average spend than Standard
-  **Top-rated products** are concentrated in specific categories
-  Certain **age groups** contribute disproportionately to total revenue

---

##  Tech Stack

| Tool | Version | Purpose |
|------|---------|---------|
| MySQL | 8.0 | Database & SQL queries |
| Power BI Desktop | Latest | Dashboard & visuals |
| MySQL Connector/NET | 9.6.0 | Power BI driver |
| MySQL ODBC | 8.0.43 | ODBC connectivity |
| Python / Jupyter | 3.x | EDA notebook |

---

> **Author:** Saurabh | Customer Behavior Analysis Project
