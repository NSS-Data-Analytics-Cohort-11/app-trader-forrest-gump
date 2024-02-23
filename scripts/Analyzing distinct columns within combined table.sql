

SELECT DISTINCT name, size_bytes, CAST(price AS MONEY), CAST(review_count AS INTEGER), rating, content_rating AS age, primary_genre, 
CASE WHEN MONEY(price) BETWEEN '$0' AND '$1'
	THEN '$10,000'
	ELSE MONEY(price)*10000
	END AS app_purchase_price
FROM public.app_store_apps
WHERE rating > 4.0
	AND price <=1.00
	AND CAST(review_count AS INTEGER)>500
UNION ALL
SELECT DISTINCT name, size, MONEY(price), review_count, rating, content_rating, genres,
CASE WHEN MONEY(price) BETWEEN '$0' AND '$1'
	THEN '$10,000'
	ELSE MONEY(price)*10000
	END AS app_purchase_price
FROM public.play_store_apps
WHERE rating > 4.0
	AND MONEY(price) <='$1.00'
	AND review_count>500
ORDER BY rating DESC
