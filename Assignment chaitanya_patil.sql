-- use classicmodels
-- Day 3
-- 1)	Show customer number, customer name, state and credit limit from customers table for below conditions. Sort the results by highest to lowest values of creditLimit.

-- ●	State should not contain null values
-- ●	credit limit should be between 50000 and 100000

select customerNumber,
customerName,
State,
creditLimit
from customers
where State is not null
and creditLimit between 50000 and 100000
order by 4 desc

-- 2)Show the unique productline values containing the word cars at the end from products table.

select distinct productline
from products
where productline like '%Cars'


-- Day 4
-- 1)	Show the orderNumber, status and comments from orders table for shipped status only. If some comments are having null values then show them as “-“.

select orderNumber,
status,
ifnull(Comments,'-') as Comments
from orders
where status = 'Shipped'

-- 2)Select employee number, first name, job title and job title abbreviation from employees table based on following conditions.
-- If job title is one among the below conditions, then job title abbreviation column should show below forms.
-- ●	President then “P”
-- ●	Sales Manager / Sale Manager then “SM”
-- ●	Sales Rep then “SR”
-- ●	Containing VP word then “VP”

select employeeNumber, firstName, jobTitle,
  case
    when jobTitle = 'President' THEN 'P'
    when jobTitle LIKE 'Sales Manager%' OR jobTitle like 'Sale Manager%' THEN 'SM'
    when jobTitle = 'Sales Rep' THEN 'SR'
    when jobTitle LIKE '%VP%' THEN 'VP'
  end as jobTitleAbbr
from employees;

-- Day 5:
-- 1)For every year, find the minimum amount value from payments table.

select year(paymentDate) as Year,
min(amount) as `Min Amount`
from payments 
group by 1 
order by 1 asc

-- 2)For every year and every quarter, find the unique customers and total orders from orders table. Make sure to show the quarter as Q1,Q2 etc.

select YEAR(orderDate) AS Year,
  CONCAT('Q', QUARTER(orderDate)) AS Quarter,
  COUNT(DISTINCT customerNumber) AS UniqueCustomers,
  COUNT(*) AS TotalOrders
from orders
group by Year, Quarter

-- 3)Show the formatted amount in thousands unit (e.g. 500K, 465K etc.) for every month (e.g. Jan, Feb etc.) with filter on total amount as 500000 to 1000000. Sort the output by total amount in descending mode. [ Refer. Payments Table]


select
    Month,
    CONCAT(FORMAT(TotalAmount / 1000, 0), 'K') AS `Formatted Amount`
from
    (
        select
            MONTHNAME(paymentDate) AS Month,
            SUM(amount) AS TotalAmount
        from
            payments
        GROUP BY
            MONTH(paymentDate)
    ) AS subquery
where
    TotalAmount BETWEEN 500000 AND 1000000
ORDER BY
    TotalAmount DESC
    

-- SET sql_mode = ''


-- Day 6:

-- 1)	Create a journey table with following fields and constraints.
-- ●	Bus_ID (No null values)
-- ●	Bus_Name (No null values)
-- ●	Source_Station (No null values)
-- ●	Destination (No null values)
-- ●	Email must not contain any duplicates

create table journey (
    Bus_ID int not null primary key,
    Bus_Name varchar(50) not null,
    Source_Station varchar(50) not null,
    Destination varchar(50) not null,
    Email varchar(100) not null,
    UNIQUE (Email)
)


-- 2)	Create vendor table with following fields and constraints.
-- ●	Vendor_ID (Should not contain any duplicates and should not be null)
-- ●	Name (No null values)
-- ●	Email (must not contain any duplicates)
-- ●	Country (If no data is available then it should be shown as “N/A”)

create table vendor(
Vendor_ID int not null primary key,
Name varchar(50) not null ,
Email varchar(100) not null,
Country varchar(50) DEFAULT 'N/A',
unique(Email) 
)

-- 3)	Create movies table with following fields and constraints.
-- ●	Movie_ID (Should not contain any duplicates and should not be null)
-- ●	Name (No null values)
-- ●	Release_Year (If no data is available then it should be shown as “-”)
-- ●	Cast (No null values)
-- ●	Gender (Either Male/Female)
-- ●	No_of_shows (Must be a positive number)

create table movie (
Movie_ID int not null primary key,
Name varchar (50) not null,
Release_Year varchar(10) default '-',
Cast varchar(100) not null,
Gender ENUM('Male', 'Female'),
No_of_shows int UNSIGNED
)

