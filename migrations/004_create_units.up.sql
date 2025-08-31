-- Migration: create table units
CREATE TABLE units (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,       -- pcs, box, kg, liter
    abbreviation VARCHAR(10) NOT NULL
);
