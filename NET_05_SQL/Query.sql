USE Northwind

-- 1.1	������� � ������� Orders ������, ������� ���� ���������� ����� 6 ��� 1998 ���� (������� ShippedDate) ������������ 
-- � ������� ���������� � ShipVia >= 2. 
-- ������ �������� ���� ������ ���� ������ ��� ����� ������������ ����������, 
-- �������� ����������� ������ �Writing International Transact-SQL Statements� 
-- � Books Online ������ �Accessing and Changing Relational Data Overview�. 
-- ���� ����� ������������ ����� ��� ���� �������. 
-- ������ ������ ����������� ������ ������� OrderID, ShippedDate � ShipVia.
-- �������� ������ ���� �� ������ ������ � NULL-�� � ������� ShippedDate. 

-- NULL �������� �� ������ � �������, ������ ��� ��� �������� NULL �������� ������ ������������ false,
-- ���� ����� ������������ ��� NULL ��������
SELECT [OrderID], [ShippedDate], [ShipVia] FROM [Orders]
WHERE [ShipVia] >= 2 AND [ShippedDate] >= CONVERT(datetime, '05/06/1996', 101)

-- 1.2	�������� ������, ������� ������� ������ �������������� ������ �� ������� Orders.
-- � ����������� ������� ����������� ��� ������� ShippedDate
-- ������ �������� NULL ������ �Not Shipped� � ������������ ��������� ������� CAS�. 
-- ������ ������ ����������� ������ ������� OrderID � ShippedDate.
SELECT [OrderID],
CASE 
	WHEN [ShippedDate] IS NULL THEN 'Not Shipped' 
END AS 'Shipped Date'
FROM Orders
WHERE [ShippedDate] IS NULL 

-- 1.3	������� � ������� Orders ������, ������� ���� ���������� ����� 6 ��� 1998 ���� (ShippedDate) 
-- �� ������� ��� ���� ��� ������� ��� �� ����������. 
-- � ������� ������ ������������� ������ ������� OrderID (������������� � Order Number) 
-- � ShippedDate (������������� � Shipped Date). 
-- � ����������� ������� ����������� ��� ������� ShippedDate ������ �������� NULL ������ �Not Shipped�, 
-- ��� ��������� �������� ����������� ���� � ������� �� ���������.
SELECT [OrderID] AS 'Order Number', 
CASE 
	WHEN [ShippedDate] IS NULL THEN 'Not Shipped' 
	ELSE CONVERT(nvarchar, [ShippedDate])
END AS 'Shipped Date' 
FROM Orders
WHERE [ShippedDate] IS NULL OR [ShippedDate] > CONVERT(datetime, '1996-05-06', 101)

-- 2.1	������� �� ������� Customers ���� ����������, ����������� � USA � Canada. 
-- ������ ������� � ������ ������� ��������� IN.
-- ����������� ������� � ������ ������������ � ��������� ������ � ����������� �������. 
-- ����������� ���������� ������� �� ����� ���������� � �� ����� ����������.
SELECT ContactName, Country
FROM Customers
WHERE Country IN ('USA', 'Canada')
ORDER BY ContactName, Country

-- 2.2	������� �� ������� Customers ���� ����������, �� ����������� � USA � Canada. ������ ������� � ������� ��������� IN. 
-- ����������� ������� � ������ ������������ � ��������� ������ � ����������� �������. 
-- ����������� ���������� ������� �� ����� ����������.
SELECT ContactName, Country
FROM Customers
WHERE Country NOT IN ('USA', 'Canada')
ORDER BY ContactName

-- 2.3	������� �� ������� Customers ��� ������, � ������� ��������� ���������. 
-- ������ ������ ���� ��������� ������ ���� ��� � ������ ������������ �� ��������. 
-- �� ������������ ����������� GROUP BY. ����������� ������ ���� ������� � ����������� �������. 
SELECT DISTINCT Country
FROM Customers
ORDER BY Country DESC

-- 3.1	������� ��� ������ (OrderID) �� ������� Order Details (������ �� ������ �����������), 
-- ��� ����������� �������� � ����������� �� 3 �� 10 ������������ � ��� ������� Quantity � ������� Order Details. 
-- ������������ �������� BETWEEN. ������ ������ ����������� ������ ������� OrderID.
SELECT DISTINCT OrderID 
FROM [Order Details]
WHERE Quantity BETWEEN 3 AND 10

