/*
1.What is an object in SQL?
	In SQL, object is a data structure used to store or reference data such as table, index, stored procedure, views, etc.

2.What is Index? What are the advantages and disadvantages of using Indexes?
	Index is a tuning techque used in database for faster data retrieval. It is a table that stored pointers pointing to a field of a table
	Advantages: faster data accessing that meet conditions of where clause, 
	Disadvantages: additional space, slower when inserting, deleting, or updating data.

3.What are the types of Indexes?
	Unique index, Clustered index, No cluster index

4.Does SQL Server automatically create indexes when a table is created? If yes, under which constraints?
	Yes, unique constraint

5.Can a table have multiple clustered index? Why?
	Clustered indexes sort and store the data rows in the table or view based on their key values. 
	These are the columns included in the index definition. 
	There can be only one clustered index per table, because the data rows themselves can be stored in only one order.   

6.Can an index be created on multiple columns? Is yes, is the order of columns matter?
	Index can be created on multiple columns, and the orders of columns matter

7.Can indexes be created on views?
	Yes

8.What is normalization? What are the steps (normal forms) to achieve normalization?
	Normalization is a process of organizing data to minimize redundancy and ensure database integrity
	Each step to archieve normalization is called "Form" including:
		- First Normal Form: data each column should be atomic and there is no multivalue. There should be a primary key identifying each record
		- Second Normal Form: meet conditions of 1NF, and redundant data must be moved to separated tables, use foreign keys to set table relations
		- Third Normal: meet conditions of 2NF, and columns must be fully dependent on primary key

9.What is denormalization and under which scenarios can it be preferable?
	Denormalization is an optimization technique in which we add redundant data to one or more tables to avoid costly joins in a database
	It is used when a field of another table is accessed intensively with join query that may cause performance issue.

10.How do you achieve Data Integrity in SQL Server?
	The data integrity in SQL Server is divided into 3 subsets: domain, entity, and referential
	In order to archive the data integrity, each of the 3 subsets must be archived by using:
	- Using foreign key to enforces that changes cannot be made to data in the primary key table if those changes invalidate the link to data in the foreign key table
	- All columns in a relational database must be declared upon a defined domain. The primary unit of data in the relational data model is the data item. Such data items are said to be non-decomposable or atomic
	- Every table must have a primary key and that the column or columns chosen to be the primary key should be unique and not null

11.What are the different kinds of constraint do SQL Server have?
	Primary Key, Unique Key, Not Null, Foreign Key, Check, Default

12.What is the difference between Primary Key and Unique Key?
	Primary key is default unique and not null
	Unique key can have null value

13.What is foreign key?
	Foreign key is a column or group of columns that is used to represent the relation between two table

14.Can a table have multiple foreign keys?
	Yes, a table can have multiple foreign keys referencing other tables

15.Does a foreign key have to be unique? Can it be null?
	Foreign key can be duplicated, and can be null if is set as ON DELTE SET NULL.

16.Can we create indexes on Table Variables or Temporary Tables?
	Indexes cannot be created on table variables, but can be created on temporary tables

17.What is Transaction? What types of transaction levels are there in SQL Server?
	Transaction is a logical unit of work that executes either completely or not al all. 
	It contains one or more SQL statements that change the database from one consistent state to another
*/

-- 1
CREATE TABLE [customer](cust_id INT, iname VARCHAR(50));
CREATE TABLE [order](order_id INT, cust_id INT, amount MONEY, order_date SMALLDATETIME);

SELECT c.iname, SUM(o.amount) total FROM [customer] c 
JOIN [order] o ON c.cust_id = o.cust_id
WHERE YEAR(order_date)=2002
GROUP BY c.iname;

-- 2
CREATE TABLE person (id INT, firstname VARCHAR(100), lastname VARCHAR(100)) ;
SELECT * FROM person WHERE lastname LIKE 'A%';

-- 3

SELECT b.name [Manager], COUNT(a.name) [People Report] FROM person a
LEFT JOIN (SELECT * FROM person WHERE manager_id IS NULL) b ON b.person_id = a.manager_id
WHERE b.name IS NOT NULL
GROUP BY  b.name;

-- 4 Trigger Events: Insert, delete, update

-- 5

CREATE TABLE Companies(
	comp_id INT, 
	contact_id INT,
	comp_name VARCHAR(40) NOT NULL,
	CONSTRAINT PK_Companies PRIMARY KEY (comp_id),
);

CREATE TABLE PhysicalLocations (
	pl_id INT,
	address VARCHAR(50),
	city VARCHAR(40),
	country VARCHAR(40),
	zipcode VARCHAR(10),
	CONSTRAINT PK_PhysicalLocations PRIMARY KEY (pl_id),
);

CREATE TABLE Divisions(
	div_id INT,
	div_name VARCHAR(40) NOT NULL,
	CONSTRAINT PK_Divisions PRIMARY KEY (div_id),
);

CREATE TABLE ContactAddresses (
	suit_id INT,
	mail VARCHAR(40),
	CONSTRAINT PK_ContactAddresses PRIMARY KEY (suit_id),
);

CREATE TABLE Contacts(
	div_id INT,
	suit_id INT,
	comp_id INT,
	pl_id INT,
	CONSTRAINT PK_Contacts PRIMARY KEY(div_id, suit_id, comp_id, pl_id),
	CONSTRAINT FK_Contacts_Divisions FOREIGN KEY(div_id) REFERENCES Divisions(div_id),
	CONSTRAINT FK_Contacts_Companies FOREIGN KEY(comp_id) REFERENCES Companies(comp_id),
	CONSTRAINT FK_Contacts_PhysicalLocations FOREIGN KEY(pl_id) REFERENCES PhysicalLocations(pl_id),
	CONSTRAINT FK_Contacts_ContactAddresses FOREIGN KEY(suit_id) REFERENCES ContactAddresses(suit_id),
)

