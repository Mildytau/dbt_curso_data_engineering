{{config(materialized='table')}}

with 

source as (select * from {{ source('sql_server_dbo', 'products') }}
),

temporal as (

    select
        cast(
            {{ dbt_utils.generate_surrogate_key(["product_id"])}} as varchar(256)
        ) as product_id,
        cast(price as float) as price,
        cast(name as varchar(256)) as name,
        cast(inventory as integer) as inventory,
        cast(_fivetran_synced as timestamp_ntz) as _fivetran_synced

    from source

)

select * from temporal
