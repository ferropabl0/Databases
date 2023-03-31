USE northwind;

DROP VIEW IF EXISTS query_1;
CREATE VIEW query_1 AS
	SELECT suppliers.CompanyName AS supplierName, count(productID) AS productCount
	FROM products JOIN suppliers ON suppliers.SupplierID = products.SupplierID
	GROUP BY products.supplierID
    ORDER BY productCount DESC
    LIMIT 1;
    
DROP VIEW IF EXISTS query_2;
CREATE VIEW query_2 AS
	SELECT employees.EmployeeID, employees.FirstName, employees.LastName, count(orders.EmployeeID) AS orderCount
    FROM employees JOIN orders ON employees.EmployeeID = orders.EmployeeID
    GROUP BY orders.EmployeeID
    ORDER BY orderCount DESC
    LIMIT 5;
    
DROP VIEW IF EXISTS query_3;
CREATE VIEW query_3 AS
	SELECT * FROM products
    WHERE supplierID = (SELECT SupplierID FROM suppliers
	WHERE CompanyName = "Grandma Kelly's Homestead");
    
DROP VIEW IF EXISTS query_4;
CREATE VIEW query_4 AS
	SELECT orderdetails.orderID, count(productID) AS productCount, employees.FirstName, employees.LastName
    FROM orderdetails JOIN orders ON orderdetails.orderID = orders.orderID
    JOIN employees ON orders.employeeID = employees.employeeID
    GROUP BY orderdetails.orderID;

DROP VIEW IF EXISTS query_5;
CREATE VIEW query_5 AS
	SELECT ProductName, Quantity, avg(orderdetails.UnitPrice) FROM products
    JOIN orderdetails ON products.ProductID = orderdetails.ProductID
    GROUP BY products.ProductID;
    
    /*SELECT FirstName, LastName, max(T.orderCount) FROM 
	(SELECT count(orders.OrderID) as OrderCount, FirstName, LastName FROM employees
	JOIN orders ON employees.EmployeeID = orders.EmployeeID
	Group by employees.EmployeeID) AS T;*/

DROP VIEW IF EXISTS query_6;
CREATE VIEW query_6 AS
	SELECT orders.* FROM orders JOIN customers
    ON customers.CustomerID = orders.CustomerID
    WHERE year(orders.OrderDate) = 1997
    AND year(orders.ShippedDate) = 1997
    AND customers.Country = "Germany";
    
DROP VIEW IF EXISTS query_7;
CREATE VIEW query_7 AS
	SELECT orders.OrderID, orders.OrderDate AS orderDate FROM orders 
    JOIN orderdetails ON orders.OrderID = orderdetails.OrderID 
	JOIN products ON orderdetails.ProductID = products.ProductID
	JOIN categories ON products.CategoryID = categories.CategoryID
	WHERE categories.CategoryName = 'Beverages'
	ORDER BY orderDate DESC;

DROP VIEW IF EXISTS query_8;
CREATE VIEW query_8 AS
	SELECT sum(UnitPrice) AS priceSum FROM orderdetails
    WHERE OrderID = 10255;

DROP VIEW IF EXISTS query_9;
CREATE VIEW query_9 AS 
	SELECT orders.* FROM orders JOIN orderdetails ON orders.OrderID = orderdetails.OrderID
	JOIN products ON orderdetails.ProductID = products.ProductID
	JOIN customers ON orders.CustomerID = customers.CustomerID 
	JOIN suppliers ON products.SupplierID = suppliers.SupplierID
	WHERE suppliers.Country = 'Japan'
    ORDER BY CustomerID, orderDate ASC;

DROP VIEW IF EXISTS query_10;
CREATE VIEW query_10 AS 
	SELECT * FROM products
    WHERE unitPrice = (SELECT max(unitPrice) FROM products)
    OR unitPrice = (SELECT min(unitPrice) FROM products);

DROP VIEW IF EXISTS query_11;
CREATE VIEW query_11 AS
	SELECT CONCAT(Address, City, PostalCode, Country) AS infoClients, CustomerID, CompanyName
    FROM customers;