-- 4)	Create the following tables. Use auto increment wherever applicable
-- a. Product
-- ✔	product_id - primary key
-- ✔	product_name - cannot be null and only unique values are allowed
-- ✔	description
-- ✔	supplier_id - foreign key of supplier table
-- b. Suppliers
-- ✔	supplier_id - primary key
-- ✔	supplier_name
-- ✔	location
-- c. Stock
-- ✔	id - primary key
-- ✔	product_id - foreign key of product table
-- ✔	balance_stock

create table product(
product_id int not null auto_increment primary key,
product_name varchar(50) not null,   
description varchar(100),
supplier_id int ,
foreign key (supplier_id) References suppliers(supplier_id)
)

create table suppliers(
supplier_id int not null auto_increment primary key,
supplier_name varchar(50),
location varchar(50)
)

create table Stock(
id int not null auto_increment primary key,
product_id int,
balance_stock int,
foreign key (product_id) References product(product_id)
) 


-- Day 7
-- 1)	Show employee number, Sales Person (combination of first and last names of employees), unique customers for each employee number and sort the data by highest to lowest unique customers.
-- Tables: Employees, Customers

select e.employeeNumber,
concat(e.firstName,' ',e.lastName) as Sales_Person,
count(distinct customerNumber) as Unique_Customers
from employees as e 
left join customers as c on e.employeeNumber = c.salesRepEmployeeNumber
group by 1
order by 3 desc

-- 2)	Show total quantities, total quantities in stock, left over quantities for each product and each customer. Sort the data by customer number.
-- Tables: Customers, Orders, Orderdetails, Products

select
    c.customerNumber AS CustomerNumber,
    c.customerName,
    p.productCode AS ProductCode,
    p.productName,
    SUM(od.quantityOrdered) AS `Ordered Qty`,
    SUM(p.quantityInStock) AS `Total Inventory`,
    SUM(p.quantityInStock) - SUM(od.quantityOrdered) AS `Left Qty`
from customers as c 
left join orders as o on o.customerNumber = c.customerNumber
left join orderdetails as od on od.orderNumber = o.orderNumber
left join products as p on p.productCode = od.productCode
group by 1,3
order by 1

-- 3)	Create below tables and fields. (You can add the data as per your wish)
-- ●	Laptop: (Laptop_Name)
-- ●	Colours: (Colour_Name)
-- Perform cross join between the two tables and find number of rows.

create table Laptop(
Laptop_Name varchar(50)
)

create table Colours(
Colour_Name varchar(50)
)

insert into Laptop (Laptop_Name)
value ('Dell'),
('HP')

insert into Colours (Colour_Name)
value ('White'),
('Silver'),
('Black')

-- Cross Join
select *
from Laptop
cross join colours 
order by 1

-- Number Of Rows 
select count(*) as NumberOfRows
from Laptop
cross join colours 
order by 1

-- 4)	Create table project with below fields.
-- ●	EmployeeID
-- ●	FullName
-- ●	Gender
-- ●	ManagerID
-- Add below data into it.
-- INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
-- INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
-- INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
-- INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
-- INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
-- INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
-- INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);
-- Find out the names of employees and their related managers.

create table project(
Employee_ID int not null primary key,
FullName Char(50),
Gender enum ('Male','Female'),
ManagerID int default NULL 
)
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3),
(2, 'Priyanka', 'Female', 1),
(3, 'Preety', 'Female', NULL),
(4, 'Anurag', 'Male', 1),
(5, 'Sambit', 'Male', 1),
(6, 'Rajesh', 'Male', 3),
(7, 'Hina', 'Female', 3)

select
    m.FullName AS ManagerName,
    p.FullName AS EmpName
from
    Project as p
inner join Project as m ON p.ManagerID = m.Employee_ID
order by 1


-- Day 8

-- Create table facility. Add the below fields into it.
-- ●	Facility_ID
-- ●	Name
-- ●	State
-- ●	Country
-- i) Alter the table by adding the primary key and auto increment to Facility_ID column.
-- ii) Add a new column city after name with data type as varchar which should not accept any null values.


create table facility(
Facility_ID  int,
Name char (25),
State char (25),
Country char (25)
)

Alter table facility
modify column Facility_ID int auto_increment primary key


Alter table facility
Add column City varchar(100) not null After Name

show columns from facility

-- Create table university with below fields.
-- ●	ID
-- ●	Name
-- Add the below data into it as it is.
-- INSERT INTO University
-- VALUES (1, "       Pune          University     "), 
--                (2, "  Mumbai          University     "),
--               (3, "     Delhi   University     "),
--               (4, "Madras University"),
--               (5, "Nagpur University");
-- Remove the spaces from everywhere and update the column like Pune University etc.

