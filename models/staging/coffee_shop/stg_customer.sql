{{config(materialized='table')}}

with source as (
    select * from {{ source('seed_data', 'number_customer') }}
),
renamed as (
    select
        "customer_id",
        "home_store",
        "customer_first_name",
        "customer_email",
        "customer_since",
        "loyalty_card_number",
        "birthdate",
        "gender",
        "birth_year"
    from source
)
select * from renamed
