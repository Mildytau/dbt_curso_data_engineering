{{config(materialized='table')}}

with 

source as (select * from {{ source('sql_server_dbo', 'addresses') }}
),

temporal as (

    select
        cast(
            {{ dbt_utils.generate_surrogate_key(["address_id"])}} as varchar(256)
        ) as address_id,
        cast(zipcode as integer) as zipcode,
        cast(country as varchar(256)) as country,
        cast(address as varchar(256)) as address,
        cast(state as varchar(256)) as state,
        cast(_fivetran_synced as timestamp_ntz) as _fivetran_synced

    from source

)

select * from temporal
