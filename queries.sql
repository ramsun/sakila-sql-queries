-- import downloaded database
USE sakila;

-- Display the first name and last name from the table actor
SELECT first_name, last_name 
FROM actor;

-- Merge the columns into one
SELECT CONCAT(first_name,' ',last_name) AS 'Actor Name' 
FROM actor;

-- 1b
SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name = 'Joe';

-- 2a
SELECT last_name 
FROM actor
WHERE last_name LIKE '%GEN%';

-- 2b
SELECT last_name 
FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;


-- 2d
SELECT country_id, country
FROM country
WHERE country IN('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor
ADD description BLOB;

-- 3b 
ALTER TABLE actor
DROP COLUMN description;

-- 4a
SELECT last_name, count(last_name) 
FROM actor
GROUP BY last_name;

-- 4b
SELECT last_name, count(last_name) 
FROM actor
GROUP BY last_name
HAVING count(last_name)>1; -- useful for filtering aggregate function records

-- 4c - Update an entry in the schema
UPDATE actor
SET first_name = 'HARPO', last_name = 'WILLIAMS'  
WHERE (first_name = 'GROUCHO ' AND last_name = 'WILLIAMS');

-- 4d - Revert the update on the schema
UPDATE actor
SET first_name = 'GROUCHO', last_name = 'WILLIAMS'  
WHERE (first_name = 'HARPO' AND last_name = 'WILLIAMS');

-- 5a - Recreate the table within the 
CREATE TABLE IF NOT EXISTS address (

address_id INT AUTO_INCREMENT,
address VARCHAR(255) NOT NULL,
address2 VARCHAR(255) NOT NULL,
district VARCHAR(20) NOT NULL,
city_id INT AUTO_INCREMENT NOT NULL,

)
