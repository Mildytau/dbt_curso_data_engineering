{{ config(materialized='table') }}

with source as (
    select * from {{ source('coffee_shop','stg_customer') }}
),

renamed as (
    select
        customer_id,
        home_store,
        customer_first_name,
        customer_email,
        customer_since,
        loyalty_card_number,
        birth_date,
        gender,
        birth_year
    from source
)

select * from renamed