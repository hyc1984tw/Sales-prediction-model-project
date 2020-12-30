Create or replace table `mldata-8nkm.tw_weather.taichung_weather` as 

With T1 as (
Select month, CAST(StnPresMaxTime as timestamp) as time, cast(Temperature as numeric) as temperature,  
case 
when precp = 'T' then '0'
else precp end as rainfall
from `mldata-8nkm.tw_weather.copy_taichung_2`),
T2 as (
select month, time, extract(ISOYEAR from time) as Year, extract(ISOWEEK from time) as Week, temperature, cast(rainfall as numeric) as rainfall
from T1),
T3 as(
select month, time, Year, Week, 
case when Week < 10 then CONCAT(Year,'0',Week)
else CONCAT(Year,Week)
END AS Year_week,
temperature, rainfall,
case when rainfall > 10 then 1
else 0
END AS rainfall_index_daily
from T2
order by Year, week),
T4 as (
select month, time, Year, Week, Year_week, temperature, rainfall,
round(avg(temperature) over(partition by Year_week),1) as avg_temp_wk,
sum(rainfall_index_daily) over(partition by Year_week) as rainfall_weekly
from T3
order by year, week),
T5 as (
select month, time, Year, Week, Year_week, temperature, rainfall_weekly,
avg_temp_wk,
case 
when rainfall_weekly < 3 then 0
when rainfall_weekly >= 3 and rainfall_weekly < 5 then 1
else 2  end as rainfall_index_wk,
case 
when avg_temp_wk <= 15 then 0
when avg_temp_wk >15 and avg_temp_wk <= 20 then 1
when avg_temp_wk >20 and avg_temp_wk <= 25 then 2
when avg_temp_wk >25 and avg_temp_wk <= 30 then 3
else 4  end as avg_temp_index_wk,
from T4)
select distinct Year, Week, Year_week, avg_temp_index_wk, rainfall_index_wk
from T5
order by Year, week asc
