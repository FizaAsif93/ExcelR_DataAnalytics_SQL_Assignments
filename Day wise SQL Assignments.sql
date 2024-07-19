# DAY WISE SQL ASSIGNMENTS

# Day 3

use classicmodels;
# Question 1
select * from customers;
select CustomerNumber, customerName, state ,creditLimit from customers where state is not null and creditlimit between 50000 and 100000 order by creditlimit desc;
# Question 2
select * from products;
select distinct(productLine) from products where productLine like "%cars";

# Day 4

use classicmodels;
# Question 1
select * from orders;
select orderNumber, status, ifnull(comments, "-") from orders where status = "shipped";
# Question 2
select * from employees;
select employeeNumber, firstName, jobTitle,
case
when jobTitle = "President" then "P"
when jobTitle = "Sales Rep" then "SR"
when jobTitle like "Sale%" then "SM"
when jobTitle like "VP%" then "VP"
end as jobTitle_abbr
from employees order by jobTitle;

# Day 5

use classicmodels;
# Question 1
select * from payments;
select year(PaymentDate) as year, min(amount) as MinAmount from payments
group by year(paymentDate) order by year;
# Question 2
select * from orders;
select year(orderDate) as year, concat("Q", quarter(orderDate)) as Quarter, count(distinct customerNumber) as unique_Customers, count(*) as Total_orders from orders group by year, quarter;
# Question 3
select * from payments;
select monthname(paymentDate) as Month, concat(round(sum(amount)/1000), "K") as `formatted amount` from payments group by `month` having sum(amount) between 500000 and 1000000 order by `formatted amount` desc;

# Day 6

use classicmodels;
# Question 1
create table journey(Bus_ID varchar(15) not null, Bus_Name varchar(50) not null, Source_Station varchar(50) not null, Destination varchar(50) not null, Email varchar(25) unique);
desc journey;
# Question 2
create table vendor(Vendor_ID varchar(20) Primary key, Name varchar(50) not null, Email varchar(25) unique, Country varchar(50) default "N/A");
desc vendor;
# Question 3
Create table movies (Movie_ID int Primary key, Name varchar(50) not null, Release_year varchar(10) default "-", Cast varchar(50) not null, Gender  enum("Male", "Female"), No_of_shows int check(No_of_shows > 0));
select * from movies;
desc movies;
# Question 4
create table suppliers(supplier_id varchar(20) primary key, supplier_name varchar (50) not null, location varchar(100));
desc suppliers;
create table Product(Product_id varchar(20) primary key, Product_name varchar(50) unique not null, description varchar(200), supplier_id varchar(20), foreign key(supplier_id) references suppliers(supplier_id));
desc Product;
create table Stock(Id int primary key auto_increment, product_id varchar(20), balance_stock int default 0, foreign key(product_id) references Product(Product_id));
desc stock;

# Day 7

use classicmodels;
# Question 1
select * from employees;
select * from customers;
select employeeNumber, concat(firstName, " ", lastName) as `Sales Person` , count(salesRepEmployeeNumber) as `Unique Customers`from employees e join customers c on e.employeeNumber = c.salesRepEmployeeNumber group by salesRepEmployeeNumber order by `Unique Customers` desc;
# Question 2
select * from customers;
select * from orders;
select * from orderdetails;
select * from products;
select c.customerNumber, c.customerName, p.productCode, p.productName, od.quantityOrdered as `Ordered Qty`, p.quantityInStock as `Total Inventory`, quantityInStock - quantityOrdered as `Left Qty` from orderdetails as od join products as p join orders as o on od.orderNumber = o.orderNumber join customers as c on o.customerNumber = c.customerNumber order by c.customerNumber;
# Question 3
create table Laptop (Laptop_Name varchar(50));
create table Colours (Colour_Name varchar(30));
insert into laptop values ("Lenovo"), ("HP"), ("Dell"),("Asus");
insert into colours values ("White"), ("Silver"), ("Black");
select * from laptop;
select * from colours;
select * from laptop cross join colours;
with CTE as
(select * from laptop cross join colours)
select count(*) as `Row Count` from CTE;
# Question 4
create table Project (EmployeeID int primary key, FullName varchar(100) not null, Gender enum ("Male", "Female"), ManagerID int);
desc project;
insert into project values (1, "Pranaya", "Male", 3), (2, "Priyanka", "Female", 1), (3, "Preety", "Female", null), (4, "Anurag", "Male", 1), (5, "Sambit", "Male", 1), (6, "Rajesh", "Male", 3), (7, "Hina", "Female", 3);
select * from project;
select mgr.fullname as `Manager Name`, emp.fullname as `Emp Name` from project as emp inner join project as mgr on emp.ManagerID = mgr.EmployeeID order by `Manager Name`;

# Day 8

use classismodels;

create table facility (Facility_ID int, Name varchar(100), State varchar(100), Country varchar(100));
desc facility;

alter table facility modify facility_id int primary key auto_increment;
desc facility;

alter table facility add column City varchar(100) not null after Name;
desc facility;

# Day 9

use classicmodels;

create table university (ID int, Name varchar(100));
insert into university values(1, "   Pune    University   "), (2," Mumbai    University   "), (3, "  Delhi  University   "), (4, "Madras University"), (5, "Nagpur University");
select * from university;
update university set name = replace(replace(trim("   Pune    University   "), "  ", " "), "  ", " ") where ID = 1;
update university set name = replace(replace(trim(" Mumbai    University   "), "  ", " "), "  ", " ") where ID = 2;
update university set name = replace(replace(trim("  Delhi  University   "), "  ", " "), "  ", " ") where ID = 3;

