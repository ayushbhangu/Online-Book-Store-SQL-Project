
create database OnlineBookStore;

use OnlineBookStore;

drop table if exists Books;
drop table if exists Customers;
drop table if exists Orders;

-- We have imported 3 data files.
-- Assigned primary keys to Book_ID in Books table, Customer_ID in Customers table, Order_ID in Orders table
-- Creating foreign keys in the Orders table for Book_Id and Customer_Id

alter table Orders
add constraint fk_Book_ID 
foreign key (Book_ID)
references Books(Book_ID);

alter table Orders
add constraint fk_Customer_ID 
foreign key (Customer_ID)
references Customers(Customer_ID);


Select top 5* from Books;
Select top 5* from Customers;
Select top 5* from Orders;

/* Basic Queries -
1) Retrieve all books in the "Fiction" genre
2) Find books published after the year 1950
3) List all customers from the Canada
4) Show orders placed in November 2023
5) Retrieve the total stock of books available
6) Find the details of the most expensive book
7) Show all customers who ordered more than 1 quantity of a book
8) Retrieve all orders where the total amount exceeds $20
9) List all genres available in the Books table 
10) Find the book with the lowest stock
11) Calculate the total revenue generated from all orders */

-- 1) Retrieve all books in the "Fiction" genre

Select * from Books
where Genre = 'Fiction'

-- 2) Find books published after the year 1950

select * from Books
where Published_Year > 1950


-- 3) List all customers from the Canada

Select * from Customers
where country = 'Canada';

-- 4) Show orders placed in November 2023

Select * from Orders
where Order_Date between '2023-11-01' and '2023-11-30';

--5) Retrieve the total stock of books available

Select Sum(Stock) as total_stock from Books;

-- 6) Find the details of the most expensive book

Select top 1* from Books
order by Price desc;

--7) Show all customers who ordered more than 1 quantity of a book

Select Customers.Name,Orders.Quantity 
from Customers join Orders
on Customers.Customer_ID = Orders.Order_ID
where Orders.Quantity > 1;

--8) Retrieve all orders where the total amount exceeds $20

Select * from Orders
where Total_Amount > 20;

--9) List all genres available in the Books table 

Select distinct Genre from Books;

--10) Find the book with the lowest stock

Select top 1* from Books
order by stock;

--11) Calculate the total revenue generated from all orders

Select round(sum(Total_Amount),2) as total_revenue from Orders;


/*Advanced Queries
1) Retrieve the total number of books sold for each genre
2) Find the average price of books in the "Fantasy" genre
3) List customers who have placed at least 2 orders
4) Find the most frequently ordered book
5) Show the top 3 most expensive books of 'Fantasy' Genre 
6) Retrieve the total quantity of books sold by each author
7) List the cities where customers who spent over $30 are located
8) Find the customer who spent the most on orders
9) Calculate the stock remaining after fulfilling all order*/

--1) Retrieve the total number of books sold for each genre

Select Books.Genre,sum(Orders.Quantity) as books_sold
from Books join Orders
on Books.Book_ID = Orders.Book_ID
group by Books.Genre;

--2) Find the average price of books in the "Fantasy" genre

select Avg(Price) as AVG_price from Books 
where Genre = 'Fantasy';

--3) List customers who have placed at least 2 orders

select Customers.Name, count(Orders.Order_ID) as Orders_placed
from Customers join Orders
on Customers.Customer_ID = Orders.Customer_ID
group by Customers.Name
having count(Orders.Order_ID) >= 2;

--4) Find the most frequently ordered book

Select top 5 Books.Title,Books.Author,count(Orders.Order_ID) as Orders_Received,sum(Orders.Quantity) as Qty_Ordered
from Books join Orders
on Books.Book_ID = Orders.Book_ID
group by Books.Title,Books.Author
order by Qty_Ordered desc;


--5) Show the top 3 most expensive books of 'Fantasy' Genre

Select top 3*
from Books
where Genre = 'Fantasy'
order by Price desc;

--6) Retrieve the total quantity of books sold by each author

Select Books.Author,sum(Orders.Quantity) as Qty_sold
from Books join Orders
on Books.Book_ID = Orders.Book_ID
group by Books.Author;

--7) List the cities where customers who spent over $30 are located

Select distinct Customers.City,Orders.Total_Amount
from Customers join Orders
on Customers.Customer_ID = Orders.Customer_ID
where Orders.Total_Amount > 30;

--Alternatively if we have to show customer name as well

SELECT c.Name, c.City, SUM(o.Total_Amount) AS total_spent
FROM Orders o JOIN Customers c
ON o.Customer_ID = c.Customer_ID
GROUP BY c.Name, c.City
HAVING SUM(o.Total_Amount) > 30
ORDER BY total_spent DESC;


8) Find the customer who spent the most on orders

Select top 1 Customers.Name,round(sum(Orders.Total_Amount),2) as Amount_spent
from Customers join Orders
on Customers.Customer_ID = Orders.Customer_ID
group by Customers.Name
order by Amount_spent desc;


--9) Calculate the stock remaining after fulfilling all order


Select Books.Book_ID,Books.Title,Books.Stock,coalesce(sum(Orders.Quantity),0) as Qty_sold,
(Books.Stock - coalesce(sum(Orders.Quantity),0)) as Remaining_stock
from Books left join Orders
on Books.Book_ID = Orders.Book_ID
group by Books.Book_ID,Books.Title,Books.Stock;

-- Coalesce function used to replace null values with 0.

