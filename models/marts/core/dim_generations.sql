{{ config(materialized='table') }}

with source as (
    select * from {{ ref('stg_generations') }}
),

renamed as (
    select
        birth_year,
        generation
    from source
)

select * from renamed
