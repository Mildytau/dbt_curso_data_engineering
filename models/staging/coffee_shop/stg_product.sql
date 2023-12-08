{{ config(materialized='table') }}

with source as (
    select * from {{ source('seed_data', 'product') }}
),

renamed as (
    select
        "product_id",
        "product_group",
        "product_category",
        "product_type",
        "product",
        "product_description",
        "unit_of_measure",
        "current_wholesale_price",
        "current_retail_price",
        "tax_exempt_yn",
        "promo_yn",
        "new_product_yn"
    from source
)

select * from renamed