create database danny_dinner;
use danny_dinner;
CREATE SCHEMA dannys_diner;
SET search_path = dannys_diner;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 select * from sales;

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  
  select * from menu;
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
  select * from menu;
  
  select * from sales;
  select * from members;
  select * from menu;
  
  # 1. What is the total amount each customer spent at the restaurant?
  select s.customer_id, sum(price) as taotal_amount
  from sales s
  join menu m
  on s.product_id=m.product_id
  group by s.customer_id;
  
  #2.How many days has each customer visited the restaurant?
  select customer_id, count(distinct order_date) as visit_days
  from sales 
  group by customer_id;
  
  #3.What was the first item from the menu purchased by each customer?
select customer_id,product_name from (
select *,rank() over(partition by customer_id order by order_date asc) as rn
from sales s inner join menu m using(product_id)) as t
where rn = 1 group by customer_id,product_name;
  
# 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
select product_name, count(*) as most_purchased_item
from menu m inner join sales s using (product_id)
group by product_name
order by count(*) desc
limit 1;

# 5. Which item was the most popular for each customer?
select customer_id,product_name,no_of_purchased from (
select customer_id,product_name,count(*) as no_of_purchased,
dense_rank() over(partition by customer_id order by count(*) desc) as drnk
from sales s inner join menu m
using (product_id) group by customer_id,product_name) as t where drnk = 1;

# 6. Which item was purchased first by the customer after they became a member?
select customer_id,product_name from (
select *,dense_rank() over(partition by customer_id order by order_date asc) as drnk
from sales s inner join menu using (product_id)
inner join members mb using(customer_id) where s.order_date>mb.join_date) as t 
where drnk=1;

# 7. Which item was purchased just before the customer became a member?
select customer_id,product_name from (
select *,row_number() over(partition by customer_id order by order_date desc) as rn
from sales s inner join menu m using (product_id)
inner join members mb using(customer_id) where s.order_date<mb.join_date) as t
where rn = 1; 

# 8. What is the total items and amount spent for each member before they became a member?
select customer_id, count(*) as total_items,sum(price) as total_amount_spent
from sales s inner join menu m using (product_id)
inner join members mb using(customer_id) 
where order_date< join_date
group by customer_id;

# 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT 
    customer_id,
    SUM(CASE
        WHEN product_name = 'Sushi' THEN price * 20
        ELSE Price * 10
    END) AS Total_Points
FROM
    sales s
        INNER JOIN
    menu m USING (product_id)
GROUP BY customer_id;

# 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi 
-- how many points do customer A and B have at the end of January?*/
  
SELECT 
    customer_id,
    SUM(CASE
        WHEN join_date BETWEEN join_date AND DATE_ADD(join_date, INTERVAL 7 DAY) THEN price * 20
        WHEN product_name = 'sushi' THEN price * 20
        ELSE price * 10
    END) AS total_points
FROM
    sales s
        INNER JOIN
    menu m USING (product_id)
        INNER JOIN
    members mb USING (customer_id)
WHERE
    MONTH(order_date) = '01'
GROUP BY customer_id;
  
  