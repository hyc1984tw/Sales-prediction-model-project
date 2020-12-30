create or replace table `mldata-8nkm.google_trend.basketball_key_nba` as
select date_yyww_dd, year, week, Year_week, index, 
case 
when index <= 20 then 0
when index > 20 and index <= 40 then 1
when index > 40 and index <= 60 then 2
when index > 60 and index <= 80 then 3
else 4 end as index_score
from `mldata-8nkm.google_trend.basketball_key_nba`
order by year, week asc
