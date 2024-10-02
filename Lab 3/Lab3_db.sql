-- ------------------------ PARTE 1 -------------------------- --
-- Lista el nombre de la ciudad, nombre del país, región y forma de gobierno de las 10 ciudades más pobladas del mundo.
SELECT ci.Name, co.Name , co.Region , co.GovernmentForm  FROM city AS ci
INNER JOIN country AS co ON ci.CountryCode = co.Code 
ORDER BY ci.Population DESC LIMIT 10;
-- Listar los 10 países con menor población del mundo, junto a sus ciudades capitales 
SELECT country.Name, city.Name FROM country 
LEFT JOIN city ON country.Capital = city.ID 
ORDER BY country.Population ASC LIMIT 10;
-- Listar el nombre, continente y todos los lenguajes oficiales de cada país
SELECT country.Name , country.Continent , countrylanguage.Language  FROM country
RIGHT JOIN countrylanguage ON countrylanguage.CountryCode = country.Code 
-- Listar el nombre del país y nombre de capital, de los 20 países con mayor superficie del mundo.
SELECT country.Name, city.Name FROM country 
INNER JOIN city ON country.Capital = city.ID
ORDER BY country.SurfaceArea DESC LIMIT 20;
-- Listar las ciudades junto a sus idiomas oficiales (ordenado por la población de la ciudad) y el porcentaje de hablantes del idioma.
SELECT city.Name,countrylanguage.Language,countrylanguage.Percentage FROM city 
LEFT JOIN countrylanguage ON countrylanguage.CountryCode = city.CountryCode 
ORDER BY city.Population;
-- Listar los 10 países con mayor población y los 10 países con menor población (que tengan al menos 100 habitantes) en la misma consulta.
(SELECT country.Name FROM country ORDER BY country.Population DESC LIMIT 10)
UNION
(SELECT country.Name FROM country WHERE country.Population > 100 ORDER BY country.Population ASC LIMIT 10);
-- Listar aquellos países cuyos lenguajes oficiales son el Inglés y el Francés
(SELECT country.Name FROM country LEFT JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.Language = 'English' AND countrylanguage.IsOfficial ='T')
INTERSECT 
(SELECT country.Name FROM country LEFT JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.Language = 'French'AND countrylanguage.IsOfficial ='T')
-- Listar aquellos países que tengan hablantes del Inglés pero no del Español en su población.*/
(SELECT country.Name FROM country LEFT JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.Language = 'English')
EXCEPT
(SELECT country.Name FROM country LEFT JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.Language != 'Spanish')
-- EXTRA : Para corroborar que lenguajes se usan en tal país
SELECT country.Name,countrylanguage.`Language` FROM country LEFT JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE country.Name LIKE '%Jap%'
-- ------------------------ PARTE 2 -------------------------- --
-- ¿Devuelven los mismos valores las siguientes consultas? ¿Por qué? 

SELECT city.Name, country.Name
FROM city
LEFT JOIN country ON city.CountryCode = country.Code AND country.Name = 'Argentina';

SELECT city.Name, country.Name
FROM city
INNER JOIN country ON city.CountryCode = country.Code
WHERE country.Name = 'Argentina';

-- Si, ambas consultas devolveran lo mismo (todas las ciudades de Arg)

-- ¿Y si en vez de INNER JOIN fuera un LEFT JOIN?
/* En ese caso la segunda consulta seguiría devolviendo el mismo resultado,pero la primera consulta 
 * interpretaría que buscamos devolver todas las ciudades y dar el pais de aquellas ciudades 
 * que sean de Arg mientras que las otras quedan en NULL. */
