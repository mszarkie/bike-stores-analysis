--Check how data looks like
SELECT TOP 100
	*
FROM Sales.Employee

--Company structure
SELECT
	a.FirstName + ' ' + a.LastName AS employee_name,
	b.FirstName + ' ' + b.LastName AS employee_manager
FROM Sales.Employee a
LEFT OUTER JOIN Sales.Employee b ON a.ManagerID = b.EmployeeID

--Employees that prepared orders
SELECT
	DISTINCT(EmployeeID)
FROM Sales.[Order]

--Orders prepared per employee
SELECT
	EmployeeID,
	COUNT(*) AS orders_prepared
FROM Sales.[Order]
GROUP BY EmployeeID
ORDER BY orders_prepared DESC

--Stores with sold items count per employee
SELECT
	b.Name AS shop_name,
	c.EmployeeID,
	b.StateOrRegion,
	COUNT(a.StoreID) AS sold_count
FROM Sales.[Order] a
JOIN Sales.Store b ON a.StoreID = b.StoreID
JOIN Sales.Employee c ON a.EmployeeID = c.EmployeeID 
GROUP BY b.Name, c.EmployeeID, b.StateOrRegion
ORDER BY sold_count DESC

--Update employees email
UPDATE Sales.Employee
SET Email = LOWER(FirstName + '.' + LastName + '@bikeshop.com')
WHERE Email like '%@bikes.shop'

--Delete last column
ALTER TABLE Sales.Employee
DROP COLUMN FullName