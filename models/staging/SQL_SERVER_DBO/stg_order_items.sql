{{
  config(
    materialized='table'
  )
}}

with 

source as (

    select * from {{ source('SQL_SERVER_DBO', 'ORDER_ITEMS') }}

),

temporal as (

    select
        order_id,
        product_id,
        quantity,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from temporal