# Day 10

use classicmodels;

select * from orderdetails;
select * from orders;
Create View Product_Status as
(with CTE_02 as
(with CTE_01 as
(select od.ordernumber, year(OrderDate) as Year, count(od.ordernumber) as `val` from orderdetails as od join orders as o on od.ordernumber = o.ordernumber group by od.ordernumber)
select year, sum(val) as `Value` from CTE_01 group by year order by `value` desc)
select year, concat(value, " ", "(", round(value*100/sum(value) over()), "%", ")") as `Value` from CTE_02);
select * from Product_Status;

# Day 11

use classicmodels;
# Question 1
select * from customers;
call GetCustomerLevel (103);
call GetCustomerLevel (114);
call GetCustomerLevel (112); 

/*
CREATE PROCEDURE `GetCustomerLevel` (cid int)
BEGIN
declare x int default 0;
set x = (select CreditLimit from customers where customerNumber = cid);
if x < 25000 then
select "Silver" as Result;
elseif x between 25000 and 100000 then
select "Gold" as Result;
elseif x > 100000 then
select "Platinum" as Result;
end if;
END
*/

# Question 2
select * from customers;
select * from Payments;
call Get_Country_Payments (2003, "France");

/*
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Country_Payments`(i_Year int, i_Country varchar(50))
BEGIN
with CTE as 
(select year(paymentdate) as `Year`, country, amount from customers as c join payments as p on c.customernumber = p.customernumber)
select `Year`, country, concat(round(sum(amount)/1000), "K") as `Total Amount` from CTE group by Year, country having `Year` = i_Year and country = i_country;
END
*/

# Day 12

use classicmodels;
# Question 1
select * from orders;
With CTE as 
(select Year(orderDate) as`Year`, monthname(orderDate) as `Month`, count(orderNumber) as `Total Orders` from orders group by Year(orderDate), Monthname(orderDate))
select `Year`, `Month`, `Total Orders`, Concat(round((`Total Orders` - lag(`Total Orders`) over(Partition by Year))*100/lag(`Total Orders`) over(Partition by Year)), "%") as `%YoYChange` from CTE;

# Question 2
create table Emp_udf (Emp_ID int auto_increment primary key, Name varchar(100), DOB date);
insert into emp_udf (name, dob) values ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");
select * from emp_udf;
select calculate_age("1990-03-30") as Age;
select calculate_age("1992-08-15") as Age;
/*
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_age`(DOB Date) RETURNS varchar(100) CHARSET latin1
BEGIN
declare age varchar(100);
declare years int;
declare months int;
set years = timestampdiff(year, dob, curdate());
set months = timestampdiff(month, dob, curdate()) - timestampdiff(year, dob, curdate())*12;
set age = concat(years, " ", "Years", " ", months, " ", "Months");
RETURN age;
END
*/

# Day 13

use classicmodels;
# Question 1
select * from customers;
select * from orders;
select customerNumber, customerName from customers where customerNumber not in (select customerNumber from Orders);
# Question 2
select * from customers;
select * from orders;
select c.customerNumber, c.customerName, count(o.customerNumber) as OrderCount from customers c left join orders o on c.customerNumber = o.customerNumber group by c.customerNumber
Union
select c.customerNumber, c.customerName, count(o.customerNumber) as OrderCount from customers c right join orders o on c.customerNumber = o.customerNumber group by c.customerNumber;
# Question 3
select * from orderdetails;
with CTE as 
(select orderNumber, quantityOrdered, dense_rank() over(Partition by orderNumber order by quantityOrdered desc) as drnk from orderdetails)
select orderNumber, Max(quantityOrdered) as SecondHighestQuantity from CTE where drnk = 2 group by orderNumber;
# Question 4
select * from orderdetails;
with CTE as
(select orderNumber, count(*) as ProductCount from orderdetails group by orderNumber)
select max(ProductCount) as `MAX(Total)`, MIN(ProductCount) as `MIN(Total)` from CTE;
# Question 5
select * from products;
select productLine, count(*) as Total from products where buyPrice > (select Avg(buyPrice) from Products) group by productLine;

# Day 14

use classicmodels;

create table Emp_EH (EmpID int primary key, EmpName varchar(100), EmailAddress varchar(100));
call InsertEmp_EH (null, "Priya", "pppp@gmail.com");

/*
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertEmp_EH`(e_EmpID int, e_EmpName varchar(100), e_EmailAddress varchar(100))
BEGIN
declare exit handler for 1048
begin
select "Error Occurred" as Message;
end;
Insert into Emp_EH (EmpID, EmpName, EmailAddress) values (e_EmpID, e_EmpName, e_EmailAddress);
END
*/

# Day 15

use classicmodels;

create table Emp_BIT (Name varchar(50), Occupation varchar(50), Working_date Date, Working_hours int);
insert into Emp_BIT values ("Robin", "Scientist", "2020-10-12", 12), ("Warner", "Engineer", "2020-10-04", 10), ("Peter", "Actor", "2020-10-04", 13), ("Marco", "Doctor", "2020-10-04", 14), ("Brayden", "Teacher", "2020-10-04", 12), ("Antonio", "Business", "2020-10-04", 11);
insert into emp_bit values ("Priya", "Musician", "2020-10-04", -15);
select * from Emp_BIT;

/*
CREATE DEFINER=`root`@`localhost` TRIGGER `emp_bit_BEFORE_INSERT` BEFORE INSERT ON `emp_bit` FOR EACH ROW BEGIN
If new.working_hours < 0 then
set new.working_hours = -(new.working_hours);
end if;
END
*/
