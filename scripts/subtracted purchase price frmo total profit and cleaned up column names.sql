

SELECT sub.name, ROUND(AVG(sub.rating), 1) AS avg_rating, size_bytes, CAST(sub.price AS MONEY), install_count, CAST(sub.review_count AS INTEGER), sub.rating, age, primary_genre, ROUND(longevity, 0) AS years_of_longevity, MONEY(longevity*9000*12)-sub.purchase_price AS total_profit
FROM (SELECT name, ROUND(AVG(rating), 1) AS avg_rating, size_bytes, CAST(price AS MONEY), CAST(review_count AS INTEGER), rating, age, primary_genre, purchase_price,
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
	AND CAST(review_count AS INTEGER)>=500
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
 	AND review_count >= 500
GROUP BY name, size, MONEY(price), review_count, content_rating, genres, purchase_price, rating)
GROUP BY name, size_bytes, CAST(price AS MONEY), CAST(review_count AS INTEGER), rating, age, primary_genre, purchase_price) AS sub
INNER JOIN play_store_apps
USING(name)
GROUP BY sub.name, size_bytes, CAST(sub.price AS MONEY), install_count, CAST(sub.review_count AS INTEGER), sub.rating, age, primary_genre, purchase_price, longevity, total_profit
ORDER BY total_profit DESC;

