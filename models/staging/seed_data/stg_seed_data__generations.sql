with

source as (

    select * from {{ source('seed_data', 'generations') }}

),

renamed as (

    select
        generation,
        birth_year

    from source

)

select * from renamed
