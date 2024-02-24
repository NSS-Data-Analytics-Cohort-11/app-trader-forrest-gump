SELECT *
FROM app_store_apps;

SELECT *
FROM play_store_apps;



--start of combining both tables together
SELECT name, primary_genre
FROM app_store_apps AS apps
UNION ALL
SELECT name, genres 
FROM play_store_apps AS games;


--Genre counts
SELECT app.primary_genre, COUNT(app.primary_genre) AS app_count
	FROM app_store_apps AS app
	GROUP BY primary_genre 
UNION 
SELECT play.genres, COUNT(play.genres)
	FROM play_store_apps AS play
	GROUP BY play.genres 
ORDER BY app_count DESC;


--**Successful tables**--
--UNION TABLES: converted price to money so tables could union together
SELECT name, rating, category, install_count, MONEY(price)
FROM play_store_apps
UNION  ALL
SELECT name, rating, primary_genre, review_count, MONEY(price)
FROM app_store_apps
ORDER BY name, category DESC;


--*******UNION TABLES: 2a.) Calculated app purchase price. Distinguished which apps are on which store.. can we use this in a FROM subquery later on?
SELECT name AS app_name, genres, MONEY(price), rating, 'play_store' AS app,
	CASE WHEN MONEY(price) BETWEEN '$0' AND '$1'
	THEN '$10,000'
	ELSE MONEY(price)*10000
	END AS app_purchase_price
FROM play_store_apps
UNION All
SELECT name AS app_name, primary_genre, MONEY(price), rating, 'app_store' AS app,
	CASE WHEN MONEY(price) BETWEEN '$0' AND '$1'
	THEN '$10,000'
	ELSE MONEY(price)*10000
	END AS app_purchase_price
FROM app_store_apps
ORDER BY app_purchase_price DESC;
-----



--trying to find which apps are on both app stores
SELECT app_name, app
FROM
		(SELECT name AS app_name, genres, MONEY(price), 'play_store' AS app,
		CASE WHEN MONEY(price) BETWEEN '$0' AND '$1'
		THEN '$10,000'
		ELSE MONEY(price)*10000
		END AS app_purchase_price
		FROM play_store_apps
		UNION All
		SELECT name AS app_name, primary_genre, MONEY(price), 'app_store' AS app,
		CASE WHEN MONEY(price) BETWEEN '$0' AND '$1'
		THEN '$10,000'
		ELSE MONEY(price)*10000
		END AS app_purchase_price
		FROM app_store_apps) AS sub
GROUP BY app_name;




--life expectancy..long way to use it. DONT use it lol
SELECT name AS app_name, rating,
	CASE WHEN rating BETWEEN 0 AND 0.4 THEN 1
	WHEN rating BETWEEN 0.5 AND 0.9 THEN 2
	WHEN rating BETWEEN 1 AND 1.4 THEN 3
	WHEN rating BETWEEN 1.5 AND 1.9 THEN 4
	WHEN rating BETWEEN 2 AND 2.4 THEN 5
	WHEN rating BETWEEN 2.5 AND 2.9 THEN 6
	WHEN rating BETWEEN 3 AND 3.4 THEN 7
	WHEN rating BETWEEN 3.5 AND 3.9 THEN 8
	WHEN rating BETWEEN 4 AND 4.4 THEN 9
	WHEN rating BETWEEN 4.5 AND 4.9 THEN 10
	WHEN rating = 5 THEN 11
	END AS life_expectency
FROM play_store_apps
WHERE rating IS NOT NULL
UNION All
SELECT name AS app_name,  rating,
CASE WHEN rating BETWEEN 0 AND 0.4 THEN 1
	WHEN rating BETWEEN 0.5 AND 0.9 THEN 2
	WHEN rating BETWEEN 1 AND 1.4 THEN 3
	WHEN rating BETWEEN 1.5 AND 1.9 THEN 4
	WHEN rating BETWEEN 2 AND 2.4 THEN 5
	WHEN rating BETWEEN 2.5 AND 2.9 THEN 6
	WHEN rating BETWEEN 3 AND 3.4 THEN 7
	WHEN rating BETWEEN 3.5 AND 3.9 THEN 8
	WHEN rating BETWEEN 4 AND 4.4 THEN 9
	WHEN rating BETWEEN 4.5 AND 4.9 THEN 10
	WHEN rating = 5 THEN 11
	END AS life_expectency
FROM app_store_apps
WHERE rating IS NOT NULL
ORDER BY rating DESC;


--life expectancy
SELECT app_name, app_purchase_price, ROUND(AVG(rating), 1) AS avg_rating,
CASE
	WHEN ROUND(AVG(rating)) < 0.49
	THEN 1
	ELSE ROUND(AVG(rating))/0.50+1
	END AS longevity
