{{ config(materialized='incremental') }}

with source as (
    select * from {{ source('seed_data', 'sales_reciepts') }}

    {% if is_incremental() %}

        where load_data > (select max(loaded_data) from {{ this }})

    {% endif %}
),

renamed as (
    select
        cast(transaction_id as varchar(4096)) as transaction_id,
        cast(transaction_date as varchar(4096)) as transaction_date,
        cast(transaction_time as varchar(4096)) as transaction_time,
        cast(sales_outlet_id as varchar(4096)) as sales_outlet_id,
        cast(staff_id as varchar(4096)) as staff_id,
        cast(customer_id as varchar(4096)) as customer_id,
        cast(instore_yn as varchar(4096)) as instore_yn,
        cast(orders as varchar(4096)) as orders,
        cast(product_id as varchar(4096)) as product_id,
        cast(quantity as varchar(4096)) as quantity,
        cast(line_item_amount as varchar(4096)) as line_item_amount,
        cast(unit_price as varchar(4096)) as unit_price,
        cast(promo_item_yn as varchar(4096)) as promo_item_yn,
        load_data as loaded_data
    from source
),

with_coalesce as (
    select
        coalesce(nullif(transaction_id,''), NULL) as transaction_id,
        coalesce(nullif(transaction_date,''), NULL) as transaction_date,
        coalesce(nullif(transaction_time,''), NULL) as transaction_time,
        coalesce(nullif(sales_outlet_id,''), NULL) as sales_outlet_id,
        coalesce(nullif(staff_id,''), NULL) as staff_id,
        coalesce(nullif(customer_id,''), NULL) as customer_id,
        coalesce(nullif(instore_yn,''), NULL) as instore_yn,
        coalesce(nullif(orders,''), NULL) as orders,
        coalesce(nullif(product_id,''), NULL) as product_id,
        coalesce(nullif(quantity,''), NULL) as quantity,
        coalesce(nullif(line_item_amount,''), NULL) as line_item_amount,
        coalesce(nullif(unit_price,''), NULL) as unit_price,
        coalesce(nullif(promo_item_yn,''), NULL) as promo_item_yn,
        loaded_data
    from renamed
),

with_re_change as (
    select
        cast(transaction_id as number) as transaction_id,
        cast(transaction_date as date) as transaction_date,
        transaction_time,
        cast(sales_outlet_id as number) as sales_outlet_id,
        cast(staff_id as number) as staff_id,
        cast(customer_id as number) as customer_id,
        instore_yn,
        cast(orders as number) as orders,
        cast(product_id as number) as product_id,
        cast(quantity as number) as quantity,
        cast(line_item_amount as float) as line_item_amount,
        cast(unit_price as float) as unit_price,
        promo_item_yn,
        loaded_data
    from with_coalesce
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
            {{ dbt_utils.generate_surrogate_key(["product_id"]) }} as varchar(4096)
        ) as product_id,
        quantity,
        line_item_amount,
        unit_price,
        promo_item_yn,
        loaded_data
    from with_re_change
)

select * from with_hash