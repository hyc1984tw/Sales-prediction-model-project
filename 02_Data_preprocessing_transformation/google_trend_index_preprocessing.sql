create or replace table `mldata-8nkm.google_trend.basketball_key_nba` as
select date_field_0 as date_yyww_dd, EXTRACT(YEAR FROM date_field_0) AS year, EXTRACT(week FROM date_field_0) AS week, int64_field_1 as index
from `mldata-8nkm.google_trend.basketball_key_nba`
order by year, week asc
