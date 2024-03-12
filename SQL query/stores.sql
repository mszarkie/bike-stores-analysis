--Check how data looks like
SELECT TOP 1000
	*
FROM Sales.Store

--Stores with sold items count
SELECT
	b.Name AS shop_name,
	b.StateOrRegion,
	COUNT(a.StoreID) AS sold_count
FROM Sales.[Order] a
JOIN Sales.Store b ON a.StoreID = b.StoreID 
GROUP BY b.Name, b.StateOrRegion
ORDER BY sold_count DESC

--Revenue by store
SELECT
	b.Name AS store_name,
	b.StateOrRegion,
	FORMAT(SUM(a.OrderTotal), 'C2') AS revenue
FROM Sales.[Order] a
JOIN Sales.Store b ON a.StoreID = b.StoreID
GROUP BY b.Name, b.StateOrRegion
ORDER BY revenue DESC

--Total quantity of items sold for each store and product category
SELECT
	a.Name AS store_name,
	e.Name AS category_name,
	SUM(c.Quantity) AS items_sold
FROM Sales.Store a
JOIN Sales.[Order] b ON a.StoreID = b.StoreID
JOIN Sales.OrderItem c ON b.OrderID = c.OrderID
JOIN Production.Product d ON c.ProductID = d.ProductID
JOIN Production.Category e ON d.CategoryID = e.CategoryID
GROUP BY a.Name, e.Name
ORDER BY store_name, items_sold DESC