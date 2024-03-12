--Check how data looks like
SELECT TOP 100
	*
FROM Sales.[Order]

--Total orders
SELECT
	COUNT(OrderID) AS total_items_ordered
FROM Sales.[Order]

--Total items ordered
SELECT
	SUM(Quantity) AS total_items_ordered
FROM Sales.OrderItem

--Years with the corresponding count of items ordered for each year
SELECT
	YEAR(b.OrderDate) AS [Year],
	SUM(a.Quantity) AS total_items_ordered
FROM Sales.OrderItem a
JOIN Sales.[Order] b ON a.OrderID = b.OrderID
GROUP BY YEAR(b.OrderDate)

--Average discount
SELECT
	AVG(ListPrice * Discount) AS avg_discount
FROM Sales.OrderItem

--Customers that didnt placed any orders 
SELECT
	a.CustomerID,
	FirstName,
	LastName
FROM Sales.Customer a
LEFT JOIN Sales.[Order] b on a.CustomerID = b.CustomerID
WHERE b.[Status] is null
GROUP BY a.CustomerID, FirstName, LastName

--Customers who placed most orders (with window ranking function)
SELECT
	CONCAT(FirstName, ' ', LastName) AS full_name,
	COUNT(*) AS orders_made,
	RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
FROM Sales.[Order] a
JOIN Sales.Customer b ON a.CustomerID = b.CustomerID
GROUP BY CONCAT(FirstName, ' ', LastName)
ORDER BY orders_made DESC

--Unique customers that placed orders in first quater of year 2009
SELECT
	DISTINCT(a.CustomerID)
FROM Sales.[Order] a
JOIN Sales.Customer b ON a.CustomerID = b.CustomerID
WHERE YEAR(OrderDate) = 2009
AND MONTH(OrderDate) BETWEEN 1 AND 3

--Most recent and second most recent purchase dates for customers with at least 2 orders
SELECT
	a.CustomerID,
	MAX(a.OrderDate) AS most_recent_order,
	MAX(b.OrderDate) AS second_recent_order
FROM Sales.[Order] a
JOIN Sales.[Order] b ON a.CustomerID = b.CustomerID
AND a.OrderDate > b.OrderDate
GROUP BY a.CustomerID

--Order count by customer which first name starts with T
SELECT
	CustomerID,
	FirstName,
	LastName,
	(SELECT COUNT (*)
	FROM Sales.[Order] b
	WHERE a.CustomerID = b.CustomerID) AS OrderCount
FROM Sales.Customer a
WHERE FirstName like 'T%'
ORDER BY OrderCount DESC

--Orders with price, where customer has PARK in city name AND difference between order date and shipped date is 1 day
SELECT
	a.OrderID,
	b.ListPrice,
	c.Name
FROM Sales.[Order] a
JOIN Sales.OrderItem b ON a.OrderID = b.OrderID
JOIN Production.Product c ON b.ProductID = c.ProductID
WHERE a.OrderID IN
	(SELECT CustomerID
	FROM Sales.Customer
	WHERE City like '%PARK%')
AND DATEDIFF(DAY, OrderDate, ShippedDate) = 1

--TOP 20 sold products and its total count where brand is TREK
SELECT TOP 20
	a.ProductID,
	b.Name,
	a.ListPrice,
	COUNT(*) AS sold_count
FROM Sales.OrderItem a
JOIN Production.Product b
ON a.ProductID = b.ProductID
WHERE b.BrandID IN 
	(SELECT BrandID
	FROM Production.Brand
	WHERE Name like 'Trek')
GROUP BY a.ProductID, b.Name, a.ListPrice
ORDER BY sold_count DESC