
/*
1.What is View? What are the benefits of using views?
	view is the result set of a stored query on the data, which the database users can query just as
they would in a persistent database collection object.
a view can limit the degree of exposure of the underlying tables to the outer world: a given user

2.Can data be modified through views?
	Data cannot be modified through views. Views are only to show data

3.What is stored procedure and what are the benefits of using it?
	A stored precedure is a block of code similar to a function that is used to avoid rewriting code. It can be called and executed without writing same codes again.

4.What is the difference between view and stored procedure?
	Views are used to display data with SELECT query and they are fater than stored procedures
	Stored Procedure are used to execute to perform a set of tasks

5.What is the difference between stored procedure and functions?
	Stored Procedures: 
	Functions have return type and returns a value

6.Can stored procedure return multiple result sets?
	Yes, the output with OUT parameters can result in multiple sets.

7.Can stored procedure be executed as part of SELECT Statement? Why?
	If the stored procedure returns a result set, it can be used as a part of SELECT statement.

8.What is Trigger? What types of Triggers are there?
	Trigger is a type of stored procedure that is executed when an event happens
	DML Triggers, DDL Triggers, LOGON Triggers

9.What are the scenarios to use Triggers?
	Triggers can be invoked when a new row inserted/removed/updated from a table

10.What is the difference between Trigger and Stored Procedure?
	Stored procedures are to perform a specific task that requires manual execution.
	Trigger is a stored procedure that executes automatically based a specific event
*/
USE [Northwind]
GO
-- 1
BEGIN TRAN
	-- a.A new region called “Middle Earth”;
	INSERT INTO Region VALUES(5, 'Middle Earth');
	-- b.A new territory called “Gondor”, belongs to region “Middle Earth”;
	INSERT INTO Territories VALUES(10000,'Gondor', 5)
	-- c.A new employee “Aragorn King” who's territory is “Gondor”.
	INSERT INTO Employees(LastName, FirstName) VALUES('King', 'Aragorn');
	INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES(10, 10000);

-- 2
	UPDATE Territories SET TerritoryDescription = 'Arnor' WHERE TerritoryDescription = 'Gondor';

-- 3
	DELETE FROM EmployeeTerritories WHERE EmployeeID = 10 AND TerritoryID = 10000;
	DELETE FROM Territories WHERE TerritoryID = 10000 AND TerritoryDescription = 'Arnor';
	DELETE FROM Region WHERE RegionDescription = 'Middle Earth';
ROLLBACK TRAN;

-- 4
CREATE VIEW view_product_order_Dinh 
AS
	SELECT p.ProductID, Count(o.Quantity) [Order Quantity] FROM Products p 
	INNER JOIN [Order Details] o
	ON o.ProductID = p.ProductID
	GROUP BY p.ProductName;

-- 5
CREATE PROCEDURE sp_product_order_quantity_Dinh 
	@id INT, @total INT OUT
AS 
	BEGIN
		SELECT @id = v.ProductID, @total = v.[Order Quantity]
		FROM view_product_order_Dinh v
		WHERE v.ProductID = @id
	END;

-- 6
CREATE PROCEDURE sp_product_order_city_Dinh 
	@pName VARCHAR(40)
AS
	BEGIN
	SELECT c.ProductName, c.ShipCity, c.[Total Quantity] 
		FROM (
			SELECT p.ProductName, SUM(od.Quantity) [Total Quantity], o.ShipCity, 
			ROW_NUMBER() OVER (PARTITION BY p.ProductName ORDER BY SUM(od.Quantity) DESC) rnk
			FROM Products p
			LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
			LEFT JOIN Orders o ON od.OrderID = o.OrderID
			GROUP BY o.ShipCity,  p.ProductName 
		) AS c 
	WHERE c.rnk <= 5 AND c.ProductName LIKE @pName;
	END;

-- 7
SELECT * FROM Territories ORDER BY TerritoryDescription;
BEGIN TRAN
	
	CREATE PROCEDURE sp_move_employees_Dinh
	AS
		BEGIN
		DECLARE @Troy INT = (SELECT TerritoryID FROM Territories WHERE TerritoryDescription = 'Troy');
		IF EXISTS(SELECT * FROM EmployeeTerritories WHERE TerritoryID =  @Troy)
			BEGIN 
				INSERT INTO Territories(TerritoryDescription, RegionID) VALUES (11000, 'Stevens Point', 3);
				UPDATE EmployeeTerritories SET TerritoryID = 11000 WHERE TerritoryID = 48084;
			END
		END
ROLLBACK TRAN;

