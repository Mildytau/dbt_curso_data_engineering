{{
  config(
    materialized='table'
  )
}}

with 

source as (

    select * from {{ source('SQL_SERVER_DBO', 'ADDRESSES') }}

),

temporal as (

    select
        address_id,
        zipcode,
        country,
        address,
        state,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from temporal
