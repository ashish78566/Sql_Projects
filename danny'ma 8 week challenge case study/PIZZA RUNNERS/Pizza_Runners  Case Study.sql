create database Pizza_Runners;
use pizza_runners;

CREATE TABLE runners (
  runner_id INTEGER,
  registration_date DATE
);
INSERT INTO runners
  (runner_id, registration_date)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');
  
select * from runners;

CREATE TABLE customer_orders (
  order_id INTEGER,
  customer_id INTEGER,
  pizza_id INTEGER,
  exclusions VARCHAR(4),
  extras VARCHAR(4),
  order_time TIMESTAMP
);

INSERT INTO customer_orders
  (order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');
  
  select * from customer_orders;
  
  CREATE TABLE runner_orders (
  order_id INTEGER,
  runner_id INTEGER,
  pickup_time VARCHAR(19),
  distance VARCHAR(7),
  duration VARCHAR(10),
  cancellation VARCHAR(23)
);

INSERT INTO runner_orders
  (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');
  
  select * from runner_orders;
  
  
  CREATE TABLE pizza_names (
  pizza_id INTEGER,
  pizza_name TEXT
);
INSERT INTO pizza_names
  (pizza_id, pizza_name)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');
  
  select * from pizza_names;
  
  CREATE TABLE pizza_recipes (
  pizza_id INTEGER,
  toppings TEXT
);
INSERT INTO pizza_recipes
  (pizza_id, toppings)
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');
  
  select * from pizza_recipes;
  
  
  CREATE TABLE pizza_toppings (
  topping_id INTEGER,
  topping_name TEXT
);
INSERT INTO pizza_toppings
  (topping_id, topping_name)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  
  select * from pizza_toppings;
  
  
# 1. How many pizzas were ordered?
select * from customer_orders;
select count(*) as total_pizza_orders
from customer_orders;

# 2. How many unique customer orders were made?
select  count(distinct order_id) as unique_customer_orders from customer_orders;

#3.How many successful orders were delivered by each runner?
select * from runners;
select  runner_id, count(order_id) as successful_orders
from runner_orders
where distance!=0
group by runner_id;

#4.How many of each type of pizza was delivered?
select * from customer_orders;
select * from runner_orders;
select c.pizza_id,count(c.order_id) as total_delivered from customer_orders c
join runner_orders r on c.order_id=r.order_id
where r.cancellation is null or r.cancellation= ''
group by c.pizza_id
order by c.pizza_id;

#5.How many Vegetarian and Meatlovers were ordered by each customer?
select * from customer_orders;
select * from pizza_names;

select c.customer_id,p.pizza_name ,count(c.pizza_id) as total_ordered
from customer_orders c
join pizza_names p on c.pizza_id=p.pizza_id
group by c.customer_id,p.pizza_name
order by c.customer_id,p.pizza_name;

#6.What was the maximum number of pizzas delivered in a single order?
SELECT 
    MAX(pizza_count) AS max_pizzas_delivered
FROM (
    SELECT 
        c.order_id,
        COUNT(c.pizza_id) AS pizza_count
    FROM customer_orders c
    JOIN runner_orders r
        ON c.order_id = r.order_id
    WHERE r.cancellation IS NULL OR r.cancellation = ''
    GROUP BY c.order_id
) sub;

#7.For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT c.customer_id,SUM(CASE WHEN (c.exclusions IS NOT NULL AND c.exclusions <> '') OR (c.extras IS NOT NULL AND c.extras <> '') THEN 1 ELSE 0 END) AS pizzas_with_changes,
    SUM(
        CASE 
            WHEN (c.exclusions IS NULL OR c.exclusions = '') 
             AND (c.extras IS NULL OR c.extras = '') 
            THEN 1 ELSE 0 
        END
    ) AS pizzas_without_changes
FROM customer_orders c
JOIN runner_orders r 
    ON c.order_id = r.order_id
WHERE r.cancellation IS NULL OR r.cancellation = ''
GROUP BY c.customer_id
ORDER BY c.customer_id;

# 8. How many pizzas were delivered that had both exclusions and extras?
select count(*) as pizzas_with_exclusions_and_extras
from customer_orders c
join runner_orders r on c.order_id=r.order_id
where (c.exclusions is not null and c.extras is not null and c.exclusions!='' and c.extras!='') 
  AND (r.cancellation IS NULL OR r.cancellation = '');
  
# 9. What was the total volume of pizzas ordered for each hour of the day?  
select hour(order_time) as hour_of_day ,count(*) as pizzas_ordered
from customer_orders
group by hour(order_time);
# 10. What was the volume of orders for each day of the week?
select dayofweek(order_time) as day_of_week,count(*) as order_count
from customer_orders
group by dayofweek(order_time); 
  
  #B. Runner and Customer Experience
  
-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
select * from runners;

SELECT DATE_FORMAT(registration_date, '%Y-%u') AS week_starting,COUNT(*) AS runners_signed_up #DATE_FORMAT(..., '%Y-%u') → formats the date as YYYY-week_number
FROM runners
GROUP BY week_starting
ORDER BY week_starting;
#2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pick up the order?
select runner_id,avg(timestampdiff(minute,str_to_date(order_time,'%y-%m-%d %h:%i:%s'),pickup_time)) as avg_arrival_time_minutes
from runner_orders r
join customer_orders c on r.order_id=c.order_id
where pickup_time is not null
group by runner_id;

# 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
SELECT c.order_id,COUNT(*) AS number_of_pizzas,TIMESTAMPDIFF(MINUTE, MIN(c.order_time), STR_TO_DATE(MIN(r.pickup_time), '%Y-%m-%d %H:%i:%s')) AS preparation_time_minutes
FROM customer_orders c
JOIN runner_orders r ON c.order_id = r.order_id
WHERE r.pickup_time IS NOT NULL
GROUP BY c.order_id;

# 4. What was the average distance travelled for each customer?
select round(avg(r.distance),2) as avg_distance_travelled from customer_orders c
join runner_orders r on c.order_id=r.order_id
where r.cancellation is null or r.cancellation=''
group by c.customer_id
order by c.customer_id;

# 5. What was the difference between the longest and shortest delivery times for all orders?
SELECT MAX(CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED)) - MIN(CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED)) AS diff_longest_shortest_minutes
FROM runner_orders
WHERE (cancellation IS NULL OR cancellation = '') AND duration IS NOT NULL;
 
 #6.Is there any relationship between the number of pizzas and how long the order takes to prepare?

