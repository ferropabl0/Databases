SET GLOBAL event_scheduler = ON;
USE northwind;


DROP TRIGGER IF EXISTS insert_prod;
CREATE TRIGGER insert_prod BEFORE INSERT ON products
FOR EACH ROW
	SET NEW.UnitPriceEUR = 0.96*NEW.UnitPriceUSD,
    NEW.UnitPriceGBP = 0.84*NEW.UnitPriceUSD, 
    NEW.UnitPriceJPY = 140*NEW.UnitPriceUSD;
    
DROP TRIGGER IF EXISTS update_prod;
DELIMITER //
CREATE TRIGGER update_prod BEFORE UPDATE ON products
FOR EACH ROW
	IF NEW.UnitPriceUSD <> OLD.UnitPriceUSD THEN SET NEW.UnitPriceEUR = 0.96*NEW.UnitPriceUSD,
	NEW.UnitPriceGBP = 0.84*NEW.UnitPriceUSD,
    NEW.UnitPriceJPY = 140*NEW.UnitPriceUSD;
    END IF;
//

DELIMITER ;
    
    
