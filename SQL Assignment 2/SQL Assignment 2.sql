
/*
1.What is a result set?
	A set of data returned by the SELECT or Store Procedures that can be empty or not. It is saved in RAM and displayed on Screen. 
	TSQL script can return 0 or more result sets.

2.What is the difference between Union and Union All?
	Union return the data of two tables that have matching columns with no duplicate rows
	Union all return the all data of two tables that have matching columns with duplicate rows

3.What are the other Set Operators SQL Server has?
	Besides UNION and UNION ALL, there are: INTERSECT, EXCEPT
		EXCEPT: returns distinct records from the left table that aren't output by the right table.
		INTERSECT: returns distinct records that are output by both the left and right table.

4.What is the difference between Union and Join?
	Union returns the combinations of data between two tables with maching columns into new rows
	Join combines the data sets of two tables using a JOIN condition into new columns

5.What is the difference between INNER JOIN and FULL JOIN?
	Inner Join: brings data from left and right table that satisfy the join condition
	Full Join: return all records from both left and right table that satisfy the join conditions, and fill the missing records from either table with null

6.What is difference between left join and outer join
	Outer Join: includes left join, right join, and full join
		Left Join: brings all records from the left table and only those records from the right table which satisfy the join condition. 
				If there is no matching rows on the right, return null. It is a part of outer join
		Right Join: brings all records from the left table (the table after JOIN statement) and only those records from the right table (the table before the JOIN statement) that satisfy the join condition.
				If there is no matching rows on the right, return null. It is a part of outer join
		Full Join: brings all records from both left and right table that satisfy the join condition. If there is missing data from either table, it will fill them with null

7.What is cross join?
	cross join: return a result set containing the number of records in the first table multiplied by the number of records in the second table if no WHERE clause is used along with CROSS JOIN.

8.What is the difference between WHERE clause and HAVING clause?
	WHERE: apply the conditions to each row before grouping statement
	HAVING: used only on SELECT in a GROUP BY clause.

9.Can there be multiple group by columns?
	Yes, GROUP BY can contain two or more columns
*/
USE [AdventureWorks2019]
GO

-- 1
SELECT COUNT(1) FROM Production.Product
GO

-- 2
SELECT COUNT(ProductSubcategoryID) FROM Production.Product
GO

-- 3
SELECT ProductSubcategoryID, COUNT(ProductSubcategoryID) AS [Number of Products] FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID
GO

-- 4
SELECT COUNT(ISNULL(ProductSubcategoryID,1)) FROM Production.Product
WHERE ProductSubcategoryID IS NULL
GROUP BY ProductSubcategoryID
GO

-- 5
SELECT ProductID, SUM(Quantity) FROM Production.ProductInventory
GROUP BY ProductID
GO

-- 6
SELECT ProductID, SUM(Quantity) AS [TheSum] FROM Production.ProductInventory
WHERE LocationID = 40  
GROUP BY ProductID
HAVING SUM(Quantity) < 100
GO

-- 7
SELECT Shelf, ProductID, SUM(Quantity) AS [TheSum] FROM Production.ProductInventory
WHERE LocationID = 40  
GROUP BY Shelf, ProductID
HAVING SUM(Quantity) < 100
GO

-- 8
SELECT ProductID, AVG(Quantity) AS [TheAvg] FROM Production.ProductInventory
WHERE LocationID = 10  
GROUP BY ProductID
GO

-- 9
SELECT ProductID, Shelf, AVG(Quantity) AS [TheAvg] FROM Production.ProductInventory
GROUP BY ProductID, Shelf
GO

-- 10
SELECT ProductID, Shelf, AVG(Quantity) AS [TheAvg] FROM Production.ProductInventory
GROUP BY ProductID, Shelf
HAVING Shelf != 'N/A'
GO

-- 11
SELECT Color, Class, COUNT(ListPrice) AS TheCount, AVG(ListPrice) AS AvgPrice  
FROM Production.Product
GROUP BY Color, Class
HAVING Color IS NOT NULL AND Class IS NOT NULL
GO

