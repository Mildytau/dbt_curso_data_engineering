{{ config(materialized='table') }}

with source as (
    select * from {{ source('coffee_shop','stg_sales_outlet') }}
),

renamed as (
    select
        sales_outlet_id,
        store_square_feet,
        store_longitude,
        store_latitude
    from source
)

select * from renamed