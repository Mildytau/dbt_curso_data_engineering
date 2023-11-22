{{
  config(
    materialized='table'
  )
}}

with 

source as (

    select * from alumno8_dev_bronze_db.sql_server_dbo.promos

),

renamed as (

    select
        md5(cast(coalesce(cast(promo_id as 
    varchar
), '') as 
    varchar
)) as promo_id,
        discount,
        status,
        _fivetran_deleted
        _fivetran_synced

    from source

)

select * from renamed