-- 3.2	������� ���� ���������� �� ������� Customers, � ������� �������� ������ ���������� �� ����� �� ��������� b � g.
-- ������������ �������� BETWEEN. ���������, ��� � ���������� ������� �������� Germany. 
-- ������ ������ ����������� ������ ������� CustomerID � Country � ������������ �� Country.
SELECT CustomerID, Country
FROM Customers
WHERE Country BETWEEN 'b' AND 'h'
ORDER BY Country

-- 3.3	������� ���� ���������� �� ������� Customers, � ������� �������� ������ ���������� �� ����� �� ��������� b � g, 
-- �� ��������� �������� BETWEEN. 
-- � ������� ����� �Execution Plan� ���������� ����� ������ ���������������� 3.2 ��� 3.3 
-- � ��� ����� ���� ������ � ������ ���������� ���������� Execution Plan-a ��� ���� ���� ��������, 
-- ���������� ���������� Execution Plan ���� ������ � ������ � ���� ����������� 
-- � �� �� ����������� ���� ����� �� ������ � �� ������ ��������� ���� ��������� ���������. 
-- ������ ������ ����������� ������ ������� CustomerID � Country � ������������ �� Country.

-- ��� ������� �������� �������� ���������
SELECT CustomerID, Country
FROM Customers
WHERE Country LIKE '[b-g]%'
ORDER BY Country

-- 4.1	� ������� Products ����� ��� �������� (������� ProductName), ��� ����������� ��������� 'chocolade'. 
-- ��������, ��� � ��������� 'chocolade' ����� ���� �������� ���� ����� 'c' � �������� 
-- - ����� ��� ��������, ������� ������������� ����� �������. 
-- ���������: ���������� ������� ������ ����������� 2 ������.
SELECT ProductName 
FROM Products
WHERE ProductName LIKE '%cho%c%olade%'

-- 5.1	����� ����� ����� ���� ������� �� ������� Order Details � ������ ���������� ����������� ������� � ������ �� ���. 
-- ��������� ��������� �� ����� � ��������� � ����� 1 ��� ���� ������ money.  
-- ������ (������� Discount) ���������� ������� �� ��������� ��� ������� ������. 
-- ��� ����������� �������������� ���� �� ��������� ������� ���� ������� ������ �� ��������� � ������� UnitPrice ����. 
-- ����������� ������� ������ ���� ���� ������ � ����� �������� � ��������� ������� 'Totals'.
SELECT SUM((UnitPrice - (UnitPrice * Discount)) * Quantity) AS Totals
FROM [Order Details]

-- 5.2	�� ������� Orders ����� ���������� �������, ������� ��� �� ���� ���������� 
-- (�.�. � ������� ShippedDate ��� �������� ���� ��������). 
-- ������������ ��� ���� ������� ������ �������� COUNT. �� ������������ ����������� WHERE � GROUP.
SELECT COUNT(*) - COUNT(ShippedDate) AS Totals
FROM Orders

-- 5.3	�� ������� Orders ����� ���������� ��������� ����������� (CustomerID), ��������� ������. 
-- ������������ ������� COUNT � �� ������������ ����������� WHERE � GROUP.
SELECT COUNT(DISTINCT CustomerID)
FROM Orders

-- 6.1	�� ������� Orders ����� ���������� ������� � ������������ �� �����. 
-- � ����������� ������� ���� ����������� ��� ������� c ���������� Year � Total. 
SELECT 
	YEAR(ShippedDate) AS 'Year', 
	COUNT(*) AS 'Total'
FROM Orders
GROUP BY Year(ShippedDate)
-- �������� ����������� ������, ������� ��������� ���������� ���� �������.
SELECT COUNT(*) AS 'Total orders Count' FROM Orders

