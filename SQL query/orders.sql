--Check how data looks like
SELECT TOP 1000
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

--Customers that didnt placed any orders 
SELECT
	a.CustomerID,
	FirstName,
	LastName
FROM Sales.Customer a
LEFT JOIN Sales.[Order] b on a.CustomerID = b.CustomerID
WHERE b.[Status] IS NULL
GROUP BY a.CustomerID, FirstName, LastName

--Years with the corresponding count of items ordered for each year
SELECT
	YEAR(b.OrderDate) AS [Year],
	SUM(a.Quantity) AS total_items_ordered
FROM Sales.OrderItem a
JOIN Sales.[Order] b ON a.OrderID = b.OrderID
GROUP BY YEAR(b.OrderDate)

--customer id along with the corresponding count of orders for each customer who placed orders for products with a total value 4000, ordered descending
SELECT 
	 CustomerID,
	 COUNT(CustomerID) as orders_made
FROM Sales.[Order]
WHERE EXISTS (
				SELECT OrderID
				FROM Sales.OrderItem
				WHERE Sales.OrderItem.OrderID = Sales.[Order].CustomerID
				AND OrderTotal > 4000
			)
GROUP BY CustomerID
ORDER BY orders_made DESC

--categorizing shipping status of orders based on the difference in days between the order date and the shipped date
SELECT
	OrderID,
	StoreID,
	CASE
		WHEN DATEDIFF(DAY, OrderDate, ShippedDate) is null THEN 'not shipped'
		WHEN DATEDIFF(DAY, OrderDate, ShippedDate) = 1 THEN 'shipped quickly'
		ELSE 'long shipping time'
	END AS shipping_status
FROM Sales.[Order]

--Average discount
SELECT
	ROUND(AVG(ListPrice * Discount), 2) AS avg_discount
FROM Sales.OrderItem

--Customers who placed most orders
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

--Most recent and second most recent purchase dates for customers with at least 2 orders PLUS data type convert to dd/mm/yyyy
SELECT
	a.CustomerID,
	CONVERT(varchar, MAX(a.OrderDate), 103) AS most_recent_order,
	CONVERT(varchar, MAX(b.OrderDate), 103) AS second_recent_order
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

--difference in years between last order and today's date
SELECT
	DATEDIFF(YEAR, MAX(OrderDate), GETDATE())
FROM Sales.[Order]

--create view with orders from year 2009
CREATE VIEW orders_2009 AS
SELECT
	*
FROM Sales.[Order]
WHERE OrderDate BETWEEN '2009-01-01' AND '2009-12-31'

SELECT * FROM orders_2009