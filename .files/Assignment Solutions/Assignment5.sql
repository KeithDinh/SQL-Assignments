-----ASSIGNMENT 5-----------------------------------------------
--1 Table, schema ,databse etc are objects in sql server

--2 Indexes are database objects based on table column for faster retrieval of data.
	Advantages :
	1. To quickly find data that satisfy conditions in the WHERE clause.
	2. To find matching rows in the JOIN clause.
	3. To maintain uniqueness of key column during INSERT and UPDATE.
	4. To Sort, Aggregate and Group data.
	
	Disadvantages :
	1. Additional Disk Space.
	2. Insert, Update, Delete Statement become slow.
	3. A clustered Index always cover a query.
	 

--3. Clustred, non clustured unique and non unique indexes.

--4. When a table is created SQL Server automatically creates custered and unique indexes on primary key column and unique non clustered indexes on unique key constraints.

--5. A table can't have multiple clustered indexes beacuse clustered index columns will be sorted in ascending order, 
there will be abiguity which columns to be sorted if there are more than one clustered index on a table.

--6. Index can be created on multiple columns in a table. In the order first column will perform better over second and second over third and son on.

--7. Yes indexes can be created on views.


--8. Database Normalization is a process of organizing data to minimize redundancy (data duplication), which in turn ensures data consistency. 
There are 3 normal forms to achieve this.
First Normal form :
Data in each column should be atomic, no multiples values separated by comma.
The table does not contain any repeating column group
Identify each record using primary key.

Second normal form:
The table must meet all the conditions of 1NF
Move redundant data to separate table
Create relationships between these tables using foreign keys

Third Normal form:
Table must meet all the conditions of 1NF and 2NF.
Does not contain columns that are not fully dependent on primary key.


--9. Denormalization is a strategy used on a previously-normalized database to increase performance. The idea behind it is to add redundant 
data where we think it will help us the most. We can use extra attributes in an existing table, add new tables, or even create instances 
of existing tables. The usual goal is to decrease the running time of select queries by making data more accessible to the queries or by 
generating summarized reports in separate tables. This process can bring some new problems, and we’ll discuss them later.

-10 Using transaction we can achive data integity. 

--11 Primary key constraint, froeign key constraint, unique key constraint, check constraint etc

--12 Primary key can't have null value but unique key can. There will be only one foreign key per table where as there can be any number of unique keys per table

--13 A foreign key (FK) is a column or combination of columns that is used to establish and enforce a link between the data in two tables. You can create a foreign key by defining a FOREIGN KEY constraint when you create or modify a table.

--14 Yes 

--15 Foreign key need not be unique and it can be null too

--16 No

--17 Transaction sql server will keep databse in consitant state. Threre are many trnsaction levels in sql server like, red commited, read uncommitted, repeatble read , serializable and snapshot isolation level transaction.

/*

--------------------------------------------------------------QUERIES---------------------------------------------------------------

--1.

select CustomerID as cust_id , ContactName as iname into #customer
from Customers


select od.OrderID as order_id, CustomerID as cust_id , UnitPrice as amout, OrderDate as order_date into #order 
from [Order Details] od join Orders o on o.OrderID=od.OrderID

select c.iname,sum(amout) from #customer c join #order o on c.cust_id = o.cust_id
where DATEPART(yyyy,order_date)='1996'
group by c.iname


--2

declare @person table(id int,firstname nvarchar(100),lastName nvarchar(100))
insert into @person
select EmployeeID,FirstName,LastName from Employees
select * from @person where lastname like 'A%'

--3
declare @person1 table(person_id int,manager_id int,name nvarchar(100))
insert into @person1
select EmployeeID,ReportsTo,FirstName+''+LastName from Employees
select person_id,(select count(*)  from @person1 p2 where p2.manager_id=p1.person_id group by manager_id) as numberOfEmployees from @person1 p1
where manager_id is null and person_id in (select manager_id from @person1)

--4 insert ,update, delete statements can cause trigger to happen



