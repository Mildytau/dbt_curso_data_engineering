{{
  config(
    materialized='table'
  )
}}

with 

source as (

    select * from {{ source('SQL_SERVER_DBO', 'PROMOS') }}

),

temporal as (

    select
        promo_id,
        discount,
        status,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from temporal
