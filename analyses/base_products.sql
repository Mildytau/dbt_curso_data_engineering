{{config(materialized='table')}}

with 

source as (select * from {{ source('sql_server_dbo', 'products') }}),

temporal as (

    select
        product_id,
        price,
        name,
        inventory,
        _fivetran_synced

    from source

)