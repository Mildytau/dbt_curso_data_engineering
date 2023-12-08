{{ config(materialized='table') }}

with source as (
    select * from {{ source('seed_data', 'sales_reciepts') }}
),

renamed as (
    select
        "transaction_id",
        "transaction_date",
        "transaction_time",
        "sales_outlet_id",
        "staff_id",
        "customer_id",
        "instore_yn",
        "order",
        "line_item_id",
        "product_id",
        "quantity",
        "line_item_amount",
        "unit_price",
        "promo_item_yn"
    from source
)

select * from renamed