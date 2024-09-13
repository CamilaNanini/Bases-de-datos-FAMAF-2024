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

