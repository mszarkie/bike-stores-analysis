--check how data looks like
SELECT TOP 1000
	*
FROM Production.Product

--Products count by brand name ordered descending
SELECT
	b.Name AS brand_name,
	COUNT(*) AS total_count
FROM Production.Product a
JOIN Production.Brand b ON a.BrandID = b.BrandID
GROUP BY b.Name
ORDER BY total_count DESC

--Total count of products for each distinct ModelYear from the production
SELECT
	ModelYear,
	COUNT(*) AS total_count
FROM Production.Product
GROUP BY ModelYear

--product id with its name without production year in name
SELECT
	ProductID,
	TRIM(LEFT(Name, CHARINDEX('- 2', Name) - 1)) AS product_name
FROM Production.Product

--Products with 2005 model year which list price is higher than average list price
SELECT
	ProductID,
	Name AS product_name,
	ListPrice
FROM Production.Product
WHERE ModelYear = 2005
AND ListPrice > (SELECT
					AVG(ListPrice) as AvgPrice
					FROM Production.Product)

--Max price per brand
SELECT
	b.Name AS brand_name,
	MAX(a.ListPrice) AS max_brand_price
FROM Production.Product a
JOIN Production.Brand b ON a.BrandID = b.BrandID
GROUP BY b.Name
ORDER BY max_brand_price DESC

--Min price per brand
SELECT
	b.Name AS brand_name,
	MIN(a.ListPrice) AS min_brand_price
FROM Production.Product a
JOIN Production.Brand b ON a.BrandID = b.BrandID
GROUP BY b.Name
ORDER BY min_brand_price