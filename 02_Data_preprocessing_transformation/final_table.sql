create or replace table `mldata-8nkm.cdp_mltable2.final_table` as

with T1 as (
select Year_week, avg_temp_index_wk, rainfall_index_wk
from `mldata-8nkm.tw_weather.taichung_weather`),
T2 as (
select Year_week, index_score as bb_trend_index 
from `mldata-8nkm.google_trend.basketball_key_basketball`),
T3 as (
select Year_week, index_score as nba_trend_index 
from `mldata-8nkm.google_trend.basketball_key_nba`),
T4 as (
select Year_week, index_score as hbl_trend_index
from `mldata-8nkm.google_trend.basketball_key_hbl`),
T5 as (
select Year_week, sales_index
from `mldata-8nkm.cdp_mltable2.taiwan_store_sale_index`)
select t5.Year_week, bb_trend_index, nba_trend_index, hbl_trend_index, avg_temp_index_wk, rainfall_index_wk, sales_index
from T5
left join T1
on T5.Year_week = T1.Year_week
left join T2
on T5.Year_week = T2.Year_week
left join T3
on T5.Year_week = T3.Year_week
left join T4
on T5.Year_week = T4.Year_week
order by Year_week asc