SELECT c.order_id,COUNT(*) AS num_pizzas,CAST(SUBSTRING_INDEX(r.duration, ' ', 1) AS UNSIGNED) AS duration_mins
FROM customer_orders c
JOIN runner_orders r 
    ON c.order_id = r.order_id
WHERE r.duration IS NOT NULL
  AND (r.cancellation IS NULL OR r.cancellation = '')
GROUP BY c.order_id, r.duration;

 #7. What is the successful delivery percentage for each runner?

SELECT runner_id,100.0 * SUM(CASE WHEN cancellation IS NULL OR cancellation = '' THEN 1 ELSE 0 END) / COUNT(*) AS successful_delivery_percentage
FROM runner_orders
GROUP BY runner_id;

#  C. Ingredient Optimisation


# 1. What are the standard ingredients for each pizza?

SELECT pn.pizza_name,pt.topping_name
FROM pizza_recipes pr
JOIN pizza_names pn ON pr.pizza_id = pn.pizza_id
JOIN pizza_toppings pt ON FIND_IN_SET(pt.topping_id, pr.toppings);

# 2. What was the most commonly added extra?
SELECT pt.topping_name, COUNT(*) AS frequency
FROM customer_orders co
JOIN pizza_toppings pt ON FIND_IN_SET(pt.topping_id, co.extras)
GROUP BY pt.topping_name
ORDER BY frequency DESC
LIMIT 1;

# 3. What was the most common exclusion?
SELECT pt.topping_name, COUNT(*) AS frequency
FROM customer_orders co
JOIN pizza_toppings pt ON FIND_IN_SET(pt.topping_id, co.exclusions)
GROUP BY pt.topping_name
ORDER BY frequency DESC
LIMIT 1;


# 4. Generate an order item for each record in the customer_orders table in the specified format

SELECT 
    c.order_id,
    CONCAT(
        pn.pizza_name,
        ' pizza',
        CASE 
            WHEN c.extras IS NOT NULL AND c.extras <> '' THEN CONCAT(' with extra ', c.extras)
            ELSE ''
        END,
        CASE 
            WHEN c.exclusions IS NOT NULL AND c.exclusions <> '' THEN CONCAT(' without ', c.exclusions)
            ELSE ''
        END
    ) AS order_item
FROM customer_orders c
JOIN pizza_names pn ON c.pizza_id = pn.pizza_id;

 #6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
select  pt.topping_name,sum(case when find_in_set(pt.topping_id,c.extras) then 2 else 1 end) as total_quantity
from customer_orders c
join runner_orders r on c.order_id=r.order_id
join pizza_recipes pr on c.pizza_id=pr.pizza_id
join pizza_toppings pt on find_in_set(pt.topping_id,pr.toppings)
where r.cancellation is null or r.cancellation=''
group by pt.topping_name
order by total_quantity desc;

# D. Pricing and Ratings

# 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes, how much money has Pizza Runner made so far if there are no delivery fees?
select sum(case when pn.pizza_name='meatlovers' then 12 when pn.pizza_name='vegetarian' then 10 end ) as total_revenue
from customer_orders c
join pizza_names pn on c.pizza_id=pn.pizza_id;

#2. What if there was an additional $1 charge for any pizza extras? - Add cheese is $1 extra
select sum(case when pn.pizza_name='meatlovers' then 12 when pn.pizza_name='vegatarian' then 10 end + if(c.extras is not null, length(replace(c.extras,',',''))+1,0)) as total_revenue
from customer_orders c
join pizza_names pn on c.pizza_id=pn.pizza_id;

# 3. The Pizza Runner team now wants to add an additional ratings system that allows 
-- customers to rate their runner. Design an additional table for this new dataset - generate a 
-- schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
 
 #step 1: Add Indexes
 alter table runner_orders add index (order_id);
 alter table runners add index (runner_id);

#step 2:create the 'runner_ratings table with foreign keys'
create table runner_ratings(
rating_id int auto_increment primary key,
order_id int,
runner_id int,
rating int,
foreign key(order_id) references runner_orders(order_id),
foreign key(runner_id) references runners(runner_id)
);

#step 3: insert sample data into the 'runner_ratings' Table 
insert into runner_ratings(order_id,runner_id,rating) values
(1,1,5),
(2,1,4),
(3,1,5),
(4,2,3),
(5,3,4),
(7,2,5),
(8,2,4),
(10,1,5);











































  
  
  
  
  
  
  
