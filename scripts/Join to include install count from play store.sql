--add cost, yearly_revenue, longevity, and avg_rating
--cost is price*10,000
--revenue yearly = profit-ad costs (9000*12)
--longevity assumes that for every half point that an app gains in rating, its projected lifespan increases by one year. In other words, an app with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years, and an app with a rating of 4.0 can be expected to last 9 years. 
--App store ratings should be calculated by taking the average of the scores from both app stores and rounding to the nearest 0.5.

-- rating	lifespan
-- 0
-- 0.5		2
-- 1		3
-- 1.5		4
-- 2		5
-- 2.5		6
-- 3		7
-- 3.5		8
-- 4		9
-- 4.5		10
-- 5		11

-- CASE 
-- 	WHEN ROUND(AVG(rating)) < 0.49
-- 	THEN 1 
-- 	ELSE ROUND(AVG(rating))/0.50+1
-- 	END AS longevity

SELECT sub.name, ROUND(AVG(sub.rating), 1) AS avg_rating, size_bytes, CAST(sub.price AS MONEY), install_count, CAST(sub.review_count AS INTEGER), sub.rating, age, primary_genre, longevity, MONEY(longevity*9000*12)-sub.purchase_price AS total_profit
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

