-- Active: 1747992694221@@127.0.0.1@5432@b5a2@public
CREATE DATABASE B5A2;

DROP Table rangers;
DROP Table species;
DROP Table sightings;

CREATE TABLE rangers(
    ranger_id SERIAL PRIMARY KEY,
    "name"  VARCHAR (50) NOT NULL,
    region TEXT
);

CREATE TABLE species(
    species_id SERIAL PRIMARY KEY,
    common_name  VARCHAR (50) NOT NULL,
    scientific_name VARCHAR(50) NOT NULL UNIQUE,
    discovery_date TIMESTAMP NOT NULL,
    conservation_status VARCHAR(20)
);

CREATE TABLE sightings(
    sighting_id SERIAL PRIMARY KEY,
    ranger_id  INTEGER REFERENCES rangers(ranger_id),
    species_id  INTEGER REFERENCES species(species_id),
    sighting_time TIMESTAMP NOT NULL,
    "location" TEXT NOT NULL,
    notes TEXT
);


INSERT INTO rangers ("name", region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');

INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');


INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 'Peak Ridge',        '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area',     '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass',     '2024-05-18 18:30:00', NULL);


SELECT * from rangers;

SELECT * from species;

SELECT * from sightings;


--  PROBLEM 1 
INSERT INTO rangers ("name", region) VALUES ('Derek Fox', 'Coastal Plains');

--  PROBLEM 2
SELECT Count(DISTINCT sightings.species_id) AS unique_species_count
FROM sightings;


--  PROBLEM 3
SELECT * from sightings
    WHERE "location" LIKE '%Pass%';


--  PROBLEM 4
SELECT "name", count(*) as total_sightings from rangers
    Join sightings ON rangers.ranger_id = sightings.ranger_id
    GROUP BY "name"
;


--  PROBLEM 5
SELECT common_name from species
    LEFT OUTER Join sightings ON species.species_id = sightings.species_id
    WHERE sightings.species_id IS NULL;
;


--  PROBLEM 6
SELECT common_name, sighting_time, name from sightings
    Join rangers ON sightings.ranger_id = rangers.ranger_id
    JOIN species On species.species_id = sightings.species_id
    ORDER BY sighting_time DESC
    LIMIT 2
;


--  PROBLEM 7

UPDATE species
SET conservation_status = 'Historic'
Where extract(YEAR from discovery_date) < 1800;

--  PROBLEM 8

CREATE OR REPLACE FUNCTION get_time_of_day(ts TIMESTAMP)
RETURNS TEXT  
LANGUAGE plpgsql
AS
$$
BEGIN
    IF EXTRACT(HOUR FROM ts) < 12 THEN
        RETURN 'Morning';
    ELSIF EXTRACT(HOUR FROM ts) BETWEEN 12 AND 17 THEN
        RETURN 'Afternoon';
    ELSE
        RETURN 'Evening';
    END IF;
END;
$$;

SELECT sighting_id, get_time_of_day(sighting_time) as time_of_day  FROM sightings;


--  PROBLEM 9

DELETE FROM rangers 
    WHERE rangers.ranger_id NOT IN 
        (SELECT DISTINCT ranger_id from sightings);



