SELECT * FROM public.app_store_apps LIMIT 10
SELECT DISTINCT price FROM public.play_store_apps ORDER BY price DESC

UPDATE public.play_store_apps
SET price = REPLACE(price, '$', '')

SELECT name, COUNT(name) FROM public.play_store_apps
GROUP BY name 
HAVING COUNT(name) > 1
ORDER BY count DESC

SELECT DISTINCT name, size_bytes, CAST(price AS MONEY), CAST(review_count AS INTEGER), rating, content_rating AS age, primary_genre
FROM public.app_store_apps
WHERE rating > 4.0
	AND price <=1.00
UNION ALL
SELECT DISTINCT name, size, MONEY(price), review_count, rating, content_rating, genres
FROM public.play_store_apps
WHERE rating > 4.0
	AND MONEY(price) <='$1.00'
ORDER BY MONEY(price) DESC