SELECT *
FROM app_store_apps

SELECT *
FROM play_store_apps
--play store apps - categories are all caps

SELECT MONEY(price)
FROM play_store_apps
ORDER BY price DESC


--calculating net profit
SELECT name, rating, primary_genre, MONEY(price) AS app_price, MONEY(price)*10000 AS purchase_price, 
	CASE WHEN MONEY(price) = '$0.00' THEN 1 --to convert 0 to 1
		END
FROM app_store_apps
UNION ALL
SELECT name, rating, category, MONEY(price), MONEY(price)*10000
CASE WHEN MONEY(price) = '$0.00' THEN 1 --to convert 0 to 1
		END
FROM play_store_apps
ORDER BY name, primary_genre DESC;



--is currency the same?
SELECT DISTINCT(currency) 
FROM app_store_apps

SELECT DISTINCT(currency) 
FROM play_store_apps

SELECT DISTINCT primary_genre
FROM app_store_apps;