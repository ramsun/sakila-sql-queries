-- import downloaded database
USE sakila;

-- Display the first name and last name from the table actor
SELECT first_name, last_name 
FROM actor;

-- Merge the columns into one
SELECT CONCAT(first_name,' ',last_name) AS 'Actor Name' 
FROM actor;

-- Diplay information for the actor with the first name Joe
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

-- 5a - Recreate the table address 
CREATE TABLE IF NOT EXISTS address (
address_id INT AUTO_INCREMENT,
address VARCHAR(50),
address2 VARCHAR(50),
district VARCHAR(20),
city_id INT AUTO_INCREMENT,
postal_code VARCHAR(10) NOT NULL,
phone VARCHAR(20) NOT NULL,
last_update TIMESTAMP NOT NULL
)

-- 6a
SELECT first_name, last_name, address
FROM address
INNER JOIN staff ON staff.address_id = address.address_id;

-- 6b
SELECT first_name, last_name, amount
FROM staff
INNER JOIN payment ON staff.staff_id = payment.staff_id;

-- 6c
SELECT title, count(actor_id)
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY title;

-- 6d
SELECT title, count(inventory_id)
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
WHERE title = "Hunchback Impossible"
GROUP BY title;

-- 6e
SELECT title, count(inventory_id)
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
WHERE title = "Hunchback Impossible"
GROUP BY title;

-- 6e
SELECT first_name, last_name, sum(amount)
FROM payment
INNER JOIN customer ON payment.customer_id = customer.customer_id
GROUP BY last_name;

-- 7a
SELECT title
FROM film
WHERE title LIKE 'K%' OR title LIKE 'Q%'
AND language_id IN(	SELECT language_id
					FROM language
					WHERE name = 'English');

-- 7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN(SELECT actor_id
				FROM film
				WHERE title = 'Alone Trip');
                
-- 7c

	








