{{ config(materialized='table') }}

with source as (
    select * from {{ source('seed_data', 'staff') }}
),

renamed as (
    select
        cast(staff_id as number) as staff_id,
        cast(first_name as varchar(4096)) as first_name,
        cast(last_name as varchar(4096)) as last_name,
        cast(position as varchar(4096)) as position,
        cast(start_date as date) as start_date,
        cast(location as varchar(4096)) as location
    from source
),

with_hash as (
    select
        cast(
            {{ dbt_utils.generate_surrogate_key(["staff_id"])}} as varchar(4096)
        ) as staff_id,
        first_name,
        last_name,
        position,
        start_date,
        location
    from renamed
)

select * from with_hash
