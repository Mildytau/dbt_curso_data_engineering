{{ config(materialized='table') }}

with source as (
    select * from {{ source('seed_data', 'generations') }}
),

renamed as (
    select
        cast(birth_year as number) as birth_year,
        cast(generation as varchar(4096)) as generation
    from source
)

select * from renamed
