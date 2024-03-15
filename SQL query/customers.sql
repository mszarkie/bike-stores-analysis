--Check how data looks like
SELECT TOP 100
	*
FROM Sales.Customer

--retrieves CustomerID along with credentials, favoring phone number, but defaulting to email if phone number is null.
SELECT
	CustomerID,
	FirstName,
	LastName,
	ISNULL(Phone, Email) AS contact_info
FROM Sales.Customer

--ID of clients which order status is 3
SELECT
	a.CustomerID
FROM Sales.Customer a
WHERE a.FirstName IN (
	SELECT a.FirstName
	FROM Sales.[Order] b
	WHERE b.Status = 3)

--Customers based by city 
SELECT
	DISTINCT City,
	COUNT(*) AS CityCount
FROM Sales.Customer
GROUP BY City
ORDER BY CityCount DESC

--Customers based by State 
SELECT
	DISTINCT StateOrRegion,
	COUNT(*) AS state_count
FROM Sales.Customer
GROUP BY StateOrRegion
ORDER BY state_count DESC

--Customers without phone number
SELECT
	*
FROM Sales.Customer
WHERE Phone is null

--Customers with hotmail email domain
SELECT
	CustomerID,
	CONCAT(FirstName, ' ', LastName) AS full_name,
	Email
FROM Sales.Customer
WHERE Email like '%@hotmail.com'

