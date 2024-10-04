-- 1
WITH anio_idJugos (anio,idCity) AS(
	SELECT g.games_year as anio , gc.city_id as idCity
	FROM games g 
	INNER JOIN games_city gc
		ON gc.games_id = g.id 
	WHERE g.season = 'Summer'
)
SELECT c.city_name , anio
FROM city c
INNER JOIN anio_idJugos ai
	ON c.id = ai.idCity
ORDER BY anio DESC

-- 1 pero sin with
SELECT c.city_name , g.games_year 
FROM city c 
INNER JOIN games_city gc 
	ON gc.city_id = c.id 
INNER JOIN games g 
	ON g.id = gc.games_id 
WHERE g.season = 'Summer'
ORDER BY g.games_year DESC

-- 2 
WITH sports AS (
    SELECT e.id AS eventID, s.sport_name AS nombreSport
    FROM event e
    INNER JOIN sport s 
    	ON e.sport_id = s.id
    WHERE s.sport_name = 'Football'
),

medals AS (
    SELECT ce.event_id AS eventIDT, COUNT(m.id) AS cantMedals
    FROM competitor_event ce
    INNER JOIN medal m 
    	ON ce.medal_id = m.id
    WHERE m.medal_name = 'Gold'
    GROUP BY ce.event_id
)

SELECT nr.region_name, SUM(ms.cantMedals) AS totalMedals, ss.nombreSport
FROM noc_region nr
INNER JOIN person_region pr 
	ON nr.id = pr.region_id
INNER JOIN person p 
	ON pr.person_id = p.id
INNER JOIN games_competitor gc 
	ON p.id = gc.person_id
INNER JOIN sports ss 
	ON ss.eventID = gc.games_id
INNER JOIN medals ms 
	ON ms.eventIDT = ss.eventID
GROUP BY nr.region_name, ss.nombreSport
ORDER BY totalMedals DESC
LIMIT 10;

-- 3
WITH sports AS (
    SELECT e.id AS eventID, s.sport_name AS nombreSport
    FROM event e
    INNER JOIN sport s 
    	ON e.sport_id = s.id
    WHERE s.sport_name = 'Football'
),

medals AS (
    SELECT ce.event_id AS eventIDT, COUNT(m.id) AS cantMedals
    FROM competitor_event ce
    INNER JOIN medal m 
    	ON ce.medal_id = m.id
    WHERE m.medal_name = 'Gold'
    GROUP BY ce.event_id
)

(
SELECT nr.region_name, COUNT(gc.games_id) AS participaciones, SUM(ms.cantMedals) AS totalMedals, ss.nombreSport
FROM noc_region nr
INNER JOIN person_region pr 
	ON nr.id = pr.region_id
INNER JOIN person p 
	ON pr.person_id = p.id
INNER JOIN games_competitor gc 
	ON p.id = gc.person_id
INNER JOIN sports ss 
	ON ss.eventID = gc.games_id
INNER JOIN medals ms 
	ON ms.eventIDT = ss.eventID
GROUP BY nr.region_name, ss.nombreSport
ORDER BY participaciones DESC 
LIMIT 1
)
UNION
(
SELECT nr.region_name, COUNT(gc.games_id) AS participaciones, SUM(ms.cantMedals) AS totalMedals, ss.nombreSport
FROM noc_region nr
INNER JOIN person_region pr 
	ON nr.id = pr.region_id
INNER JOIN person p 
	ON pr.person_id = p.id
INNER JOIN games_competitor gc 
	ON p.id = gc.person_id
INNER JOIN sports ss 
	ON ss.eventID = gc.games_id
INNER JOIN medals ms 
	ON ms.eventIDT = ss.eventID
GROUP BY nr.region_name, ss.nombreSport
ORDER BY participaciones ASC 
LIMIT 1
)

-- 4
CREATE VIEW medals_sports_country AS (
    SELECT 
        nr.region_name,
        s.sport_name,
        SUM(CASE WHEN m.medal_name = 'Gold' THEN 1 ELSE 0 END) AS gold_medals_count,
        SUM(CASE WHEN m.medal_name = 'Silver' THEN 1 ELSE 0 END) AS silver_medals_count,
        SUM(CASE WHEN m.medal_name = 'Bronze' THEN 1 ELSE 0 END) AS bronze_medals_count
    FROM noc_region nr
    INNER JOIN person_region pr ON nr.id = pr.region_id
    INNER JOIN person p ON pr.person_id = p.id
    INNER JOIN games_competitor gc ON p.id = gc.person_id
    INNER JOIN competitor_event ce ON gc.games_id = ce.event_id
    INNER JOIN event e ON ce.event_id = e.id
    INNER JOIN sport s ON e.sport_id = s.id
    INNER JOIN medal m ON m.id = ce.medal_id
    GROUP BY nr.region_name, s.sport_name
);
-- DROP VIEW medals_sports_country;

SELECT * FROM medals_sports_country; 

-- 5
DELIMITER //
CREATE PROCEDURE GetMedalCountsByCountry(
    IN country_name VARCHAR(100)
)
BEGIN
    SELECT 
        SUM(msc.gold_medals_count) AS total_gold,
        SUM(msc.silver_medals_count) AS total_silver,
        SUM(msc.bronze_medals_count) AS total_bronze
    FROM medals_sports_country msc
    WHERE msc.region_name = country_name;
END; 
//
DELIMITER ;

-- CALL GetMedalCountsByCountry('Argentina');

-- 6
-- a
ALTER TABLE event 
ADD COLUMN sport_name VARCHAR(255)

UPDATE event e
JOIN sport s ON e.sport_id = s.id
SET e.sport_name = s.sport_name;
-- b
ALTER TABLE event 
DROP FOREIGN KEY fk_ev_sp;

ALTER TABLE event 
DROP COLUMN sport_id
-- c
DROP TABLE sport 
















