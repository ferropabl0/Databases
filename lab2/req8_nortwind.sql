SET GLOBAL event_scheduler = 1;

USE northwind;

DROP EVENT IF EXISTS default_employee_2023;

CREATE EVENT default_employee_2023
ON SCHEDULE AT '2023-01-01 00:00:00'
DO CALL inserttable();