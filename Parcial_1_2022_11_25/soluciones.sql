-- 1 
CREATE TABLE stocks (
		store_id INT NOT NULL,
		product_id INT NOT NULL, 
		quantity INT NOT NULL DEFAULT 0
);

-- 2 
SELECT c.category_name, MAX(p.list_price) AS maxPrice, MIN(p.list_price) AS minPrice
FROM categories c
INNER JOIN products p 
	ON p.category_id = c.category_id 
GROUP BY c.category_name
HAVING MAX(p.list_price) > 5000 OR MIN(p.list_price) < 400;

-- 3
CREATE PROCEDURE add_product_stock_on_store 
(IN nombre_store VARCHAR(100),IN nombre_producto VARCHAR(100),IN cantidad INT)
BEGIN
	DECLARE v_store_id INT;
    DECLARE v_product_id INT;

    SELECT store_id 
    INTO v_store_id 
    FROM stores 
    WHERE store_name = nombre_store;

    SELECT product_id 
    INTO v_product_id 
    FROM products 
    WHERE product_name = nombre_producto;
	
	UPDATE stocks 
    SET quantity = quantity + cantidad 
    WHERE store_id = v_store_id AND product_id = v_product_id;
END;

-- 4
CREATE TRIGGER decrease_product_stock_on_store AFTER INSERT
ON order_items FOR EACH ROW
BEGIN	
	UPDATE stocks 
    SET quantity = quantity - NEW.quantity 
    WHERE product_id = NEW.item_id;
END;

-- 5 
SELECT b.brand_name , AVG(p.list_price) AS precioPromedio
FROM products p 
INNER JOIN brands b 
	ON p.brand_id = b.brand_id 
WHERE p.model_year BETWEEN 2016 AND 2018
GROUP BY b.brand_name 

-- 6 No sé si es del toda correcta
SELECT c.category_name ,COUNT(p.product_id) AS cantProductos, COUNT(o.order_id) as ventas
FROM categories c 
INNER JOIN products p 
	ON p.category_id = c.category_id 
INNER JOIN order_items oi 
	ON oi.product_id = p.product_id 
INNER JOIN orders o 
	ON o.order_id = oi.order_id 
WHERE o.order_status = 4
GROUP BY c.category_name 

-- 7 
CREATE ROLE human_care_dept ;

GRANT CREATE 
ON staffs
TO human_care_dept;

GRANT UPDATE (active)
ON staffs
TO human_care_dept;

SHOW GRANTS FOR human_care_dept;



