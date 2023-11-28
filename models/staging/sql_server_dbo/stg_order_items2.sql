{{config(materialized='table')}}

with 

source as (select * from {{ source('sql_server_dbo', 'order_items') }}
),

temporal as (

    select
        cast(
            {{ dbt_utils.generate_surrogate_key(["order_id"])}} as varchar(256)
        ) as order_id,
        cast(
            {{ dbt_utils.generate_surrogate_key(["product_id"])}} as varchar(256)
        ) as product_id,
        cast(quantity as integer) as quantity,
        cast(_fivetran_synced as timestamp_ntz) as _fivetran_synced

    from source

)

select * from temporal
