SET GLOBAL event_scheduler = ON;
USE northwind;
SET SQL_SAFE_UPDATES = 0;

-- this view counts the times that employees repeat with the same customer
drop view if exists rep;
create view rep as 
SELECT customerID, EmployeeID, count(*) as repetition FROM orders
group by customerId, employeeID; 

-- this view relates each customer with the employee that assist in more orders,
-- if two of them have the same number it takes the first one on the list.
drop view if exists assigned_employee;
create view assigned_employee as 	
Select customerID, EmployeeID from rep as t1
where repetition = (select max(t2.repetition) from rep as t2
where t1.customerID = t2.customerID)
group by customerID
order by customerID;

ALTER TABLE customers
ADD Employee_assigned INT;

DELIMITER XX

DROP PROCEDURE IF EXISTS inserttable XX

CREATE PROCEDURE inserttable()

BEGIN
	DECLARE continued INT DEFAULT 0;
	DECLARE CustomerID_c VARCHAR(10);
   
	
    DECLARE cursor_customers CURSOR FOR (SELECT CustomerID  FROM customers);
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET continued=1;
      
	OPEN cursor_customers;
	
	bucle1:LOOP
    
		FETCH NEXT FROM cursor_customers INTO 
		CustomerID_c;

		IF continued =1 THEN
			LEAVE bucle1; 
		END IF;
		
		UPDATE customers SET employee_assigned = (SELECT employeeID FROM assigned_employee WHERE CustomerID = CustomerID_c) where CustomerID = CustomerID_c;
        
	END LOOP bucle1;

	CLOSE cursor_customers;


END XX

DELIMITER ;
call inserttable();

SELECT customers.* INTO OUTFILE 'customers.csv'
FIELDS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM customers;

Select @@datadir;