-- 12
SELECT cr.Name AS [Country], sp.Name AS [Province] FROM Person.CountryRegion cr
INNER JOIN Person.StateProvince sp ON cr.CountryRegionCode = sp.CountryRegionCode
GO

-- 13
SELECT cr.Name AS [Country], sp.Name AS [Province] FROM Person.CountryRegion cr
INNER JOIN Person.StateProvince sp ON cr.CountryRegionCode = sp.CountryRegionCode
WHERE cr.Name IN ('Germany', 'Canada')
GO

USE [Northwind]
GO

-- 14
SELECT p.ProductName FROM [Products] p
INNER JOIN  [Order Details] od ON p.ProductID = od.ProductID
INNER JOIN  [Orders] o ON od.OrderID = o.OrderID
WHERE DATEDIFF(year, GETDATE(), o.OrderDate) < 25
GROUP BY od.ProductID, p.ProductName
HAVING SUM(od.Quantity) > 0
GO

-- 15
SELECT TOP 5 ShipPostalCode FROM Orders
GROUP BY ShipPostalCode
ORDER BY COUNT(ShipPostalCode) DESC
GO

-- 16
SELECT TOP 5 ShipPostalCode FROM Orders
WHERE DATEDIFF(year, GETDATE(), OrderDate) < 25
GROUP BY ShipPostalCode
ORDER BY COUNT(ShipPostalCode) DESC
GO

-- 17
SELECT City, COUNT(1) AS [Number of customers]
FROM Customers
GROUP BY City
GO

-- 18
SELECT City, COUNT(1) AS [Number of customers]
FROM Customers
GROUP BY City
HAVING COUNT(ContactName) > 10
GO

-- 19
SELECT DISTINCT c.ContactName
FROM Customers c INNER JOIN Orders o 
ON c.CustomerID = o.CustomerID
WHERE o.OrderDate > '1998-01-01'
GO

-- 20
SELECT c.ContactName, MAX(o.OrderDate) AS [Recent Date]
FROM Customers c INNER JOIN Orders o 
ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName
GO

-- 21
SELECT c.ContactName, ood.s AS [Count] FROM Customers c
INNER JOIN ( SELECT o.CustomerID, SUM(od.Quantity) s FROM Orders o 
			INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
			GROUP BY o.CustomerID ) AS ood ON c.CustomerID = ood.CustomerID
GO

-- 22
SELECT o.CustomerID FROM Orders o 
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.CustomerID
HAVING SUM(od.Quantity) > 100
GO

-- 23
SELECT su.CompanyName [Supplier Company Name], sh.CompanyName [Shipping Company Name] 
FROM Suppliers su
CROSS JOIN Shippers sh
GO

-- 24
SELECT DISTINCT o.OrderDate, p.ProductName
FROM Products p 
INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
INNER JOIN Orders o ON o.OrderID = od.OrderID
ORDER BY o.OrderDate
GO

-- 25
SELECT CONCAT(a.FirstName, ' ', a.LastName), CONCAT(b.FirstName, ' ', b.LastName) FROM Employees a 
INNER JOIN Employees b ON a.Title = b.Title
GO

-- 26
SELECT CONCAT(b.FirstName, ' ', b.LastName) AS [Full Name], b.Title FROM Employees a
INNER JOIN Employees b ON a.ReportsTo = b.EmployeeID
WHERE b.Title LIKE '%Manager%'
GROUP BY CONCAT(b.FirstName, ' ', b.LastName), b.Title
HAVING COUNT(b.Title) > 2
GO

-- 27
(SELECT c.City, c.CompanyName, 'Customer' AS [Type] FROM Customers c)
UNION
(SELECT s.City, s.CompanyName, 'Suppliers' AS [Type] FROM Suppliers s)
GO

-- 28
SELECT * FROM F1
INNER JOIN F2 ON F1.T1 = F2.T2
GO
/*
RESULT
T1	T2
2	2
3	3
*/

-- 29
SELECT * FROM F1
LEFT JOIN F2 ON F1.T1 = F2.T2
GO
/*
RESULT
T1	T2
1	NULL
2	2
3	3
*/
