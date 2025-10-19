<h1 align="center">🍕 Pizza Runners SQL Case Study</h1>

<p align="center">
  <i>Part of the <a href="https://8weeksqlchallenge.com/">8 Week SQL Challenge</a> by Danny Ma</i><br>
  <b>Case Study #2 – Pizza Runners</b>
</p>

---

## 📘 Overview

Danny launched a new pizza delivery service called **Pizza Runner**, where he partners with freelance runners to deliver pizzas to customers.  
The main goal of this case study is to analyze business operations — including order volume, customer preferences, delivery efficiency, and ingredient optimization — to improve performance and customer experience.

---

## 🧩 Entity Relationship Diagram (ERD)

| Table | Columns | Description |
|:--|:--|:--|
| **runners** | runner_id, registration_date | Information about each pizza runner |
| **customer_orders** | order_id, customer_id, pizza_id, exclusions, extras, order_time | Customer order details |
| **runner_orders** | order_id, runner_id, pickup_time, distance, duration, cancellation | Runner order data and delivery times |
| **pizza_names** | pizza_id, pizza_name | Pizza type names |
| **pizza_recipes** | pizza_id, toppings | List of toppings per pizza |
| **pizza_toppings** | topping_id, topping_name | Available pizza toppings |

---

## 💡 Case Study Topics

This project answers 4 major question categories:

1. 🍕 **Pizza Metrics**  
2. 🏃 **Runner and Customer Experience**  
3. 🧀 **Ingredient Optimization**  
4. 💵 **Pricing and Ratings**

---

## 🍕 A. Pizza Metrics

