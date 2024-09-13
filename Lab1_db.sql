-- use world;

-- CREATE TABLE city (
--     ID INT PRIMARY KEY,
--     Name VARCHAR(100),
--     CountryCode VARCHAR(50),
--     District VARCHAR(100),
--     Population INT
-- );
 
-- CREATE TABLE country (
--     Code VARCHAR(50) PRIMARY KEY,
--     Name VARCHAR(100),
--     Continent VARCHAR(50),
--     Region VARCHAR(50),
--     SurfaceArea INT,
--     IndepYear INT,
--     Population INT,
--     LifeExpectancy INT,
--     GNP INT,
--     GNPOld INT,
--     LocalName VARCHAR(100),
--     GovernmentForm VARCHAR(100),
--     HeadOfState VARCHAR(100),
--     Capital INT,
--     Code2 VARCHAR(50)
-- );
 
-- CREATE TABLE countrylanguage (
--     CountryCode VARCHAR(100),
--     Language VARCHAR(100),
--     IsOfficial VARCHAR(5),
--     Percentage NUMERIC(4,2),
--     PRIMARY KEY (CountryCode, Language)
-- );

-- Y para descomprimir los datos hacer gunzip world-data.sql.gz
-- Para cargar los datos usar ejecutar script desde dbeaver o mysql -u usuario -p nombre_base_datos < /ruta/del/archivo.sql

-- CREATE TABLE continent(
-- 	NombreContinente VARCHAR(30),
-- 	Area BIGINT,
-- 	PorcentajeDeMasaTerrestre FLOAT,
-- 	CiudadMasPoblada int,
-- 	FOREIGN KEY (CiudadMasPoblada) REFERENCES city(ID) ON DELETE CASCADE,
-- 	PRIMARY KEY (NombreContinente)
-- );

-- Antes de insertar los datos a la nueva tabla hay que saber y agregar datos a la de city. Esto porque una referencia a la otra
-- SELECT ID FROM city ORDER BY ID DESC; -- Con esto sé la última ID
-- INSERT INTO city VALUES (4080,'McMurdo Station','NZIR','Antarctic',525); -- Agrego la data que faltaba

-- Ahora necesito el ID de las ciudades que se piden
-- SELECT * FROM city WHERE Name LIKE '%Istanbul%';
-- Cairo 608, McMurdo 4080, Mumbai 1024, Ciudad d Mex 2515,Sydney 130, São Paulo 206, Istanbul 3357
-- INSERT INTO continent VALUES ('Asia',44579000,29.5,1024);

-- Modificar la tabla "country" de manera que el campo "Continent" pase a ser una clave externa (o foreign key) a la tabla Continent.
-- ALTER TABLE country ADD CONSTRAINT fk_continent_country FOREIGN KEY (Continent) REFERENCES continent (NombreContinente) ON DELETE CASCADE;

-- CONSULTAS:
-- SELECT Name , Region FROM country ORDER BY Name ASC; 
-- SELECT Name , Population FROM city ORDER BY Population DESC LIMIT 10; 
-- SELECT Name , Region , SurfaceArea, GovernmentForm FROM country ORDER BY SurfaceArea ASC LIMIT 10; 
-- SELECT * FROM country WHERE IndepYear IS NULL; 
-- Para la última necesito vincular el pais con su lenguaje

-- Verificar que todas las filas de la tabla country tengan una referencia válida en countrylanguage
-- SELECT Code FROM country WHERE Code NOT IN (SELECT CountryCode FROM countrylanguage);

-- Agregar las entradas faltantes en countrylanguage
-- INSERT INTO countrylanguage (CountryCode, Language, IsOfficial, Percentage) SELECT Code, 'Unknown', 'F', 0 
-- FROM country WHERE Code NOT IN (SELECT CountryCode FROM countrylanguage);

-- Eliminar las filas sin correspondencia en country
-- DELETE FROM country WHERE Code NOT IN (SELECT CountryCode FROM countrylanguage);

-- ALTER TABLE country ADD CONSTRAINT fk_continent_language FOREIGN KEY (Code) REFERENCES countrylanguage (CountryCode) ON DELETE CASCADE;

-- SELECT Language , Percentage FROM countrylanguage WHERE IsOfficial = 'T';


