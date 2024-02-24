SELECT *
FROM app_store_apps 

SELECT * 
FROM play_store_apps
--change price and review_count columns data type.



---SELECT name, genres, MONEY(price),
	--CASE WHEN MONEY(price) BETWEEN '$0' AND '$1'
	--THEN '$10,000'
	--ELSE MONEY(price)*10000

--Combine the two tables using UNION
SELECT name, rating, primary_genre, review_count::integer, MONEY(price)
FROM app_store_apps
UNION 
SELECT name, rating, genres, review_count, MONEY(price)
FROM play_store_apps 

--TRY TO GET LIFESPAN "don't use it"
select
		name, ROUND(AVG(rating),1) AS average_rating,
			ROUND(avg(rating)*2, 0) AS lifespan
from			
		(SELECT name, rating, primary_genre, review_count::integer, MONEY(price)
FROM app_store_apps
UNION 
SELECT name, rating, genres, review_count, MONEY(price)
FROM play_store_apps ) as sub
group by name
--order by average_rating





--calculate the cost
-- Since monthly revenue is fixed, we need to calculate the lifespan of the app.(star rating *2)+1
-- create  new columns for Revenu and Lifespan of apple store

--TRYING TO CALCULATE REVENU (Don't use it, calculate the lifespan first)
SELECT apple.name, 
		apple.price::Money AS apple_price,
		apple.rating AS apple_rating,
		(apple.rating + 1)* (5000 * 12) AS apple_revenue,
		(apple.rating * 2)+1 AS apple_years
FROM app_store_apps AS apple
--WHERE (apple.rating + 1)* (5000 * 12) IS NOT NULL
--WHERE  apple.name ilike '%roblox%'
--ORDER BY apple_rating DESC
UNION ALL
SELECT play.name, 
		play.price::Money AS play_price,
		play.rating AS play_rating,
		(play.rating + 1)* (5000 * 12) AS play_revenue,
		(play.rating * 2)+1 AS play_years
FROM play_store_apps AS play
WHERE (play.rating + 1)* (5000 * 12) IS NOT NULL
ORDER BY apple_revenue DESC

-- Calculating purchase price:
SELECT name AS app_name, genres, MONEY(price), rating, 'play_store' AS app,
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
	ORDER BY app_purchase_price
	
	
	

--look for apps in both stores
SELECT apple.name, apple.rating, MONEY(apple.price) As apple_money, MONEY(play.price) AS play_money
FROM play_store_apps AS play
INNER JOIN app_store_apps AS apple
ON play.name = apple.name


--try to find which apps are in both tables from purchase query
SELECT app_name, app
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
	FROM app_store_apps) AS sub
	ORDER BY app_purchase_price


---Longevity/lifespan
SELECT name, ROUND(AVG(rating), 1) AS avg_rating,
CASE
	WHEN ROUND(AVG(rating)) < 0.49
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
	AND CAST(review_count AS INTEGER)>500
GROUP BY name, size_bytes, CAST(price AS MONEY), CAST(review_count AS INTEGER), age, primary_genre, purchase_price, rating
HAVING AVG(rating) > 4.0
UNION
SELECT name, size, MONEY(price), review_count, rating, content_rating, genres,
CASE WHEN MONEY(price) BETWEEN '$0' AND '$1'
	THEN '$10,000'
	ELSE MONEY(price)*10000
	END AS purchase_price
FROM public.play_store_apps
WHERE MONEY(price) <='$1.00'
	AND review_count>500
GROUP BY name, size, MONEY(price), review_count, content_rating, genres, purchase_price, rating
HAVING AVG(rating) > 4.0)
GROUP BY name



--WHERE  play.name ilike '%roblox%'
--ORDER BY play.name DESC
--ORDER BY play_rating DESC

--Average rating
SELECT name, ROUND(AVG(rating), 1) AS avg_rating, size_bytes, CAST(price AS MONEY), CAST(review_count AS INTEGER), rating, age, primary_genre,
CASE
	WHEN ROUND(AVG(rating)) < 0.49
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
	AND CAST(review_count AS INTEGER)>500
GROUP BY name, size_bytes, CAST(price AS MONEY), CAST(review_count AS INTEGER), age, primary_genre, purchase_price, rating
HAVING AVG(rating) > 4.0
UNION
SELECT name, size, MONEY(price), review_count, rating, content_rating, genres,
CASE WHEN MONEY(price) BETWEEN '$0' AND '$1'
	THEN '$10,000'
	ELSE MONEY(price)*10000
	END AS purchase_price
FROM public.play_store_apps
WHERE MONEY(price) <='$1.00'
	AND review_count>500
GROUP BY name, size, MONEY(price), review_count, content_rating, genres, purchase_price, rating
HAVING AVG(rating) > 4.0)
GROUP BY name, size_bytes, CAST(price AS MONEY), CAST(review_count AS INTEGER), rating, age, primary_genre, purchase_price
ORDER BY avg_rating DESC; 
--***
--SQL to return: name, avg rating, longevity,  app_purchase_price
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




---figuring out profit

SELECT sub.name, primary_genre, ROUND(AVG(sub.rating), 1) AS avg_rating, size_bytes, CAST(sub.price AS MONEY), install_count, CAST(sub.review_count AS INTEGER), sub.rating, age,
ROUND(longevity, 0) AS years_of_viability, MONEY(longevity*9000*12)-sub.purchase_price AS total_profit
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
			AND rating IS NOT NULL AND rating >=4.5
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
			AND rating IS NOT NULL AND rating >=4.5
			AND review_count >= 10000
		GROUP BY name, size, MONEY(price), review_count, content_rating, genres, purchase_price, rating)
	GROUP BY name, size_bytes, CAST(price AS MONEY), CAST(review_count AS INTEGER), rating, age, primary_genre, purchase_price) AS sub
INNER JOIN play_store_apps
USING(name)
WHERE install_count IS NOT NULL 
GROUP BY sub.name, primary_genre, size_bytes, CAST(sub.price AS MONEY), install_count, CAST(sub.review_count AS INTEGER), sub.rating, age, purchase_price, longevity, total_profit
ORDER BY total_profit DESC, install_count --DESC; --avg_rating DESC, review_count DESC, 








