{{config(materialized='table')}}

with 
source as (select * from alumno8_dev_bronze_db.sql_server_dbo.promos),

temporal as (
    select
        cast(
            {{ dbt_utils.surrogate_key(["promo_id"])}} as varchar(50)
        ) as promo_id,
        cast(discount as float) as discount,
        cast(status as varchar(50)) as status,
        cast(_fivetran_synced as timestamp_ntz) as date_load
    from source
)

select * from temporal
union all
select
    '9999' as promo_id,
    'Sin promo' as des_promo,
    '0' as discount,
    'inactive' as status,
    {{ dbt_date.now("America/New_York")}} as date_load