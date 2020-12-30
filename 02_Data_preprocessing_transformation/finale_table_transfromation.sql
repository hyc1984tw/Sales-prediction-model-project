Create or replace table `mldata-8nkm.cdp_mltable2.final_table_cleaned` as

With t1 as (select Year_week, bb_trend_index as bb_trend_n, nba_trend_index as nba_trend_n, hbl_trend_index as hbl_trend_n, avg_temp_index_wk as temp_n, rainfall_index_wk as rainfall_n, sales_index as sales_n
from `mldata-8nkm.cdp_mltable2.final_table`
where year_week between '201635' and '202044'
order by year_week asc),
t2 as (
select year_week, bb_trend_n, nba_trend_n, hbl_trend_n, temp_n, rainfall_n, 
lag(bb_trend_n) over(order by year_week asc) as bb_trend_n1,
lag(bb_trend_n, 2) over(order by year_week asc) as bb_trend_n2,
lag(nba_trend_n) over(order by year_week asc) as nba_trend_n1,
lag(nba_trend_n, 2) over(order by year_week asc) as nba_trend_n2,
lag(hbl_trend_n) over(order by year_week asc) as hbl_trend_n1,
lag(hbl_trend_n, 2) over(order by year_week asc) as hbl_trend_n2,
lag(temp_n) over(order by year_week asc) as temp_n1,
lag(temp_n, 2) over(order by year_week asc) as temp_n2,
lag(rainfall_n) over(order by year_week asc) as rainfall_n1,
lag(rainfall_n, 2) over(order by year_week asc) as rainfall_n2,
sales_n
from t1
order by year_week asc)
select year_week, temp_n, rainfall_n, bb_trend_n1, nba_trend_n1, hbl_trend_n1, temp_n1, rainfall_n1, bb_trend_n2, nba_trend_n2, hbl_trend_n2, temp_n2, rainfall_n2, sales_n
from t2
where year_week > '201636'
order by year_week asc