create table university(
ID int not null primary key,
Name char(50)
)
INSERT INTO University
VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");

UPDATE University
SET Name = TRIM(REGEXP_REPLACE(Name, ' +', ' '));
              
-- SET SQL_SAFE_UPDATES = 0

-- Day 10
-- Create the view products status. Show year wise total products sold. Also find the percentage of total value for each year. The output should look as shown in below figure.

create view products_status as
select
    YEAR(o.orderDate) AS Year,
    CONCAT(COUNT(od.productCode), ' (', ROUND(COUNT(od.productCode) / (SELECT COUNT(*) FROM orderdetails) * 100), '%)') AS Value
FROM
    orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY Year;

-- Day 11
-- 1)	Create a stored procedure GetCustomerLevel which takes input as customer number and gives the output as either Platinum, Gold or Silver as per below criteria.

-- Table: Customers

-- ●	Platinum: creditLimit > 100000
-- ●	Gold: creditLimit is between 25000 to 100000
-- ●	Silver: creditLimit < 25000

DELIMITER //

CREATE PROCEDURE GetCustomerLevel(IN customerNumber INT, OUT customerLevel VARCHAR(20))
BEGIN
    DECLARE customerCreditLimit DECIMAL(10, 2);

    SELECT creditLimit INTO customerCreditLimit
    FROM Customers
    WHERE customerNumber = customerNumber
    LIMIT 1;

    IF customerCreditLimit > 100000 THEN
        SET customerLevel = 'Platinum';
    ELSEIF customerCreditLimit >= 25000 THEN
        SET customerLevel = 'Gold';
    ELSE
        SET customerLevel = 'Silver';
    END IF;
END //

DELIMITER ;


CALL GetCustomerLevel(114, @customerLevel);
SELECT @customerLevel AS CustomerLevel;


-- select * from customers


-- 2)	Create a stored procedure Get_country_payments which takes in year and country as inputs and gives year wise, country wise total amount as an output. Format the total amount to nearest thousand unit (K)
-- Tables: Customers, Payments

DELIMITER //

CREATE PROCEDURE Get_country_payments(IN inputYear INT, IN inputCountry VARCHAR(100), OUT outputYear INT, OUT outputCountry VARCHAR(100), OUT totalAmountFormatted VARCHAR(10))
BEGIN
    DECLARE totalAmount DECIMAL(10, 2);

    SELECT YEAR(p.paymentDate) AS Year, c.country AS Country, SUM(p.amount) AS TotalAmount
    INTO outputYear, outputCountry, totalAmount
    FROM Payments p
    JOIN Customers c ON p.customerNumber = c.customerNumber
    WHERE YEAR(p.paymentDate) = inputYear AND c.country = inputCountry;

    SET totalAmountFormatted = CONCAT(FORMAT(totalAmount / 1000, 0), 'K');
END //

DELIMITER ;


CALL Get_country_payments(2003, 'France', @outputYear, @outputCountry, @totalAmountFormatted);
SELECT @outputYear AS Year, @outputCountry AS Country, @totalAmountFormatted AS `Total Amount`;



-- select * from customers
-- select * from payments



-- Day 12
-- 1)	Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. Format the YoY values in no decimals and show in % sign.
-- Table: Orders

select
    YEAR(orderDate) AS Year,
    MONTHNAME(orderDate) AS Month,
    COUNT(*) AS TotalOrders,
    CONCAT(
        IFNULL(FORMAT((COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY YEAR(orderDate), MONTH(orderDate))) / LAG(COUNT(*)) OVER (ORDER BY YEAR(orderDate), MONTH(orderDate)) * 100, 0), 'NULL'),
        '%'
    ) AS '% YoY Change'
from
    Orders
GROUP BY
    YEAR(orderDate), MONTH(orderDate)
ORDER BY
    YEAR(orderDate), MONTH(orderDate);
    
    

-- 2)	Create the table emp_udf with below fields.

-- ●	Emp_ID
-- ●	Name
-- ●	DOB
-- Add the data as shown in below query.
-- INSERT INTO Emp_UDF(Name, DOB)
-- VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");

-- Create a user defined function calculate_age which returns the age in years and months (e.g. 30 years 5 months) by accepting DOB column as a parameter.

create table emp_udf (
    Emp_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    DOB DATE
)

INSERT INTO Emp_UDF(Name, DOB)
VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21")

