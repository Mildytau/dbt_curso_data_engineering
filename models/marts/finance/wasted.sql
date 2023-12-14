{{ config(materialized='table') }}

with source as (
    select * from {{ ref('fct_pastry_inventory') }}
),

source2 as (
    select * from {{ ref('dim_product') }}
),

renamed as (
    select
        source.product_id as product_id,
        source2.product_category as product_category,
        source2.product as product,
        source2.product_description as product_description,
        source.quantity_sold as quantity_sold,
        source.waste as waste,
        source.percentage_waste as percentage_waste
    from source, source2
),

calculate as (
    select
        product_id,
        product_category,
        product,
        product_description,
        sum(quantity_sold) as total_quantity_sold,
        sum(waste) as total_waste,
        avg(percentage_waste) as avg_percentage_waste
    from renamed
    group by product_id, product, product_description, product_category
)

select * from calculate
order by total_quantity_sold desc
