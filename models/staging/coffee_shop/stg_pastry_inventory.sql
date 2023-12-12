{{ config(materialized='table') }}

with source as (
    select * from {{ source('seed_data', 'pastry_inventory') }}
),

renamed as (
    select
        cast(sales_outlet_id as number) as sales_outlet_id,
        cast(transaction_date as varchar(4096)) as transaction_date,
        cast(product_id as number) as product_id,
        cast(start_of_day as number) as start_of_day,
        cast(quantity_sold as number) as quantity_sold,
        cast(waste as number) as waste,
        cast(percentage_waste as number) as percentage_waste
    from source
),

with_hash as (
    select
        cast(
            {{ dbt_utils.generate_surrogate_key(["sales_outlet_id"]) }} as varchar(4096)
        ) as sales_outlet_id,
        transaction_date,
        cast(
            {{ dbt_utils.generate_surrogate_key(["product_id"]) }} as varchar(4096)
        ) as product_id,
        start_of_day,
        quantity_sold,
        waste,
        percentage_waste
    from renamed
)

select * from with_hash
