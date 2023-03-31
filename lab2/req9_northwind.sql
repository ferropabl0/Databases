SET GLOBAL event_scheduler = ON;
USE northwind;


DROP PROCEDURE IF EXISTS check_units;
DELIMITER //
CREATE PROCEDURE check_units()
BEGIN
	DROP TABLE IF EXISTS `productdemand`;
	CREATE TABLE `productdemand` ( 
    `ProductID` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Demand` INT DEFAULT '0');
    INSERT INTO productdemand (Demand) (SELECT sum(Quantity) AS demand FROM orderdetails GROUP BY ProductID);
    
    
	UPDATE products INNER JOIN productdemand ON products.ProductID = productdemand.ProductID AND products.UnitsOnOrder <> productdemand.Demand SET products.UnitsOnOrder = productdemand.Demand;
    
	UPDATE products SET UnitsInStock = UnitsInStock - UnitsOnOrder
    WHERE UnitsInStock >= UnitsOnOrder;
    UPDATE products SET UnitsInStock = -1
    WHERE UnitsInStock < UnitsOnOrder;
    
	DROP TABLE IF EXISTS `productdemand`;
END//

DELIMITER ;
CALL check_units();