SELECT *
FROM app_store_apps 

SELECT * 
FROM play_store_apps
--change price and review_count columns data type.
SELECT name, rating, primary_genre, review_count::integer, MONEY(price)
FROM app_store_apps
UNION 
SELECT name, rating, genres, review_count, MONEY(price)
FROM play_store_apps 
--look for apps in both stores
SELECT apple.name, apple.rating, MONEY(apple.price) As apple_money, MONEY(play.price) AS play_money
FROM play_store_apps AS play
INNER JOIN app_store_apps AS apple
ON play.name = apple.name
--calculate the cost
-- Since monthly revenue is fixed, we need to calculate the lifespan of the app.(star rating *2)+1
-- create  new columns for Revenu and Lifespan of apple store
SELECT apple.name, 
		apple.price::Money AS apple_price,
		apple.rating AS apple_rating,
		(apple.rating + 1)* (5000 * 12) AS apple_revenue,
		(apple.rating * 2)+1 AS apple_years
FROM app_store_apps AS apple
ORDER BY apple_rating DESC


SELECT play.name, 
		play.price::Money AS play_price,
		play.rating AS play_rating,
		(play.rating + 1)* (5000 * 12) AS play_revenue,
		(play.rating * 2)+1 AS play_years
FROM play_store_apps AS play
WHERE play.rating IS NOT NULL 
ORDER BY play_rating DESC