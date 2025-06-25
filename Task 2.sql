-- Drop existing tables for a clean setup
DROP TABLE IF EXISTS MovieAudit;
DROP TABLE IF EXISTS Movies;

-- Create Movies table
CREATE TABLE Movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    genre VARCHAR(50) DEFAULT 'Unknown',
    release_year INT CHECK (release_year >= 1900),
    rating DECIMAL(3,1),
    language VARCHAR(50) DEFAULT 'English',
    platform VARCHAR(50) NOT NULL
);

-- Create MovieAudit table for logging deletions
CREATE TABLE MovieAudit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger for logging deleted movies
DELIMITER //
CREATE TRIGGER after_movie_delete
AFTER DELETE ON Movies
FOR EACH ROW
BEGIN
    INSERT INTO MovieAudit (movie_id) VALUES (OLD.movie_id);
END;
//
DELIMITER ;

-- Insert sample data with NULLs and defaults
INSERT INTO Movies (title, genre, release_year, rating, language, platform)
VALUES
('Interstellar', 'Sci-Fi', 2014, COALESCE(NULL, 8.6), NULL, 'Netflix'),
('The Lighthouse', NULL, 2019, 7.5, 'English', 'Prime Video'),
('Her', 'Drama', 2013, NULL, NULL, 'Netflix');

-- Conditional insert to prevent duplicates
INSERT INTO Movies (title, genre, release_year, rating, language, platform)
SELECT * FROM (SELECT 'Inception', 'Sci-Fi', 2010, 8.8, 'English', 'Netflix') AS tmp
WHERE NOT EXISTS (
    SELECT 1 FROM Movies WHERE title = 'Inception' AND platform = 'Netflix'
);

-- Safe UPDATE using subquery to comply with SQL_SAFE_UPDATES
UPDATE Movies
SET rating = rating + 0.3
WHERE movie_id IN (
    SELECT movie_id FROM (
        SELECT movie_id FROM Movies
        WHERE release_year < 2015 AND rating IS NOT NULL
    ) AS temp
);

-- Normalize any remaining NULLs
UPDATE Movies
SET genre = COALESCE(genre, 'Unknown'),
    language = COALESCE(language, 'English');

-- Delete old movies with NULL rating
DELETE FROM Movies
WHERE rating IS NULL AND release_year < 2015;

-- Transaction with rollback option (manually toggle in Workbench)
START TRANSACTION;
DELETE FROM Movies WHERE title = 'Her';
-- ROLLBACK;
COMMIT;