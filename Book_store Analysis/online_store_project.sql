create database online_store;
use online_store;

# Customers
create table customers (
customer_id int primary key,
name varchar(50),
city varchar(50),
email varchar(100)
);
insert into customers values
(1,'John Doe','New York','john@gmail.com'),
(2,'Alice Smith','Los Angles','alice@gmail.com'),
(3,'Bob Johnson','Chicago','bob@gmail.com'),
(4,'Emily Davis','Huston','emily@gmail.com');
select * from customers;

#Products 
create table products(
product_id int primary key,
name varchar(50),
category varchar(50),
price decimal(10,2)
);


insert into products values
(1,'Laptop','Electronics',800.00),
(2,'Smartphone','Electronics',500.00),
(3,'Headphones','Electronics',100.00),
(4,'Desk Chair','Furniture',150.00);
select * from products;

#Orders 
create table orders (
order_id int primary key,
customer_id int,
order_date date,
foreign key (customer_id) References customers(customer_id)
);

insert into orders values
(101,1,'2025-08-01'),
(102,2,'2025-08-02'),
(103,1,'2025-08-03'),
(104,3,'2025-08-04');
select * from orders;

#Order Details
create table order_details(
order_id int,
product_id int,
quantity int,
foreign key (order_id) references orders(order_id),
foreign key (product_id) references products(product_id)
);
insert into order_details values
(101,1,1),
(101,3,2),
(102,2,1),
(103,4,1),
(104,1,2),
(104,2,1);

select * from order_details;

#1.List all customers
select * from customers;

#2.Products in 'Electronics' category
select * from products
where category='Electronics';

#3.Total number of customers
select count(*) as total_customers from customers;

#4.Total orders placed
select count(*) as total_orders from orders;

#5.Total sales amount(money)
select sum(od.quantity * p.price) as total_sales 
from order_details od
join products p on od.product_id=p.product_id;

#6.Sales per product
select p.name,sum(od.quantity * p.price) as total_sales
from order_details od
join products p on od.product_id=p.product_id
group by p.name;

#7.Sales per category
select p.category,sum(od.quantity * p.price) as total_sales
from order_details od
join products p on od.product_id=p.product_id
group by p.category;

#8.Highest-selling product(by quantity)
select p.name,sum(od.quantity) as total_qty
from order_details od
join products p on od.product_id=p.product_id
group by p.name
order by total_qty desc
limit 1;

#9.Orders placed by 'John Doe'
select o.order_id,o.order_date from orders o
join customers c on o.customer_id=c.customer_id
where c.name='John Doe';

#10.Customers from chicago
select * from customers
where city='chicago';

#11.Total spend per customer
select c.name,sum(od.quantity *p.price) as total_spent from orders o
join customers c on o.customer_id=c.customer_id
join order_details od on o.order_id=od.order_id
join products p on od.product_id=p.product_id
group by c.name
order by total_spent desc;

#12.Customer who spent the most
select c.name,sum(od.quantity * p.price) as total_spent from orders o
join customers c on o.customer_id=c.customer_id
join order_details od on o.order_id=od.order_id
join products p on od.product_id=p.product_id
group by c.name
order by total_spent desc
limit 1;

#13.Orders with product names and quantities
select o.order_id,c.name as customer_name,p.name as product_name,od.quantity from orders o
join customers c on o.customer_id=c.customer_id
join order_details od on o.order_id=od.order_id
join products p on od.product_id=p.product_id;


SELECT o.order_id,o.order_date,p.name,od.quantity FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
ORDER BY o.order_id;

#14.Product counts per category
select category,count(*) as product_count
from products group by category;

#15.Average order value
select avg(order_total) as average_order_value from (
select o.order_id,sum(od.quantity * p.price) as order_total
from orders o
join order_details od on o.order_id=od.order_id
join products p on od.product_id=p.product_id
group by o.order_id) as order_total;

#16.Orders in Augest 2025
select * from orders
where month(order_date)=8 and
year(order_date)=2025;

#17.Numbers of orders each customer made
select c.name,count(o.order_id) as order_count from customers c
join orders o on c.customer_id=o.customer_id
group by c.name;

#18.Customers who never placed an order
select c.name from customers c
join orders o on c.customer_id=o.customer_id
where o.order_id is null;

#19.Most recent order
select * from orders
order by order_date desc
limit 1;

#20.Total quantity of 'Laptop' sold
SELECT SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN products p ON od.product_id = p.product_id
WHERE p.name = 'Laptop';



