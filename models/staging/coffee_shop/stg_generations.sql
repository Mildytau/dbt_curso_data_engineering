{{ config(materialized='table') }}

with source as (
    select * from {{ source('seed_data', 'generations') }}
),

renamed as (
    select
        "birth_year",
        "generation"
    from source
)

select * from renamed