DROP VIEW IF EXISTS query_12;
CREATE VIEW query_12 AS
	SELECT employees.* FROM employees
    JOIN orders ON employees.EmployeeID = orders.EmployeeID
    GROUP BY orders.EmployeeID
    HAVING count(orders.OrderID) > (SELECT count(*) FROM orders
    JOIN employees ON employees.EmployeeID = orders.EmployeeID
    WHERE employees.EmployeeID = 8);
    
DROP VIEW IF EXISTS query_13;
CREATE VIEW query_13 AS
	SELECT count(ProductID) as productCount, orders.* FROM orders 
    JOIN orderdetails ON orderdetails.OrderID = orders.OrderID
    GROUP BY OrderID
    HAVING productCount > 3;

DROP VIEW IF EXISTS query_14;
CREATE VIEW query_14 AS
	SELECT orders.* FROM orders JOIN customers ON orders.CustomerID = customers.CustomerID
    JOIN orderdetails ON orderdetails.OrderID = orders.OrderID
    JOIN products ON products.ProductID = orderdetails.ProductID
    JOIN suppliers ON suppliers.SupplierID = products.SupplierID
    WHERE customers.City = 'London' AND suppliers.City = 'New Orleans';
    
DROP VIEW IF EXISTS query_15;
CREATE VIEW query_15 AS
	SELECT products.productName, categories.CategoryID, products.UnitPrice FROM products
    JOIN categories ON products.CategoryID = categories.CategoryID
    WHERE products.UnitPrice > 20 AND products.CategoryID = (SELECT CategoryID FROM products HAVING min(categoryID));

DROP VIEW IF EXISTS query_16;
CREATE VIEW query_16 AS 
SELECT FirstName, LastName, max(T.orderCount) FROM 
	(SELECT count(orders.OrderID) as OrderCount, FirstName, LastName FROM employees
	JOIN orders ON employees.EmployeeID = orders.EmployeeID
	Group by employees.EmployeeID) AS T;
    
DROP VIEW IF EXISTS query_17;
CREATE VIEW query_17 AS
	SELECT customers.* FROM customers JOIN orders ON orders.CustomerID = customers.CustomerID
    JOIN shippers ON shippers.shipperID = orders.shipperID
    JOIN employees ON employees.EmployeeID = orders.EmployeeID
    GROUP BY customers.CustomerID
    HAVING count(orders.orderID) > 25 AND count(shippers.shipperID) AND count(employees.employeeID) > 4;
    
DROP VIEW IF EXISTS query_18;
CREATE VIEW query_18 AS
	SELECT CONCAT(employees.FirstName,' ', employees.LastName) as CompleteName
    FROM employees JOIN orders ON employees.EmployeeID = orders.EmployeeID
    GROUP BY orders.EmployeeID
    HAVING count(DISTINCT orders.ShipperID) = (SELECT count(*) FROM shippers);

DROP VIEW IF EXISTS query_19;
CREATE VIEW query_19 AS
	SELECT OrderID FROM orders
    WHERE datediff(OrderDate, RequiredDate);

DROP VIEW IF EXISTS query_20;
CREATE VIEW query_20 AS
	SELECT products.ProductName, suppliers.CompanyName AS Supplier, categories.CategoryName,
    employees.FirstName, employees.LastName, shippers.CompanyName AS Shipper,
    customers.CompanyName AS Customer FROM orderdetails
	JOIN orders ON orderdetails.OrderID = orders.OrderID
    JOIN customers ON orders.CustomerID = customers.CustomerID
    JOIN shippers ON orders.ShipperID = shippers.ShipperID
    JOIN employees ON orders.EmployeeID = employees.EmployeeID
    JOIN products ON orderdetails.ProductID = products.ProductID
    JOIN categories ON products.CategoryID = categories.CategoryID
    JOIN suppliers ON products.SupplierID = suppliers.SupplierID
    ORDER BY orders.OrderID, products.ProductName ASC;