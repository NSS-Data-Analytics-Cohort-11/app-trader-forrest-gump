SELECT * FROM public.app_store_apps LIMIT 10
SELECT primary_genre, COUNT(primary_genre) FROM public.app_store_apps GROUP BY primary_genre
--23 primary genres in the apple app store
SELECT * FROM public.play_store_apps LIMIT 10
SELECT category, COUNT(category) FROM public.play_store_apps GROUP BY category
--33 categories in the google play store

SELECT primary_genre, COUNT(primary_genre) FROM public.app_store_apps GROUP BY primary_genre
UNION ALL
SELECT category, COUNT(category) FROM public.play_store_apps GROUP BY category
UNION ALL 
SELECT genres, COUNT(genres) FROM public.play_store_apps GROUP BY genres
ORDER BY count DESC

--56 total categories/genres, some overlap but not all. Same apps may not align with same category in different stores. Ex: an app under games in one store may be under education in the other store. Google play store has both categories and genres, which overlap in differnt ways.

