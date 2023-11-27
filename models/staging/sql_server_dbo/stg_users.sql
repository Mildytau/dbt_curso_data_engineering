{{config(materialized='table')}}

with 

source as (select * from {{ source('sql_server_dbo', 'users') }}
),

temporal as (

    select
        cast(
            {{ dbt_utils.generate_surrogate_key(["user_id"])}} as varchar(256)
        ) as user_id,
        cast(
            {{ dbt_utils.generate_surrogate_key(["address_id"])}} as varchar(256)
        ) as address_id,
        cast(first_name as varchar(50)) as first_name,
        cast(last_name as varchar(50)) as last_name,
        cast(created_at as timestamp_ntz) as created_at,
        cast(updated_at as timestamp_ntz) as updated_at,
        cast(phone_number as varchar(256)) as phone_number,
        cast(email as varchar(256)) as email,
        cast(_fivetran_synced as timestamp_ntz) as _fivetran_synced

    from source

)

select * from temporal