DELIMITER //
create function calculate_age(dob DATE) RETURNS VARCHAR(50)
DETERMINISTIC
READS SQL DATA
begin
    DECLARE years INT;
    DECLARE months INT;
    DECLARE age VARCHAR(50);
    SET years = TIMESTAMPDIFF(YEAR, dob, CURDATE());
    SET months = TIMESTAMPDIFF(MONTH, dob, CURDATE()) - (years * 12);
    SET age = CONCAT(years, ' years ', months, ' months');
    RETURN age;
end //
DELIMITER ;

SELECT Name, DOB, calculate_age(DOB) AS Age FROM emp_udf


-- Day 13
-- 1)	Display the customer numbers and customer names from customers table who have not placed any orders using subquery

-- Table: Customers, Orders

select customerNumber, customerName
from Customers
where customerNumber NOT IN (
    select customerNumber
    from Orders
)

-- 2)	Write a full outer join between customers and orders using union and get the customer number, customer name, count of orders for every customer.
-- Table: Customers, Orders


select c.customerNumber, c.customerName, COUNT(o.orderNumber) AS orderCount
from Customers c
left join Orders o on c.customerNumber = o.customerNumber
GROUP BY c.customerNumber, c.customerName

UNION

select c.customerNumber, c.customerName, COUNT(o.orderNumber) AS orderCount
from Orders o
right join Customers c on o.customerNumber = c.customerNumber
GROUP BY c.customerNumber, c.customerName


-- 3)	Show the second highest quantity ordered value for each order number.
-- Table: Orderdetails

select orderNumber, MAX(quantityOrdered) AS secondHighestQuantity
from Orderdetails as od
WHERE quantityOrdered < (select MAX(quantityOrdered) from Orderdetails where orderNumber = od.orderNumber)
GROUP BY orderNumber


-- 4)	For each order number count the number of products and then find the min and max of the values among count of orders.
-- Table: Orderdetails

SELECT MAX(productCount) AS `MAX(Total)`, MIN(productCount) AS `MIN(Total)`
FROM (
    SELECT orderNumber, COUNT(*) AS productCount
    FROM Orderdetails
    GROUP BY orderNumber
) as abc

-- 5)	Find out how many product lines are there for which the buy price value is greater than the average of buy price value. Show the output as product line and its count.

select productLine, COUNT(*) as Total
from products
where buyPrice > (select AVG(buyPrice) from products)
GROUP BY productLine


-- Day 14
-- Create the table Emp_EH. Below are its fields.
-- ●	EmpID (Primary Key)
-- ●	EmpName
-- ●	EmailAddress
-- Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling concept. Show the message as “Error occurred” in case of anything wrong.

create table Emp_EH(
EmpID int primary key,
EmpName char(25),
EmailAddress varchar(50)
)


DELIMITER //
CREATE PROCEDURE InsertIntoEmp_EH(
    IN input_EmpID INT,
    IN input_EmpName VARCHAR(100),
    IN input_EmailAddress VARCHAR(100)
)
BEGIN
    DECLARE error_occurred BOOLEAN DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND
    BEGIN
        SET error_occurred = TRUE;
    END;

    START TRANSACTION;

    -- Insert the values into Emp_EH
    INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)
    VALUES (input_EmpID, input_EmpName, input_EmailAddress);

    IF error_occurred THEN
        ROLLBACK;
        SELECT 'Error occurred' AS Message;
    ELSE
        COMMIT;
        SELECT 'Data inserted successfully' AS Message;
    END IF;
END //
DELIMITER ;

CALL InsertIntoEmp_EH(1, 'Shubh', 'shubh@example.com');

select * from emp_eh


-- Day 15
-- Create the table Emp_BIT. Add below fields in it.
-- ●	Name
-- ●	Occupation
-- ●	Working_date
-- ●	Working_hours
-- Insert the data as shown in below query.
-- INSERT INTO Emp_BIT VALUES
-- ('Robin', 'Scientist', '2020-10-04', 12),  
-- ('Warner', 'Engineer', '2020-10-04', 10),  
-- ('Peter', 'Actor', '2020-10-04', 13),  
-- ('Marco', 'Doctor', '2020-10-04', 14),  
-- ('Brayden', 'Teacher', '2020-10-04', 12),  
-- ('Antonio', 'Business', '2020-10-04', 11);  
-- Create before insert trigger to make sure any new value of Working_hours, if it is negative, then it should be inserted as positive

create table Emp_BIT(
Name char(50),
Occupation VARCHAR(100),
Working_date DATE,
Working_hours INT
)

INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  

DELIMITER //
CREATE TRIGGER Before_Insert_Emp_BIT
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = -NEW.Working_hours;
    END IF;
END //
DELIMITER 

SHOW TRIGGERS 
