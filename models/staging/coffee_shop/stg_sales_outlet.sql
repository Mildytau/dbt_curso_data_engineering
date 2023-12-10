{{ config(materialized='table') }}

with source as (
    select * from {{ source('seed_data', 'number_sales_outlet') }}
),

renamed as (
    select
        cast("Number_outlet_id" as varchar(4096)) as "outlet_id",
        cast("sales_outlet_type" as varchar(4096)) as sales_outlet_type,
        cast("store_square_feet" as number) as store_square_feet,
        cast("store_address" as varchar(4096)) as store_address,
        cast("store_city" as varchar(4096)) as store_city,
        cast("store_state_province" as varchar(4096)) as store_state_province,
        cast("store_telephone" as varchar(4096)) as store_telephone,
        cast("store_postal_code" as number) as store_postal_code,
        cast("store_longitude" as float) as store_longitude,
        cast("store_latitude" as float) as store_latitude,
        cast("manager" as number) as manager,
        cast("Neighorhood" as varchar(4096)) as neighorhood
    from source
),

with_change as (
    select
        "outlet_id" as outlet_id,
        sales_outlet_type,
        store_square_feet,
        store_address,
        store_city,
        store_state_province,
        store_telephone,
        store_postal_code,
        store_longitude,
        store_latitude,
        manager,
        neighorhood
    from renamed
),

with_hash as (
    select
        cast(
            {{ dbt_utils.generate_surrogate_key(["outlet_id"]) }} as varchar(4096)
        ) as outlet_id,
        sales_outlet_type,
        store_square_feet,
        store_address,
        store_city,
        store_state_province,
        store_telephone,
        store_postal_code,
        store_longitude,
        store_latitude,
        manager,
        neighorhood
    from with_change
)

select * from with_hash
