USE [AdventureWorks2019]
GO

-- 1
SELECT ProductID, Name, Color, ListPrice FROM Production.Product
GO

-- 2
SELECT ProductID, Name, Color, ListPrice FROM Production.Product WHERE ListPrice = 0
GO

-- 3
SELECT ProductID, Name, Color, ListPrice FROM Production.Product WHERE Color IS NULL
GO

-- 4
SELECT ProductID, Name, Color, ListPrice FROM Production.Product WHERE Color IS NOT NULL
GO

-- 5
SELECT ProductID, Name, Color, ListPrice FROM Production.Product WHERE Color IS NOT NULL AND ListPrice > 0
GO

-- 6
SELECT CONCAT(Name, ' ', Color) FROM Production.Product WHERE Color IS NOT NULL
GO

-- 7
SELECT CONCAT('NAME:', Name, ' -- COLOR: ', Color) AS [Name And Color] FROM Production.Product WHERE Color IS NOT NULL
GO

-- 8
SELECT ProductID, Name FROM Production.Product WHERE ProductID BETWEEN 400 AND 500
GO

-- 9
SELECT ProductID, Name, Color FROM Production.Product WHERE Color IN ('Black', 'Blue')
GO

-- 10
SELECT * FROM Production.Product WHERE Name LIKE 'S%'
GO

-- 11
SELECT Name, ListPrice FROM Production.Product WHERE Name LIKE 'S%' ORDER BY Name
GO

-- 12
SELECT Name, ListPrice FROM Production.Product WHERE Name LIKE '[S|A]%' ORDER BY Name
GO

-- 13
SELECT * FROM Production.Product WHERE Name LIKE '[S|P|O][^K]%' ORDER BY Name
GO

-- 14
SELECT DISTINCT Color FROM Production.Product ORDER BY Color DESC
GO

-- 15
SELECT DISTINCT ProductSubcategoryID, Color FROM Production.Product 
WHERE ProductSubcategoryID IS NOT NULL AND Color IS NOT NULL 
ORDER BY ProductSubcategoryID, Color
GO

-- 16
SELECT ProductSubCategoryID , LEFT([Name],35) AS [Name] , Color, ListPrice 
FROM Production.Product
WHERE (Color NOT IN ('Red','Black') AND ProductSubCategoryID = 1)
      OR ListPrice BETWEEN 1000 AND 2000 
ORDER BY ProductID ASC
GO

-- 17
SELECT ProductSubCategoryID, Name, Color, ListPrice FROM Production.Product
WHERE ProductSubcategoryID < 15
ORDER BY ProductSubcategoryID DESC, Name
GO