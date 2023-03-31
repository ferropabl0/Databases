SET GLOBAL event_scheduler = 1;

USE northwind;

-- 1
ALTER TABLE products
RENAME COLUMN UnitPrice TO UnitPriceUSD; 

-- 2
ALTER TABLE products
ADD UnitPriceEUR DOUBLE DEFAULT '0';

-- 3
ALTER TABLE products
ADD UnitPriceGBP DOUBLE DEFAULT '0';

-- 4
ALTER TABLE products
ADD UnitPriceJPY DOUBLE DEFAULT '0';

DROP PROCEDURE IF EXISTS currency_exchange;
DELIMITER //
CREATE PROCEDURE currency_exchange(IN p_prod_id INT)
BEGIN
	IF p_prod_id = 0 THEN UPDATE products SET UnitPriceEUR = 0.96*UnitPriceUSD, 
    UnitPriceGBP = 0.84*UnitPriceUSD, 
    UnitPriceJPY = 140*UnitPriceUSD;
    ELSEIF p_prod_id > 0 AND p_prod_id < 78 THEN UPDATE products SET UnitPriceEUR = 0.96*UnitPriceUSD, 
    UnitPriceGBP = 0.84*UnitPriceUSD, 
    UnitPriceJPY = 140*UnitPriceUSD
    WHERE ProductID = p_prod_id;
    ELSE SELECT "There is no product with the specified ID" AS "WARNING";
    END IF;
END//

DELIMITER ;

CALL currency_exchange(43);
SELECT * FROM products;