FROM
	(SELECT name AS app_name, genres, MONEY(price), rating, 'play_store' AS app,
		CASE WHEN MONEY(price) BETWEEN '$0' AND '$1'
		THEN '$10,000'
		ELSE MONEY(price)*10000
		END AS app_purchase_price
	FROM play_store_apps
	WHERE rating IS NOT NULL
	UNION
	SELECT name AS app_name, primary_genre, MONEY(price), rating, 'app_store' AS app,
		CASE WHEN MONEY(price) BETWEEN '$0' AND '$1'
		THEN '$10,000'
		ELSE MONEY(price)*10000
		END AS app_purchase_price
	FROM app_store_apps
	WHERE rating IS NOT NULL)
GROUP BY app_name, app_purchase_price
ORDER BY avg_rating DESC;
---
SELECT *
FROM app_store_apps;

SELECT *
FROM play_store_apps;

--Marketing price per year... failed 
SELECT sub.app_name, sub.genres, sub.age, ROUND(AVG(sub.avg_rating),1) AS avg_rating, sub.app_purchase_price, ROUND(sub.longevity,0), sub.marketing_fee_per_year
FROM
	(SELECT app_name, genres, age, app_purchase_price, ROUND(AVG(rating), 1) AS avg_rating,
		CASE WHEN ROUND(AVG(rating)) < 0.49
			THEN 1
			ELSE ROUND(AVG(rating))/0.50+1
			END AS longevity,
		MONEY(9000)*12 AS marketing_fee_per_year
	FROM
		(SELECT name AS app_name, genres, MONEY(price),rating, content_rating AS age, 'play_store' AS app,
			CASE WHEN MONEY(price) BETWEEN '$0' AND '$1'
			THEN '$10,000'
			ELSE MONEY(price)*10000
			END AS app_purchase_price
		FROM play_store_apps
		WHERE rating IS NOT NULL
		UNION
		SELECT name AS app_name, primary_genre, MONEY(price), rating, content_rating, 'app_store' AS app,
			CASE WHEN MONEY(price) BETWEEN '$0' AND '$1'
			THEN '$10,000'
			ELSE MONEY(price)*10000
			END AS app_purchase_price
		FROM app_store_apps
		WHERE rating IS NOT NULL
		GROUP BY app_name, app_purchase_price, content_rating, primary_genre, MONEY(price), rating)
	GROUP BY sub.app_name, sub.genres, sub.age, sub.app_purchase_price) AS sub
		
	
	
	 
	 
	 
--Final Query for analysis
SELECT sub.name, primary_genre, ROUND(AVG(sub.rating), 1) AS avg_rating, size_bytes, CAST(sub.price AS MONEY), install_count, CAST(sub.review_count AS INTEGER), sub.rating, age, ROUND(longevity, 0) AS years_of_viability, MONEY(longevity*9000*12)-sub.purchase_price AS total_profit
FROM
	(SELECT name, ROUND(AVG(rating), 1) AS avg_rating, size_bytes, CAST(price AS MONEY), CAST(review_count AS INTEGER), rating, age, primary_genre, purchase_price,
	CASE
		WHEN ROUND(AVG(rating)) <= 0.49
		THEN 1
		ELSE ROUND(AVG(rating))/0.50+1
		END AS longevity
	FROM
		(SELECT name, size_bytes, CAST(price AS MONEY), CAST(review_count AS INTEGER), rating, content_rating AS age, primary_genre,
		CASE WHEN MONEY(price) BETWEEN '$0' AND '$1'
			THEN '$10,000'
			ELSE MONEY(price)*10000
			END AS purchase_price
		FROM public.app_store_apps
		WHERE price <=1.00
			AND rating IS NOT NULL
		 AND rating >= 4.5
			AND CAST(review_count AS INTEGER)>= 10000
		GROUP BY name, size_bytes, CAST(price AS MONEY), CAST(review_count AS INTEGER), age, primary_genre, purchase_price, rating
		UNION
		SELECT name, size, MONEY(price), review_count, rating, content_rating, genres,
		CASE WHEN MONEY(price) BETWEEN '$0' AND '$1'
			THEN '$10,000'
			ELSE MONEY(price)*10000
			END AS purchase_price
		FROM public.play_store_apps
		WHERE MONEY(price) <='$1.00'
			AND rating IS NOT NULL
		 AND rating >= 4.5
			AND review_count >= 10000
		GROUP BY name, size, MONEY(price), review_count, content_rating, genres, purchase_price, rating)
	GROUP BY name, size_bytes, CAST(price AS MONEY), CAST(review_count AS INTEGER), rating, age, primary_genre, purchase_price) AS sub
INNER JOIN play_store_apps
USING(name)
WHERE install_count IS NOT NULL
GROUP BY sub.name, primary_genre, size_bytes, CAST(sub.price AS MONEY), install_count, CAST(sub.review_count AS INTEGER), sub.rating, age, purchase_price, longevity, total_profit
ORDER BY total_profit DESC, install_count --review_count DESC;
	 
	 
