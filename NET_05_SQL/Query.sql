USE Northwind

-- 1.1	Выбрать в таблице Orders заказы, которые были доставлены после 6 мая 1998 года (колонка ShippedDate) включительно 
-- и которые доставлены с ShipVia >= 2. 
-- Формат указания даты должен быть верным при любых региональных настройках, 
-- согласно требованиям статьи “Writing International Transact-SQL Statements” 
-- в Books Online раздел “Accessing and Changing Relational Data Overview”. 
-- Этот метод использовать далее для всех заданий. 
-- Запрос должен высвечивать только колонки OrderID, ShippedDate и ShipVia.
-- Пояснить почему сюда не попали заказы с NULL-ом в колонке ShippedDate. 

-- NULL значения не попали в выборку, потому что при проверке NULL значения всегда возвращается false,
-- даже когда сравниваются два NULL значения
SELECT [OrderID], [ShippedDate], [ShipVia] FROM [Orders]
WHERE [ShipVia] >= 2 AND [ShippedDate] >= CONVERT(datetime, '05/06/1996', 101)

-- 1.2	Написать запрос, который выводит только недоставленные заказы из таблицы Orders.
-- В результатах запроса высвечивать для колонки ShippedDate
-- вместо значений NULL строку ‘Not Shipped’ – использовать системную функцию CASЕ. 
-- Запрос должен высвечивать только колонки OrderID и ShippedDate.
SELECT [OrderID],
CASE 
	WHEN [ShippedDate] IS NULL THEN 'Not Shipped' 
END AS 'Shipped Date'
FROM Orders
WHERE [ShippedDate] IS NULL 

-- 1.3	Выбрать в таблице Orders заказы, которые были доставлены после 6 мая 1998 года (ShippedDate) 
-- не включая эту дату или которые еще не доставлены. 
-- В запросе должны высвечиваться только колонки OrderID (переименовать в Order Number) 
-- и ShippedDate (переименовать в Shipped Date). 
-- В результатах запроса высвечивать для колонки ShippedDate вместо значений NULL строку ‘Not Shipped’, 
-- для остальных значений высвечивать дату в формате по умолчанию.
SELECT [OrderID] AS 'Order Number', 
CASE 
	WHEN [ShippedDate] IS NULL THEN 'Not Shipped' 
	ELSE CONVERT(nvarchar, [ShippedDate])
END AS 'Shipped Date' 
FROM Orders
WHERE [ShippedDate] IS NULL OR [ShippedDate] > CONVERT(datetime, '1996-05-06', 101)

-- 2.1	Выбрать из таблицы Customers всех заказчиков, проживающих в USA и Canada. 
-- Запрос сделать с только помощью оператора IN.
-- Высвечивать колонки с именем пользователя и названием страны в результатах запроса. 
-- Упорядочить результаты запроса по имени заказчиков и по месту проживания.
SELECT ContactName, Country
FROM Customers
WHERE Country IN ('USA', 'Canada')
ORDER BY ContactName, Country

-- 2.2	Выбрать из таблицы Customers всех заказчиков, не проживающих в USA и Canada. Запрос сделать с помощью оператора IN. 
-- Высвечивать колонки с именем пользователя и названием страны в результатах запроса. 
-- Упорядочить результаты запроса по имени заказчиков.
SELECT ContactName, Country
FROM Customers
WHERE Country NOT IN ('USA', 'Canada')
ORDER BY ContactName

-- 2.3	Выбрать из таблицы Customers все страны, в которых проживают заказчики. 
-- Страна должна быть упомянута только один раз и список отсортирован по убыванию. 
-- Не использовать предложение GROUP BY. Высвечивать только одну колонку в результатах запроса. 
SELECT DISTINCT Country
FROM Customers
ORDER BY Country DESC

