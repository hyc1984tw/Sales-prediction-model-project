Create or replace table `mldata-8nkm.cdp_mltable2.taiwan_store_sale_index` as

WITH T0 AS (
select tdt_date_event, web_label, brand_name, but_num_business_unit, f_to_tax_in, unv_num_univers, dpt_num_department, fam_num_family, category_label, EXTRACT(ISOYEAR FROM tdt_date_event) AS year, EXTRACT(ISOWEEK FROM tdt_date_event) AS week
from `mldata-8nkm.cdp_mltable.tw_transaction_2016`
where but_num_business_unit = '666' and brand_name = 'TARMAK' and category_label = 'FOOTWEAR'),
T1 AS (
select tdt_date_event, web_label, brand_name, but_num_business_unit, f_to_tax_in, unv_num_univers, dpt_num_department, fam_num_family, category_label, EXTRACT(ISOYEAR FROM tdt_date_event) AS year, EXTRACT(ISOWEEK FROM tdt_date_event) AS week
from `mldata-8nkm.cdp_mltable.tw_transaction_2017`
where but_num_business_unit = '666' and brand_name = 'TARMAK' and category_label = 'FOOTWEAR'),
T2 AS (
select tdt_date_event, web_label, brand_name, but_num_business_unit, f_to_tax_in, unv_num_univers, dpt_num_department, fam_num_family, category_label, EXTRACT(ISOYEAR FROM tdt_date_event) AS year, EXTRACT(ISOWEEK FROM tdt_date_event) AS week
from `mldata-8nkm.cdp_mltable.tw_transaction_2018`
where but_num_business_unit = '666' and brand_name = 'TARMAK' and category_label = 'FOOTWEAR'),
T3 AS (
select tdt_date_event, web_label, brand_name, but_num_business_unit, f_to_tax_in, unv_num_univers, dpt_num_department, fam_num_family, category_label, EXTRACT(ISOYEAR FROM tdt_date_event) AS year, EXTRACT(ISOWEEK FROM tdt_date_event) AS week
from `mldata-8nkm.cdp_mltable.tw_transaction_2019`
where but_num_business_unit = '666' and brand_name = 'TARMAK' and category_label = 'FOOTWEAR'),
T4 AS (
select tdt_date_event, web_label, brand_name, but_num_business_unit, f_to_tax_in, unv_num_univers, dpt_num_department, fam_num_family, category_label, EXTRACT(ISOYEAR FROM tdt_date_event) AS year, EXTRACT(ISOWEEK FROM tdt_date_event) AS week
from `mldata-8nkm.cdp_mltable.tw_transaction_current`
where but_num_business_unit = '666' and brand_name = 'TARMAK' and category_label = 'FOOTWEAR'),
T5 AS (
SELECT tdt_date_event, web_label, brand_name, but_num_business_unit, f_to_tax_in, unv_num_univers, dpt_num_department, fam_num_family, category_label, 
case when week < 10 then CONCAT(year,'0',week)
else CONCAT(year,week) END AS Year_week, year, week
from T0
UNION ALL
SELECT tdt_date_event, web_label, brand_name, but_num_business_unit, f_to_tax_in, unv_num_univers, dpt_num_department, fam_num_family, category_label, 
case when week < 10 then CONCAT(year,'0',week)
else CONCAT(year,week) END AS Year_week, year, week
from T1
UNION ALL
SELECT tdt_date_event, web_label, brand_name, but_num_business_unit, f_to_tax_in, unv_num_univers, dpt_num_department, fam_num_family, category_label, 
case when week < 10 then CONCAT(year,'0',week)
else CONCAT(year,week) END AS Year_week, year, week
from T2
UNION ALL
SELECT tdt_date_event, web_label, brand_name, but_num_business_unit, f_to_tax_in, unv_num_univers, dpt_num_department, fam_num_family, category_label, 
case when week < 10 then CONCAT(year,'0',week)
else CONCAT(year,week) END AS Year_week, year, week
from T3
UNION ALL
SELECT tdt_date_event, web_label, brand_name, but_num_business_unit, f_to_tax_in, unv_num_univers, dpt_num_department, fam_num_family, category_label, 
case when week < 10 then CONCAT(year,'0',week)
else CONCAT(year,week) END AS Year_week, year, week
from T4
),
T6 AS (
SELECT Year_week, year, week, SUM(f_to_tax_in) as TO_WK
FROM T5
group by Year_week, year, week
order by year, week asc),
T7 AS (
SELECT 
rank() OVER(ORDER BY year, week asc) as rank,
Year_week, year, week, TO_WK,
round(AVG(TO_WK) OVER (ORDER BY year, week asc ROWS BETWEEN 14 PRECEDING AND CURRENT ROW)) AS avg_TO_WK,
round(stddev(TO_WK) OVER (ORDER BY year, week asc ROWS BETWEEN 14 PRECEDING AND CURRENT ROW)) AS stddev_TO_WK
from T6
order by year, week asc),
T8 AS (
SELECT rank, Year_week, year, week, TO_WK, 
CASE WHEN rank < 15 THEN NULL ELSE avg_TO_WK  END AS avg_TO_WK,
CASE WHEN rank < 15 THEN NULL ELSE stddev_TO_WK  END AS stddev_TO_WK,
CASE WHEN rank < 15 THEN NULL ELSE round((TO_WK - avg_TO_WK)/stddev_TO_WK, 1) END AS INDEX
from T7
order by year, week)
Select rank, Year_week,  year, week, TO_WK, avg_TO_WK, stddev_TO_WK, INDEX,
case 
when INDEX > 1.0 then 1
else 0
end as sales_index
from T8
order by year, week



