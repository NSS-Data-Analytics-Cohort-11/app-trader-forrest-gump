SELECT name, install_count, cost

FROM

(select name, rating, category,install_count, MONEY(PRICE) AS cost from 
play_store_apps
union
select name, rating, primary_genre, review_count, MONEY(PRICE) AS cost from app_store_apps
Order by name, category desc)
ORDER BY cost


--Lifespan of App
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








--Purchase Price and Longevity
SELECT app_name, app_purchase_price, ROUND(AVG(rating), 1) AS avg_rating,(longevity*12000) as marketing
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




select name,rating
play_store_apps
 order by rating desc



select * from play_store_apps order by name
app_store_apps	


-- select * from play_store_dup
-- create table play_store_dup AS table play_store_apps

-- ALTER TABLE play_store_dup
-- ALTER COLUMN price TYPE numeric(5,2) USING price::numeric


