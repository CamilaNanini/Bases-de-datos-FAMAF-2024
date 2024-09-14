-- 1 Cree una tabla de `directors` con las columnas: Nombre, Apellido, Número de Películas.
CREATE TABLE `directors`(
	Nombre varchar(100) NOT NULL DEFAULT '',
	Apellido varchar(100) NOT NULL DEFAULT '',
	NumeroDePelículas int NOT NULL DEFAULT '0'
);

-- 2 El top 5 de actrices y actores de la tabla `actors` que tienen la mayor experiencia (i.e. el mayor número de películas filmadas) 
-- son también directores de las películas en las que participaron. Basados en esta información, inserten, utilizando una subquery 
-- los valores correspondientes en la tabla `directors`.
INSERT INTO directors
SELECT actor.first_name,actor.last_name,COUNT(film_actor.actor_id) as filmscount
FROM actor INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id 
GROUP BY film_actor.actor_id 
ORDER BY filmscount DESC 
LIMIT 5;

-- 3 Agregue una columna `premium_customer` que tendrá un valor 'T' o 'F' de acuerdo a si 
-- el cliente es "premium" o no. Por defecto ningún cliente será premium.
ALTER TABLE customer ADD COLUMN premium_customer varchar (1) NOT NULL DEFAULT 'F'

-- Extra porque soy boba y puse en otra tabla la columna
-- ALTER TABLE directors DROP COLUMN premium_customer

-- 4 Modifique la tabla customer. Marque con 'T' en la columna `premium_customer` de los 10 clientes 
-- con mayor dinero gastado en la plataforma.

WITH TopCustomers AS (
    SELECT payment.customer_id
    FROM payment
    GROUP BY payment.customer_id
    ORDER BY SUM(payment.payment_id) DESC
    LIMIT 10
)
UPDATE customer
SET premium_customer = 'T'
WHERE customer_id IN (SELECT customer_id FROM TopCustomers);

-- 5 Listar, ordenados por cantidad de películas (de mayor a menor), los distintos ratings de las 
-- películas existentes (Hint: rating se refiere en este caso a la clasificación según edad: G, PG, R, etc)
SELECT film.rating, COUNT(film.film_id) as countfilms 
FROM film 
GROUP BY film.rating 
ORDER BY countfilms DESC 

-- 6 ¿Cuáles fueron la primera y última fecha donde hubo pagos?
SELECT MIN(payment_date) AS first_payment, MAX(payment_date) AS last_payment
FROM payment ;

-- 7 Calcule, por cada mes, el promedio de pagos 
-- (Hint: vea la manera de extraer el nombre del mes de una fecha). 
SELECT MONTHNAME(payment.payment_date) AS payment_day, AVG(payment.amount)
FROM payment
GROUP BY payment_day 
ORDER BY payment_day DESC;  -- Feb antes que Agosto?

-- 8 Listar los 10 distritos que tuvieron mayor cantidad de alquileres 
-- (con la cantidad total de alquileres).
SELECT address.district,COUNT(rental.rental_id) AS countrental  -- CORROBORAR
FROM address INNER JOIN customer  
ON address.address_id = customer.address_id
INNER JOIN rental 
ON customer.customer_id = rental.customer_id 
GROUP BY address.district 
ORDER BY countrental DESC 
LIMIT 10;

-- 9 Modifique la table `inventory_id` agregando una columna `stock` que sea un número entero y 
-- representa la cantidad de copias de una misma película que tiene determinada tienda. El número por 
-- defecto debería ser 5 copias.
ALTER TABLE inventory ADD COLUMN stock INT DEFAULT '5'

-- 10 Cree un trigger `update_stock` que, cada vez que se agregue un nuevo registro a la tabla rental, 
-- haga un update en la tabla `inventory` restando una copia al stock de la película rentada 
-- (Hint: revisar que el rental no tiene información directa sobre la tienda, sino sobre el cliente, 
-- que está asociado a una tienda en particular).

CREATE TRIGGER update_stock AFTER INSERT 
ON rental FOR EACH ROW
BEGIN
	UPDATE inventory SET inventory.stock = inventory.stock - 1  WHERE inventory.inventory_id = NEW.inventory_id;
END;








