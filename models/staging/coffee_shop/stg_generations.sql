{{ config(materialized='table') }}

with source as (
    select * from {{ source('seed_data', 'generations') }}
),

renamed as (
    select
        cast(birth_year as varchar(4096)) as birth_year,
        cast(generation as varchar(4096)) as generation
    from source
),

with_coalesce as (
    select
        coalesce(nullif(birth_year,''), NULL) as birth_year
        coalesce(nullif(generation,''), NULL) as generation
    from renamed
),

with_re_change (
    select
        cast(birth_year as number) as birth_year,
        generation
    from with_coalesce
)

select * from with_re_change
