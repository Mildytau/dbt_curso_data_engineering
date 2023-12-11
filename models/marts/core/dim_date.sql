{{ 
    config(
        materialized='table', 
        sort='date_day',
        dist='date_day',
        pre_hook="alter session set timezone = 'Europe/Madrid'; alter session set week_start = 7;" 
        ) }}

with date as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2000-01-01' as date)",
        end_date="cast(current_date()+1 as date)"
    )
    }}  
),


renamed_casted AS(
    select
      date_day as forecast_date
    , year(date_day)*10000+month(date_day)*100+day(date_day) as date_id
    , year(date_day) as year
    , month(date_day) as month
    ,monthname(date_day) as month_desc
    , year(date_day)*100+month(date_day) as year_month_id
    , date_day-1 as previous_day
    , year(date_day)||weekiso(date_day)||dayofweek(date_day) as year_week_day
    , weekiso(date_day) as week
    ,{{ dbt_date.now("Europe/Madrid") }} as full_current_time
    ,date_part('hour', {{ dbt_date.now("Europe/Madrid") }}) as current_hour
from date
order by
    date_day desc
)

SELECT * FROM renamed_casted