-- Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
USE sakila;

SELECT COUNT(*) AS 'count of copies'
FROM sakila.inventory i
JOIN sakila.film f ON f.film_id = i.film_id
WHERE f.title = "Hunchback Impossible";

-- List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT AVG(length) AS "duration film in min"
FROM sakila.film f;

SELECT * FROM sakila.film
WHERE length > (SELECT AVG(length) FROM sakila.film);

-- Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT first_name, last_name
FROM sakila.actor 
WHERE actor_id IN (
	SELECT actor_id
    FROM sakila.film_actor
    WHERE film_id = (SELECT film_id FROM sakila.film WHERE title = "Alone Trip"
));

-- Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.

SELECT title AS "family films"
FROM sakila.film
WHERE film_id IN (
	SELECT film_id
    FROM sakila.film_category
    WHERE category_id = (SELECT category_id FROM sakila.category WHERE name = "Family"));

-- Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
-- JOIN
SELECT first_name, last_name, email
FROM sakila.customer c
JOIN sakila.address a ON c.address_id = a.address_id
JOIN sakila.city ct ON a.city_id = ct.city_id
JOIN sakila.country ctr ON ct.country_id = ctr.country_id
WHERE ctr.country = "Canada";

-- Subquery
SELECT first_name, last_name, email
FROM sakila.customer c
WHERE address_id IN (
	SELECT address_id
    FROM sakila.address 
    WHERE city_id IN (
    SELECT city_id
    FROM sakila.city
    WHERE country_id = (SELECT country_id FROm sakila.country WHERE country = "Canada")));

-- Determine which films were starred by the most prolific actor in the Sakila database.
SELECT f.title, a.first_name, a.last_name
FROM sakila.film f
JOIN sakila.film_actor fa ON f.film_id = fa.film_id
JOIN sakila.actor a ON fa.actor_id = a.actor_id
WHERE a.actor_id = (
	SELECT actor_id
    FROM sakila.film_actor
    GROUP BY actor_id
    ORDER by COUNT(*) DESC
    LIMIT 1
);

-- Find the films rented by the most profitable customer in the Sakila database.
-- You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE c.customer_id = (
	SELECT p.customer_id
	FROM payment p
	GROUP BY customer_id
	ORDER BY SUM(p.amount) DESC
	LIMIT 1
);


-- Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.
SELECT customer_id AS "client_id", SUM(amount) AS "total_amount_spend"
FROM payment p
GROUP BY p.customer_id
HAVING total_amount_spend > (
	SELECT ROUND(AVG(amount),2) AS "average_amount"
	FROM payment
);