-- 3.1	Выбрать все заказы (OrderID) из таблицы Order Details (заказы не должны повторяться), 
-- где встречаются продукты с количеством от 3 до 10 включительно – это колонка Quantity в таблице Order Details. 
-- Использовать оператор BETWEEN. Запрос должен высвечивать только колонку OrderID.
SELECT DISTINCT OrderID 
FROM [Order Details]
WHERE Quantity BETWEEN 3 AND 10

-- 3.2	Выбрать всех заказчиков из таблицы Customers, у которых название страны начинается на буквы из диапазона b и g.
-- Использовать оператор BETWEEN. Проверить, что в результаты запроса попадает Germany. 
-- Запрос должен высвечивать только колонки CustomerID и Country и отсортирован по Country.
SELECT CustomerID, Country
FROM Customers
WHERE Country BETWEEN 'b' AND 'h'
ORDER BY Country

-- 3.3	Выбрать всех заказчиков из таблицы Customers, у которых название страны начинается на буквы из диапазона b и g, 
-- не используя оператор BETWEEN. 
-- С помощью опции “Execution Plan” определить какой запрос предпочтительнее 3.2 или 3.3 
-- – для этого надо ввести в скрипт выполнение текстового Execution Plan-a для двух этих запросов, 
-- результаты выполнения Execution Plan надо ввести в скрипт в виде комментария 
-- и по их результатам дать ответ на вопрос – по какому параметру было проведено сравнение. 
-- Запрос должен высвечивать только колонки CustomerID и Country и отсортирован по Country.

-- Два запроса работают примерно одинаково
SELECT CustomerID, Country
FROM Customers
WHERE Country LIKE '[b-g]%'
ORDER BY Country

-- 4.1	В таблице Products найти все продукты (колонка ProductName), где встречается подстрока 'chocolade'. 
-- Известно, что в подстроке 'chocolade' может быть изменена одна буква 'c' в середине 
-- - найти все продукты, которые удовлетворяют этому условию. 
-- Подсказка: результаты запроса должны высвечивать 2 строки.
SELECT ProductName 
FROM Products
WHERE ProductName LIKE '%cho%c%olade%'

-- 5.1	Найти общую сумму всех заказов из таблицы Order Details с учетом количества закупленных товаров и скидок по ним. 
-- Результат округлить до сотых и высветить в стиле 1 для типа данных money.  
-- Скидка (колонка Discount) составляет процент из стоимости для данного товара. 
-- Для определения действительной цены на проданный продукт надо вычесть скидку из указанной в колонке UnitPrice цены. 
-- Результатом запроса должна быть одна запись с одной колонкой с названием колонки 'Totals'.
SELECT SUM((UnitPrice - (UnitPrice * Discount)) * Quantity) AS Totals
FROM [Order Details]

-- 5.2	По таблице Orders найти количество заказов, которые еще не были доставлены 
-- (т.е. в колонке ShippedDate нет значения даты доставки). 
-- Использовать при этом запросе только оператор COUNT. Не использовать предложения WHERE и GROUP.
SELECT COUNT(*) - COUNT(ShippedDate) AS Totals
FROM Orders

-- 5.3	По таблице Orders найти количество различных покупателей (CustomerID), сделавших заказы. 
-- Использовать функцию COUNT и не использовать предложения WHERE и GROUP.
SELECT COUNT(DISTINCT CustomerID)
FROM Orders

-- 6.1	По таблице Orders найти количество заказов с группировкой по годам. 
-- В результатах запроса надо высвечивать две колонки c названиями Year и Total. 
SELECT 
	YEAR(ShippedDate) AS 'Year', 
	COUNT(*) AS 'Total'
FROM Orders
GROUP BY Year(ShippedDate)
-- Написать проверочный запрос, который вычисляет количество всех заказов.
SELECT COUNT(*) AS 'Total orders Count' FROM Orders