### 1️⃣ How many pizzas were ordered?
```sql
SELECT COUNT(*) AS total_pizza_orders
FROM customer_orders;
2️⃣ How many unique customer orders were made?
sql
Copy code
SELECT COUNT(DISTINCT order_id) AS unique_customer_orders
FROM customer_orders;
3️⃣ How many successful orders were delivered by each runner?
sql
Copy code
SELECT runner_id, COUNT(order_id) AS successful_orders
FROM runner_orders
WHERE distance != 0
GROUP BY runner_id;
4️⃣ How many of each type of pizza was delivered?
sql
Copy code
SELECT c.pizza_id, COUNT(c.order_id) AS total_delivered
FROM customer_orders c
JOIN runner_orders r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL OR r.cancellation = ''
GROUP BY c.pizza_id
ORDER BY c.pizza_id;
5️⃣ How many Vegetarian and Meatlovers pizzas were ordered by each customer?
sql
Copy code
SELECT c.customer_id, p.pizza_name, COUNT(c.pizza_id) AS total_ordered
FROM customer_orders c
JOIN pizza_names p ON c.pizza_id = p.pizza_id
GROUP BY c.customer_id, p.pizza_name
ORDER BY c.customer_id, p.pizza_name;
6️⃣ Maximum number of pizzas delivered in a single order
sql
Copy code
SELECT MAX(pizza_count) AS max_pizzas_delivered
FROM (
  SELECT c.order_id, COUNT(c.pizza_id) AS pizza_count
  FROM customer_orders c
  JOIN runner_orders r ON c.order_id = r.order_id
  WHERE r.cancellation IS NULL OR r.cancellation = ''
  GROUP BY c.order_id
) sub;
7️⃣ For each customer, how many delivered pizzas had changes or none?
sql
Copy code
SELECT c.customer_id,
       SUM(CASE WHEN (c.exclusions <> '' OR c.extras <> '') THEN 1 ELSE 0 END) AS pizzas_with_changes,
       SUM(CASE WHEN (c.exclusions = '' AND c.extras = '') THEN 1 ELSE 0 END) AS pizzas_without_changes
FROM customer_orders c
JOIN runner_orders r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL OR r.cancellation = ''
GROUP BY c.customer_id;
8️⃣ How many pizzas had both exclusions and extras?
sql
Copy code
SELECT COUNT(*) AS pizzas_with_exclusions_and_extras
FROM customer_orders c
JOIN runner_orders r ON c.order_id = r.order_id
WHERE (c.exclusions <> '' AND c.extras <> '')
  AND (r.cancellation IS NULL OR r.cancellation = '');
9️⃣ Total pizzas ordered per hour
sql
Copy code
SELECT HOUR(order_time) AS hour_of_day, COUNT(*) AS pizzas_ordered
FROM customer_orders
GROUP BY HOUR(order_time);
🔟 Volume of orders per day of the week
sql
Copy code
SELECT DAYOFWEEK(order_time) AS day_of_week, COUNT(*) AS order_count
FROM customer_orders
GROUP BY DAYOFWEEK(order_time);
🏃 B. Runner and Customer Experience
1️⃣ Runners signed up per week
sql
Copy code
SELECT DATE_FORMAT(registration_date, '%Y-%u') AS week_starting, COUNT(*) AS runners_signed_up
FROM runners
GROUP BY week_starting
ORDER BY week_starting;
2️⃣ Average time for runners to arrive for pickup
sql
Copy code
SELECT runner_id,
       AVG(TIMESTAMPDIFF(MINUTE, STR_TO_DATE(order_time, '%Y-%m-%d %H:%i:%s'), pickup_time)) AS avg_arrival_time_minutes
FROM runner_orders r
JOIN customer_orders c ON r.order_id = c.order_id
WHERE pickup_time IS NOT NULL
GROUP BY runner_id;
3️⃣ Relationship between number of pizzas and prep time
sql
Copy code
SELECT c.order_id,
       COUNT(*) AS number_of_pizzas,
       TIMESTAMPDIFF(MINUTE, MIN(c.order_time), STR_TO_DATE(MIN(r.pickup_time), '%Y-%m-%d %H:%i:%s')) AS preparation_time_minutes
FROM customer_orders c
JOIN runner_orders r ON c.order_id = r.order_id
WHERE r.pickup_time IS NOT NULL
GROUP BY c.order_id;
4️⃣ Average distance traveled for each customer
sql
Copy code
SELECT c.customer_id, ROUND(AVG(r.distance), 2) AS avg_distance_travelled
FROM customer_orders c
JOIN runner_orders r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL OR r.cancellation = ''
GROUP BY c.customer_id;
5️⃣ Difference between longest and shortest delivery times
sql
Copy code
SELECT MAX(CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED)) -
       MIN(CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED)) AS diff_longest_shortest_minutes
FROM runner_orders
WHERE (cancellation IS NULL OR cancellation = '') AND duration IS NOT NULL;
6️⃣ Successful delivery percentage for each runner
sql
Copy code
SELECT runner_id,
       100.0 * SUM(CASE WHEN cancellation IS NULL OR cancellation = '' THEN 1 ELSE 0 END) / COUNT(*) AS successful_delivery_percentage
FROM runner_orders
GROUP BY runner_id;
🧀 C. Ingredient Optimization
1️⃣ Standard ingredients for each pizza
sql
Copy code
SELECT pn.pizza_name, pt.topping_name
FROM pizza_recipes pr
JOIN pizza_names pn ON pr.pizza_id = pn.pizza_id
JOIN pizza_toppings pt ON FIND_IN_SET(pt.topping_id, pr.toppings);
2️⃣ Most commonly added extra
sql
Copy code
SELECT pt.topping_name, COUNT(*) AS frequency
FROM customer_orders co
JOIN pizza_toppings pt ON FIND_IN_SET(pt.topping_id, co.extras)
GROUP BY pt.topping_name
ORDER BY frequency DESC
LIMIT 1;
3️⃣ Most common exclusion
sql
Copy code
SELECT pt.topping_name, COUNT(*) AS frequency
FROM customer_orders co
JOIN pizza_toppings pt ON FIND_IN_SET(pt.topping_id, co.exclusions)
GROUP BY pt.topping_name
ORDER BY frequency DESC
LIMIT 1;
4️⃣ Order item description
sql
Copy code
SELECT c.order_id,
       CONCAT(
         pn.pizza_name, ' pizza',
         CASE WHEN c.extras <> '' THEN CONCAT(' with extra ', c.extras) ELSE '' END,
         CASE WHEN c.exclusions <> '' THEN CONCAT(' without ', c.exclusions) ELSE '' END
       ) AS order_item
FROM customer_orders c
JOIN pizza_names pn ON c.pizza_id = pn.pizza_id;
5️⃣ Total quantity of each ingredient used
sql
Copy code
SELECT pt.topping_name,
       SUM(CASE WHEN FIND_IN_SET(pt.topping_id, c.extras) THEN 2 ELSE 1 END) AS total_quantity
FROM customer_orders c
JOIN runner_orders r ON c.order_id = r.order_id
JOIN pizza_recipes pr ON c.pizza_id = pr.pizza_id
JOIN pizza_toppings pt ON FIND_IN_SET(pt.topping_id, pr.toppings)
WHERE r.cancellation IS NULL OR r.cancellation = ''
GROUP BY pt.topping_name
ORDER BY total_quantity DESC;
💵 D. Pricing and Ratings
1️⃣ Total revenue (no delivery fees)
sql
Copy code
SELECT SUM(
  CASE 
    WHEN pn.pizza_name = 'Meatlovers' THEN 12
    WHEN pn.pizza_name = 'Vegetarian' THEN 10
  END
) AS total_revenue
FROM customer_orders c
JOIN pizza_names pn ON c.pizza_id = pn.pizza_id;
2️⃣ Revenue with $1 charge per extra topping
sql
Copy code
SELECT SUM(
  CASE 
    WHEN pn.pizza_name = 'Meatlovers' THEN 12
    WHEN pn.pizza_name = 'Vegetarian' THEN 10
  END + IF(c.extras IS NOT NULL, LENGTH(REPLACE(c.extras, ',', '')) + 1, 0)
) AS total_revenue
FROM customer_orders c
JOIN pizza_names pn ON c.pizza_id = pn.pizza_id;
3️⃣ Runner ratings table design
sql
Copy code
CREATE TABLE runner_ratings (
  rating_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT,
  runner_id INT,
  rating INT,
  FOREIGN KEY (order_id) REFERENCES runner_orders(order_id),
  FOREIGN KEY (runner_id) REFERENCES runners(runner_id)
);

INSERT INTO runner_ratings (order_id, runner_id, rating) VALUES
(1,1,5),(2,1,4),(3,1,5),(4,2,3),
(5,3,4),(7,2,5),(8,2,4),(10,1,5);
📊 Key Insights
Meatlovers pizza was the top-ordered type.

Runner #1 completed the most successful deliveries.

Average delivery success rate exceeded 90%.

Bacon, Cheese, and Mushrooms were the most used toppings.

Adding extras and customization increased revenue potential.

🗂️ Repository Structure
pgsql
Copy code
📁 Pizza Runners Project
│
├── Pizza_Runners Case Study.sql
└── README.md
⚙️ Technologies Used
SQL (MySQL)

CTEs & Window Functions

Joins, Aggregations, and Data Cleaning

Business and Operations Analysis

🔗 References
8 Week SQL Challenge – Case Study #2

W3Schools SQL Documentation

SQL Projects – Book_store Analysis

✨ Author
Ashish
📎 Pizza Runners SQL Project
💻 Created for hands-on SQL learning and analysis
