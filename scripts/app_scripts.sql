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
ORDER BY app_count DESC
	
--UNION TABLES: converted price to money so tables could union together
SELECT name, rating, genres, install_count, MONEY(price)
FROM play_store_apps
UNION  ALL
SELECT name, rating, primary_genre, review_count, MONEY(price)
FROM app_store_apps
ORDER BY name, genres DESC


--life expectancy??
SELECT rating, (rating)
FROM play_store_apps



--trying to group together money for purchase price
SELECT name, genres, MONEY(price),
	CASE WHEN MONEY(price) BETWEEN 0 AND 1
	THEN '$10,000' END AS app_return
FROM play_store_apps
UNION 
SELECT name, primary_genre, MONEY(price)
FROM app_store_apps