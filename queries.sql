/*   
This script has 8 parts, each of which composes of about 1
to 8 querries each.

The goal of this script is to showcase some of the queries that can
be made in MySQL.  The database sakila can be downloaded directly from
MYSQL's website:
https://dev.mysql.com/doc/sakila/en/sakila-installation.html

Table of Contents:
Part 1 - Basic Querries
Part 2 - Filtering
Part 3 - Basic DDL Commands
Part 4 - Groupbys and More DDL
Part 5 - Creating tables
Part 6 - Joins
Part 7 - Sub Queries
Part 8 - Views
*/

-- import downloaded database
USE sakila;

/*  Part 1 - Basic Querries  */
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

/*   Part 2 - Filtering   */
-- Display the last names of the actors that contain the letters GEN
SELECT last_name 
FROM actor
WHERE last_name LIKE '%GEN%';

-- Show the actors whose last name contains the letters LI
-- order by last_name
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 
SELECT country_id, country
FROM country
WHERE country IN('Afghanistan', 'Bangladesh', 'China');

/*     Part 3 - Basic DDL Commands    */
-- Add a new column to the table actor
ALTER TABLE actor
ADD description BLOB;

-- Remove the added column from the table 
ALTER TABLE actor
DROP COLUMN description;

/*  Part 4 - Groupbys and More DDL  */
-- Display the name and the count of each name from the table actor
SELECT last_name, count(last_name) 
FROM actor
GROUP BY last_name;

-- Only display the last names who have 2 or more counts
SELECT last_name, count(last_name) 
FROM actor
GROUP BY last_name
HAVING count(last_name)>1; -- useful for filtering aggregate function records

-- Update an entry in the schema
UPDATE actor
SET first_name = 'HARPO', last_name = 'WILLIAMS'  
WHERE (first_name = 'GROUCHO ' AND last_name = 'WILLIAMS');

-- Revert the update on the schema
UPDATE actor
SET first_name = 'GROUCHO', last_name = 'WILLIAMS'  
WHERE (first_name = 'HARPO' AND last_name = 'WILLIAMS');

/*   Part 5 - Creating tables */
-- Recreate the table "address" 
CREATE TABLE IF NOT EXISTS address (
address_id INT AUTO_INCREMENT,
address VARCHAR(50),
address2 VARCHAR(50),
district VARCHAR(20),
city_id INT AUTO_INCREMENT,
postal_code VARCHAR(10),
phone VARCHAR(20),
location GEOMETRY,
last_update TIMESTAMP
)

/*  Part 6 - Joins    */
-- Use joins to show the first name, last name, and address of each staff member
SELECT first_name, last_name, address
FROM address
INNER JOIN staff ON staff.address_id = address.address_id;

-- Use joins to display the total amount each staff member rung up
SELECT first_name, last_name, amount
FROM staff
INNER JOIN payment ON staff.staff_id = payment.staff_id;

-- List the number of movies each actor has acted in
SELECT title, COUNT(actor_id)
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY title;

-- Display the number of movies named "Hunchback Impossible" exist
SELECT title, count(inventory_id)
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
WHERE title = "Hunchback Impossible"
GROUP BY title;

-- Display total amount of money each customer spent
SELECT first_name, last_name, SUM(amount)
FROM payment
INNER JOIN customer ON payment.customer_id = customer.customer_id
GROUP BY last_name;

/* Part 7. Sub Queries
The bellow code shows how to make sub queries using both WHERE clauses and 
INNER JOIN statements.  This allows us to connect all sorts of tables together
with the use of the primary key or id.  
*/
-- Display all of the movies that begin with K and Q and are in
-- english
SELECT title
FROM film
WHERE title LIKE 'K%' OR title LIKE 'Q%'
AND language_id IN(	SELECT language_id
					FROM language
					WHERE name = 'English');

-- Display the actors who performed in the movie Alone Trip
SELECT first_name, last_name
FROM actor
WHERE actor_id IN(SELECT actor_id
				FROM film
				WHERE title = 'Alone Trip');
                
-- Display all customers from Canada
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN(SELECT address.address_id
				  FROM address
                  INNER JOIN city ON address.city_id = city.city_id
                  INNER JOIN country ON city.country_id = country.country_id
				  WHERE country = 'Canada');

-- Display the movies in the category Family
SELECT title
FROM film
WHERE film_id IN(SELECT film_id
				  FROM film_category
                  INNER JOIN category ON film_category.category_id = category.category_id
				  WHERE name = "Family");
                  
-- Most frequently rented movies in decending order
SELECT title, COUNT(ren.film_id) AS CNT
FROM film
INNER JOIN(SELECT film_id 
		   FROM inventory
		   INNER JOIN rental on inventory.inventory_id = rental.inventory_id) ren
ON ren.film_id = film.film_id
GROUP BY title
ORDER BY CNT DESC;

-- Display the total sales from each store
SELECT store.store_id, SUM(sales.amount)
FROM store
INNER JOIN(SELECT amount, store_id
		   FROM staff
		   INNER JOIN payment ON staff.staff_id = payment.staff_id) sales
ON sales.store_id = store.store_id
GROUP BY store.store_id;

--  display the store_id, city, and country for each store
SELECT store_id, location.city, location.country
FROM store
INNER JOIN(SELECT city, country, address_id
		   FROM address
		   INNER JOIN city ON address.city_id = city.city_id
           INNER JOIN country ON city.country_id = country.country_id) location            
ON location.address_id = store.address_id
GROUP BY store_id;

-- Display the top 5 most profitable genres
SELECT name, SUM(genre_sales.amount) AS tot
FROM category
INNER JOIN(SELECT amount, category_id
		   FROM film_category
		   INNER JOIN inventory ON film_category.film_id = inventory.film_id
           INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
           INNER JOIN payment ON rental.customer_id = payment.customer_id) genre_sales            
ON genre_sales.category_id = category.category_id
GROUP BY name
ORDER BY tot DESC
LIMIT 5;

/*  Part 8 - Creating views */
-- Create a view table querried in the previous part 
CREATE VIEW vw_gross_revenue AS 
SELECT name, SUM(genre_sales.amount) AS tot
FROM category
INNER JOIN(SELECT amount, category_id
		   FROM film_category
		   INNER JOIN inventory ON film_category.film_id = inventory.film_id
           INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
           INNER JOIN payment ON rental.customer_id = payment.customer_id) genre_sales            
ON genre_sales.category_id = category.category_id
GROUP BY name
ORDER BY tot DESC
LIMIT 5;

-- Display the view
SELECT * FROM vw_gross_revenue;

-- Delete the view
DROP VIEW IF EXISTS vw_gross_revenue;







