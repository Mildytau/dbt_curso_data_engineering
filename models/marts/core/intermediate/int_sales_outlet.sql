{{ config(materialized='table') }}

with source as (
    select * from {{ ref('stg_sales_outlet') }}
),

renamed as (
    select
        outlet_id,
        sales_outlet_type,
        store_square_feet,
        store_address,
        store_city,
        store_state_province,
        store_telephone,
        store_postal_code,
        store_longitude,
        store_latitude,
        manager,
        neighorhood
    from source
)

select * from renamed
