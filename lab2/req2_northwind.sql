SET GLOBAL event_scheduler = ON;
USE northwind;
-- event = CUANDO LO PROGRAMAS PARA QUE PASE EN UN MOMENTO DETERMINADO

-- REQUIREMENT 2

DELIMITER XX

DROP PROCEDURE IF EXISTS check_orders XX

CREATE PROCEDURE chech_orders()

BEGIN
	DECLARE continued INT DEFAULT 0;
	DECLARE OrderID_c INT;
    DECLARE OrderDate_c datetime; 
    DECLARE RequiredDate_c datetime;
    DECLARE ShippedDate_c datetime;
	
    DECLARE cursor_orders CURSOR FOR (SELECT OrderID, OrderDate, RequiredDate, ShippedDate FROM orders);
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET continued=1;
      
	OPEN cursor_orders;
	
	bucle1:LOOP
    
		FETCH NEXT FROM cursor_orders INTO 
		OrderID_c, OrderDate_c, RequiredDate_c, ShippedDate_c;

		IF continued =1 THEN
			LEAVE bucle1; 
		END IF;
		
		IF RequiredDate_c < ShippedDate_c THEN
			UPDATE orders SET ShippedDate = RequiredDate_c WHERE orderID = OrderID_c;
		END IF;
		If ShippedDate_c < OrderDate_c THEN
			UPDATE orders SET OrderDate = DATE_ADD(ShippedDate_c,INTERVAL -1 DAY) WHERE orderID = OrderID_c;
		END IF;
	END LOOP bucle1;

	CLOSE cursor_orders;


END XX
DELIMITER ;
call chech_orders();

-- extra
SELECT *, min(t.times) from 
(SELECT *,count(orderID) as times FROM orders JOIN employees ON employees.employeeID = orders.employeeID
group by employees.employeeID)

 
