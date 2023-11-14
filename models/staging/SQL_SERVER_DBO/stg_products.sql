{{
  config(
    materialized='table'
  )
}}

with 

source as (

    select * from {{ source('SQL_SERVER_DBO', 'PRODUCTS') }}

),

temporal as (

    select
        product_id,
        price,
        name,
        inventory,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from temporal
