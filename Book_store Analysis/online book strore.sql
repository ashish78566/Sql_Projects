create database project1;
use project1;
select * from customers;
select * from books;
select * from orders;

#1.Retrive all books in the 'Fiction' genre.
select * from books
where Genre='Fiction';

#2.Find books publised after the year 1950.
select *  from books
where Published_Year > 1950;

#3.List all customers from Canada.
select * from customers
where  country='Canada';

#4.Show orders placed in November 2023.
select * from orders
where Order_Date between '2023-11-01' and '2023-11-30';

#5.Retrive the total stocks of books available.
select sum(Stock) as total_stock
from books;

#6.Find the details of the most expensive books.
select * from books order by price desc limit 1;

#7.Show all customers who ordered more than 1 quantity of a book.
select * from orders
where quantity>1;

#8.Retrive all orders where the total amount exceeds $20.
select * from orders
where total_amount>20;

#9.List all genres available in the books table.
select distinct genre from books;

#10.Find the book with the lowest stock.
select * from books
order by stock 
limit 1;

#11.Calculate the total revenue generated from all orders.
select sum(total_amount) as revenue from orders;

#Advance Questions:
#1.Retrive the total number of books sold for each genre.
select b.Genre,sum(o.Quantity) as total_sold from orders o
join books b on o.book_id=b.book_id
group by b.Genre;

#2.Find the average price of books in the 'Fantasy' genre:
select avg(price) as average_price
from books
where genre='Fantasy';

#3.List customers who have placed at least 2 orders.
select c.name,c.customer_id,count(o.order_id) as total_orders
from customers c 
join orders o on c.customer_id=o.customer_id
group by c.name,c.customer_id
having count(o.order_id) >=2
order by total_orders asc;

#4.Find the most frequently ordered book.
select b.book_id,b.title, sum(o.quantity) as total_order from orders o
join books b on o.book_id=b.book_id
group by b.book_id,b.title
order by total_order desc
limit 1;

#5.Show the top 3 most expensive books of 'Fantasy' genre.
SELECT book_id,title,genre,price
FROM Books
WHERE genre = 'Fantasy'
ORDER BY price desc
LIMIT 3;

#6.Retrive the total quantity of books sold by each author.
select b.author, sum(quantity) as total_quantity from orders o
join books b on o.book_id=b.book_id
group by b.author;

#7.List the cities where customers who spent over $30 are located.
select distinct c.city,total_amount
from orders o
join customers c on o.customer_id=c.customer_id
where o.total_amount>300;

#8.Find the customers who spent more orders.
select c.customer_id,c.name, sum(total_amount) as total_spent
from orders o
join customers c on o.customer_id=c.customer_id
group by c.customer_id,c.name
order by total_spent desc
limit 1;







