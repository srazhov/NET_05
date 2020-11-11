USE Northwind

-- 13.1	�������� ���������, ������� ���������� ����� ������� ����� ��� ������� �� ��������� �� ������������ ���.
-- � ����������� �� ����� ���� ��������� ������� ������ ��������, ������ ���� ������ ���� � ����� �������. 
-- � ����������� ������� ������ ���� �������� ��������� �������: ������� � ������ � �������� �������� 
-- (FirstName � LastName � ������: Nancy Davolio), ����� ������ � ��� ���������. � ������� ���� ��������� Discount 
-- ��� ������� �������. ��������� ���������� ���, �� ������� ���� ������� �����, � ���������� ������������ �������. 
-- ���������� ������� ������ ���� ����������� �� �������� ����� ������. ��������� ������ ���� ����������� 
-- � �������������� ��������� SELECT � ��� ������������� ��������. �������� ������� �������������� GreatestOrders. 
-- ���������� ������������������ ������������� ���� ��������. ����� ������ ������������ ������� �������� � ������� Query.sql 
-- ���� �������� ��������� �������������� ����������� ������ ��� ������������ ������������ ������ ��������� GreatestOrders. 
-- ����������� ������ ������ �������� � ������� ��� ��������� � ������������ ������ �������� ���� ��� ������������� ��������
-- ��� ���� ��� ������� �� ������������ ��������� ��� � ����������� ��������� �������: ��� ��������, 
-- ����� ������, ����� ������. ����������� ������ �� ������ ��������� ������, ���������� � ���������, 
-- - �� ������ ��������� ������ ��, ��� ������� � ����������� �� ����.
GO
CREATE OR ALTER PROCEDURE GreatestOrders
	@Year INT,
	@ReqCount INT
AS BEGIN
	SELECT TOP (@ReqCount) FirstName + ' ' + LastName AS 'Name', o.OrderID, Price
	FROM Employees e
	INNER JOIN Orders o ON o.EmployeeID = e.EmployeeID
	INNER JOIN 
		(SELECT od.OrderID, MAX(UnitPrice * Quantity - (UnitPrice * Quantity * Discount)) AS Price
		FROM [Order Details] od
		GROUP BY od.OrderID) 
	AS a ON o.OrderID = a.OrderID
	WHERE YEAR(o.OrderDate) = @Year
	ORDER BY Price DESC
END

-- 13.2	�������� ���������, ������� ���������� ������ � ������� Orders, �������� ���������� ����� �������� � ���� 
-- (������� ����� OrderDate � ShippedDate).  � ����������� ������ ���� ���������� ������, ���� ������� ��������� 
-- ���������� �������� ��� ��� �������������� ������. �������� �� ��������� ��� ������������� ����� 35 ����. 
-- �������� ��������� ShippedOrdersDiff. ��������� ������ ����������� ��������� �������: OrderID, OrderDate, ShippedDate, 
-- ShippedDelay (�������� � ���� ����� ShippedDate � OrderDate), SpecifiedDelay (���������� � ��������� ��������).  
-- ���������� ������������������ ������������� ���� ���������.
GO 
CREATE OR ALTER PROCEDURE ShippedOrdersDiff
	@Time INT = 35
AS BEGIN
	SELECT *
	FROM 
	(SELECT OrderID, OrderDate, ShippedDate, DATEDIFF(DD, OrderDate, ShippedDate) AS [ShippedDelay], SpecifiedDelay = @Time
	FROM Orders) AS db
	WHERE [ShippedDelay] >= @Time OR ShippedDate IS NULL
END

-- 13.4	 �������� �������, ������� ����������, ���� �� � �������� �����������. ���������� ��� ������ BIT.
-- � �������� �������� ��������� ������� ������������ EmployeeID. �������� ������� IsBoss. 
-- ������������������ ������������� ������� ��� ���� ��������� �� ������� Employees.
GO 
CREATE OR ALTER FUNCTION IsBoss (@EmployeeID INT)
RETURNS BIT
AS BEGIN 
	DECLARE @Res BIT 
	IF (@EmployeeID IN 
		(SELECT DISTINCT b.EmployeeID
		FROM Employees e
		INNER JOIN Employees b ON b.EmployeeID = e.ReportsTo))
		SET @Res = 1
	ELSE 
		SET @Res = 0
	RETURN @Res
END