-- 6.2	По таблице Orders найти количество заказов, cделанных каждым продавцом. 
-- Заказ для указанного продавца – это любая запись в таблице Orders, где в колонке EmployeeID 
-- задано значение для данного продавца. 
-- В результатах запроса надо высвечивать колонку с именем продавца (Должно высвечиваться 
-- имя полученное конкатенацией LastName & FirstName. Эта строка LastName & FirstName должна быть получена 
-- отдельным запросом в колонке основного запроса. Также основной запрос должен использовать группировку по EmployeeID.) 
-- с названием колонки ‘Seller’ и колонку c количеством заказов высвечивать с названием 'Amount'. 
-- Результаты запроса должны быть упорядочены по убыванию количества заказов. 
SELECT  
	Seller = (SELECT FirstName + ' ' + LastName FROM Employees WHERE EmployeeID = [Orders].EmployeeID),
	COUNT(*) AS Amount
FROM Orders
GROUP BY EmployeeID
ORDER BY Amount DESC

-- 6.3	По таблице Orders найти количество заказов, cделанных каждым продавцом и для каждого покупателя. 
-- Необходимо определить это только для заказов сделанных в 1998 году.
-- В результатах запроса надо высвечивать колонку с именем продавца (название колонки ‘Seller’), 
-- колонку с именем покупателя (название колонки ‘Customer’)  и колонку c количеством заказов высвечивать с названием 'Amount'. 
-- В запросе необходимо использовать специальный оператор языка T-SQL для работы с выражением GROUP 
-- (Этот же оператор поможет выводить строку “ALL” в результатах запроса). 
-- Группировки должны быть сделаны по ID продавца и покупателя. 
-- Результаты запроса должны быть упорядочены по продавцу, покупателю и по убыванию количества продаж.
-- В результатах должна быть сводная информация по продажам. 
SELECT empl.EmployeeID AS Seller, cust.CustomerID AS Customer, COUNT(*) AS Amount
FROM Orders o
INNER JOIN Customers cust ON cust.CustomerID = o.CustomerID
INNER JOIN Employees empl ON empl.EmployeeID = o.EmployeeID
WHERE YEAR(OrderDate) = 1998
GROUP BY empl.EmployeeID, cust.CustomerID
ORDER BY [Seller], [Customer], [Amount] 

-- 6.4	Найти покупателей и продавцов, которые живут в одном городе. Если в городе живут только один 
-- или несколько продавцов или только один или несколько покупателей, то информация о таких покупателя и продавцах 
-- не должна попадать в результирующий набор. Не использовать конструкцию JOIN. В результатах запроса необходимо 
-- вывести следующие заголовки для результатов запроса: ‘Person’, ‘Type’ (здесь надо выводить строку ‘Customer’ или  
-- ‘Seller’ в завимости от типа записи), ‘City’. 
-- Отсортировать результаты запроса по колонке ‘City’ и по ‘Person’.
SELECT e.FirstName + ' ' + e.LastName AS [Person], cust.ContactName AS [Type], e.City
FROM Employees e
INNER JOIN Customers cust ON cust.City = e.City
ORDER BY e.City, [Person]

-- 6.5	Найти всех покупателей, которые живут в одном городе. В запросе использовать соединение таблицы Customers c собой 
-- - самосоединение. Высветить колонки CustomerID и City. Запрос не должен высвечивать дублируемые записи. 
SELECT CustomerID, City
FROM Customers A
WHERE EXISTS (
	SELECT City
	FROM Customers B
	WHERE A.City = B.City AND NOT (A.CustomerID = B.CustomerID))

-- Для проверки написать запрос, который высвечивает города, которые встречаются более одного раза в таблице Customers. 
-- Это позволит проверить правильность запроса.
SELECT City
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) > 1

-- 6.6	По таблице Employees найти для каждого продавца его руководителя, т.е. кому он делает репорты. 
-- Высветить колонки с именами 'User Name' (LastName) и 'Boss'. 
-- В колонках должны быть высвечены имена из колонки LastName. Высвечены ли все продавцы в этом запросе?

