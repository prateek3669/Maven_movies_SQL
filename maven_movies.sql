-- 1. Obtain staff's first and last names, email addresses, and the store identification number where they work.
SELECT
	first_name,
    last_name,
    email,
    address_id
FROM staff;

-- 2. Conduct separate counts of inventory items held at each of the two stores.
SELECT s.store_id, COUNT(inventory_id) AS total_items
FROM store s
JOIN inventory i
ON s.store_id = i.store_id
GROUP BY 1;

-- 3. Provide a count of active customers for each of the stores, separately.
SELECT s.store_id, COUNT(*) AS customer_count
FROM store s
JOIN customer c
ON s.store_id = c.store_id
WHERE active = 1
GROUP BY 1;

-- 4. Determine the count of all customer email addresses stored in the database, to assess the liability of a potential data breach.
SELECT store_id, COUNT(email) AS email_count
FROM customer;

-- 5. Analyze the diversity of the film offerings to understand the likelihood of keeping customers engaged.
-- Provide a count of unique film titles and categories available at each store.

SELECT store_id, COUNT(DISTINCT film_id) AS film_id_count
FROM inventory
GROUP BY 1;

-- 6. Determine the replacement cost of films by providing the replacement cost for the least expensive, most expensive, and the average of all films carried.
SELECT 
    MIN(replacement_cost),
    MAX(replacement_cost),
    AVG(replacement_cost)
FROM film;

-- 7. Implement payment monitoring systems and maximum payment processing restrictions to minimize the future risk of fraud by staff.
-- Provide the average and maximum payment processed.

SELECT
    AVG(amount) AS avg_amount,
    MAX(amount) AS max_amount
FROM payment;

-- 8. Obtain a better understanding of the customer base by providing a list of all customer identification values with a count of rentals they have made all-time,
-- with the highest volume customers listed at the top.

SELECT
    c.customer_id, 
    COUNT(r.customer_id) AS rental_count
FROM customer c
JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY 1
ORDER BY 2 DESC;

-- 9. My partner and I want to come by each of the stores in person and meet the managers. Please send over the managers’ names at each store, with the full address 
-- of each property (street address, district, city, and country please).  

SELECT
	first_name,
    last_name,
    address,
    district,
    city,
    country
FROM store
JOIN staff ON store.manager_staff_id = staff.staff_id
JOIN address ON address.address_id = store.address_id
JOIN city ON city.city_id = address.city_id
JOIN country ON country.country_id = city.country_id;

-- 10.	I would like to get a better understanding of all of the inventory that would come along with the business. 
-- Please pull together a list of each inventory item you have stocked, including the store_id number, 
-- the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 

SELECT
	store_id,
    inventory_id,
    title,
    rating,
    rental_rate,
    replacement_cost
FROM inventory i
JOIN film f
ON i.film_id = f.film_id;
 
 -- 11.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
-- of your inventory. We would like to know how many inventory items you have with each rating at each store. 

SELECT
    rating,
	store_id,
    COUNT(inventory_id) AS inventory_count
FROM inventory i
JOIN film f
ON i.film_id = f.film_id
GROUP BY 1,2;

-- 12. Similarly, we want to understand how diversified the inventory is in terms of replacement cost.
-- We want to see how big of a hit it would be if a certain category of film became unpopular at a certain store.
-- We would like to see the number of films, as well as the average replacement cost, and total replacement cost, sliced by store and film category. 

SELECT
	store_id,
    c.name,
    COUNT(i.film_id) AS total_count,
    AVG(replacement_cost) AS avg_replacement_cost,
    SUM(replacement_cost) AS total_replacement_cost
FROM inventory i
JOIN  film f
ON i.film_id = f.film_id
JOIN film_category fc
ON fc.film_id = f.film_id
JOIN category c
ON fc.category_id = c.category_id
GROUP BY 1,2
ORDER BY 3 DESC;

-- 13.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
-- of all customer names, which store they go to, whether or not they are currently active, 
-- and their full addresses – street address, city, and country. 

SELECT
	first_name,
    last_name,
    store_id,
    active,
	address,
    city,
    country
FROM customer c
JOIN address a
ON c.address_id = a.address_id
JOIN city
ON city.city_id = a.city_id
JOIN country
ON country.country_id = city.country_id;

-- 14.	We would like to understand how much your customers are spending with you, and also to know 
-- who your most valuable customers are. Please pull together a list of customer names, their total 
-- lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
-- see this ordered on total lifetime value, with the most valuable customers at the top of the list. 

SELECT
	first_name,
    last_name,
    COUNT(r.customer_id) AS total_rentals,
    SUM(amount) AS total_payment
FROM customer c
JOIN rental r
ON c.customer_id = r.customer_id
JOIN payment p
ON p.rental_id = r.rental_id
GROUP BY 1,2
ORDER BY 3 DESC;

-- 15. My partner and I would like to get to know your board of advisors and any current investors.
-- Could you please provide a list of advisor and investor names in one table? 
-- Could you please note whether they are an investor or an advisor, and for the investors, 
-- it would be good to include which company they work with. 

SELECT
	first_name,
    last_name,
    'Advisor' AS profession,
    'N/A' AS company
FROM advisor
UNION
SELECT 
	first_name,
    last_name,
    'Investor',
    company_name
FROM investor;