-- 6.2	�� ������� Orders ����� ���������� �������, c�������� ������ ���������. 
-- ����� ��� ���������� �������� � ��� ����� ������ � ������� Orders, ��� � ������� EmployeeID 
-- ������ �������� ��� ������� ��������. 
-- � ����������� ������� ���� ����������� ������� � ������ �������� (������ ������������� 
-- ��� ���������� ������������� LastName & FirstName. ��� ������ LastName & FirstName ������ ���� �������� 
-- ��������� �������� � ������� ��������� �������. ����� �������� ������ ������ ������������ ����������� �� EmployeeID.) 
-- � ��������� ������� �Seller� � ������� c ����������� ������� ����������� � ��������� 'Amount'. 
-- ���������� ������� ������ ���� ����������� �� �������� ���������� �������. 
SELECT  
	Seller = (SELECT FirstName + ' ' + LastName FROM Employees WHERE EmployeeID = [Orders].EmployeeID),
	COUNT(*) AS Amount
FROM Orders
GROUP BY EmployeeID
ORDER BY Amount DESC

-- 6.3	�� ������� Orders ����� ���������� �������, c�������� ������ ��������� � ��� ������� ����������. 
-- ���������� ���������� ��� ������ ��� ������� ��������� � 1998 ����.
-- � ����������� ������� ���� ����������� ������� � ������ �������� (�������� ������� �Seller�), 
-- ������� � ������ ���������� (�������� ������� �Customer�)  � ������� c ����������� ������� ����������� � ��������� 'Amount'. 
-- � ������� ���������� ������������ ����������� �������� ����� T-SQL ��� ������ � ���������� GROUP 
-- (���� �� �������� ������� �������� ������ �ALL� � ����������� �������). 
-- ����������� ������ ���� ������� �� ID �������� � ����������. 
-- ���������� ������� ������ ���� ����������� �� ��������, ���������� � �� �������� ���������� ������.
-- � ����������� ������ ���� ������� ���������� �� ��������. 
SELECT empl.EmployeeID AS Seller, cust.CustomerID AS Customer, COUNT(*) AS Amount
FROM Orders o
INNER JOIN Customers cust ON cust.CustomerID = o.CustomerID
INNER JOIN Employees empl ON empl.EmployeeID = o.EmployeeID
WHERE YEAR(OrderDate) = 1998
GROUP BY empl.EmployeeID, cust.CustomerID
ORDER BY [Seller], [Customer], [Amount] 

-- 6.4	����� ����������� � ���������, ������� ����� � ����� ������. ���� � ������ ����� ������ ���� 
-- ��� ��������� ��������� ��� ������ ���� ��� ��������� �����������, �� ���������� � ����� ���������� � ��������� 
-- �� ������ �������� � �������������� �����. �� ������������ ����������� JOIN. � ����������� ������� ���������� 
-- ������� ��������� ��������� ��� ����������� �������: �Person�, �Type� (����� ���� �������� ������ �Customer� ���  
-- �Seller� � ��������� �� ���� ������), �City�. 
-- ������������� ���������� ������� �� ������� �City� � �� �Person�.
SELECT e.FirstName + ' ' + e.LastName AS [Person], cust.ContactName AS [Type], e.City
FROM Employees e
INNER JOIN Customers cust ON cust.City = e.City
ORDER BY e.City, [Person]

-- 6.5	����� ���� �����������, ������� ����� � ����� ������. � ������� ������������ ���������� ������� Customers c ����� 
-- - ��������������. ��������� ������� CustomerID � City. ������ �� ������ ����������� ����������� ������. 
SELECT CustomerID, City
FROM Customers A
WHERE EXISTS (
	SELECT City
	FROM Customers B
	WHERE A.City = B.City AND NOT (A.CustomerID = B.CustomerID))

-- ��� �������� �������� ������, ������� ����������� ������, ������� ����������� ����� ������ ���� � ������� Customers. 
-- ��� �������� ��������� ������������ �������.
SELECT City
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) > 1

-- 6.6	�� ������� Employees ����� ��� ������� �������� ��� ������������, �.�. ���� �� ������ �������. 
-- ��������� ������� � ������� 'User Name' (LastName) � 'Boss'. 
-- � �������� ������ ���� ��������� ����� �� ������� LastName. ��������� �� ��� �������� � ���� �������?

-- � ����������� ��� Fuller'�, � �������� ��� ������������ 
SELECT a.LastName AS [User Name], Boss
FROM Employees a
INNER JOIN (SELECT LastName AS [Boss], EmployeeID  FROM Employees b) AS b ON a.ReportsTo = b.EmployeeID

