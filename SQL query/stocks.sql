--Check how data looks like
SELECT TOP 100
	*
FROM Production.Stock

--Products that have not been ordered yet
SELECT
	a.ProductID,
	a.Name,
	a.ListPrice
FROM Production.Product a
LEFT JOIN Sales.OrderItem b ON a.ProductID = b.ProductID
WHERE b.Quantity IS NULL


--Number of stocks based on store name and category name
SELECT
	a.Name as store_name,
	e.Name as category_name,
	SUM(b.Quantity) as total_quantity
FROM Sales.Store a
JOIN Production.Stock b ON a.StoreID = b.StoreID
JOIN Production.Product d ON b.ProductID = d.ProductID
JOIN Production.Category e ON d.BrandID = e.CategoryID
GROUP BY a.Name, e.Name
Order BY store_name, category_name