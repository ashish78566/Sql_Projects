<h1 align="center">🍜 Danny's Diner SQL Case Study</h1>

<p align="center">
  <i>Part of the <a href="https://8weeksqlchallenge.com/">8 Week SQL Challenge</a> by Danny Ma</i><br>
  <b>Case Study #1 – Danny’s Diner</b>
</p>

---

## 📘 Overview

Danny, the owner of a small Japanese restaurant, wants to analyze customer spending, visiting patterns, and menu preferences.  
Using the `sales`, `menu`, and `members` tables, SQL queries are written to help Danny make data-driven business decisions.

---

## 🧩 Entity Relationship Diagram (ERD)

| Table | Columns | Description |
|:--|:--|:--|
| **sales** | customer_id, order_date, product_id | Records of customer orders |
| **menu** | product_id, product_name, price | Menu items and prices |
| **members** | customer_id, join_date | Membership details |

---

## 💡 Business Questions & SQL Solutions

All SQL queries for this case study are available here 👉 [dannys dinner.sql](./dannys%20dinner.sql)

Below are the queries from that file 👇

---

### 1️⃣ What is the total amount each customer spent at the restaurant?

```sql
SELECT s.customer_id, SUM(price) AS total_amount
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;
2️⃣ How many days has each customer visited the restaurant?
sql
Copy code
SELECT customer_id, COUNT(DISTINCT order_date) AS visit_days
FROM sales
GROUP BY customer_id;
3️⃣ What was the first item from the menu purchased by each customer?
sql
Copy code
SELECT customer_id, product_name 
FROM (
  SELECT *, RANK() OVER(PARTITION BY customer_id ORDER BY order_date ASC) AS rn
  FROM sales s 
  INNER JOIN menu m USING(product_id)
) AS t
WHERE rn = 1 
GROUP BY customer_id, product_name;
4️⃣ What is the most purchased item on the menu and how many times was it purchased by all customers?
sql
Copy code
SELECT product_name, COUNT(*) AS most_purchased_item
FROM menu m 
INNER JOIN sales s USING (product_id)
GROUP BY product_name
ORDER BY COUNT(*) DESC
LIMIT 1;
5️⃣ Which item was the most popular for each customer?
sql
Copy code
SELECT customer_id, product_name, no_of_purchased
FROM (
  SELECT customer_id, product_name, COUNT(*) AS no_of_purchased,
         DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY COUNT(*) DESC) AS drnk
  FROM sales s 
  INNER JOIN menu m USING (product_id)
  GROUP BY customer_id, product_name
) AS t
WHERE drnk = 1;
6️⃣ Which item was purchased first by the customer after they became a member?
sql
Copy code
SELECT customer_id, product_name
FROM (
  SELECT *, DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY order_date ASC) AS drnk
  FROM sales s 
  INNER JOIN menu USING (product_id)
  INNER JOIN members mb USING(customer_id)
  WHERE s.order_date > mb.join_date
) AS t
WHERE drnk = 1;
7️⃣ Which item was purchased just before the customer became a member?
sql
Copy code
SELECT customer_id, product_name
FROM (
  SELECT *, ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date DESC) AS rn
  FROM sales s 
  INNER JOIN menu m USING (product_id)
  INNER JOIN members mb USING(customer_id)
  WHERE s.order_date < mb.join_date
) AS t
WHERE rn = 1;
8️⃣ What is the total items and amount spent for each member before they became a member?
sql
Copy code
SELECT customer_id, COUNT(*) AS total_items, SUM(price) AS total_amount_spent
FROM sales s 
INNER JOIN menu m USING (product_id)
INNER JOIN members mb USING(customer_id)
WHERE order_date < join_date
GROUP BY customer_id;
9️⃣ If each $1 spent equates to 10 points and sushi has a 2x points multiplier, how many points would each customer have?
sql
Copy code
SELECT customer_id,
       SUM(CASE WHEN product_name = 'sushi' THEN price * 20 ELSE price * 10 END) AS total_points
FROM sales s
INNER JOIN menu m USING (product_id)
GROUP BY customer_id;
🔟 In the first week after a customer joins the program (including their join date), they earn 2x points on all items — how many points do customer A and B have at the end of January?
sql
Copy code
SELECT customer_id,
       SUM(
         CASE
           WHEN join_date BETWEEN join_date AND DATE_ADD(join_date, INTERVAL 7 DAY) THEN price * 20
           WHEN product_name = 'sushi' THEN price * 20
           ELSE price * 10
         END
       ) AS total_points
FROM sales s
INNER JOIN menu m USING (product_id)
INNER JOIN members mb USING (customer_id)
WHERE MONTH(order_date) = '01'
GROUP BY customer_id;
📊 Key Insights
Customer A enjoys Ramen and joined the loyalty program early.

Customer B has the highest frequency of visits.

Ramen is the most popular and profitable menu item.

Membership encourages repeat purchases and increases customer engagement.

🗂️ Repository Structure
pgsql
Copy code
📁 Danny’s Diner Project
│
├── dannys dinner.sql
└── README.md
⚙️ Technologies Used
SQL (MySQL / PostgreSQL)

Joins & Aggregations

Ranking Functions

Data Analysis Queries

🔗 References
8 Week SQL Challenge – Case Study #1

W3Schools SQL Documentation

SQL Projects – Book_store Analysis

✨ Author
Ashish
📎 Danny’s Diner SQL Project
💻 Created for hands-on SQL learning and analysis
