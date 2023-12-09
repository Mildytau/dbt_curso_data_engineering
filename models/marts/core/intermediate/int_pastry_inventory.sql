{{ config(materialized='table') }}

with source as (
    select * from {{ ref('stg_pastry_inventory') }}
),

renamed as (
    select
        sales_outlet_id,
        transaction_date,
        product_id,
        start_of_day,
        quantity_sold,
        waste,
        percentage_waste
    from source
)

select * from renamed
