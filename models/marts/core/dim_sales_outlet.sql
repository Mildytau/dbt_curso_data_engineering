{{ config(materialized='table') }}

with source as (
    select * from {{ ref('int_sales_outlet') }}
),

renamed as (
    select
        sales_outlet_id,
        sales_outlet_type,
        store_address,
        store_city,
        store_state_province,
        store_telephone,
        store_postal_code,
        manager,
        neighorhood
    from source
)

select * from renamed