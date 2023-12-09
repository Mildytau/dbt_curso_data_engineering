{{ config(materialized='table') }}

with source as (
    select * from {{ source('seed_data', 'product') }}
),

renamed as (
    select
        cast("product_id" as number) as product_id,
        cast("product_group" as varchar(1024)) as product_group,
        cast("product_category" as varchar(1024)) as product_category,
        cast("product_type" as varchar(1024)) as product_type,
        cast("product" as varchar(1024)) as product,
        cast("product_description" as varchar(1024)) as product_description,
        cast("unit_of_measure" as varchar(1024)) as unit_of_measure,
        cast("current_wholesale_price" as float) as current_wholesale_price,
        cast("current_retail_price" as float) as current_retail_price,
        cast("tax_exempt_yn" as varchar(1024)) as tax_exempt_yn,
        cast("promo_yn" as varchar(1024)) as promo_yn,
        cast("new_product_yn" as varchar(1024)) as new_product_yn
    from source
),

with_hash as (
    select
        cast(
            {{ dbt_utils.generate_surrogate_key(["product_id"]) }} as varchar(1024)
        ) as product_id,
        product_group,
        product_category,
        product_type,
        product,
        product_description,
        unit_of_measure,
        current_wholesale_price,
        current_retail_price,
        tax_exempt_yn,
        promo_yn,
        new_product_yn
    from renamed
)

select * from with_hash
