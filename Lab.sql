-- 1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
SELECT 
min(length) as max_duration,
max(length) as min_duration
FROM sakila.film;
-- 1.2. Express the average movie duration in hours and minutes. Don't use decimals. Hint: look for floor and round functions.
SELECT 
ceil(AVG(length/60)) as duration_in_hours
FROM sakila.film;
 
-- We need to use SQL to help us gain insights into our business operations related to rental dates:

-- 2.1 Calculate the number of days that the company has been operating. Hint: To do this, use the rental table, and the DATEDIFF() function to subtract the earliest date in the rental_date column from the latest date.
SELECT 
min(rental_date) as mindate,
max(rental_date) as maxdate
FROM sakila.rental;

SELECT 
datediff(year, min(rental_date), max(return_date)) as days
FROM sakila.rental;


-- 2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.
SELECT rental_id, rental_date, date_format(rental_date, '%M') as 'month', dayofweek(rental_date) as 'day'
FROM sakila.rental;


-- 2.3 Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week. Hint: use a conditional expression
SELECT rental_id, rental_date, dayofweek(rental_date) as 'day',
CASE 
WHEN dayofweek(rental_date) = '1' then 'workday'
WHEN dayofweek(rental_date) = '2' then 'workday'
WHEN dayofweek(rental_date) = '3' then 'workday'
WHEN dayofweek(rental_date) = '4' then 'workday'
WHEN dayofweek(rental_date) = '5' then 'workday'
WHEN dayofweek(rental_date) = '6' then 'WEEKEND'
WHEN dayofweek(rental_date) = '7' then 'WEEKEND'
ELSE 'NO DAY'
END AS 'DAY_TYPE'
FROM sakila.rental;



-- 3.We need to ensure that our customers can easily access information about our movie collection. To achieve this, retrieve the film titles and their rental duration.
-- If any rental duration value is NULL, replace it with the string 'Not Available'. Sort the results by the film title in ascending order.
-- Please note that even if there are currently no null values in the rental duration column, the query should still be written to handle such cases in the future
SELECT title, rental_duration,
CASE
WHEN rental_duration is null and rental_duration = ' ' then 'Not Available'
ELSE 'Available'
END AS 'STATUS'
FROM sakila.film
ORDER BY title desc;

 

-- 4. As a marketing team for a movie rental company, we need to create a personalized email campaign for our customers. 
-- To achieve this, we want to retrieve the concatenated first and last names of our customers, along with the first 3 characters of their email address, so that we can address them by their first name and use their email address to send personalized recommendations
 -- The results should be ordered by last name in ascending order to make it easier for us to use the data
SELECT first_name, last_name, CONCAT(first_name,' ' ,last_name, substring(email,1,3)) AS Concatenated_names
FROM sakila.customer
ORDER BY last_name asc;

-- Challenge 2
-- We need to analyze the films in our collection to gain insights into our business operations. Using the film table, determine:
-- 1.1 The total number of films that have been released.
SELECT count(distinct(title)) FROM sakila.film;

-- 1.2 The number of films for each rating.
SELECT count(title) as number_of_titles, rating FROM sakila.film
GROUP BY rating;

SELECT count(distinct(rating)) FROM sakila.film;


-- 1.3 The number of films for each rating, and sort the results in descending order of the number of films. This will help us better understand the popularity of different film ratings and adjust our purchasing decisions accordingly.
SELECT count(title) as number_of_titles, rating FROM sakila.film
GROUP BY rating
ORDER BY number_of_titles desc;

-- 2. We need to track the performance of our employees. Using the rental table, determine the number of rentals processed by each employee. This will help us identify our top-performing employees and areas where additional training may be necessary.
SELECT count(staff_id) as number_of_rentals, staff_id FROM sakila.rental
GROUP BY staff_id;

-- 3.Using the film table, determine:
-- 3.1 The mean film duration for each rating, and sort the results in descending order of the mean duration. Round off the average lengths to two decimal places. This will help us identify popular movie lengths for each category.
SELECT round(AVG(length),2) as duration, rating FROM sakila.film
GROUP BY rating
ORDER BY duration desc;
-- 3.2 Identify which ratings have a mean duration of over two hours, to help us select films for customers who prefer longer movies.
SELECT round(AVG(length),2) as duration, rating FROM sakila.film
GROUP BY rating
HAVING duration > 120;
-- 4.Determine which last names are not repeated in the table actor.
SELECT count(last_name) as count, last_name FROM sakila.actor
group by last_name
HAVING count = 1;
