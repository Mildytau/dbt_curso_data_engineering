{{ config(materialized='table') }}

with source as (
    select * from {{ source('coffee_shop','stg_staff') }}
),

renamed as (
    select
        staff_id,
        first_name,
        last_name,
        position,
        start_date,
        location
    from source
)

select * from renamed
