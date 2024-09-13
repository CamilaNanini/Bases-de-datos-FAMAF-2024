-- 1 Listar el nombre de la ciudad y el nombre del país de todas las ciudades que pertenezcan a países con una población menor a 10000 habitantes.
SELECT city.Name, country.Name 
FROM city INNER JOIN country
ON city.CountryCode = country.Code 
WHERE country.Code IN (
		SELECT country.Code 
		FROM country
		WHERE country.Population < 10000
);

-- 2 Listar todas aquellas ciudades cuya población sea mayor que la población promedio entre todas las ciudades.
SELECT city.Name 
FROM city 
WHERE city.Population > ALL(
			SELECT AVG(city.Population)
			FROM city
);

-- 3 Listar todas aquellas ciudades no asiáticas cuya población sea igual o mayor a la población total de algún país de Asia.
SELECT city.Name
FROM city INNER JOIN country
ON city.CountryCode = country.Code 
WHERE country.Continent != 'Asia' AND city.Population >= SOME(
				SELECT city.Population 
				FROM city INNER JOIN country
				ON city.CountryCode = country.Code
				WHERE country.Continent = 'Asia'
);

-- 4 Listar aquellos países junto a sus idiomas no oficiales, que superen en porcentaje de hablantes a cada uno de los idiomas oficiales del país.
SELECT country.Name , countrylanguage.Language 
FROM country INNER JOIN countrylanguage
ON country.Code = countrylanguage.CountryCode AND countrylanguage.IsOfficial != 'T'
WHERE countrylanguage.Percentage > ALL (
		SELECT countrylanguage.Percentage 
        FROM countrylanguage
        WHERE countrylanguage.IsOfficial = 'T' AND country.Code = countrylanguage.CountryCode
);
-- 5 Listar (sin duplicados) aquellas regiones que tengan países con una superficie menor a 1000 km2 y exista (en el país) al menos una ciudad con más de 100000 habitantes. 
-- Con subquery
SELECT DISTINCT country.Region 
FROM country 
WHERE country.SurfaceArea < 1000 AND 100000 < SOME (
				SELECT city.Population
				FROM city 
				WHERE city.CountryCode = country.Code 
);
-- Sin subquery
SELECT DISTINCT country.Region 
FROM country INNER JOIN city 
ON city.CountryCode = country.Code 
WHERE country.SurfaceArea < 1000 AND 100000 < city.Population

-- 6 Listar el nombre de cada país con la cantidad de habitantes de su ciudad más poblada. 
-- (Hint: Hay dos maneras de llegar al mismo resultado. Usando consultas escalares o usando agrupaciones, encontrar ambas).
-- Consulta escalar
SELECT DISTINCT country.name, (SELECT MAX(city.population)
        FROM city
        WHERE city.countrycode = country.code)
FROM country;

-- Consulta agrupada
SELECT country.Name, max(city.Population)
FROM country INNER JOIN city 
ON country.Code = city.CountryCode
GROUP BY country.Code ;

-- 7 Listar aquellos países y sus lenguajes no oficiales cuyo porcentaje de hablantes sea mayor al promedio de hablantes de los lenguajes oficiales. 
SELECT country.Name , countrylanguage.Language
FROM country INNER JOIN countrylanguage
ON country.Code = countrylanguage.CountryCode AND countrylanguage.IsOfficial!='T'
WHERE countrylanguage.Percentage > ALL( 
			SELECT AVG(countrylanguage.Percentage)
			FROM countrylanguage
			WHERE countrylanguage.IsOfficial = 'T' AND country.Code = countrylanguage.CountryCode 
)
-- 8 Listar la cantidad de habitantes por continente ordenado en forma descendente.
SELECT country.Continent , SUM(country.Population) as cpopulation
FROM country 
GROUP BY country.Continent
ORDER BY cpopulation DESC;

-- 9 Listar el promedio de esperanza de vida (LifeExpectancy) por continente con una esperanza de vida entre 40 y 70 años.
SELECT country.Continent , AVG(country.LifeExpectancy) AS clifeexpextanxy
FROM country 
GROUP BY country.Continent
HAVING clifeexpextanxy>40 AND clifeexpextanxy<70
ORDER BY clifeexpextanxy DESC 

-- Listar la cantidad máxima, mínima, promedio y suma de habitantes por continente.
SELECT  country.continent, MAX(country.Population), MIN(country.Population), AVG(country.Population), SUM(country.Population)
FROM country
GROUP BY country.Continent;

-- Modificar la consulta 6 para que además devuelva el nombre de la ciudad más poblada. 
-- ¿Podría lograrse con agrupaciones? ¿y con una subquery escalar?
SELECT country.Name,city.Name,city.Population
FROM country INNER JOIN city 
ON country.Code = city.CountryCode
WHERE city.Population = ALL(
		SELECT MAX(city.Population)
		FROM city 
		WHERE city.CountryCode = country.Code
		);
		
-- SELECT c.Name AS CountryName, ci.Name AS CityName, ci.Population
-- FROM country c
-- INNER JOIN city ci
--     ON c.Code = ci.CountryCode
-- INNER JOIN (
--     SELECT CountryCode, MAX(Population) AS MaxPopulation
--     FROM city
--     GROUP BY CountryCode
-- ) max_pop
--     ON ci.CountryCode = max_pop.CountryCode
--     AND ci.Population = max_pop.MaxPopulation;



