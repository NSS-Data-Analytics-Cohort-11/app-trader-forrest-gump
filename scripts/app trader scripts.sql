SELECT *
FROM app_store_apps
ORDER BY rating DESC


SELECT *
FROM play_store_apps
WHERE rating IS NOT NULL
ORDER BY rating DESC

--play store apps - categories are all caps

SELECT MONEY(price)
FROM play_store_apps
ORDER BY price DESC

--LIFESPAN
SELECT name AS app_name, rating, life_yrs * 5000,
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
	END AS life_yrs
	
FROM play_store_apps
WHERE rating IS NOT NULL


--calculating purchase price
WITH merge AS (SELECT app_store_apps.name
FROM app_store_apps
INNER JOIN play_store_apps
USING (name)
ORDER BY name), 

purchase AS
--SELECT purchase.name, purchase.rating, purchase.primary_genre, MONEY(purchase.price),
	(SELECT name, rating, primary_genre, MONEY(price),
		CASE WHEN MONEY(price) BETWEEN '$0' AND '$1'
			THEN '$10,000'
			ELSE MONEY(price)*10000
			END AS app_purchase_price
	FROM app_store_apps
	UNION 
	SELECT name, rating, category, MONEY(price), 
		CASE WHEN MONEY(price) BETWEEN '$0' AND '$1'
			THEN '$10,000'
			ELSE MONEY(price)*10000
			END AS app_purchase_price
	FROM play_store_apps)

SELECT merge.name 
FROM merge
UNION
purchase

SELECT purchase.name, purchase.rating, purchase.primary_genre, MONEY(purchase.price)
FROM purchase
ORDER BY merge.name, purchase.primary_genre DESC;


SELECT name, rating, primary_genre, MONEY(price),
-- 	CASE WHEN MONEY(price) BETWEEN '$0' AND '$1'
-- 	THEN '$10,000'
-- 	ELSE MONEY(price)*10000
-- 	END AS app_purchase_price
FROM app_store_apps
-- UNION ALL
-- SELECT name, rating, category, MONEY(price), 
-- 	CASE WHEN MONEY(price) BETWEEN '$0' AND '$1'
-- 	THEN '$10,000'
-- 	ELSE MONEY(price)*10000
-- 	END AS app_purchase_price
-- FROM play_store_apps
-- ORDER BY name, primary_genre DESC;

WITH merge AS (SELECT app_store_apps.name
FROM app_store_apps
INNER JOIN play_store_apps
USING (name)
ORDER BY name) 


--is currency the same?
-- SELECT DISTINCT(currency) 
-- FROM app_store_apps

-- SELECT DISTINCT(currency) 
-- FROM play_store_apps

-- SELECT DISTINCT primary_genre
-- FROM app_store_apps;


SELECT app_name, app_purchase_price, ROUND(AVG(rating), 1) AS avg_rating, 
	CASE
		WHEN ROUND(AVG(rating)) < 0.49
		THEN 1
		ELSE ROUND(AVG(rating))/0.50+1
		END AS longevity
--longevity *(MONEY (9000*12)) AS yearly_revenue

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
ORDER BY longevity;


--from Mel:
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
			AND review_count >= 10000
		GROUP BY name, size, MONEY(price), review_count, content_rating, genres, purchase_price, rating)
	GROUP BY name, size_bytes, CAST(price AS MONEY), CAST(review_count AS INTEGER), rating, age, primary_genre, purchase_price) AS sub
INNER JOIN play_store_apps
USING(name)
WHERE install_count IS NOT NULL
GROUP BY sub.name, primary_genre, size_bytes, CAST(sub.price AS MONEY), install_count, CAST(sub.review_count AS INTEGER), sub.rating, age, purchase_price, longevity, total_profit
ORDER BY total_profit DESC, avg_rating DESC, review_count DESC;