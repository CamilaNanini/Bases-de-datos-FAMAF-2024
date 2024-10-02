-- https://www.w3schools.com/sql/sql_alter.asp
USE `olympics`;
-- 1
ALTER TABLE person 
ADD COLUMN total_medals INT DEFAULT'0';

-- 2
WITH contando_medallas(idParticipante,medallasTotales) AS(
	SELECT games_competitor.person_id AS idParticipante, 
	COUNT(medal.id) AS medallasTotales
	FROM  games_competitor
	INNER JOIN competitor_event
	ON games_competitor.id = competitor_event.competitor_id
	INNER JOIN medal
	ON competitor_event.medal_id = medal.id
	GROUP BY games_competitor.person_id
)


UPDATE person
SET total_medals = contando_medallas.medallasTotales
FROM contando_medallas
WHERE person.id = contando_medallas.idParticipante
 
-- 3 
SELECT p.full_name, m.medal_name, COUNT(m.medal_name) AS medal_count
FROM person p
INNER JOIN person_region pr ON p.id = pr.person_id
INNER JOIN noc_region nr ON pr.region_id = nr.id
INNER JOIN games_competitor gc ON p.id = gc.person_id
INNER JOIN competitor_event ce ON gc.games_id = ce.event_id
INNER JOIN medal m ON ce.medal_id = m.id
WHERE nr.region_name = 'Argentina'
GROUP BY p.full_name, m.medal_name;

-- 4 
SELECT sport.name, COUNT(medal.id) AS todas_las_medallas
FROM person
INNER JOIN person_region ON person.id = person_region.person_id
INNER JOIN noc_region ON noc_region.id = person_region.person_id
INNER JOIN games_competitor ON games_competitor.id = person.id
INNER JOIN competitor_event ON competitor_event.competitor_id = games_competitor.person_id
INNER JOIN medal ON medal.id = competitor_event.medal_id
INNER JOIN event ON competitor_event.event_id = event.id
INNER JOIN sport ON sport.id = event.sport_id
WHERE noc_region.region = "Argentina"
GROUP BY sport.name

-- 5 
SELECT noc_region.region_name, 
  SUM(CASE WHEN m.medal_name = 'Gold' THEN 1 ELSE 0 END) AS gold_medals,
  SUM(CASE WHEN m.medal_name = 'Silver' THEN 1 ELSE 0 END) AS silver_medals,
  SUM(CASE WHEN m.medal_name = 'Bronze' THEN 1 ELSE 0 END) AS bronze_medals
FROM person
INNER JOIN person_region ON person.id = person_region.person_id
INNER JOIN noc_region ON person_region.region_id = noc_region.id
INNER JOIN games_competitor ON person.id = games_competitor.person_id
INNER JOIN competitor_event ON games_competitor.games_id = competitor_event.event_id
INNER JOIN medal ON competitor_event.medal_id = medal.id
GROUP BY noc_region.region_name;

-- Version 2
WITH MedalCounts AS (
  SELECT 
    noc_region.region_name,
    m.medal_name
  FROM person
  INNER JOIN person_region ON person.id = person_region.person_id
  INNER JOIN noc_region ON person_region.region_id = noc_region.id
  INNER JOIN games_competitor ON person.id = games_competitor.person_id
  INNER JOIN competitor_event ON games_competitor.games_id = competitor_event.event_id
  INNER JOIN medal ON competitor_event.medal_id = medal.id
)

SELECT 
  region_name,
  SUM(CASE WHEN medal_name = 'Gold' THEN 1 ELSE 0 END) AS gold_medals,
  SUM(CASE WHEN medal_name = 'Silver' THEN 1 ELSE 0 END) AS silver_medals,
  SUM(CASE WHEN medal_name = 'Bronze' THEN 1 ELSE 0 END) AS bronze_medals
FROM MedalCounts
GROUP BY region_name;

--6
WITH cantidad_medallas (regionPersona, cantMedalla) AS (
        SELECT person_region.region_id AS regionPersona, COUNT(medal.id)
        FROM person_region
        INNER JOIN person ON person_region.person_id = person.id
        INNER JOIN games_competitor ON games_competitor.person_id = person.id
        INNER JOIN competitor_event ON competitor_event.competitor_id = games_competitor.person_id
        INNER JOIN medal ON medal.id = competitor_event.medal_id
        GROUP BY person_region.region_id
)

(
SELECT noc_region.region_name, MAX(cantMedalla) AS maximasMedallas
FROM noc_Region
INNER JOIN cantidad_medallas ON noc_region.id = regionPersona
GROUP BY noc_region.region_name
ORDER BY maximasMedallas
LIMIT 1;
)
UNION
(
SELECT noc_region.region_name, MIN(cantMedalla) AS minimasMedallas
FROM noc_Region
INNER JOIN cantidad_medallas ON noc_region.id = regionPersona
GROUP BY noc_region.region_name
ORDER BY minimasMedallas
LIMIT 1;
)

-- 7
-- a
CREATE TRIGGER increase_number_of_medals BEFORE INSERT
ON competitor_event FOR EACH ROW
BEGIN
    DECLARE won INT
    DECLARE medals VARCHAR(30)
 
    SELECT games_competitor.person_id
    INTO won
    FROM games_competitor
    WHERE games_competitor.id = NEW.competitor_id
    LIMIT 1

    SELECT medal.medal_name
    INTO medals
    FROM medal
    WHERE medal.id = NEW.medal_id
    
    IF (medals != 'NA') THEN
        UPDATE person
        SET person.total_medals = person.total_medals + 1
        WHERE person.id = person_won
    END IF;
END;

-- b
CREATE TRIGGER decrease_number_of_medals AFTER DELETE
ON competitor_event FOR EACH ROW
BEGIN
    DECLARE won INT
    DECLARE medals VARCHAR(30)
 
    SELECT games_competitor.person_id
    INTO won
    FROM games_competitor
    WHERE games_competitor.id = NEW.competitor_id
    LIMIT 1

    SELECT medal.medal_name
    INTO medals
    FROM medal
    WHERE medal.id = NEW.medal_id
    
    IF (medals != 'NA') THEN
        UPDATE person
        SET person.total_medals = person.total_medals - 1
        WHERE person.id = person_won
    END IF;
END;

-- 8
CREATE PROCEDURE add_new_medalists (IN events_id INT, IN g_id INT, IN s_id INT,IN b_id INT)
    BEGIN
        -- Busco los id de las medallas
        DECLARE gold_id INT 
        DECLARE bronze_id INT 
        DECLARE silver_id INT 
        
        SELECT medal.id
        INTO gold_id
        FROM medal
        WHERE medal.id = 'Gold';

        SELECT medal.id
        INTO silver_id
        FROM medal
        WHERE medal.id = 'Silver';

        SELECT medal.id
        INTO bronze_id
        FROM medal
        WHERE medal.id = 'Bronze';

        INSERT INTO competitor_event(event_id,competitor_id,medal_id)
        VALUES (events_id,g_id,gold_id), (events_id,s_id,silver_id),(events_id,b_id,bronze_id);
    END

-- 9
CREATE ROLE organizer;

GRANT DELETE 
ON games
TO organizer;

GRANT UPDATE (games_name)
ON games
TO organizer;






