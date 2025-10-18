# 📚 Online Book Store SQL Case Study

<p align="center">
  <i>A complete SQL-based project analyzing an Online Book Store.</i><br>
  <b>Database Project – Book Store Analysis</b>
</p>

---

## 📘 Overview

This project simulates a small **Online Book Store** where customers purchase books across multiple genres.  
The goal is to analyze customer behavior, sales performance, book availability, and revenue trends using **SQL queries**.  

It includes **data creation, relationships, and analytical queries** to draw meaningful business insights from the data.

---

## 🧩 Database Schema

| Table | Columns | Description |
|:--|:--|:--|
| **customers** | customer_id, name, city, country | Customer details and location |
| **books** | book_id, title, author, genre, price, stock, published_year | Book information and inventory |
| **orders** | order_id, customer_id, book_id, order_date, quantity, total_amount | Purchase and sales details |

**Relationships:**
- Each *customer* can place multiple *orders*.
- Each *order* contains one *book*.
- The *books* table connects to *orders* through `book_id`.

---

## 💡 Business Questions & SQL Solutions

All SQL queries for this project are available in the file 👉  
[`online book strore.sql`](./online%20book%20strore.sql)

Below are the major analytical queries used in this project 👇

---

### 1️⃣ Retrieve all books in the 'Fiction' genre
```sql
SELECT * FROM books
WHERE genre = 'Fiction';

2️⃣ Find books published after the year 1950
SELECT * FROM books
WHERE published_year > 1950;

3️⃣ List all customers from Canada
SELECT * FROM customers
WHERE country = 'Canada';

4️⃣ Show orders placed in November 2023
SELECT * FROM orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

5️⃣ Retrieve the total stocks of books available
SELECT SUM(stock) AS total_stock
FROM books;

6️⃣ Find the details of the most expensive book
SELECT * FROM books
ORDER BY price DESC
LIMIT 1;

7️⃣ Show all customers who ordered more than 1 quantity of a book
SELECT * FROM orders
WHERE quantity > 1;

8️⃣ Retrieve all orders where the total amount exceeds $20
SELECT * FROM orders
WHERE total_amount > 20;

9️⃣ List all genres available in the books table
SELECT DISTINCT genre FROM books;

🔟 Find the book with the lowest stock
SELECT * FROM books
ORDER BY stock
LIMIT 1;

1️⃣1️⃣ Calculate the total revenue generated from all orders
SELECT SUM(total_amount) AS revenue
FROM orders;

⚡ Advanced Analysis
1️⃣ Total number of books sold for each genre
SELECT b.genre, SUM(o.quantity) AS total_sold
FROM orders o
JOIN books b ON o.book_id = b.book_id
GROUP BY b.genre;

2️⃣ Average price of books in the 'Fantasy' genre
SELECT AVG(price) AS average_price
FROM books
WHERE genre = 'Fantasy';

3️⃣ Customers who have placed at least 2 orders
SELECT c.name, c.customer_id, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name, c.customer_id
HAVING COUNT(o.order_id) >= 2
ORDER BY total_orders ASC;

4️⃣ Most frequently ordered book
SELECT b.book_id, b.title, SUM(o.quantity) AS total_order
FROM orders o
JOIN books b ON o.book_id = b.book_id
GROUP BY b.book_id, b.title
ORDER BY total_order DESC
LIMIT 1;

5️⃣ Top 3 most expensive books of 'Fantasy' genre
SELECT book_id, title, genre, price
FROM books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;

6️⃣ Total quantity of books sold by each author
SELECT b.author, SUM(quantity) AS total_quantity
FROM orders o
JOIN books b ON o.book_id = b.book_id
GROUP BY b.author;

7️⃣ Cities where customers who spent over $300 are located
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.total_amount > 300;

8️⃣ Customer who spent the most
SELECT c.customer_id, c.name, SUM(total_amount) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 1;
