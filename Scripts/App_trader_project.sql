SELECT *
FROM app_store_apps 

SELECT * 
FROM play_store_apps

SELECT name, rating, price, category, install_count, MONEY(Price) 
FROM  play_store_apps

UNION all
SELECT name,rating, primary_genre, review_count, MONEY(price)
FROM app_store_apps
WHERE name ilike 'snapchat'

SELECT name, rating, MONEY(price)
FROM app_store_apps
WHERE name  ilike 'snapchat'
UNION 
SELECT name, rating, MONEY(price)
FROM play_store_apps
WHERE name  ilike 'snapchat'