-- В результатах нет Fuller'а, у которого нет руководителя 
SELECT a.LastName AS [User Name], Boss
FROM Employees a
INNER JOIN (SELECT LastName AS [Boss], EmployeeID  FROM Employees b) AS b ON a.ReportsTo = b.EmployeeID

-- 7.1	Определить продавцов, которые обслуживают регион 'Western' (таблица Region). 
-- Результаты запроса должны высвечивать два поля: 'LastName' продавца и название обслуживаемой территории 
-- ('TerritoryDescription' из таблицы Territories). Запрос должен использовать JOIN в предложении FROM. 
-- Для определения связей между таблицами Employees и Territories надо использовать графические диаграммы для базы Northwind.
SELECT 
	Employees.LastName,
	TerritorieName = (SELECT TerritoryDescription FROM Territories WHERE TerritoryID = empl.TerritoryID)
FROM Employees
INNER JOIN EmployeeTerritories empl ON empl.EmployeeID = Employees.EmployeeID
INNER JOIN Territories terr ON terr.TerritoryID = empl.TerritoryID
WHERE (SELECT RegionDescription FROM Region WHERE RegionID = terr.RegionID) = 'Western'

-- 8.1	Высветить в результатах запроса имена всех заказчиков из таблицы Customers и суммарное количество их заказов 
-- из таблицы Orders. Принять во внимание, что у некоторых заказчиков нет заказов, но они также должны быть выведены 
-- в результатах запроса. Упорядочить результаты запроса по возрастанию количества заказов.
SELECT c.CustomerID, COUNT(o.OrderID) AS 'Orders Count'
FROM Customers c
LEFT OUTER JOIN Orders o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID
ORDER BY 'Orders Count'

-- 9.1	Высветить всех поставщиков колонка CompanyName в таблице Suppliers, у которых нет хотя бы одного продукта 
-- на складе (UnitsInStock в таблице Products равно 0). Использовать вложенный SELECT для этого запроса с использованием 
-- оператора IN. Можно ли использовать вместо оператора IN оператор '=' ?

-- Оператор '=' нельзя использовать, потому что возвращается несколько значении в подзапросе
SELECT CompanyName 
FROM Suppliers s
INNER JOIN Products p ON p.SupplierID = s.SupplierID
WHERE UnitsInStock IN (SELECT UnitsInStock = 0 FROM Products)

-- 10.1	Высветить всех продавцов, которые имеют более 150 заказов. Использовать вложенный коррелированный SELECT.
SELECT FirstName + ' ' + LastName AS EmployeeName
FROM Employees e
WHERE 150 < (
	SELECT COUNT(*)
	FROM Orders o
	WHERE e.EmployeeID = o.EmployeeID)

-- 11.1	Высветить всех заказчиков (таблица Customers), которые не имеют ни одного заказа (подзапрос по таблице Orders).
-- Использовать коррелированный SELECT и оператор EXISTS.
SELECT CustomerID
FROM Customers c
WHERE NOT EXISTS (
	SELECT CustomerID
	FROM Orders o
	WHERE o.CustomerID = c.CustomerID
	GROUP BY o.CustomerID
	HAVING COUNT(o.OrderID) >= 1)

-- 12.1	Для формирования алфавитного указателя Employees высветить из таблицы Employees список только тех букв алфавита, 
-- с которых начинаются фамилии Employees (колонка LastName ) из этой таблицы. 
-- Алфавитный список должен быть отсортирован по возрастанию.
SELECT DISTINCT LEFT(LastName, 1) AS 'First Letter' 
FROM Employees
ORDER BY 'First Letter'

-- 13
-- ПРОЦЕДУРЫ И ФУНКЦИИ
-- 13.1
EXEC [GreatestOrders] 1998, 10

-- Проверочный запрос для 13.1
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