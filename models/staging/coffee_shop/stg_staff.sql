{{ config(materialized='table') }}

with source as (
    select * from {{ source('seed_data', 'staff') }}
),

renamed as (
    select
        cast(staff_id as varchar(4096)) as staff_id,
        cast(first_name as varchar(4096)) as first_name,
        cast(last_name as varchar(4096)) as last_name,
        cast(position as varchar(4096)) as position,
        cast(start_date as varchar(4096)) as start_date,
        cast(location as varchar(4096)) as location
    from source
),

with_coalesce as (
    select
        coalesce(nullif(staff_id,''), NULL) as staff_id,
        coalesce(nullif(first_name,''), NULL) as first_name,
        coalesce(nullif(last_name,''), NULL) as last_name,
        coalesce(nullif(position,''), NULL) as position,
        coalesce(nullif(start_date,''), NULL) as start_date,
        coalesce(nullif(location,''), NULL) as location
    from renamed
),

with_re_change as (
    select
        cast(staff_id as number) as staff_id,
        first_name,
        last_name,
        position,
        cast(start_date as date) as start_date,
        location
    from with_coalesce
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
    from with_re_change
)

select * from with_hash