-- 7.1	���������� ���������, ������� ����������� ������ 'Western' (������� Region). 
-- ���������� ������� ������ ����������� ��� ����: 'LastName' �������� � �������� ������������� ���������� 
-- ('TerritoryDescription' �� ������� Territories). ������ ������ ������������ JOIN � ����������� FROM. 
-- ��� ����������� ������ ����� ��������� Employees � Territories ���� ������������ ����������� ��������� ��� ���� Northwind.
SELECT 
	Employees.LastName,
	TerritorieName = (SELECT TerritoryDescription FROM Territories WHERE TerritoryID = empl.TerritoryID)
FROM Employees
INNER JOIN EmployeeTerritories empl ON empl.EmployeeID = Employees.EmployeeID
INNER JOIN Territories terr ON terr.TerritoryID = empl.TerritoryID
WHERE (SELECT RegionDescription FROM Region WHERE RegionID = terr.RegionID) = 'Western'

-- 8.1	��������� � ����������� ������� ����� ���� ���������� �� ������� Customers � ��������� ���������� �� ������� 
-- �� ������� Orders. ������� �� ��������, ��� � ��������� ���������� ��� �������, �� ��� ����� ������ ���� �������� 
-- � ����������� �������. ����������� ���������� ������� �� ����������� ���������� �������.
SELECT c.CustomerID, COUNT(o.OrderID) AS 'Orders Count'
FROM Customers c
LEFT OUTER JOIN Orders o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID
ORDER BY 'Orders Count'

-- 9.1	��������� ���� ����������� ������� CompanyName � ������� Suppliers, � ������� ��� ���� �� ������ �������� 
-- �� ������ (UnitsInStock � ������� Products ����� 0). ������������ ��������� SELECT ��� ����� ������� � �������������� 
-- ��������� IN. ����� �� ������������ ������ ��������� IN �������� '=' ?

-- �������� '=' ������ ������������, ������ ��� ������������ ��������� �������� � ����������
SELECT CompanyName 
FROM Suppliers s
INNER JOIN Products p ON p.SupplierID = s.SupplierID
WHERE UnitsInStock IN (SELECT UnitsInStock = 0 FROM Products)

-- 10.1	��������� ���� ���������, ������� ����� ����� 150 �������. ������������ ��������� ��������������� SELECT.
SELECT FirstName + ' ' + LastName AS EmployeeName
FROM Employees e
WHERE 150 < (
	SELECT COUNT(*)
	FROM Orders o
	WHERE e.EmployeeID = o.EmployeeID)

-- 11.1	��������� ���� ���������� (������� Customers), ������� �� ����� �� ������ ������ (��������� �� ������� Orders).
-- ������������ ��������������� SELECT � �������� EXISTS.
SELECT CustomerID
FROM Customers c
WHERE NOT EXISTS (
	SELECT CustomerID
	FROM Orders o
	WHERE o.CustomerID = c.CustomerID
	GROUP BY o.CustomerID
	HAVING COUNT(o.OrderID) >= 1)

-- 12.1	��� ������������ ����������� ��������� Employees ��������� �� ������� Employees ������ ������ ��� ���� ��������, 
-- � ������� ���������� ������� Employees (������� LastName ) �� ���� �������. 
-- ���������� ������ ������ ���� ������������ �� �����������.
SELECT DISTINCT LEFT(LastName, 1) AS 'First Letter' 
FROM Employees
ORDER BY 'First Letter'

-- 13
-- ��������� � �������
-- 13.1
EXEC [GreatestOrders] 1998, 10

-- ����������� ������ ��� 13.1
SELECT 
TOP(10) od.OrderID, MAX(UnitPrice * Quantity) AS 'Price' 
FROM [Order Details] od 
INNER JOIN Orders o ON od.OrderID = o.OrderID
WHERE YEAR(o.OrderDate) = 1998
GROUP BY od.OrderID 
ORDER BY 'Price' DESC

-- 13.2
EXEC [ShippedOrdersDiff] 30

-- 13.4
SELECT FirstName + ' ' + LastName, Northwind.dbo.IsBoss(EmployeeID) AS 'IsBoss'
FROM Employees