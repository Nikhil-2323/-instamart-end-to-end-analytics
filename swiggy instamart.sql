CREATE DATABASE SWIGGY;
USE SWIGGY;
SELECT   * FROM instamart_orders 
UPDATE instamart_orders
SET Category = NULL
WHERE Category = ''



--Creating a seperate table for customers from our big table
CREATE TABLE Customers(Customer_id VARCHAR(70) PRIMARY KEY, Customer_name VARCHAR(30),City VARCHAR(20))
INSERT INTO Customers (Customer_id, Customer_name,City,Pincode) 
SELECT DISTINCT Customer_Id, Customer_Name,City,Pincode FROM instamart_orders AS o
WHERE NOT EXISTS (SELECT 1 FROM Customers c WHERE c.Customer_id = o.Customer_id);
SELECT * FROM Customers;
ALTER TABLE Customers ADD Pincode INT;
UPDATE c
SET c.Pincode = o.Pincode
FROM Customers c
JOIN instamart_orders o
ON c.Customer_id = o.Customer_id;





--Creating a seperate table for orders detail from our big table
CREATE TABLE Orders (Order_ID VARCHAR(70) PRIMARY KEY,Order_Date DATE,Order_Time TIME);
INSERT INTO Orders (Order_ID, Order_Date, Order_Time)
SELECT DISTINCT Order_ID, Order_Date, Order_Time
FROM instamart_orders o
WHERE NOT EXISTS (SELECT 1 FROM Orders ord WHERE ord.Order_ID = o.Order_ID);
SELECT * FROM Orders;
SELECT TOP 10 * FROM Orders;



--Creating a seperate table for products details from data
CREATE TABLE Products(Product_id VARCHAR(70) PRIMARY KEY,Product_name VARCHAR(20),Category VARCHAR(20),Cost_price INT, Sold_price INT);
INSERT INTO Products(Product_id,Product_name,Category,Cost_price, Sold_price)
SELECT DISTINCT Product_Id,Product_Name,Category,Cost_Price, Unit_Price
FROM instamart_orders AS o
WHERE NOT EXISTS (SELECT 1 FROM Products p WHERE p.Product_id = o.Product_Id);
SELECT * FROM Products;
SELECT COUNT(*) AS null_count
FROM Products
WHERE Product_Name IS NULL;

SELECT DISTINCT od.Product_ID
FROM Orderdetails od
LEFT JOIN Products p
    ON od.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;






--Creating seperate table for the region from the big table
CREATE TABLE Location(Pincode BIGINT PRIMARY KEY ,City VARCHAR(10), State1 VARCHAR(15),Region VARCHAR(10));
INSERT INTO Location (Pincode,City,State1,Region) SELECT DISTINCT Pincode,City,State,Region FROM instamart_orders 
SELECT * FROM Location;



--Creating a seperate table for the delivery details from the big table 
CREATE TABLE Delivery (Delivery_id INT IDENTITY(1,1) PRIMARY KEY,Order_id VARCHAR(70),Payment_mode VARCHAR(10),Delivery_time INT,Delivery_status VARCHAR(15),Rating INT,Delivery_partner VARCHAR(20));
INSERT INTO Delivery (Order_id,Payment_mode ,Delivery_time ,Delivery_status ,Rating ,Delivery_partner) 
SELECT DISTINCT Order_Id,Payment_Mode,Delivery_Time_minutes,Delivery_Status ,Rating,Delivery_Partner FROM instamart_orders
SELECT TOP 10 * FROM Delivery;

ALTER TABLE Delivery ADD  Customer_id VARCHAR(50);
UPDATE d
SET d.Customer_id = o.Customer_id
FROM Delivery d
JOIN instamart_orders o
ON d.Order_id = o.Order_id;


--Creating a seperate table for complete orderdetails from the big table
CREATE TABLE Orderdetails (OrderDetail_ID INT IDENTITY(1,1) PRIMARY KEY, Order_id VARCHAR(70), Product_id VARCHAR(70),Product_name VARCHAR(10),Quantity INT,Cost_price INT,Total_purchased_amount INT,Sold_price INT,
Total_sold_amount INT, Discount INT,Final_sold_amount INT,Profit INT)
INSERT INTO Orderdetails (Order_id, Product_id ,Product_name ,Quantity ,Cost_price ,Total_purchased_amount ,Sold_price, Total_sold_amount, Discount ,Final_sold_amount ,Profit)
SELECT DISTINCT Order_ID, Product_ID ,Product_Name ,Quantity ,Cost_price ,Total_purchased_amount ,Unit_price,Total_sold_amount, Discount ,Final_sold_amount ,Profit 
FROM instamart_orders;

SELECT * FROM Orderdetails;

SELECT TOP 1 
    Category, 
    SUM(Final_Sold_Amount) AS Total_Revenue
FROM Orderdetails
WHERE Category IS NOT NULL
GROUP BY Category
ORDER BY Total_Revenue DESC;

