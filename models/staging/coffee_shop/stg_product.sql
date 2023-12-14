{{ config(materialized='table') }}

with source as (
    select * from {{ source('seed_data', 'product') }}
),

casted_renamed as (
    select
        cast(product_id as varchar(4096)) as product_id,
        cast(product_group as varchar(4096)) as product_group,
        cast(product_category as varchar(4096)) as product_category,
        cast(product_type as varchar(4096)) as product_type,
        cast(product as varchar(4096)) as product,
        cast(product_description as varchar(4096)) as product_description,
        cast(unit_of_measure as varchar(4096)) as unit_of_measure,
        cast(current_wholesale_price as varchar(4096)) as current_wholesale_price,
        cast(current_retail_price as varchar(4096)) as current_retail_price,
        cast(tax_exempt_yn as varchar(4096)) as tax_exempt_yn,
        cast(promo_yn as varchar(4096)) as promo_yn,
        cast(new_product_yn as varchar(4096)) as new_product_yn
    from source
),

with_coalesce as (
    select
        coalesce(nullif(product_id,''), NULL) as product_id,
        coalesce(nullif(product_group,''), NULL) as product_group,
        coalesce(nullif(product_category,''), NULL) as product_category,
        coalesce(nullif(product_type,''), NULL) as product_type,
        coalesce(nullif(product,''), NULL) as product,
        coalesce(nullif(product_description,''), NULL) as product_description,
        coalesce(nullif(unit_of_measure,''), NULL) as unit_of_measure,
        coalesce(nullif(current_wholesale_price,''), NULL) as current_wholesale_price,
        coalesce(nullif(current_retail_price,''), NULL) as current_retail_price,
        coalesce(nullif(tax_exempt_yn,''), NULL) as tax_exempt_yn,
        coalesce(nullif(promo_yn,''), NULL) as promo_yn,
        coalesce(nullif(new_product_yn,''), NULL) as new_product_yn
    from casted_renamed
),

with_re_change as (
    select
        cast(product_id as number) as product_id,
        product_group,
        product_category,
        product_type,
        product,
        product_description,
        unit_of_measure,
        cast(current_wholesale_price as float) as current_wholesale_price,
        cast(current_retail_price as float) as current_retail_price,
        tax_exempt_yn,
        promo_yn,
        new_product_yn
    from with_coalesce
),

with_hash as (
    select
        cast(
            {{ dbt_utils.generate_surrogate_key(["product_id"]) }} as varchar(4096)
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
    from with_re_change
)

select * from with_hash
