select name, rating, category,install_count, MONEY(PRICE) from 
play_store_apps
union all
select name, rating, primary_genre, review_count, MONEY(PRICE) from app_store_apps
Order by name, category desc




select * from play_store_apps order by name
app_store_apps	


-- select * from play_store_dup
-- create table play_store_dup AS table play_store_apps

-- ALTER TABLE play_store_dup
-- ALTER COLUMN price TYPE numeric(5,2) USING price::numeric


