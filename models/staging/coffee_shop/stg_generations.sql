{{ config(materialized='table') }}

with

source as (select * from {{ ref('generations') }}
),

renamed as (

    select
        birth_year,
        cast(generation as varchar(1024)) as generation

    from source

)

select * from renamed
