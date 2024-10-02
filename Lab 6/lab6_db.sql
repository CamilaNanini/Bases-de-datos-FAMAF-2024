-- 1 Devuelva la oficina con mayor número de empleados.
SELECT officeCode, COUNT(*) AS employee_count
FROM employees
GROUP BY officeCode
ORDER BY employee_count DESC
LIMIT 1;
-- 2 ¿Cuál es el promedio de órdenes hechas por oficina?
-- ¿Qué oficina vendió la mayor cantidad de productos?
SELECT codeOffice, AVG(ctnOrder)
FROM (
	SELECT employees.officeCode as codeOffice, COUNT(orders.orderNumber) ctnOrder
	FROM orders
	INNER JOIN customers  
    	ON orders.customerNumber = customers.customerNumber
	INNER JOIN employees
		ON customers.salesRepEmployeeNumber = employees.employeeNumber
	GROUP BY employees.officeCode 
) as subquerry1
GROUP BY codeOffice;

SELECT codeOffice,MAX(ctnOrder) as maxOrder 
FROM (
	SELECT employees.officeCode as codeOffice, COUNT(orders.orderNumber) ctnOrder
	FROM orders
	INNER JOIN customers  
    	ON orders.customerNumber = customers.customerNumber
	INNER JOIN employees
		ON customers.salesRepEmployeeNumber = employees.employeeNumber
	GROUP BY employees.officeCode 
) as subquerry2
GROUP BY codeOffice
ORDER BY maxOrder DESC
LIMIT 1;

-- 3 Devolver el valor promedio, máximo y mínimo de pagos que se hacen por mes.
SELECT MONTH(payments.paymentDate) AS month,AVG(payments.amount) as promedioPagos,MAX(payments.amount) as maximoPago,MIN(payments.amount) as minimoPago
FROM payments
GROUP BY month
ORDER BY month ASC ;

-- 4 Crear un procedimiento "Update Credit" en donde se modifique el límite de crédito de un cliente 
-- con un valor pasado por parámetro.
DELIMITER |
	CREATE PROCEDURE UpdateCredit(IN customer_id INT(11) ,IN new_credit_limit DECIMAL(10, 2)))
	BEGIN
		UPDATE customers
		SET customers.creditLimit = new_credit_limit
		WHERE customers.customerNumber = customer_id
	END;
|
DELIMITER;

-- Cree una vista "Premium Customers" que devuelva el top 10 de clientes que más dinero han gastado en 
-- la plataforma. La vista deberá devolver el nombre del cliente, la ciudad y el total gastado por ese 
-- cliente en la plataforma.
CREATE VIEW premiumCustomers AS (
	SELECT customers.customerName AS name, customers.city AS city, SUM(payments.amount) AS total
	FROM customers 
	INNER JOIN payments
	WHERE customers.customerNumber = payments.customerNumber 
	GROUP BY name
	ORDER BY total DESC 
	LIMIT 10
);

-- Cree una función "employee of the month" que tome un mes y un año y devuelve el empleado 
-- (nombre y apellido) cuyos clientes hayan efectuado la mayor cantidad de órdenes en ese mes.
DELIMITER |
CREATE FUNCTION employee_of_the_month(mes INT, año INT) 
    RETURNS VARCHAR(100)
    READS SQL DATA
BEGIN
    DECLARE name_employee VARCHAR(100);

    SELECT CONCAT(employees.firstName, ' ', employees.lastName)
    INTO name_employee
    FROM employees
    INNER JOIN customers ON customers.salesRepEmployeeNumber = employees.employeeNumber
    INNER JOIN orders ON orders.customerNumber = customers.customerNumber 
    WHERE MONTH(orders.orderDate) = mes AND YEAR(orders.orderDate) = año
    GROUP BY employees.employeeNumber 
    ORDER BY COUNT(*) DESC
    LIMIT 1;

    RETURN name_employee;
END;
|
DELIMITER ;

-- 7 Crear una nueva tabla "Product Refillment". Deberá tener una relación varios a uno con "products" y 
-- los campos: `refillmentID`, `productCode`, `orderDate`, `quantity`.
CREATE TABLE productRefillment (
	`refillmentID` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`productCode` VARCHAR(15) NOT NULL,
	`orderDate` DATETIME NOT NULL,
	`quantity` INT NOT NULL DEFAULT '0',
	FOREIGN KEY (`productCode`) REFERENCES `products` (`productCode`)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

-- 8 Definir un trigger "Restock Product" que esté pendiente de los cambios efectuados en `orderdetails` y 
-- cada vez que se agregue una nueva orden revise la cantidad de productos pedidos (`quantityOrdered`) y 
-- compare con la cantidad en stock (`quantityInStock`) y si es menor a 10 genere un pedido en la tabla 
-- "Product Refillment" por 10 nuevos productos.

CREATE TRIGGER restockProduct AFTER INSERT 
ON productRefillment FOR EACH ROW
BEGIN
	DECLARE stockactual INT;
	
	SELECT products.quantityInStock 
    INTO stockactual
    FROM products
    WHERE products.productCode = NEW.productCode;
   
   IF stockactual < 10 THEN
        INSERT INTO ProductRefillment (productCode, quantity)
        VALUES (NEW.productCode, 10);
    END IF;
END;

-- 9 Crear un rol "Empleado" en la BD que establezca accesos de lectura a todas las tablas y 
-- accesos de creación de vistas.
CREATE ROLE Empleado;

GRANT SELECT
ON classicmodels.*
TO Empleado;

GRANT CREATE VIEW
ON classicmodels.*
TO Empleado;


