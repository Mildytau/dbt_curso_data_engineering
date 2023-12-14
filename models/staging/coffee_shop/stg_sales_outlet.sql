{{ config(materialized='table') }}

with source as (
    select * from {{ source('seed_data', 'sales_outlet') }}
),

renamed as (
    select
        cast(outlet_id as varchar(4096)) as sales_outlet_id,
        cast(sales_outlet_type as varchar(4096)) as sales_outlet_type,
        cast(store_square_feet as varchar(4096)) as store_square_feet,
        cast(store_address as varchar(4096)) as store_address,
        cast(store_city as varchar(4096)) as store_city,
        cast(store_state_province as varchar(4096)) as store_state_province,
        cast(store_telephone as varchar(4096)) as store_telephone,
        cast(store_postal_code as varchar(4096)) as store_postal_code,
        cast(store_longitude as varchar(4096)) as store_longitude,
        cast(store_latitude as varchar(4096)) as store_latitude,
        cast(manager as varchar(4096)) as manager,
        cast(neighorhood as varchar(4096)) as neighorhood
    from source
),

with_coalesce as (
    select
        coalesce(nullif(sales_outlet_id,''), NULL) as sales_outlet_id,
        coalesce(nullif(sales_outlet_type,''), NULL) as sales_outlet_type,
        coalesce(nullif(store_square_feet,''), NULL) as store_square_feet,
        coalesce(nullif(store_address,''), NULL) as store_address,
        coalesce(nullif(store_city,''), NULL) as store_city,
        coalesce(nullif(store_state_province,''), NULL) as store_state_province,
        coalesce(nullif(store_telephone,''), NULL) as store_telephone,
        coalesce(nullif(store_postal_code,''), NULL) as store_postal_code,
        coalesce(nullif(store_longitude,''), NULL) as store_longitude,
        coalesce(nullif(store_latitude,''), NULL) as store_latitude,
        coalesce(nullif(manager,''), NULL) as manager,
        coalesce(nullif(neighorhood,''), NULL) as neighorhood
    from renamed
),

with_re_change as (
    select
        sales_outlet_id,
        sales_outlet_type,
        cast(store_square_feet as number) as store_square_feet,
        store_address,
        store_city,
        store_state_province,
        store_telephone,
        cast(store_postal_code as number) as store_postal_code,
        cast(store_longitude as float) as store_longitude,
        cast(store_latitude as float) as store_latitude,
        cast(manager as number) as manager,
        neighorhood
    from with_coalesce
),

with_hash as (
    select
        cast(
            {{ dbt_utils.generate_surrogate_key(["sales_outlet_id"]) }} as varchar(4096)
        ) as sales_outlet_id,
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
    from with_re_change
)

select * from with_hash
