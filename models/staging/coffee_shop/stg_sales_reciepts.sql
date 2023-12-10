{{ config(materialized='table') }}

with source as (
    select * from {{ source('seed_data', 'sales_reciepts') }}
),

renamed as (
    select
        cast("transaction_id" as number) as transaction_id,
        cast("transaction_date" as date) as transaction_date,
        cast("transaction_time" as varchar(4096)) as transaction_time,
        cast("sales_outlet_id" as number) as sales_outlet_id,
        cast("staff_id" as number) as staff_id,
        cast("customer_id" as number) as customer_id,
        cast("instore_yn" as varchar(4096)) as instore_yn,
        cast("order" as number) as orders,
        cast("line_item_id" as number) as line_item_id,
        cast("product_id" as number) as product_id,
        cast("quantity" as number) as quantity,
        cast("line_item_amount" as float) as line_item_amount,
        cast("unit_price" as float) as unit_price,
        cast("promo_item_yn" as varchar(4096)) as promo_item_yn
    from source
),

with_hash as (
    select
        cast(
            {{ dbt_utils.generate_surrogate_key(["transaction_id"]) }} as varchar(4096)
        ) as transaction_id,
        transaction_date,
        transaction_time,
        cast(
            {{ dbt_utils.generate_surrogate_key(["sales_outlet_id"]) }} as varchar(4096)
        ) as sales_outlet_id,
        cast(
            {{ dbt_utils.generate_surrogate_key(["staff_id"]) }} as varchar(4096)
        ) as staff_id,
        cast(
            {{ dbt_utils.generate_surrogate_key(["customer_id"]) }} as varchar(4096)
        ) as customer_id,
        instore_yn,
        orders,
        cast(
            {{ dbt_utils.generate_surrogate_key(["line_item_id"]) }} as varchar(4096)
        ) as line_item_id,
        cast(
            {{ dbt_utils.generate_surrogate_key(["product_id"]) }} as varchar(4096)
        ) as product_id,
        quantity,
        line_item_amount,
        unit_price,
        promo_item_yn
    from renamed
)

select * from with_hash
