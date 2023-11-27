{{ config(
    materialized='table'
    ) }}

select
    {{ dbt_date.now("Europe/Madrid") }} as full_current_time,
    date_part('hour', {{ dbt_date.now("Europe/Madrid") }}) as current_hour,
    date_part('minute', {{ dbt_date.now("Europe/Madrid") }}) as current_minute,
    date_part('second', {{ dbt_date.now("Europe/Madrid") }}) as current_second
