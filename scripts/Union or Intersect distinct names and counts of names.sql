SELECT name, COUNT(name) FROM public.app_store_apps 
GROUP BY name 
UNION
SELECT name, COUNT(name) FROM public.play_store_apps
GROUP BY name 
ORDER BY count DESC


SELECT DISTINCT name FROM public.play_store_apps
UNION
SELECT DISTINCT name FROM public.app_store_apps 

