SET GLOBAL event_scheduler = ON;
USE northwind;

DROP TABLE IF EXISTS orders_log;
CREATE TABLE orders_log(
  `LogID` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `OrderID` int(11) NOT NULL,
  `CustomerID` char(5) DEFAULT NULL,
  `EmployeeID` int(11) DEFAULT NULL,
  `OrderDate` datetime DEFAULT NULL,
  `RequiredDate` datetime DEFAULT NULL,
  `ShippedDate` datetime DEFAULT NULL,
  `ShipperID` int(11) DEFAULT NULL,
  `Freight` double DEFAULT '0',
  `ShipName` varchar(40) DEFAULT NULL,
  `ShipAddress` varchar(60) DEFAULT NULL,
  `ShipCity` varchar(15) DEFAULT NULL,
  `ShipRegion` varchar(15) DEFAULT NULL,
  `ShipPostalCode` varchar(10) DEFAULT NULL,
  `ShipCountry` varchar(15) DEFAULT NULL,
  `DMLAction`  varchar(10) DEFAULT NULL,
  `LogTime` datetime DEFAULT NULL,
  `DataVersion` int DEFAULT 0,
  CONSTRAINT `FK_Orders_log_Customers` FOREIGN KEY (`CustomerID`) REFERENCES `Customers` (`CustomerID`),
  CONSTRAINT `FK_Orders_log_Employees` FOREIGN KEY (`EmployeeID`) REFERENCES `Employees` (`EmployeeID`),
  CONSTRAINT `FK_Orders_log_Shippers` FOREIGN KEY (`ShipperID`) REFERENCES `Shippers` (`ShipperID`)
);

DROP TRIGGER IF EXISTS insert_log;
CREATE TRIGGER insert_log AFTER INSERT ON orders
FOR EACH ROW
	INSERT INTO orders_log VALUES(LogID, NEW.OrderID, NEW.CustomerID, new.EmployeeID, new.OrderDate, new.RequiredDate, new.ShippedDate, new.ShipperID,
    new.Freight, new.ShipName, new.ShipAddress, new.ShipCity, new.ShipRegion, new.ShipPostalCode, new.ShipCountry, 'INSERT', now(), 1); 

DROP TRIGGER IF EXISTS delete_log;
CREATE TRIGGER delete_log AFTER DELETE ON orders
FOR EACH ROW
	
	INSERT INTO orders_log VALUES(LogID, OLD.OrderID, old.CustomerID, old.EmployeeID, old.OrderDate, old.RequiredDate, old.ShippedDate, old.ShipperID,
    old.Freight, old.ShipName, old.ShipAddress, old.ShipCity, old.ShipRegion, old.ShipPostalCode, old.ShipCountry, 'DELETE', now(),
    (SELECT count(log.orderID) FROM orders_log as log where log.orderID = OrderID));    

DROP TRIGGER IF EXISTS update_log;
CREATE TRIGGER update_log AFTER UPDATE ON orders
FOR EACH ROW
	INSERT INTO orders_log VALUES(LogID, NEW.OrderID, NEW.CustomerID, new.EmployeeID, new.OrderDate, new.RequiredDate, new.ShippedDate, new.ShipperID,
    new.Freight, new.ShipName, new.ShipAddress, new.ShipCity, new.ShipRegion, new.ShipPostalCode, new.ShipCountry, 'UPDATE', now(),
    (SELECT count(log.orderID)+1 FROM orders_log as log where log.orderID = new.OrderID));
    
    
    

	