{{config(materialized='table')}}

with 

source as (select * from {{ source('sql_server_dbo', 'events') }}
),

temporal as (

    select
        cast(
            {{ dbt_utils.generate_surrogate_key(["event_id"])}} as varchar(1024)
        ) as event_id,
        cast(page_url as varchar(1024)) as page_url,
        cast(event_type as varchar(100)) as event_type,
        cast(
            {{ dbt_utils.generate_surrogate_key(["user_id"])}} as varchar(256)
        ) as user_id,
        cast(
            {{ dbt_utils.generate_surrogate_key(["product_id"])}} as varchar(1024)
        ) as product_id,
        cast(
            {{ dbt_utils.generate_surrogate_key(["session_id"])}} as varchar(1024)
        ) as session_id,
        cast(created_at as timestamp_ntz) as created_at,
        cast(
            {{ dbt_utils.generate_surrogate_key(["order_id"])}} as varchar(1024)
        ) as order_id,
        cast(_fivetran_synced as timestamp_ntz) as _fivetran_synced

    from source

)

select * from temporal
