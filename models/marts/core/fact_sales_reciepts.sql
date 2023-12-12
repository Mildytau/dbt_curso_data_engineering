{{ config(materialized='table') }}

with source as (
    select * from {{ ref('stg_sales_reciepts') }}
),

renamed as (
    select
        transaction_id,
        transaction_date,
        transaction_time,
        sales_outlet_id,
        staff_id,
        customer_id,
        instore_yn,
        orders,
        product_id,
        quantity,
        line_item_amount,
        unit_price,
        promo_item_yn
    from source
)

select * from renamed