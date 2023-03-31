SET GLOBAL event_scheduler = ON;
USE northwind;


DROP TRIGGER IF EXISTS discontinued_products;
CREATE TRIGGER discontinued_products AFTER UPDATE ON products
FOR EACH ROW
	DELETE FROM orderdetails WHERE ProductID IN (SELECT products.ProductID AS delprodID FROM products 
	WHERE Discontinued = 1);

-- To prove that it works we update the following products.

#UPDATE products SET discontinued = 1 WHERE products.ProductID = 42;

#UPDATE products SET discontinued = 1 WHERE products.ProductID = 51;