-- 8 
	CREATE TRIGGER trigger_8 ON territories
	FOR UPDATE AS
		IF EXISTS(SELECT e.employeeid, COUNT(t.TerritoryDescription) FROM Territories t
				JOIN employeeterritories et ON t.TerritoryID=et.TerritoryID
				JOIN Employees e ON et.EmployeeID=e.EmployeeID
				WHERE t.TerritoryDescription='Stevens Point'
				GROUP BY e.EmployeeID
				HAVING COUNT(t.TerritoryDescription)>100
			)
		BEGIN
			UPDATE Territories
			SET TerritoryDescription='Troy' WHERE TerritoryDescription='Stevens Point'
		END
	DROP TRIGGER trigger_8

-- 9 
BEGIN TRAN
	CREATE TABLE people_Dinh(id INT, Name VARCHAR(40),City INT);
	CREATE TABLE city_Dinh(Id INT, City VARCHAR(40));

	INSERT INTO city_Dinh(Id, City) VALUES(1,'Seattle');
	INSERT INTO city_Dinh(Id, City) VALUES(2,'Green Bay');

	INSERT INTO people_Dinh(id, Name, City) VALUES(1,'Aaron Rodgers', 2);
	INSERT INTO people_Dinh(id, Name, City) VALUES(2,'Russell Wilson', 1);
	INSERT INTO people_Dinh(id, Name, City) VALUES(3,'Jody Nelson', 2);

	IF EXISTS(SELECT * FROM people_Dinh WHERE City = 1)
		BEGIN
			INSERT INTO city_Dinh(Id, City) VALUES(3,'Madison');
			UPDATE people_Dinh SET City = 3 WHERE City = 1;
		END
	ELSE
		DECLARE @nothing INT;
	DELETE FROM city_Dinh WHERE City = 'Seattle';

	CREATE VIEW Packers_Kiet_Dinh 
	AS
		SELECT p.id, p.Name FROM people_Dinh p 
		INNER JOIN city_Dinh c ON p.City = c.Id
		WHERE c.City='Green bay';

	DROP TABLE people_Dinh;
	DROP TABLE city_Dinh;
	DROP VIEW Packers_Kiet_Dinh;
ROLLBACK

-- 10
CREATE PROCEDURE sp_birthday_employees_Dinh 
AS
	BEGIN
		CREATE TABLE birthday_employees_Dinh (EmployeeID INT, LastName VARCHAR(40), FirstName VARCHAR(40));
		INSERT INTO birthday_employees_Dinh (EmployeeID, LastName, FirstName)
		SELECT e.EmployeeID, e.LastName, e.FirstName FROM Employees e WHERE DATEPART(month, e.BirthDate) = 2;
	END

DROP TABLE birthday_employees_Dinh;
DROP PROCEDURE sp_birthday_employees_Dinh;

-- 11 returns all cites that have at least 2 customers who have bought no or only one kind of product.
CREATE PROCEDURE sp_Dinh_1 
AS
	BEGIN
		SELECT a.ShipCity FROM (
			SELECT o.ShipCity, o.CustomerID FROM Orders o 
			LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
			GROUP BY o.ShipCity, o.CustomerID
			HAVING COUNT(od.ProductID) < 2 
			) a
		GROUP BY a.ShipCity 
		HAVING COUNT(a.CustomerID) > 1;
	END


CREATE PROCEDURE sp_Dinh_2 
AS
	BEGIN
		WITH CTE_CityCustomer AS
		(
			SELECT o.ShipCity, o.CustomerID, COUNT(od.ProductID) [Count] FROM Orders o 
			LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
			GROUP BY o.ShipCity, o.CustomerID
			HAVING COUNT(od.ProductID) < 2 
		) SELECT c.ShipCity FROM CTE_CityCustomer c GROUP BY c.ShipCity HAVING COUNT(c.CustomerID) > 1;
	END


-- 12.
/*  Get the size of two tables and Union them. 
	If the size of the result set from the Union query is the same as the tables, there are same data.
*/

-- 14
	SELECT CASE
		WHEN [Middle Name] IS NOT NULL THEN CONCAT([First Name],' ', [Last Name], ' ', [Middle Name], '.') 
		ELSE CONCAT([First Name],' ', [Last Name], ' ', [Middle Name], '.')
		END AS [Full Name]
	FROM People;

-- 15
	SELECT TOP(1) *
	FROM Student WHERE Sex = 'F' ORDER BY Marks;

-- 16
	SELECT * FROM Student ORDER BY Sex, Marks DESC;