{{ config(materialized='table') }}

with source as (
    select * from {{ source('coffee_shop','stg_generations') }}
),

renamed as (
    select
        birth_year,
        generation
    from source
)

select * from renamed
