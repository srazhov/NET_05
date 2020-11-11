USE Northwind

-- 13.1	Написать процедуру, которая возвращает самый крупный заказ для каждого из продавцов за определенный год.
-- В результатах не может быть несколько заказов одного продавца, должен быть только один и самый крупный. 
-- В результатах запроса должны быть выведены следующие колонки: колонка с именем и фамилией продавца 
-- (FirstName и LastName – пример: Nancy Davolio), номер заказа и его стоимость. В запросе надо учитывать Discount 
-- при продаже товаров. Процедуре передается год, за который надо сделать отчет, и количество возвращаемых записей. 
-- Результаты запроса должны быть упорядочены по убыванию суммы заказа. Процедура должна быть реализована 
-- с использованием оператора SELECT и БЕЗ ИСПОЛЬЗОВАНИЯ КУРСОРОВ. Название функции соответственно GreatestOrders. 
-- Необходимо продемонстрировать использование этих процедур. Также помимо демонстрации вызовов процедур в скрипте Query.sql 
-- надо написать отдельный ДОПОЛНИТЕЛЬНЫЙ проверочный запрос для тестирования правильности работы процедуры GreatestOrders. 
-- Проверочный запрос должен выводить в удобном для сравнения с результатами работы процедур виде для определенного продавца
-- для всех его заказов за определенный указанный год в результатах следующие колонки: имя продавца, 
-- номер заказа, сумму заказа. Проверочный запрос не должен повторять запрос, написанный в процедуре, 
-- - он должен выполнять только то, что описано в требованиях по нему.
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

-- 13.2	Написать процедуру, которая возвращает заказы в таблице Orders, согласно указанному сроку доставки в днях 
-- (разница между OrderDate и ShippedDate).  В результатах должны быть возвращены заказы, срок которых превышает 
-- переданное значение или еще недоставленные заказы. Значению по умолчанию для передаваемого срока 35 дней. 
-- Название процедуры ShippedOrdersDiff. Процедура должна высвечивать следующие колонки: OrderID, OrderDate, ShippedDate, 
-- ShippedDelay (разность в днях между ShippedDate и OrderDate), SpecifiedDelay (переданное в процедуру значение).  
-- Необходимо продемонстрировать использование этой процедуры.
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

-- 13.4	 Написать функцию, которая определяет, есть ли у продавца подчиненные. Возвращает тип данных BIT.
-- В качестве входного параметра функции используется EmployeeID. Название функции IsBoss. 
-- Продемонстрировать использование функции для всех продавцов из таблицы Employees.
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