--Total Revenue
SELECT
	FORMAT(FLOOR(SUM(OrderTotal)), 'C2') AS total_revenue
FROM Sales.[Order]

--Total revenue by year
;with base AS
(
SELECT
	YEAR(OrderDate) AS [Year],
	SUM(OrderTotal) AS Revenue
FROM Sales.[Order]
GROUP BY YEAR(OrderDate)
)
SELECT 
	[Year],
	FORMAT(Revenue, 'C2') AS revenue
FROM base
ORDER BY [Year]

--Total revenue by year with categorizing based on whether revenue for year is greater than te average revenue across all years
;with base AS
(
SELECT
	YEAR(OrderDate) AS [Year],
	SUM(OrderTotal) AS Revenue,
	AVG(SUM(OrderTotal)) OVER () AS AvgRevenue
FROM Sales.[Order]
GROUP BY YEAR(OrderDate)
)
SELECT 
	[Year],
	FORMAT(Revenue, 'C2') AS revenue,
	IIF(Revenue > AvgRevenue, 'Good Year', 'Bad Year') AS year_performance
FROM base
ORDER BY [Year]

--Revenue by year and month
;with base AS
(
SELECT
	YEAR(OrderDate) AS [Year],
	MONTH(OrderDate) AS [Month],
	SUM(OrderTotal) AS Revenue
FROM Sales.[Order]
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
)
SELECT 
	[Year],
	[Month],
	FORMAT(Revenue, 'C2') AS revenue
FROM base
ORDER BY [Year], [Month]

--Years with the corresponding count of orders for each year
SELECT
	YEAR(OrderDate) AS [Year],
	COUNT(OrderTotal) AS order_count
FROM Sales.[Order]
GROUP BY YEAR(OrderDate)
ORDER BY [Year]

--Revenue by brand descending
;with base AS
(
SELECT
	c.Name AS brand_name,
	SUM(a.LineTotal) AS revenue1
FROM Sales.OrderItem a
JOIN Production.Product b ON a.ProductID = b.ProductID
JOIN Production.Brand c ON b.BrandID = c.BrandID
GROUP BY c.Name
)
SELECT
	brand_name,
	FORMAT(revenue1, 'C2') AS revenue
FROM base
ORDER BY revenue1 DESC

--Revenue by category descending
;with base AS
(
SELECT
	c.Name AS category_name,
	SUM(a.LineTotal) AS revenue1
FROM Sales.OrderItem a
JOIN Production.Product b ON a.ProductID = b.ProductID
JOIN Production.Category c ON b.CategoryID = c.CategoryID
GROUP BY c.Name
)
SELECT
	category_name,
	FORMAT(revenue1, 'C2') AS revenue
FROM base
ORDER BY revenue1 DESC


--Revenue by employee descending
;with base AS
(
SELECT
	c.EmployeeID,
	CONCAT(c.FirstName, ' ', c.LastName) AS full_name,
	SUM(a.LineTotal) AS revenue1
FROM Sales.OrderItem a
JOIN Sales.[Order] b ON a.OrderID = b.OrderID
JOIN Sales.Employee c ON b.EmployeeID = c.EmployeeID
GROUP BY c.EmployeeID, CONCAT(c.FirstName, ' ', c.LastName)
)
SELECT
	EmployeeID,
	full_name,
	FORMAT(revenue1, 'C2') AS revenue
FROM base
ORDER BY revenue1 DESC