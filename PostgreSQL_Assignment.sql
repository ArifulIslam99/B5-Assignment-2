-- Active: 1747992694221@@127.0.0.1@5432@b5a2@public
CREATE DATABASE B5A2;

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
    conservation_status VARCHAR(20) CHECK (conservation_status IN ('Endangered', 'Vulnerable'))
);

CREATE TABLE sightings(
    sighting_id SERIAL PRIMARY KEY,
    ranger_id  INTEGER REFERENCES rangers(ranger_id),
    species_id  INTEGER REFERENCES species(species_id),
    sighting_time TIMESTAMP,
    "location" TEXT,
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



DROP Table rangers;

SELECT * from rangers;

SELECT * from species;

SELECT * from sightings;




