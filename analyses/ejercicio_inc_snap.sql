{{ config(materialized='incremental') }}

with source as (
    select * from {{ source('sql_server_dbo', 'users') }}

    {% if is_incremental() %}

        where _fivetran_synced > (select max(f_carga) from {{ this }})

    {% endif %}
),

temporal as (

    select
        user_id,
        first_name,
        last_name,
        address_id,
        _fivetran_synced as f_carga,
        cast(replace(phone_number, '-', '')as int) as phone_number
    from source

)

select * from temporal
