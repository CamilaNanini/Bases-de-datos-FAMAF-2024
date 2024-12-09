-- 1
SELECT p.name , COUNT(r.id) AS cantidadReviews
FROM properties p
INNER JOIN reviews r 
	ON r.property_id = p.id 
WHERE YEAR(r.created_at)=2024
GROUP BY p.name 
ORDER BY cantidadReviews DESC
LIMIT 7;

-- 2
SELECT p.name, b.id AS idReserva, DATEDIFF(b.check_out,b.check_in)*p.price_per_night AS totalPrice 
FROM properties p 
INNER JOIN bookings b 
	ON b.property_id = p.id 
ORDER BY totalPrice DESC;

-- 3
-- Considero que el único dato de mayor relevancia luego del nombre del usuario es el mail por 
-- si se lo busca notificar de algo
SELECT u.name,u.email ,SUM(p.amount) AS paymentTotal
FROM users u 
INNER JOIN payments p 
	ON p.user_id = u.id 
GROUP BY u.name,u.email 
ORDER BY paymentTotal DESC
LIMIT 10;

-- 4
-- Acá no tomo en cuenta el estado de la reserva que dice el booking (porque dijo que se hiciera así
CREATE TRIGGER `notify_host_after_booking` AFTER INSERT 
ON `bookings` FOR EACH ROW
BEGIN
	DECLARE idPropiedad INT;
	DECLARE idPropietario INT;
	DECLARE idQuienReserva INT;
	DECLARE mensaje TEXT;
	SET mensaje = "Se reservo una propiedad";
	
	SELECT p.id , p.owner_id , b.user_id 
	INTO idPropiedad,idPropietario,idQuienReserva
	FROM bookings b 
	INNER JOIN properties p 
		ON p.id = b.property_id;
	
	INSERT INTO airbnb_like_db.messages (sender_id, receiver_id, property_id, content) VALUES 
	(idQuienReserva,idPropietario,idPropiedad,mensaje);
	
END;

-- 5
-- El profesor permitió que total_price = 0
DELIMITER |
CREATE PROCEDURE `add_new_booking` 
(IN propiedadID INT, IN usuarioID INT, IN entrada DATE, IN salida DATE)
BEGIN
	DECLARE cuandoSeLibera DATE;
	DECLARE cuandoSeVuelveAOcupar DATE;
	DECLARE viejoStatus VARCHAR(50);
	DECLARE nuevoStatus VARCHAR(50);
	SET nuevoStatus = "confirmed";
	
	SELECT pa.available_from, pa.available_to,pa.status 
	INTO cuandoSeLibera,cuandoSeVuelveAOcupar,viejoStatus
	FROM properties p 
	INNER JOIN property_availability pa 
	ON p.id = pa.property_id;
	
	IF((cuandoSeLibera>=entrada AND salida<=cuandoSeVuelveAOcupar) AND viejoStatus!="confirmed") THEN	
		INSERT INTO airbnb_like_db.bookings (property_id,user_id,check_in,check_out,total_price,status)
		VALUES (propiedadID,usuarioID,entrada,salida,0,nuevoStatus);
	END IF;
	
END;
|
DELIMITER

-- 6
CREATE ROLE `admin`;

GRANT CREATE 
ON properties
TO admin;

GRANT UPDATE (status)
ON property_availability
TO admin;

-- 7 
-- Hay que pensar que el principio de durabilidad en ACID menciona que los datos van a ser persistentes, 
-- esto se refiere a que los datos van a mantenerse guardados en la base de datos; sin embargo esto no 
-- implica que no se puedan modificar o eliminar. 
-- Es decir la durabilidad garantiza que si "yo apago y prendo el sistema" los datos van a 
-- seguir existiendo y van a tener el estado en el que se encontraban antes; pero el modificarlos
-- por medio de una transacción no contradice ese significado.









